//
//  Device.swift
//
//
//  Created by Yuki Yamato on 2020/10/01.
//

import Foundation
import UIKit
import SceneKit
import ARKit

public enum DeviceType: String, CaseIterable {
    case iPad11 = "iPad11"
    case iPad12 = "iPad12"
}

public class Device {
    public var type: DeviceType
    public var screenSize: CGSize
    public var screenPointSize: CGSize

    public var node: SCNNode
    public var screenNode: SCNNode
    public var compensation: CGPoint
    
    
    public init(type: DeviceType) {
        self.type = type
        switch type {
        case DeviceType.iPad11:
            self.screenSize = CGSize(width: 0.1785, height: 0.2476)
            self.screenPointSize = UIScreen.main.bounds.size
            self.compensation = CGPoint(x: 0, y: 0)
        case DeviceType.iPad12:
            self.screenSize = CGSize(width: 0.2149, height: 0.2806)
            self.screenPointSize = UIScreen.main.bounds.size
            self.compensation = CGPoint(x: 50, y: 50)
        }
        // Node生成
        self.node = SCNNode()
        self.screenNode = {
            let screenGeometry = SCNPlane(width: 1, height: 1)
            screenGeometry.firstMaterial?.isDoubleSided = true
            screenGeometry.firstMaterial?.diffuse.contents = UIColor.green
            let vsNode = SCNNode()
            vsNode.geometry = screenGeometry
            return vsNode
        }()
        self.node.addChildNode(self.screenNode)
    }
    
    // 获取机型尺寸函数
    public static func getDeviceType() -> String {
        switch UIScreen.main.bounds.size {
        case CGSize(width: 834.0, height: 1194.0):
            return DeviceType.iPad11.rawValue
        case CGSize(width: 1024.0, height: 1366.0):
            return DeviceType.iPad12.rawValue
        default:
            return ""
        }
    }
}
