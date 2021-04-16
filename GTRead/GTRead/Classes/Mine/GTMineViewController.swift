//
//  GTMineViewController.swift
//  GTRead
//
//  Created by YangJie on 2021/2/20.
//

import UIKit

var profileHeight = 120.0
var otherHeight = 80.0

class GTMineViewController: UITableViewController{
    
    var cellTitle: [String] = ["登录", "消息通知", "最近浏览", "皮肤", "夜间模式", "设置"]
    var cellImage: [String] = ["profile", "information", "browse", "skin", "night" ,"setting"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        
        // 导航条设置
        self.title = "个人"
        self.tableView.tableFooterView = UIView()
    }
    
    // Cell的数量
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitle.count
    }
    
    // 行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(profileHeight)
        } else {
            return CGFloat(otherHeight)
        }
    }
    
    // 设置Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let identifier = "CustomCell"
            let cell = CustomTableView.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        
            cell.layoutMargins.top = 10
            cell.layoutMargins.bottom = 10
        
            if indexPath.row == 0 {
                cell.setUpUI(cellTitle[indexPath.row], cellImage[indexPath.row], profileHeight)
            } else {
                cell.setUpUI(cellTitle[indexPath.row], cellImage[indexPath.row], otherHeight)
            }
            
            return cell
    }
    
    // cell点击事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch indexPath.row {
            case 0:
                let vc = LoginViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let vc = GTBookShelfViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 3:
                let vc = ChangeSkinViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
            }
    }

}
