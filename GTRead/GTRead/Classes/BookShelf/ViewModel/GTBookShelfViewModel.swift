//
//  GTBookShelfViewModel.swift
//  GTRead
//
//  Created by YangJie on 2021/3/21.
//

import UIKit
import PDFKit

class GTBookShelfViewModel: NSObject {
    
    let collectionView: UICollectionView
    let viewController: GTBaseViewController
    let kGTScreenWidth = UIScreen.main.bounds.width
    let KGTScreenHeight = UIScreen.main.bounds.height
    let itemMargin: CGFloat = 16
    let itemCountInRow = 3;
    var images = [UIImage]()
    var pdfURLs = [URL]()
    var itemWidth: CGFloat = 0
    var itemHeight: CGFloat = 0
    
    
    init(viewController: GTBaseViewController,collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.viewController = viewController
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        createBookShelfData()
        collectionView.reloadData()
    }
    
    
    private func createBookShelfData() {
        
        var width = kGTScreenWidth - 16 * 2 - (CGFloat(itemCountInRow - 1) * itemMargin)
        
        width = floor(width/CGFloat(itemCountInRow))
        
        let height = floor(width * 6 / 5.0)
        
        itemWidth = width
        itemHeight = height
        
        for i in 0...4 {
            let path = Bundle.main.url(forResource: "\(i)", withExtension: ".pdf")
            guard let pdf = path else {
                continue
            }
            pdfURLs.append(pdf)
            let document = PDFDocument(url:pdf)
            let page = document?.page(at: 0)
            let thumbnail = page?.thumbnail(of: CGSize(width: width, height: height), for: .cropBox)
            guard let image = thumbnail else {
                continue
            }
            images.append(image)
        }
    }
}

extension GTBookShelfViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCollectioncell", for: indexPath) as! GTBookCollectionCell
        if self.images.count > indexPath.row {
            let image = self.images[indexPath.row]
            cell.updateData(image: image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.pdfURLs.count > indexPath.row {
            let vc = GTReadViewController(path: self.pdfURLs[indexPath.row])
            self.viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension GTBookShelfViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemMargin
    }
}
