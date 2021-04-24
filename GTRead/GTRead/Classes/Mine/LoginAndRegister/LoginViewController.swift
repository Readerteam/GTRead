//
//  LoginViewController.swift
//  GTRead
//
//  Created by Dev on 2021/4/10.
//

import UIKit
import SwiftUI

class LoginViewController: GTBaseViewController, UITextFieldDelegate {
    
    // 忘记密码、注册账号、登录按钮
    var forgetPassword: UIButton!
    var registerAccountBtn: UIButton!
    var loginBtn: UIButton!
    
    //用户密码输入框
    var txtUser: UITextField!
    var txtPwd: UITextField!
    
    //左手离脑袋的距离
    var offsetLeftHand: CGFloat = 60
    
    //左手图片,右手图片(遮眼睛的)
    var imgLeftHand:UIImageView!
    var imgRightHand:UIImageView!
        
    //左手图片,右手图片(圆形的)
    var imgLeftHandGone:UIImageView!
    var imgRightHandGone:UIImageView!
        
    //登录框状态
    var showType:LoginShowType = LoginShowType.NONE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.title = "用户登录"

        //获取屏幕尺寸
        let mainSize = UIScreen.main.bounds.size
            
        //猫头鹰头部
        let imgLogin =  UIImageView(frame:CGRect(x: mainSize.width/2-211/2, y: 100, width: 211, height: 109))
        imgLogin.image = UIImage(named:"owl-login")
        imgLogin.layer.masksToBounds = true
        self.view.addSubview(imgLogin)
            
        //猫头鹰左手(遮眼睛的)
        let rectLeftHand = CGRect(x: 61 - offsetLeftHand, y: 90, width: 40, height: 65)
        imgLeftHand = UIImageView(frame:rectLeftHand)
        imgLeftHand.image = UIImage(named:"owl-login-arm-left")
        imgLogin.addSubview(imgLeftHand)
            
        //猫头鹰右手(遮眼睛的)
        let rectRightHand = CGRect(x: imgLogin.frame.size.width / 2 + 60, y: 90, width: 40, height: 65)
        imgRightHand = UIImageView(frame:rectRightHand)
        imgRightHand.image = UIImage(named:"owl-login-arm-right")
        imgLogin.addSubview(imgRightHand)
            
        //登录框背景
        let vLogin =  UIView(frame:CGRect(x: 15, y: 200, width: mainSize.width - 30, height: 160))
        vLogin.layer.borderWidth = 0.5
        vLogin.layer.borderColor = UIColor.lightGray.cgColor
        vLogin.backgroundColor = UIColor.white
        self.view.addSubview(vLogin)
            
        //猫头鹰左手(圆形的)
        let rectLeftHandGone = CGRect(x: mainSize.width / 2 - 100,
                                      y: vLogin.frame.origin.y - 22, width: 40, height: 40)
        imgLeftHandGone = UIImageView(frame:rectLeftHandGone)
        imgLeftHandGone.image = UIImage(named:"icon_hand")
        self.view.addSubview(imgLeftHandGone)
            
        //猫头鹰右手(圆形的)
        let rectRightHandGone = CGRect(x: mainSize.width / 2 + 62,
                                       y: vLogin.frame.origin.y - 22, width: 40, height: 40)
        imgRightHandGone = UIImageView(frame:rectRightHandGone)
        imgRightHandGone.image = UIImage(named:"icon_hand")
        self.view.addSubview(imgRightHandGone)
            
        //用户名输入框
        txtUser = UITextField(frame:CGRect(x: 30, y: 30, width: vLogin.frame.size.width - 60, height: 44))
        txtUser.delegate = self
        txtUser.layer.cornerRadius = 5
        txtUser.layer.borderColor = UIColor.lightGray.cgColor
        txtUser.layer.borderWidth = 0.5
        txtUser.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        txtUser.leftViewMode = UITextField.ViewMode.always
            
        //用户名输入框左侧图标
        let imgUser =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgUser.image = UIImage(named:"icon_account")
        txtUser.leftView!.addSubview(imgUser)
        vLogin.addSubview(txtUser)
            
        //密码输入框
        txtPwd = UITextField(frame:CGRect(x: 30, y: 90, width: vLogin.frame.size.width - 60, height: 44))
        txtPwd.delegate = self
        txtPwd.layer.cornerRadius = 5
        txtPwd.layer.borderColor = UIColor.lightGray.cgColor
        txtPwd.layer.borderWidth = 0.5
        txtPwd.isSecureTextEntry = true
        txtPwd.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        txtPwd.leftViewMode = UITextField.ViewMode.always
            
        //密码输入框左侧图标
        let imgPwd =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgPwd.image = UIImage(named:"icon_password")
        txtPwd.leftView!.addSubview(imgPwd)
        vLogin.addSubview(txtPwd)
        
        // 忘记密码
        forgetPassword = UIButton(frame:CGRect(x: 45, y: 400, width: 80, height: 40))
        forgetPassword.setTitle("忘记密码", for: .normal)
        forgetPassword.setTitleColor(UIColor.red, for: .normal)
        self.view.addSubview(forgetPassword)
        
        // 注册账号
        registerAccountBtn = UIButton(frame:CGRect(x: 45 + txtUser.frame.size.width - 80, y: 400, width: 80, height: 40))
        registerAccountBtn.setTitle("注册账号", for: .normal)
        registerAccountBtn.setTitleColor(UIColor.red, for: .normal)
        self.view.addSubview(registerAccountBtn)
        
        // 登录按钮
        loginBtn = UIButton(frame:CGRect(x: 45, y: 480, width: vLogin.frame.size.width - 60, height: 60))
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.backgroundColor = UIColor.systemBlue
        self.view.addSubview(loginBtn)
        
        // 登录按钮点击事件
        loginBtn.addTarget(self, action: #selector(loginAccount), for: .touchUpInside)
        
        // 注册按钮事件
        registerAccountBtn.addTarget(self, action: #selector(registerAccount), for: .touchUpInside)
    }
    
    // 登录账户
    @IBAction func loginAccount() {
        let params = ["userId" : txtUser.text ?? "", "userPwd" : txtPwd.text ?? ""] as [String : Any]
        GTNet.shared.requestWith(url:"http://121.4.52.206:8000/loginService/loginFun", httpMethod: .post,params: params) {(json) in
            debugPrint(json)
            if let code = json["code"], code as! Int == 1 {
                debugPrint(code)
                
                UserDefaultKeys.LoginStatus.isLogin = true
                
                // 登录成功，切换至个人主页
                DispatchQueue.main.async {
                    UserDefaultKeys.AccountInfo.account = self.txtUser.text ?? ""
                    UserDefaultKeys.AccountInfo.password = self.txtPwd.text ?? ""
                    self.navigationController?.popToRootViewController(animated:true)
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue:"LoginSuccessfulNotification"), object: self)
                }
                
            } else {
                
                // 登录失败
                let errorInfo = json["errorRes"]
                let p = UIAlertController(title: "登录失败", message: errorInfo as?String, preferredStyle: .alert)
                p.addAction(UIAlertAction(title: "OK", style: .default, handler:{(act:UIAlertAction)in self.txtPwd.text=""}))
                DispatchQueue.main.async {
                    self.present(p,animated: true,completion: nil)
                }
            }
        } error: { (error) in
            debugPrint(error)
        }
    }
    
    // 注册账户
    @IBAction func registerAccount() {
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(self.toLoginView), name:NSNotification.Name(rawValue:"RegisterSuccessfulNotification"), object: nil)
        }
        self.navigationController?.pushViewController(UIHostingController(rootView: RegisterAccountView()), animated: true)
    }
    
    // 从注册页面跳转到登录页面
    @IBAction func toLoginView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //输入框获取焦点开始编辑
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        //如果当前是用户名输入
        if textField.isEqual(txtUser){
            if (showType != LoginShowType.PASS)
            {
                showType = LoginShowType.USER
                return
            }
            showType = LoginShowType.USER
                
            //播放不遮眼动画
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.imgLeftHand.frame = CGRect(
                    x: self.imgLeftHand.frame.origin.x - self.offsetLeftHand,
                    y: self.imgLeftHand.frame.origin.y + 30,
                    width: self.imgLeftHand.frame.size.width, height: self.imgLeftHand.frame.size.height)
                self.imgRightHand.frame = CGRect(
                    x: self.imgRightHand.frame.origin.x + 48,
                    y: self.imgRightHand.frame.origin.y + 30,
                    width: self.imgRightHand.frame.size.width, height: self.imgRightHand.frame.size.height)
                self.imgLeftHandGone.frame = CGRect(
                    x: self.imgLeftHandGone.frame.origin.x - 70,
                    y: self.imgLeftHandGone.frame.origin.y, width: 40, height: 40)
                self.imgRightHandGone.frame = CGRect(
                    x: self.imgRightHandGone.frame.origin.x + 30,
                    y: self.imgRightHandGone.frame.origin.y, width: 40, height: 40)
            })
        }
        //如果当前是密码名输入
        else if textField.isEqual(txtPwd){
            if (showType == LoginShowType.PASS)
            {
                showType = LoginShowType.PASS
                return
            }
            showType = LoginShowType.PASS
                
            //播放遮眼动画
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.imgLeftHand.frame = CGRect(
                    x: self.imgLeftHand.frame.origin.x + self.offsetLeftHand,
                    y: self.imgLeftHand.frame.origin.y - 30,
                    width: self.imgLeftHand.frame.size.width, height: self.imgLeftHand.frame.size.height)
                self.imgRightHand.frame = CGRect(
                    x: self.imgRightHand.frame.origin.x - 48,
                    y: self.imgRightHand.frame.origin.y - 30,
                    width: self.imgRightHand.frame.size.width, height: self.imgRightHand.frame.size.height)
                self.imgLeftHandGone.frame = CGRect(
                    x: self.imgLeftHandGone.frame.origin.x + 70,
                    y: self.imgLeftHandGone.frame.origin.y, width: 0, height: 0)
                self.imgRightHandGone.frame = CGRect(
                    x: self.imgRightHandGone.frame.origin.x - 30,
                    y: self.imgRightHandGone.frame.origin.y, width: 0, height: 0)
            })
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//登录框状态枚举
enum LoginShowType {
    case NONE
    case USER
    case PASS
}
