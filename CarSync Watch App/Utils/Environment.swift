//
//  Environment.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation

struct Environment {
    
    // Bundle ID
    static let bundleID = Bundle.main.bundleIdentifier ?? ""
    // 版本号
    static let appShortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    // 版本构建号
    static let appBuildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    // App 显示名称
    static let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String

    // Mock 服务器地址
    static let serverBaseURL = "https://mock.apifox.com/m1/3174267-0-default"
    
    // Mock 鉴权
    static let apiMockToken = "oOk4cLGM8lyG4FzH5-1yP"
    
    // OAuth 授权
    static let appClientID = ""
    static let appClientSecret = ""
    static let appSalt = ""
}
