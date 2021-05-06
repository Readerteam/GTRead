//
//  Face.swift
//
//
//  Created by Yuki Yamato on 2020/10/01.
//

import Foundation
import UIKit
import SceneKit
import ARKit

public class Face {
    // 父结点
    public let node: SCNNode
    public let rightEye: Eye
    public let leftEye: Eye
    public var transform: simd_float4x4 = simd_float4x4()


    public init(isShowRayHint: Bool = false) {
        // Node生成
        self.node = SCNNode()
        self.rightEye = Eye(isShowRayHint: isShowRayHint)
        self.leftEye = Eye(isShowRayHint: isShowRayHint)
        self.node.addChildNode(self.leftEye.node)
        self.node.addChildNode(self.rightEye.node)
    }

    public func update(anchor: ARFaceAnchor) {
        self.transform = anchor.transform
        // 左眼的位置和方向的变换矩阵
        self.leftEye.node.simdTransform = anchor.leftEyeTransform
        // 右眼的位置和方向的变换矩阵
        self.rightEye.node.simdTransform = anchor.rightEyeTransform
        // 左眼的偏移值
        self.leftEye.blink = anchor.blendShapes[.eyeBlinkLeft]?.floatValue ?? 0.0
        print("leftEye-----\(self.leftEye.blink)")
        // 右眼的偏移值
        self.rightEye.blink = anchor.blendShapes[.eyeBlinkRight]?.floatValue ?? 0.0
        print("rightEye-----\(self.rightEye.blink)")
    }

    public func getDistanceToDevice() -> Float {
        // Average distance from two eyes
        (self.leftEye.getDistanceToDevice() + self.rightEye.getDistanceToDevice()) / 2
    }
}
