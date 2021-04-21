//
//  GTCommentViewController.swift
//  GTRead
//
//  Created by YangJie on 2021/4/21.
//

import UIKit

class GTCommentViewController: GTBaseViewController {
    var contentView: UIView!
    var titleView: UIView!
    var closeBtn: UIButton!
    var titleLabel: UILabel!
    var tableView: UITableView!
    var commentView: UIView!
    var sendBtn: UIButton!
    var textField: UITextField!
    var emptyView: UIImageView = {
        let imageview = UIImageView()
        imageview.isUserInteractionEnabled = false
        imageview.contentMode = .scaleAspectFill
        imageview.image = UIImage(named: "comment_empty")
        return imageview
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        contentView = UIView()
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(resignTextField))
        contentView.addGestureRecognizer(tap)
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.top.equalTo(88)
            make.bottom.equalTo(-98)
        }
        
        titleView = UIView()
        titleView.backgroundColor = UIColor.white
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        
        closeBtn = UIButton(type: .custom)
        closeBtn.setImage(UIImage(named: "comment_close"), for: .normal)
        closeBtn.backgroundColor = UIColor.white
        closeBtn.addTarget(self, action: #selector(closeButtonDidClicked), for: .touchUpInside)
        titleView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "本章评论"
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        contentView.addSubview(emptyView)
        emptyView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(300)
        }
        
        commentView = UIView()
        commentView.backgroundColor = UIColor.white
        contentView.addSubview(commentView)
        commentView.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.bottom.equalTo(-32)
            make.height.equalTo(50)
        }
        
        sendBtn = UIButton(type: .custom)
        sendBtn.setImage(UIImage(named: "comment_send"), for: .normal)
        sendBtn.addTarget(self, action: #selector(sendButtonDidClicked), for: .touchUpInside)
        commentView.addSubview(sendBtn)
        sendBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.centerY.equalTo(commentView)
            make.width.equalTo(30)
            make.height.equalTo(40)
        }
        
        textField = UITextField()
        textField.placeholder = "开始评论吧！"
        textField.borderStyle = .roundedRect;
        commentView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalTo(commentView)
            make.right.equalTo(sendBtn.snp.left).offset(-8)
            make.height.equalTo(40)
        }
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(GTCommentViewCell.self, forCellReuseIdentifier: "GTCommentViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.bottom.equalTo(commentView.snp.top)
            make.left.equalTo(16)
            make.right.equalTo(-16);
        }
    }
    
    @objc private func closeButtonDidClicked() {
        self.view.removeFromSuperview()
    }
    
    @objc private func sendButtonDidClicked() {
        // 发送请求
        
    }
    
    @objc private func resignTextField() {
        textField.resignFirstResponder()
    }

}

extension GTCommentViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GTCommentViewCell", for: indexPath) as! GTCommentViewCell
        return cell
    }
    
    
}
