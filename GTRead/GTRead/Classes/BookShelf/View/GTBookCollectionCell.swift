//
//  GTBookCollectionCell.swift
//  GTRead
//
//  Created by YangJie on 2021/3/22.
//

import UIKit

class GTBookCollectionCell: UICollectionViewCell {
    let pdfImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    

    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)

        self.addSubview(pdfImageView)
        pdfImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateData(image: UIImage) {
        pdfImageView.image = image
        print(image.size)
    }
}
