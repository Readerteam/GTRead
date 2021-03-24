//
//  GTReadViewController.swift
//  GTRead
//
//  Created by YangJie on 2021/3/22.
//

import UIKit
import PDFKit

class GTReadViewController: GTBaseViewController {
    // pdf路径
    let pdfURL: URL
    
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
    lazy var navgationBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    // 返回按钮
    lazy var backButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("返回", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = UIColor.white
        return btn
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
        let page = document?.page(at: GTBook.shared.getCacheData())
        if let lastPage = page {
            pdfView.go(to: lastPage)
        }
    }
    
    func setupView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(navgationBar)
        self.view.addSubview(pdfView)
        
        let navHeight = self.navigationController?.navigationBar.frame.height ?? 0
        navgationBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(navHeight)
        }
        pdfView.snp.makeConstraints { (make) in
            make.top.equalTo(navgationBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        navgationBar.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalToSuperview().offset(10)
            make.width.height.equalTo(40);
        }
        backButton.addTarget(self, action: #selector(backButtonDidClicked), for: .touchUpInside)
    }
    
    @objc func backButtonDidClicked() {
        GTBook.shared.cacheData()
        // 退出
        self.navigationController?.popViewController(animated: true)
    }
    
}
