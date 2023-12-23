//
//  AppError.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation

enum AppError: Error, Identifiable {
    var id: String { localizedDescription }
    
    case networkFailed(Error)
    case serverError(Error)
    case requestURLNil
    case fileError
    case noLogin
}

extension AppError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .serverError(let error): return error.localizedDescription
        case .networkFailed(let error): return error.localizedDescription
        case .requestURLNil: return NSLocalizedString("网络请求地址无效", comment: "")
        case .fileError: return NSLocalizedString("文件操作错误", comment: "")
        case .noLogin: return NSLocalizedString("未登录", comment: "")
        }
    }
}
