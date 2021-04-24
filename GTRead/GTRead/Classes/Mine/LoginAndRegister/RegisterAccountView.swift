//
//  RegisterAccountView.swift
//  GTRead
//
//  Created by Dev on 2021/4/23.
//

import SwiftUI
import UIKit

struct RegisterAccountView: View {
    @State var account: String = ""
    @State var password1: String = ""
    @State var password2: String = ""
    @State var accountHintInfo: String = ""
    @State var password1HintInfo: String = ""
    @State var password2HintInfo: String = ""
    
    var body: some View {
        VStack(spacing: 50.0) {
            Image("profile")
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person")
                    Divider()
                    TextField("请输入账号", text: $account, onEditingChanged: {isEidting in
                        if isEidting == true {
                            accountHintInfo = ""
                        }
                    })
                }
                .padding(.horizontal, 30.0)
                .frame(height: 80)
                .cornerRadius(20)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                
                Text(accountHintInfo)
                    .foregroundColor(.red)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "lock")
                    Divider()
                    TextField("请输入密码", text: $password1) {_ in
                        password1HintInfo = ""
                    }
                }
                .padding(.horizontal, 30.0)
                .frame(height: 80)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                
                Text(password1HintInfo)
                    .foregroundColor(.red)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "lock")
                    Divider()
                    TextField("请再次确认密码", text: $password2) {_ in
                        password2HintInfo = ""
                    }
                }
                .padding(.horizontal, 30.0)
                .frame(height: 80)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                
                Text(password2HintInfo)
                    .foregroundColor(.red)
            }

            Button(action: hello) {
                Text("确认")
            }
            .frame(width: 300, height: 60.0)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(20)
            
            Spacer()
        }
        .padding(.horizontal, 40.0)
        .padding(.top, 200.0)
        
    }
  
    func hello() {
        
        if password1.isEmpty || password2.isEmpty || account.isEmpty {
            if password1.isEmpty {
                password1HintInfo = "请输入密码"
            }
            if password2.isEmpty {
                password2HintInfo = "请输入密码"
            }
            if account.isEmpty {
                accountHintInfo = "请输入账号"
            }
        } else if password1 != password2 {
            password2HintInfo = "两次输入的密码不匹配"
        } else {
            let params = ["userId" : account, "userPwd" : password1]
            GTNet.shared.requestWith(url: "http://121.4.52.206:8000/loginService/registerFun", httpMethod: .post, params: params) {(json) in
                debugPrint(json)
                if let code = json["code"], code as! Int == 1 {
                    debugPrint(code)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RegisterSuccessfulNotification"), object: self)
                    }
                    
                } else {
                    accountHintInfo = json["errorRes"] as! String
                }
            } error: { (error) in
                debugPrint(error)
            }
        }
    }
}

struct RegisterAccountView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterAccountView()
    }
}
