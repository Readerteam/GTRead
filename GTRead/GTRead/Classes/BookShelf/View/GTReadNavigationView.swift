//
//  GTReadNavigationView.swift
//  GTRead
//
//  Created by YangJie on 2021/4/21.
//

import UIKit

class GTReadNavigationView: UIView {
    
    var backBtn: UIButton!      // 返回按钮
    var backEvent: (()->())?    // 返回按钮回调事件
    var toolView: UIView!       // 工具栏
    var thumbBtn: UIButton!     // 缩略图
    var thumbEvent: (()->())?   // 缩略图回调事件
    var outlineBtn: UIButton!   // 目录按钮
    var outlineEvent: (()->())? // 目录回调事件
    var commentBtn: UIButton!   // 评论按钮
    var commentEvent: (()->())? // 评论回调事件
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // 返回按钮
        backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "back"), for: .normal)
        backBtn.backgroundColor = UIColor.clear
        backBtn.addTarget(self, action: #selector(backButtonDidClicked), for: .touchUpInside)
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalTo(self)
            make.width.height.equalTo(20)
        }
        
        // 工具栏
        toolView = UIView()
        self.addSubview(toolView)
        toolView.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.centerY.equalTo(self)
        }
        
        // 缩略图
        thumbBtn = UIButton(type: .custom)
        thumbBtn.setImage(UIImage(named: "thumbnails"), for: .normal)
        thumbBtn.backgroundColor = UIColor.clear
        thumbBtn.addTarget(self, action: #selector(thumbButtonDidClicked), for: .touchUpInside)
        toolView.addSubview(thumbBtn)
        thumbBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        // 目录
        outlineBtn = UIButton(type: .custom)
        outlineBtn.setImage(UIImage(named: "outline"), for: .normal)
        outlineBtn.backgroundColor = UIColor.clear
        outlineBtn.addTarget(self, action: #selector(outlineButtonDidClicked), for: .touchUpInside)
        toolView.addSubview(outlineBtn)
        outlineBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.thumbBtn.snp.right).offset(10)
            make.width.height.equalTo(20)
        }
        
        // 评论
        commentBtn = UIButton(type: .custom)
        commentBtn.setImage(UIImage(named: "comment"), for: .normal)
        commentBtn.backgroundColor = UIColor.clear
        commentBtn.addTarget(self, action: #selector(commentButtonDidClicked), for: .touchUpInside)
        toolView.addSubview(commentBtn)
        commentBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.outlineBtn.snp.right).offset(10)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(20)
        }
    }
    
    //MARK: - 返回
    @objc private func backButtonDidClicked() {
        if let block = backEvent {
            block()
        }
    }
    
    //MARK: -缩略图
    @objc private func thumbButtonDidClicked() {
        if let block = thumbEvent {
            block()
        }
    }

    //MARK: -目录
    @objc private func outlineButtonDidClicked() {
        if let block = outlineEvent {
            block()
        }
    }
    
    //MARK: -评论
    @objc private func commentButtonDidClicked() {
        if let block = commentEvent {
            block()
        }
    }
}
