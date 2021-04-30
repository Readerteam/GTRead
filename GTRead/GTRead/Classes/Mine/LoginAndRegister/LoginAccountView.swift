//
//  LoginAccountView.swift
//  GTRead
//
//  Created by Dev on 2021/4/24.
//

import SwiftUI

struct LoginAccountView: View {
    
    @State var account: String = ""
    @State var password: String = ""
    
    @State var isPresented = false
    
    @Binding var isPushed: Bool
    
    var body: some View {

        VStack(spacing: 30.0) {
            
            // 图片
            Image("login")
                .resizable()
                .frame(width: 500.0, height: 500.0)
                .scaledToFill()
                
            
            // 账号
            HStack {
                Image(systemName: "person")
                Divider()
                TextField("请输入账号", text: $account, onCommit: {})
                    .frame(height: 80)
            }
            .padding(.horizontal, 30.0)
            .frame(height: 80)
            .cornerRadius(20)
            .border(Color.black, width: 1)
            
            // 密码
            HStack {
                Image(systemName: "lock")
                Divider()
                TextField("请输入密码", text: $password, onCommit: {})
                    .frame(height: 80.0)
            }
            .padding(.horizontal, 30.0)
            .frame(height: 80)
            .border(Color.black, width: 1)
            
            // 注册账户
            HStack {
                Button(action: {isPresented = true}) {
                    Text("注册账户")
                        .foregroundColor(.red)
                }
                .sheet(isPresented: $isPresented, content: {
                    RegisterAccountView(isPresented: $isPresented, isPushed: $isPushed)
                })
            }
            .frame(height: 50)
            
            // 登录按钮
            Button(action: loginRequest) {
                Text("登录")
            }
            .frame(width: 300, height: 100.0)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(20)
        }
        .padding(.horizontal, 20.0)
        
    }
        
    
    // 登录请求
    func loginRequest () {
        
        let params = ["userId" : account, "userPwd" : password] as [String : Any]
        
        GTNet.shared.requestWith(url:"http://121.4.52.206:8000/loginService/loginFun", httpMethod: .post,params: params) {(json) in
            debugPrint(json)
            if let code = json["code"], code as! Int == 1 {
                debugPrint(code)
                
                isPushed = false
                
                // 保存用户信息
                UserDefaultKeys.LoginStatus.isLogin = true
                UserDefaultKeys.AccountInfo.account = account
                UserDefaultKeys.AccountInfo.password = password
                
                // 登录成功
                DispatchQueue.main.async {
                    GTNet.shared.requestAccountInfo()
                }
                
            } else {
                
                // 登录失败
                
            }
        } error: { (error) in
            debugPrint(error)
        }
    }
}



//struct LoginAccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginAccountView(isPushed: false)
//    }
//}
