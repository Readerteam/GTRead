//
//  GTReadViewController.swift
//  GTRead
//
//  Created by YangJie on 2021/3/22.
//

import UIKit
import PDFKit
import SceneKit
import ARKit

class GTReadViewController: EyeTrackViewController {
    
    //MARK: - 导航条
    var navgationBar: GTReadNavigationView!
    
    //MARK: - 视线相关
    var eyeTrackController: EyeTrackController!
//    var points = [CGPoint]()
    var points = [CGPoint(x: 10, y: 10)]
    var trackView: UIImageView!
    
    //MARK: -PDF 相关
    private var pdfdocument: PDFDocument?
    let pdfURL: URL // pdf路径
    var currentDate: TimeInterval = 0
    // pdf视图
    lazy var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal
        pdfView.usePageViewController(true, withViewOptions: [UIPageViewController.OptionsKey.interPageSpacing: 20])
        return pdfView
    }()
    
    // 构造函数
    init(path: URL) {
        pdfURL = path
        super.init(nibName: nil, bundle: nil)
        GTBook.shared.currentPdfView = pdfView
        GTBook.shared.pdfURL = pdfURL
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupView() {
        // 导航条
        self.navigation()
        self.view.addSubview(navgationBar)
        navgationBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        // 视线
        self.gateTrackView()
        
        // pdf
        self.view.addSubview(pdfView)
        pdfView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(pdfViewTapEvent))
        pdfView.addGestureRecognizer(tap)
        let document = PDFDocument(url: pdfURL)
        pdfView.document = document
        self.pdfdocument = document
        // 读取上一次阅读的页数缓存
        
        let page = document?.page(at: GTBook.shared.getCacheData())
        if let lastPage = page {
            pdfView.go(to: lastPage)
        }
        let date = Date.init()
        currentDate = date.timeIntervalSince1970

        NotificationCenter.default.addObserver(self,selector: #selector(handlePageChange(notification:)), name: Notification.Name.PDFViewPageChanged, object: nil)
        self.view.bringSubviewToFront(navgationBar)
        self.view.bringSubviewToFront(trackView)
    }
    
    private func navigation() {
        navgationBar = GTReadNavigationView()
        navgationBar.backgroundColor = UIColor.white
        navgationBar.backEvent = { [weak self] in
            GTBook.shared.cacheData()
            // 退出
            self?.navigationController?.setNavigationBarHidden(false, animated: false)
            self?.navigationController?.popViewController(animated: true)
        }
        navgationBar.thumbEvent = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 20
            
            let width = (strongSelf.view.frame.width - 10 * 4) / 3
            let height = width * 1.5
            
            layout.itemSize = CGSize(width: width, height: height)
            layout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
            
            let thumbnailGridViewController = GTThumbnailGridViewController(collectionViewLayout: layout)
            thumbnailGridViewController.pdfDocument = strongSelf.pdfdocument
            thumbnailGridViewController.delegate = strongSelf
            strongSelf.navigationController?.pushViewController(thumbnailGridViewController, animated: true)
        }
        navgationBar.outlineEvent = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let pdfoutline = strongSelf.pdfdocument?.outlineRoot {
                let oulineViewController = GTOulineTableviewController(style: UITableView.Style.plain)
                oulineViewController.pdfOutlineRoot = pdfoutline
                oulineViewController.delegate = strongSelf
                
                strongSelf.navigationController?.pushViewController(oulineViewController, animated: true)
            }
        }
        navgationBar.commentEvent = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let commentVC = GTCommentViewController()
            strongSelf.addChild(commentVC)
            strongSelf.view.addSubview(commentVC.view)
            commentVC.view.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    private func gateTrackView(){
        trackView = UIImageView(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        trackView.contentMode = .scaleAspectFill
        trackView.image = UIImage(named: "track_icon")
        trackView.isHidden = true
        self.view.addSubview(trackView)
        self.eyeTrackController = EyeTrackController(device: Device(type: .iPad), smoothingRange: 10, blinkThreshold: .infinity, isHidden: true)
        self.eyeTrackController.onUpdate = { [weak self] info in
            self?.trackView.isHidden = false
            let point = CGPoint(x: info?.centerEyeLookAtPoint.x ?? 0, y: info?.centerEyeLookAtPoint.y ?? 0)
            self?.trackView.center = point
            self?.points.append(point)
        }
        self.initialize(eyeTrack: eyeTrackController.eyeTrack)
        self.show()
    }
    
    @objc private func pdfViewTapEvent() {
        navgationBar.heightAnimation()
    }
    
    @objc private func handlePageChange(notification: Notification){
        var temp = Array<[String:CGFloat]>()
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        for point in self.points {
            if point.x < width, point.x > 0, point.y > 0, point.y < height {
                let dict = ["cx": point.x, "cy": point.y]
                temp.append(dict)
            }
        }
        GTNet.shared.commitGazeTrackData(starTime: currentDate, lists: temp)
        self.points.removeAll()
    }
}

extension GTReadViewController: GTThumbnailGridViewControllerDelegate {
    func thumbnailGridViewController(_ thumbnailGridViewController: GTThumbnailGridViewController, didSelectPage page: PDFPage) {
        pdfView.go(to: page)
    }
}

extension GTReadViewController: GTOulineTableviewControllerDelegate {
    func oulineTableviewController(_ oulineTableviewController: GTOulineTableviewController, didSelectOutline outline: PDFOutline) {
        let action = outline.action
        if let actiongoto = action as? PDFActionGoTo {
            pdfView.go(to: actiongoto.destination)
        }
    }
}
