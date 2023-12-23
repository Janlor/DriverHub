//
//  String+Valid.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation

extension JanlorLeeWrapper where Base == String {
    /// 验证手机号是否有效
    /// 1. 以1开头
    /// 2. 第二位3-9任意数字
    /// 3. 三位以后任意数字9个
    var isValidMobile: Bool {
        evaluate("^1[3-9][0-9]{9}$")
    }
    
    /// 验证验证码是否有效
    /// 6位任意数字
    var isValidSmsCode: Bool {
        evaluate("^[0-9]{6}$")
    }
    
    /// 正则匹配
    /// - Parameter regEx: 正则表达式
    /// - Returns: 是否匹配
    func evaluate(_ regEx: String) -> Bool {
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: base)
    }
}
