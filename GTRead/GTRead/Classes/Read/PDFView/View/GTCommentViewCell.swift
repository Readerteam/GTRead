//
//  GTCommentViewCell.swift
//  GTRead
//
//  Created by YangJie on 2021/4/21.
//

import UIKit

class GTCommentViewCell: UITableViewCell {
    
    var userLabel: UILabel!
    var contentLabel: UILabel!
    var tableView: UITableView!
    var itemModel: GTCommentItem?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        userLabel = UILabel()
        userLabel.text = "测试1:"
        userLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.contentView.addSubview(userLabel)
        userLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalToSuperview()
            make.height.equalTo(20)
        }
        
        contentLabel = UILabel()
        contentLabel.text = "不错不错，66666666"
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(userLabel.snp.right).offset(4)
            make.right.lessThanOrEqualTo(-16)
            make.top.equalToSuperview()
            make.height.equalTo(20)
        }
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(GTCommentViewCell.self, forCellReuseIdentifier: "GTSubCommentViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.bottom.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(-16);
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithData(model: GTCommentItem) {
        itemModel = model
        userLabel.text = model.author?["userId"]
        contentLabel.text = model.commentContent
    }
}

extension GTCommentViewCell : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let childCount = itemModel?.childCnt else {
            return 0
        }
        return childCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GTSubCommentViewCell", for: indexPath) as! GTCommentViewCell
        if itemModel?.childComments?.count ?? 0 > indexPath.row {
            guard let childList = itemModel?.childComments else {
                return cell
            }
            let item = childList[indexPath.row]
            cell.updateWithData(model: item)
        }
        return cell
    }
    
    
}
