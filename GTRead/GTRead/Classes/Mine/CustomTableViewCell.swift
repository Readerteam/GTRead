//
//  CustomTableViewCell.swift
//  GTRead
//
//  Created by Dev on 2021/4/10.
//

import UIKit

class CustomTableView: UITableViewCell {
    
    // 设置Cell的图标和标题
    var iconImage  : UIImageView?
    var titleLabel : UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setUpUI(_ cellTitle: String, _ image: String, _ height: Double){
        
        iconImage = UIImageView(frame: CGRect(x:10, y: 5, width: height - 30, height: height - 30))
        self.addSubview(iconImage!)
        
        // 标题
        titleLabel = UILabel(frame: CGRect(x: 20 + height, y: 0, width: Double(self.frame.size.width-(iconImage?.frame.size.width)!)+20.0, height: height - 5))
        titleLabel?.textColor = UIColor.black
        self.addSubview(titleLabel!)
        
        // 添加图片和标题
        iconImage?.image = UIImage(named: image)
        titleLabel?.text = cellTitle
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
