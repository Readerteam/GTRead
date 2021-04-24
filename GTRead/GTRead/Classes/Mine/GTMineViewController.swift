//
//  GTMineViewController.swift
//  GTRead
//
//  Created by YangJie on 2021/2/20.
//

import UIKit
import SDWebImage

var profileHeight = 120.0
var otherHeight = 60.0

class GTMineViewController: GTBaseViewController ,UITableViewDataSource, UITableViewDelegate {
    
    var tableView:UITableView!
    var profileImageView: UIImageView!
    var titleLabel : UILabel!
    var profileImageUrl = ""

    var cellTitle = [["登录"], ["消息通知", "最近浏览"], ["皮肤", "夜间模式"], ["设置"]]
    var cellImage = [["profile"], ["information", "browse"], ["skin", "night"], ["setting"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "个人"
        self.view.backgroundColor = UIColor.white

        tableView = UITableView(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        // 监听通知
        DispatchQueue.main.async {
            self.listenLoginNotifications()
        }
    }
    
    // 请求账户的个人信息
    @objc func requestAccountInfo() {
        let params = ["userId" : UserDefaultKeys.AccountInfo.account] as [String : Any]
        
        GTNet.shared.requestWith(url: "http://121.4.52.206:8000/loginService/userInfoFun", httpMethod: .post, params: params) { (json) in
            debugPrint(json)
            DispatchQueue.main.sync {
                self.cellTitle[0] = [json["nickName"] as! String]
                self.profileImageUrl = json["headImgUrl"] as! String
                self.tableView.reloadData()
            }
        } error: { (error) in
            debugPrint(error)
        }
    }
    
    // 监听登录页面发送的通知
    func listenLoginNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(requestAccountInfo), name:NSNotification.Name(rawValue:"LoginSuccessfulNotification"), object: nil)
    }
    
    // cell分组
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellTitle.count
    }
    
    //对应每个分组下的列表数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellImage[section].count
    }
    
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(profileHeight)
        } else {
            return CGFloat(otherHeight)
        }
    }
    
    // 设置Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let identifier = "CustomCell"
        let cell = CustomTableView.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
            
            if indexPath.section == 0 {
                // 头像
                profileImageView = UIImageView(frame: CGRect(x:10, y: 10, width: profileHeight - 30, height: profileHeight - 30))
                profileImageView?.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: UIImage(named: "profile"))
                profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2.0;
                profileImageView.layer.masksToBounds = true
                
                // 标题
                titleLabel = UILabel(frame: CGRect(x: 20 + profileHeight, y: 0, width: Double(cell.frame.size.width-(profileImageView?.frame.size.width)!)+20.0, height: profileHeight - 5))
                titleLabel.textColor = UIColor.black
                titleLabel.text = cellTitle[0][0]
                
                cell.addSubview(titleLabel!)
                cell.addSubview(profileImageView!)

            } else {
                cell.accessoryType = .disclosureIndicator
                cell.setUpUI(cellTitle[indexPath.section][indexPath.row], cellImage[indexPath.section][indexPath.row], otherHeight)
            }
            
            return cell
    }
    
    // cell点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch indexPath.section {
            case 0:
                if UserDefaultKeys.LoginStatus.isLogin == false {
                    let vc = LoginViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            default:
                break
            }
    }

}
