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
    //MARK: -PDF 相关
    private var pdfdocument: PDFDocument?
    let pdfURL: URL // pdf路径
    // pdf视图
    lazy var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal
        pdfView.usePageViewController(true, withViewOptions: [UIPageViewController.OptionsKey.interPageSpacing: 20])
        return pdfView
    }()
    
    // 导航条
    lazy var navgationBar: GTReadNavigationView = {
        let view = GTReadNavigationView()
        view.backgroundColor = UIColor.white
        return view
    }()
    var navgationBarTopMargin = -70
    
    var eyeTrackController: EyeTrackController!
    var trackView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "track_icon")
        view.isHidden = true
        return view
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
        let document = PDFDocument(url: pdfURL)
        pdfView.document = document
        self.pdfdocument = document
        let page = document?.page(at: GTBook.shared.getCacheData())
        if let lastPage = page {
            pdfView.go(to: lastPage)
        }
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
        
        self.view.addSubview(navgationBar)
        navgationBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(navgationBarTopMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        self.view.addSubview(pdfView)
        self.view.addSubview(trackView)
        pdfView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pdfViewTapEvent))
        pdfView.addGestureRecognizer(tap)
        
        self.view.bringSubviewToFront(navgationBar)
        self.eyeTrackController = EyeTrackController(device: Device(type: .iPad), smoothingRange: 10, blinkThreshold: .infinity, isHidden: true)
        self.eyeTrackController.onUpdate = { [weak self] info in
            self?.trackView.isHidden = false
            self?.trackView.center = CGPoint(x: info?.centerEyeLookAtPoint.x ?? 0, y: info?.centerEyeLookAtPoint.y ?? 0)
        }
        self.initialize(eyeTrack: eyeTrackController.eyeTrack)
        self.show()
        self.view.sendSubviewToBack(self.sceneView)
    }
    
    
    
    @objc private func pdfViewTapEvent() {
        /// 告诉self.view约束需要更新
        self.view.needsUpdateConstraints()
        /// 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
        self.view.updateConstraintsIfNeeded()
        /// 更新动画
        self.navgationBarTopMargin =  self.navgationBarTopMargin > 0 ? -70 : 20
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.navgationBar.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(self.navgationBarTopMargin)
            }
        })
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
