//
//  GTTabBarViewController.swift
//  GTRead
//
//  Created by YangJie on 2021/2/20.
//

import UIKit
import SwiftUI

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
        
        // 分析
        let analyseNav = GTBaseNavigationViewController(rootViewController: UIHostingController(rootView: GTAnalyseView()))
        let analyseItem = UITabBarItem(title: "分析", image: UIImage(named: "analyse"), selectedImage: UIImage(named: "analyse_selected"))
        analyseNav.tabBarItem = analyseItem
        
        // 个人
        let mineNav = GTBaseNavigationViewController(rootViewController: UIHostingController(rootView: GTMineView()))
        let mineItem = UITabBarItem(title: "个人", image: UIImage(named: "mine"), selectedImage: UIImage(named: "mine_selected"))
        mineNav.tabBarItem = mineItem
        
        self.viewControllers = [bookNav, analyseNav, mineNav]
    }
}

extension UITabBar {
    public override var traitCollection: UITraitCollection {
        var newTraitCollection: [UITraitCollection] = [super.traitCollection]
        // I need to force size class on iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            newTraitCollection += [UITraitCollection(verticalSizeClass: .regular), UITraitCollection(horizontalSizeClass: .compact)]
        }
        return UITraitCollection(traitsFrom: newTraitCollection)
    }
}
