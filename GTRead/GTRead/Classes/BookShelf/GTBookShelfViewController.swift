//
//  GTBookShelfViewController.swift
//  GTRead
//
//  Created by YangJie on 2021/2/20.
//

import UIKit

class GTBookShelfViewController: GTBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        
        // 导航条设置
        self.title = "书架"
        
    }
}
