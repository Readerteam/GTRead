//
//  GTThumbnailCollectionViewCell.swift
//  GTRead
//
//  Created by YangJie on 2021/4/21.
//

import UIKit

class GTThumbnailCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    var pageLab: UILabel!
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        pageLab = UILabel()
        pageLab.textAlignment = .center
        self.contentView.addSubview(pageLab)
        pageLab.snp.makeConstraints { (make) in
            make.left.right.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
