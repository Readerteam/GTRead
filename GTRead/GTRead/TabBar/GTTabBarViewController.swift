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
        
        self.tabBar.tintColor = UIColor.black
        // 书架
        let bookNav = GTBaseNavigationViewController(rootViewController: GTBookShelfViewController())
        let bookItem = UITabBarItem(title: "书架", image: UIImage(named: "shelf"), selectedImage: UIImage(named: "shelf_selected"))
        bookNav.tabBarItem = bookItem
        
        // 个人
        let mineNav = GTBaseNavigationViewController(rootViewController: GTMineViewController())
        let mineItem = UITabBarItem(title: "个人", image: UIImage(named: "mine"), selectedImage: UIImage(named: "mine_selected"))
        mineNav.tabBarItem = mineItem
        
        self.viewControllers = [bookNav, mineNav]
    }
}

extension UITabBar {
    open override var traitCollection: UITraitCollection{
        return UITraitCollection(horizontalSizeClass: .compact)
    }
}
