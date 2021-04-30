//
//  Common.swift
//  GTRead
//
//  Created by Dev on 2021/4/22.
//

import Foundation

// 全局通知定义
/// 登录成功后发送给个人主页的一个通知
let LoginSuccessfulNotification = Notification.Name(rawValue: "LoginSuccessfulNotification")
/// 注册成功后发送给登录页面的一个通知
let RegisterSuccessfulNotification = Notification.Name(rawValue: "RegisterSuccessfulNotification")

// 用户信息
struct UserDefaultKeys {
    // 账户信息
    struct AccountInfo {
        static var userName = "Login"
        static var password = ""
        static var account = ""
        static var imageUrl = ""
    }
    
    // 登录状态
    struct LoginStatus {
        static var isLogin = false
    }
}
