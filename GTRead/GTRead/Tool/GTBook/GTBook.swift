//
//  GTBook.swift
//  GTRead
//
//  Created by YangJie on 2021/3/24.
//
import PDFKit

class GTBook {
    static let shared = GTBook()
    private init() {}
    // 当前正在阅读的pdf
    var currentPdfView: PDFView?
    // 当前pdf的路径
    var pdfURL: URL?
    
    // 读取
    func getCacheData() -> Int {
        guard let path = pdfURL else {
            return 0
        }
        let key = path.absoluteString
        let lastPageCount = UserDefaults.standard.integer(forKey: key.MD5)
        return lastPageCount
    }
    
    // 保存
    func cacheData() {
        guard let pdfView = currentPdfView, let path = pdfURL else {
            return
        }
        var currentPageCount = pdfView.currentPage?.pageRef?.pageNumber ?? 0
        if currentPageCount != 0 {
            currentPageCount -= 1;
        }
        let key = path.absoluteString
        UserDefaults.standard.setValue(currentPageCount, forKey: key.MD5)
    }
}
