//
//  HttpBaseModel.swift
//  EVInfoDataTest
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation

struct HttpBaseModel<T: Codable>: Codable {
    /// 成功或者失败
    var result: Bool = false
    /// 错误码
    var errorCode: String?
    /// 错误信息
    var errorMessage: String?
    /// 返回的数据
    var data: T?
    /// 服务器时间字符串
    var systemDate: String?
    /// 服务器时间戳
    var systemTimeMillis: TimeInterval?
    /// 追踪 ID
    var traceId: String?
}
