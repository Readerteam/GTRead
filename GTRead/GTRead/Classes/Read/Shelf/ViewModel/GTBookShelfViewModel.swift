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
    var isEditing: Bool = false
    var isSeletedAll: Bool = false
    var seletedImages = [UIImage]()
    var seletedEvent: ((_ count: Int)->())?
    
    
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
    
    func reloadBookDate() {
        self.createBookShelfData()
        self.collectionView.reloadData()
    }
    // 开启编辑
    func startEditing(isEditIng: Bool) {
        self.isEditing = isEditIng
        self.collectionView.reloadData()
    }
    // 取消选中
    func cancelEditing() {
        seletedImages.removeAll()
        self.isEditing = false
        self.isSeletedAll = false
        self.collectionView.reloadData()
    }
    // 选中全部
    func seletedAll() {
        seletedImages.removeAll()
        seletedImages = images
        self.isEditing = true
        self.isSeletedAll = true
        self.collectionView.reloadData()
        seletedEvent?(seletedImages.count)
    }
    
    // 删除
    func deleteImages() {
        images = images.filter({!seletedImages.contains($0)})
        self.cancelEditing()
        self.collectionView.reloadData()
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
            if isEditing {
                cell.StartEdit()
                if isSeletedAll {
                    cell.hiddenRightImageView(hidden: false)
                }
            }else{
                cell.endEdit()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.pdfURLs.count > indexPath.row {
            if self.isEditing {
                let cell = collectionView.cellForItem(at: indexPath) as! GTBookCollectionCell
                cell.hiddenRightImageView(hidden: cell.selectedStatu)
                if cell.selectedStatu {
                    // 选中
                    seletedImages.append(images[indexPath.row])
                }else{
                    // 取消选中
                    let image = images[indexPath.row]
                    seletedImages.removeAll(where: {$0 == image})
                }
                seletedEvent?(seletedImages.count)
            }else{
                let vc = GTReadViewController(path: self.pdfURLs[indexPath.row])
                vc.hidesBottomBarWhenPushed = true;
                self.viewController.navigationController?.pushViewController(vc, animated: true)
            }
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
