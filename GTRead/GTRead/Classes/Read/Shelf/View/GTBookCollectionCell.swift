//
//  GTBookCollectionCell.swift
//  GTRead
//
//  Created by YangJie on 2021/3/22.
//

import UIKit

class GTBookCollectionCell: UICollectionViewCell {
    
    lazy var selectedStatu: Bool = false
    
    lazy var pdfImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "shelf_circle")
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "shelf_right")
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var grayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.alpha = 0.3
        view.isHidden = true
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)

        self.contentView.addSubview(pdfImageView)
        self.contentView.addSubview(grayView)
        self.contentView.addSubview(circleImageView)
        self.contentView.addSubview(rightImageView)
        pdfImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        grayView.snp.makeConstraints { (make) in
            make.edges.equalTo(pdfImageView)
        }
        circleImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
        rightImageView.snp.makeConstraints { (make) in
            make.center.equalTo(circleImageView)
            make.width.height.equalTo(10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(image: UIImage) {
        pdfImageView.image = image
        print(image.size)
    }
    
    // 开启编辑模式
    func StartEdit() {
        selectedStatu = false
        grayView.isHidden = false
        circleImageView.isHidden = false
    }
    // 关闭编辑模式
    func endEdit() {
        grayView.isHidden = true
        circleImageView.isHidden = true
        rightImageView.isHidden = true
    }
    // 选中与非选中
    func hiddenRightImageView(hidden: Bool) {
        selectedStatu = !hidden
        rightImageView.isHidden = hidden
    }
}
