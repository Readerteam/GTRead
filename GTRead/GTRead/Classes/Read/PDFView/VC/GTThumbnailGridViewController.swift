//
//  GTGTThumbnailGridViewController.swift
//  GTRead
//
//  Created by YangJie on 2021/4/21.
//

import UIKit
import PDFKit

private let reuseIdentifier = "GTThumbnailGridViewCell"

protocol GTThumbnailGridViewControllerDelegate: class{
    func thumbnailGridViewController(_ thumbnailGridViewController: GTThumbnailGridViewController, didSelectPage page: PDFPage)
}

class GTThumbnailGridViewController: UICollectionViewController {

    var pdfDocument: PDFDocument?
    weak var delegate: GTThumbnailGridViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(GTThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.gray
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pdfDocument?.pageCount ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GTThumbnailCollectionViewCell
        
        if let page = pdfDocument?.page(at: indexPath.item) {
            let thumbnail = page.thumbnail(of: cell.bounds.size, for: PDFDisplayBox.cropBox)
            cell.image = thumbnail
            cell.pageLab.text = page.label
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let page = pdfDocument?.page(at: indexPath.item) {
            self.navigationController?.popViewController(animated: true)
            delegate?.thumbnailGridViewController(self, didSelectPage: page)
        }
    }

}
