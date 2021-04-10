//
//  ChangeSkinViewCollectionView.swift
//  GTRead
//
//  Created by Dev on 2021/4/11.
//

import UIKit

class ChangeSkinCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        let layout = UICollectionViewFlowLayout()
        
        //每个元素的大小
        layout.itemSize = CGSize(width: (frame.width - 60)/3, height: (frame.width)/3 + 20)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.footerReferenceSize = CGSize(width: frame.width, height: 50)
        layout.headerReferenceSize = CGSize(width: frame.width, height: 50)
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.clear
        self.register(ChangeSkinViewControllerViewCell.self, forCellWithReuseIdentifier: "cell")
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

