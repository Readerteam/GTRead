//
//  GTOulineTableViewCell.swift
//  GTRead
//
//  Created by YangJie on 2021/4/21.
//

import UIKit

class GTOulineTableViewCell: UITableViewCell {
    var openBtn: UIButton!
    var textLab: UILabel!
    var pageLab: UILabel!
    var openBtnEvent:((_ sender: UIButton) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        openBtn = UIButton(type: .custom)
        openBtn.addTarget(self, action: #selector(openButtontnClick(sender:)), for: .touchUpInside)
        self.contentView.addSubview(openBtn)
        let leftOffset = indentationWidth * CGFloat(indentationLevel)
        openBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(leftOffset)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        pageLab = UILabel()
        pageLab.textAlignment = .left
        self.contentView.addSubview(pageLab)
        self.pageLab .setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        pageLab.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        textLab = UILabel()
        textLab.textAlignment = .left
        self.contentView.addSubview(textLab)
        textLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.openBtn.snp.right).offset(4)
            make.right.lessThanOrEqualTo(self.pageLab.snp.left).offset(4)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func openButtontnClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        openBtnEvent?(sender)
    }
}
