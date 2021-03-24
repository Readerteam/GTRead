//
//  GTReadViewController.swift
//  GTRead
//
//  Created by YangJie on 2021/3/22.
//

import UIKit
import PDFKit

class GTReadViewController: GTBaseViewController {
    let pdfURL: URL
    lazy var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal
        pdfView.usePageViewController(true, withViewOptions: [UIPageViewController.OptionsKey.interPageSpacing: 20])
        return pdfView
    }()
    
    init(path: URL) {
        pdfURL = path
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(pdfView)
        self.pdfView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let document = PDFDocument(url: pdfURL)
        pdfView.document = document
    }
    
}
