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
    var navgationBarHiddenStatu: Bool = true
    var thumbBtn: UIButton!     // 缩略图
    var outlineBtn: UIButton!   // 目录按钮
    var commentBtn: UIButton!   // 评论按钮
    
    //MARK: -PDF 相关
    private var pdfdocument: PDFDocument?
    let pdfURL: URL // pdf路径
    lazy var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal
        pdfView.usePageViewController(true, withViewOptions: [UIPageViewController.OptionsKey.interPageSpacing: 0])
        return pdfView
    }()
    
    //MARK: - 视线相关
    var eyeTrackController: EyeTrackController!
    var points = [CGPoint]()
    var trackView: UIImageView!
    
    var currentDate: TimeInterval = 0
    // pdf视图
    

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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupView() {
        // 导航条
        self.setupNavgationBar()
        
        // 视线
        self.setupGateTrackView()
        
        // pdf
        self.setupPdfView()
        
        
        
        
        // 记录进入时间
        let date = Date.init()
        currentDate = date.timeIntervalSince1970
        self.view.bringSubviewToFront(trackView)
    }
    
    func setupNavgationBar() {
        thumbBtn = UIButton(type: .custom)
        thumbBtn.setImage(UIImage(named: "thumbnails"), for: .normal)
        thumbBtn.backgroundColor = UIColor.clear
        thumbBtn.addTarget(self, action: #selector(thumbButtonDidClicked), for: .touchUpInside)
        outlineBtn = UIButton(type: .custom)
        outlineBtn.setImage(UIImage(named: "outline"), for: .normal)
        outlineBtn.backgroundColor = UIColor.clear
        outlineBtn.addTarget(self, action: #selector(outlineButtonDidClicked), for: .touchUpInside)
        commentBtn = UIButton(type: .custom)
        commentBtn.setImage(UIImage(named: "comment"), for: .normal)
        commentBtn.backgroundColor = UIColor.clear
        commentBtn.addTarget(self, action: #selector(commentButtonDidClicked), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: commentBtn),UIBarButtonItem(customView: outlineBtn),UIBarButtonItem(customView: thumbBtn)]
    }
    
    func setupPdfView() {
        self.view.addSubview(pdfView)
        pdfView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let document = PDFDocument(url: pdfURL)
        pdfView.document = document
        self.pdfdocument = document
        let page = document?.page(at: GTBook.shared.getCacheData())
        if let lastPage = page {
            pdfView.go(to: lastPage)
        }
        
        NotificationCenter.default.addObserver(self,selector: #selector(handlePageChange(notification:)), name: Notification.Name.PDFViewPageChanged, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(pdfViewTapEvent))
        pdfView.addGestureRecognizer(tap)
    }

    
    @objc private func pdfViewTapEvent() {
        navgationBarHiddenStatu = !navgationBarHiddenStatu
        self.navigationController?.setNavigationBarHidden(navgationBarHiddenStatu, animated: true)
    }

    
    //MARK: -缩略图
    @objc private func thumbButtonDidClicked() {
        navgationBarHiddenStatu = true
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20

        let width = (self.view.frame.width - 10 * 4) / 3
        let height = width * 1.5

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)

        let thumbnailGridViewController = GTThumbnailGridViewController(collectionViewLayout: layout)
        thumbnailGridViewController.pdfDocument = self.pdfdocument
        thumbnailGridViewController.delegate = self
        self.navigationController?.pushViewController(thumbnailGridViewController, animated: true)
    }

    //MARK: -目录
    @objc private func outlineButtonDidClicked() {
        navgationBarHiddenStatu = true
        if let pdfoutline = self.pdfdocument?.outlineRoot {
            let oulineViewController = GTOulineTableviewController(style: UITableView.Style.plain)
            oulineViewController.pdfOutlineRoot = pdfoutline
            oulineViewController.delegate = self

            self.navigationController?.pushViewController(oulineViewController, animated: true)
        }
    }
    
    //MARK: -评论
    @objc private func commentButtonDidClicked() {
        navgationBarHiddenStatu = true
        let commentVC = GTCommentViewController()
        self.addChild(commentVC)
        self.view.addSubview(commentVC.view)
        commentVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    

    @objc private func handlePageChange(notification: Notification){
        // 每一次翻页都保存一次进度
        GTBook.shared.cacheData()
//        var temp = Array<[String:CGFloat]>()
//        let width = UIScreen.main.bounds.width
//        let height = UIScreen.main.bounds.height
//        for point in self.points {
//            if point.x < width, point.x > 0, point.y > 0, point.y < height {
//                let dict = ["cx": point.x, "cy": point.y]
//                temp.append(dict)
//            }
//        }
//        GTNet.shared.commitGazeTrackData(starTime: currentDate, lists: temp)
//        self.points.removeAll()
    }
    private func setupGateTrackView(){
        trackView = UIImageView(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        trackView.contentMode = .scaleAspectFill
        trackView.image = UIImage(named: "track_icon")
        trackView.isHidden = true
        self.view.addSubview(trackView)
        // 获取机型的尺寸
        let deviceTypeString = Device.getDeviceType()
        let deviceType = DeviceType(rawValue: deviceTypeString)

        self.eyeTrackController = EyeTrackController(device: Device(type: deviceType ?? .iPad11), smoothingRange: 10, blinkThreshold: .infinity, isHidden: true)
        self.eyeTrackController.onUpdate = { [weak self] info in
            self?.trackView.isHidden = false
            let point = CGPoint(x: info?.centerEyeLookAtPoint.x ?? 0, y: info?.centerEyeLookAtPoint.y ?? 0)
            self?.trackView.center = point
            self?.points.append(point)
        }
        self.initialize(eyeTrack: eyeTrackController.eyeTrack)
        self.show()
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
