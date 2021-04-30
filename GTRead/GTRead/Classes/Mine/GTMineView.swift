//
//  GTMineView.swift
//  GTRead
//
//  Created by Dev on 2021/4/26.
//

import SwiftUI
import SDWebImageSwiftUI
import UIKit

struct GTMineView: View {
    
    @State var isPushed = false
    
    @State var headImageUrl = ""
    @State var nickName = "登录"

    var body: some View {
        NavigationView {
                Form {
                    Section {
                        NavigationLink(
                            destination: LoginAccountView(isPushed: $isPushed), isActive: $isPushed, label: {
                                Button(action: {isPushed = true
                                }) {
                                    HStack(spacing: 50.0) {
                                        WebImage(url: URL(string: headImageUrl))
                                            .resizable()
                                            .placeholder(Image("profile")
                                                    )
                                            .scaledToFit()
                                            .frame(width: 120.0, height: 120.0)
                                            .cornerRadius(60)
                                                         
                                        Text(nickName)
                                            .font(.system(size: 50))
                                    }
                                }
                            }
                        )
                    }.onReceive(NotificationCenter.default.publisher(for: LoginSuccessfulNotification), perform: { _ in
                        headImageUrl = UserDefaultKeys.AccountInfo.imageUrl
                        nickName = UserDefaultKeys.AccountInfo.userName
                    })
                    
                    Section {
                        NavigationLink(
                            destination: Text("hello"),
                            label: {
                                HStack(spacing: 30.0) {
                                    Image("information")
                                        .resizable()
                                        .frame(width: 50.0, height: 50.0)
                                        .scaledToFit()
                                    Text("消息")
                                        .font(.system(size: 25))
                                }
                            })
                        NavigationLink(
                            destination: Text("hello"),
                            label: {
                                HStack(spacing: 30.0) {
                                    Image("browse")
                                        .resizable()
                                        .frame(width: 50.0, height: 50.0)
                                        .scaledToFit()
                                    Text("最近浏览")
                                        .font(.system(size: 25))
                                }
                            })
                    }
                    
                    Section {
                        NavigationLink(
                            destination: Text("hello"),
                            label: {
                                HStack(spacing: 30.0) {
                                    Image("skin")
                                        .resizable()
                                        .frame(width: 50.0, height: 50.0)
                                        .scaledToFit()
                                    Text("换肤")
                                        .font(.system(size: 25))
                                }
                            })
                        
                        NavigationLink(
                            destination: Text("hello"),
                            label: {
                                HStack(spacing: 30.0) {
                                    Image("night")
                                        .resizable()
                                        .frame(width: 50.0, height: 50.0)
                                        .scaledToFit()
                                    Text("夜间模式")
                                        .font(.system(size: 25))
                                }
                            })
                    }
                    
                    Section {
                        NavigationLink(
                            destination: Text("hello"),
                            label: {
                                HStack(spacing: 30.0) {
                                    Image("setting")
                                        .resizable()
                                        .frame(width: 50.0, height: 50.0)
                                        .scaledToFit()
                                    Text("设置")
                                        .font(.system(size: 25))
                                }
                            })
                    }
                }
            Spacer()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct GTMineView_Previews: PreviewProvider {
    static var previews: some View {
        GTMineView()
    }
}



