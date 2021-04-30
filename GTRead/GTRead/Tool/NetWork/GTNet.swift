//
//  GTNet.swift
//  GTRead
//
//  Created by YangJie on 2021/3/2.
//

import Alamofire
import CryptoKit
import SwiftyJSON


typealias Success = (_ response: AnyObject) -> Void
typealias Failure = (_ error: AnyObject) -> Void

// 请求方法
enum RequestType: Int {
    case get
    case post
    case download
}

// 网络状态
enum NetworkStatus {
    case unknown    //未知网络
    case notReachable   //未联网
    case wwan   //蜂窝数据
    case wifi
}

final class GTNet {
    private init() {}
    static let shared = GTNet()
    
    private var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        let session = Session.init(configuration: configuration, delegate: SessionDelegate.init(), serverTrustManager: nil)
        return session
    }()
    
    // 请求基本路径
    let base_url = "http//gtread.com/"
    
    // 网络状态
    var networkStatus: NetworkStatus?
    
    // 数据缓存路径
    private let cachePath = NSHomeDirectory() + "/Documents/NetworkingCaches/"
    
}
/// 网络状态监听
extension GTNet {
    
    func monitorNetworkingStatus() {
        let reachability = NetworkReachabilityManager()
        reachability?.startListening(onUpdatePerforming: {[weak self] (status) in
            guard let weakSelf = self else { return }
            if reachability?.isReachable ?? false {
                switch status {
                case .notReachable:
                    weakSelf.networkStatus = .notReachable
                case .unknown:
                    weakSelf.networkStatus = .unknown
                case .reachable(.cellular):
                    weakSelf.networkStatus = .wwan
                case .reachable(.ethernetOrWiFi):
                    weakSelf.networkStatus = .wifi
                }
            } else {
                weakSelf.networkStatus = .notReachable
            }
        })
    }
    
    // 判断当前网络是否可用
    func networkAvailable() -> Bool {
        guard let status = self.networkStatus else { return false }
        
        if status == .unknown || status == .notReachable {
            return false
        }
        
        return true
    }
    
    
    // 判断是否为wifi环境
    func isWIFI() -> Bool {
        guard let status = self.networkStatus else { return false }
        
        if !self.networkAvailable() || status == .wwan { return false }

        return true
    }
          
}

/// 数据缓存
extension GTNet {
    //新建数据缓存路径
    func createRootCachePath(path: String) {
        if !FileManager.default.fileExists(atPath: path, isDirectory: nil) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                debugPrint("create cache dir error:" + error.localizedDescription + "\n")
                return
            }
        }
    }
    
    // 读取缓存
    public func cacheDataFrom(urlPath: String) -> Any? {
        //对请求路由base64编码
        let base64Path = urlPath.MD5
        //拼接缓存路径
        var directorPath: String = cachePath
        directorPath.append(base64Path)
        let data: Data? = FileManager.default.contents(atPath: cachePath + base64Path)
        let jsonData: Any?
        if data != nil {
            print("从缓存中获取数据:\(directorPath)")
            do {
                jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                return jsonData
            } catch {
                return data
            }
        }
        return nil
    }
    
    // 进行数据缓存
    public func cacheResponseDataWith(responseData: AnyObject,
                                          urlPath: String) {
        var directorPath: String = cachePath
        //创建目录
        createRootCachePath(path: directorPath)
        //对请求的路由进行base64编码
        let base64Path = urlPath.MD5
        //拼接路径
        directorPath.append(base64Path)
        //将返回的数据转换成Data
        var data: Data?
        do {
            try data = JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
        } catch {
            debugPrint("GTNet->cacheResponseDataWith")
        }
        //将data存储到指定的路径
        if data != nil {
            let cacheSuccess = FileManager.default.createFile(atPath: directorPath, contents: data, attributes: nil)
            if cacheSuccess == true {
                debugPrint("当前接口缓存成功:\(directorPath)")
            } else {
                debugPrint("当前接口缓存失败:\(directorPath)")
            }
        }
    }
}




/// 数据请求
extension GTNet {
    func requestWith(url: String, httpMethod: RequestType, params: [String: Any]?, success: @escaping Success, error: @escaping Failure) {
        switch httpMethod {
        case .get:
            manageGet(url: url, params: params, success: success, error: error)
        case .post:
            managePost(url: url, params: params, success: success, error: error)
        default:
            break
        }
    }
    private func manageGet(url: String, params: [String: Any]?, success: @escaping Success, error: @escaping Failure) {
        let urlPath:URL = URL(string: url)!
        let headers:HTTPHeaders = ["Content-Type":"application/json;charset=utf-8"]
        let request = AF.request(urlPath,method: .get,parameters: params,encoding: JSONEncoding.default, headers: headers)
        request.responseJSON { (response) in
            DispatchQueue.global().async(execute: {
                DispatchQueue.global().async(execute: {
                    switch response.result {
                    case .success(let value):
                        success(value as AnyObject)
                    case .failure:
                        let statusCode = response.response?.statusCode
                        error(statusCode as AnyObject)
                    }
                })
            })
        }
    }
    
    private func managePost(url: String,
                            params: [String: Any]?,
                            success: @escaping Success,
                            error: @escaping Failure) {
        let urlPath:URL = URL(string: url)!
        let headers:HTTPHeaders = ["Content-Type":"application/json;charset=UTF-8"]
        let request = AF.request(urlPath,method: .post,parameters: params,encoding: JSONEncoding.default, headers: headers)
        request.responseJSON { (response) in
            DispatchQueue.global().async(execute: {
                switch response.result {
                case .success(let value):
                    success(value as AnyObject)
                case .failure:
                    let statusCode = response.response?.statusCode
                    error(statusCode as AnyObject)
                }
            })
        }
    }
}

extension GTNet {
    
    // 个人信息请求
    @objc func requestAccountInfo() {
        let params = ["userId" : UserDefaultKeys.AccountInfo.account] as [String : Any]
        
        GTNet.shared.requestWith(url: "http://121.4.52.206:8000/loginService/userInfoFun", httpMethod: .post, params: params) { (json) in
            debugPrint(json)
            
            UserDefaultKeys.AccountInfo.imageUrl = json["headImgUrl"] as! String
            UserDefaultKeys.AccountInfo.userName = json["nickName"] as! String
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(LoginSuccessfulNotification.rawValue), object: self)
            }
        } error: { (error) in
            debugPrint(error)
        }
    }
    
    // 书架请求

    // 下载书籍

    // 上传评论

    // 获得评论

    // 测试
}



extension String {
    var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}


