//
//  ChangeSkinViewControllerViewCell.swift
//  GTRead
//
//  Created by Dev on 2021/4/11.
//

import UIKit

class ChangeSkinViewControllerViewCell: UICollectionViewCell {
    
    var title: UILabel!
    var btnView: UIButton!
    var blur: UIVisualEffectView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        btnView = UIButton()
        btnView.frame = CGRect(x: 10, y: 10, width:bounds.size.width, height: bounds.size.width)
        
        blur = UIVisualEffectView(frame: CGRect(x: 10, y: 10, width:bounds.size.width, height:bounds.size.width))
        
        title = UILabel(frame: CGRect(x: 0, y: btnView.frame.origin.y + btnView.frame.size.width + 10, width: self.bounds.size.width, height: 20))
        title.textAlignment = .center
        
        addSubview(btnView)
        addSubview(title)
        addSubview(blur)
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
