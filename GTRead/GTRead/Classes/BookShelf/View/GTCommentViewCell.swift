//
//  GTCommentViewCell.swift
//  GTRead
//
//  Created by YangJie on 2021/4/21.
//

import UIKit

class GTCommentViewCell: UITableViewCell {
    
    var userLabel: UILabel!
    var contentLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        userLabel = UILabel()
        userLabel.text = "测试1:"
        self.contentView.addSubview(userLabel)
        userLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        contentLabel = UILabel()
        contentLabel.text = "不错不错，66666666"
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userLabel.snp.right).offset(4)
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
