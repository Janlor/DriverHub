//
//  String+Image.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation
#if canImport(WatchKit)
import WatchKit
#endif

extension JanlorLeeWrapper where Base == String {
    /// 获取指定尺寸的图片地址
    /// - Parameters:
    ///   - width: 宽 pt
    ///   - height: 高 pt
    /// - Returns: 处理后的地址
    func resizedImageURLString(_ width: CGFloat, _ height: CGFloat) -> String {
        if let _ = base.range(of: "JL_OSS") {
            let scale = WKInterfaceDevice.current().screenScale
            let w = width * scale
            let h = height * scale
            return base.appendingFormat("?x-oss-process=image/resize,w_%d,h_%d", Int(w), Int(h))
        }
        return base
    }
}
