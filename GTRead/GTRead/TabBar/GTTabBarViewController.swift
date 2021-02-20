//
//  GTTabBarViewController.swift
//  GTRead
//
//  Created by YangJie on 2021/2/20.
//

import UIKit

class GTTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.createControllers()
    }
    
    func createControllers() {
        
        // 书架
        let bookShelf = GTBookShelfViewController()
        let bookItem = UITabBarItem(title: "书架", image: UIImage(named: ""), selectedImage: UIImage(named: ""))
        bookShelf.tabBarItem = bookItem
        
        // 个人
        let mineVC = GTMineViewController()
        let mineItem = UITabBarItem(title: "个人", image: UIImage(named: ""), selectedImage: UIImage(named: ""))
        mineVC.tabBarItem = mineItem
        
        self.viewControllers = [bookShelf, mineVC]
    }
}
