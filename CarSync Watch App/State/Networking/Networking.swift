//
//  Networking.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(WatchKit)
import WatchKit
#endif

open class Networking<T: Codable> {
    public enum RequestMethod: String {
        case get  = "GET"
        case post = "POST"
    }
    
    /// 发起网络请求
    /// - Parameters:
    ///   - urlString: 接口地址
    ///   - method: 请求方法
    ///   - parameters: 请求参数
    ///   - oauth: 需要登录的接口必传
    /// - Returns: 请求结果发布者
    func request(
        _ urlString: String,
        method: RequestMethod? = .get,
        parameters: [String: Any]? = nil
    ) -> AnyPublisher<T, AppError> {
        var urlStr = urlString
        
        // mock 鉴权
        var params = parameters ?? [String: Any]()
        params["apifoxToken"] = Environment.apiMockToken
        
        // Query 传参
        if method == .get {
            urlStr = makeQueryUrlString(urlString, parameters: params)
        }
        
        // 包装请求体
        guard let requestURL = URL(string: urlStr) else {
            return Fail(error: AppError.requestURLNil)
                .eraseToAnyPublisher()
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = method?.rawValue
        
        // Body 传参
        if !params.isEmpty, method == .post {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        
        // header 传参
        setNormalHeaderForRequest(request: &request)
        setOAuthHeaderForRequest(request: &request)
        setServerHeaderForRequest(request: &request)
        
        // 开始请求
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: HttpBaseModel<T>.self, decoder: appDecoder)
            .tryCompactMap({ base in
//                if let jsonString = String(data: base, encoding: .utf8) {
//                    print("Received JSON response:\n\(jsonString)")
//                }
//                let result = try appDecoder.decode(HttpBaseModel<T>.self, from: base)
//                return result.data
                if !base.result, let message = base.errorMessage, let codeStr = base.errorCode {
                    let error = NSError(domain: message, code: Int(codeStr) ?? 0) as Error
                    throw AppError.serverError(error)
                }
                return base.data
            })
            .mapError { AppError.networkFailed($0) }
            .eraseToAnyPublisher()
    }
    
    /// 发起登录请求
    /// - Parameters:
    ///   - urlString: 接口地址
    ///   - parameters: 请求参数
    /// - Returns: 请求结果发布者
    func requestLogin(
        _ urlString: String,
        parameters: [String: Any]? = nil
    ) -> AnyPublisher<T, AppError> {
        var formParams = parameters ?? [String: Any]()
        formParams["apifoxToken"] = Environment.apiMockToken
        formParams["client_id"] = Environment.appClientID
        formParams["client_secret"] = Environment.appClientSecret
        formParams["state"] = UUID().uuidString
        formParams["response_type"] = "token"
        
        let urlStr = makeQueryUrlString(urlString, parameters: formParams)
        guard let requestURL = URL(string: urlStr) else {
            return Fail(error: AppError.requestURLNil)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = RequestMethod.post.rawValue
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        deleteOAuthHeaderForRequest(request: &request)
        setServerHeaderForRequest(request: &request)
        
        // ephemeral 临时请求 不会缓存 保护隐私
        return URLSession(configuration: .ephemeral)
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: HttpBaseModel<T>.self, decoder: appDecoder)
            .tryCompactMap({ base in
                if !base.result, let message = base.errorMessage, let codeStr = base.errorCode {
                    let error = NSError(domain: message, code: Int(codeStr) ?? 0) as Error
                    throw AppError.serverError(error)
                }
                return base.data
            })
            .mapError { AppError.networkFailed($0) }
            .eraseToAnyPublisher()
    }
    
    /// 发起退出登录请求
    /// - Parameters:
    ///   - urlString: 接口地址
    ///   - parameters: 请求参数
    ///   - oauth: 需要登录的接口必传
    /// - Returns: 请求结果发布者
    func requestLogout(
        _ urlString: String,
        parameters: [String: Any]? = nil
    ) -> AnyPublisher<T, AppError> {
        var formParams = parameters ?? [String: Any]()
        formParams["apifoxToken"] = Environment.apiMockToken
        formParams["client_id"] = Environment.appClientID
        formParams["client_secret"] = Environment.appClientSecret
        formParams["state"] = Store.shared.appState.login.loginOAuth?.state ?? UUID().uuidString
        formParams["response_type"] = "token"
        
        let urlStr = makeQueryUrlString(urlString, parameters: formParams)
        guard let requestURL = URL(string: urlStr) else {
            return Fail(error: AppError.requestURLNil)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = RequestMethod.post.rawValue
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        setOAuthHeaderForRequest(request: &request)
        setServerHeaderForRequest(request: &request)
        
        // ephemeral 临时请求 不会缓存 保护隐私
        return URLSession(configuration: .ephemeral)
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: HttpBaseModel<T>.self, decoder: appDecoder)
            .tryCompactMap({ base in
                if !base.result, let message = base.errorMessage, let codeStr = base.errorCode {
                    let error = NSError(domain: message, code: Int(codeStr) ?? 0) as Error
                    throw AppError.serverError(error)
                }
                return base.data
            })
            .mapError { AppError.networkFailed($0) }
            .eraseToAnyPublisher()
    }
}

fileprivate extension Networking {
    func makeQueryUrlString(_ urlString: String, parameters: [String: Any]? = nil) -> String {
        guard let queryParams = parameters else { return urlString }
        var urlStr = urlString
        urlStr += "?"
        for param in queryParams {
            if let valueStr = param.value as? String,
               let value = valueStr.jl.encodeQuery {
                urlStr += param.key + "=" + value + "&"
            }
        }
        urlStr.removeLast()
        return urlStr
    }
}

/// Request Header
fileprivate extension Networking {
    /// 设置常规参数请求头
    func setNormalHeaderForRequest(request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    /// 设置授权参数请求头
    func setOAuthHeaderForRequest(request: inout URLRequest) {
        let accessToken = Store.shared.appState.login.loginOAuth?.accessToken ?? ""
        let millisTimestamp = Date.now.timeIntervalSince1970 * 1000.0
        let millisTimestampString = String(format: "%.0f", millisTimestamp)
        let appClientID = Environment.appClientID
        let appClientSecret = Environment.appClientSecret
        let appSalt = Environment.appSalt
        let nonce = UUID().uuidString
        let signature = "This is a string of signatures".jl.md5
        request.setValue(accessToken, forHTTPHeaderField: "accessToken")
        request.setValue(appClientID, forHTTPHeaderField: "oauthConsumerKey")
        request.setValue(millisTimestampString, forHTTPHeaderField: "timestamp")
        request.setValue(nonce, forHTTPHeaderField: "nonce")
        request.setValue(signature, forHTTPHeaderField: "signature")
    }
    
    /// 设置服务器需要的参数请求头
    func setServerHeaderForRequest(request: inout URLRequest) {
        // 平台类型 e.g. @"iOS"
        var systemName = ""
        // 平台版本号 e.g. @"14.2"
        var systemVersion = ""
        // e.g. @"iPhone", @"iPod touch"
        var deviceType = ""
#if os(iOS)
        systemName = UIDevice.current.systemName
        systemVersion = UIDevice.current.systemVersion
        deviceType = UIDevice.current.model
#endif
#if os(watchOS)
        systemName = WKInterfaceDevice.current().systemName
        systemVersion = WKInterfaceDevice.current().systemVersion
        deviceType = WKInterfaceDevice.current().model
#endif
        request.setValue(systemName, forHTTPHeaderField: "platformNo")
        request.setValue(systemVersion, forHTTPHeaderField: "platformVersion")
        request.setValue(deviceType, forHTTPHeaderField: "deviceType")
        
        // 版本号 e.g. @"4.8.12"
        if let version = Environment.appShortVersion {
            request.setValue(version, forHTTPHeaderField: "version")
        }
        
        // 构建号 e.g. @"12"
        if let build = Environment.appBuildVersion {
            request.setValue(build, forHTTPHeaderField: "build")
        }
        
        // 安装渠道
        request.setValue("App Store", forHTTPHeaderField: "channel")
        
        // 设备品牌
        request.setValue("Apple", forHTTPHeaderField: "deviceBrand")
    }
    
    /// 删除授权请求头
    /// - Parameter request: URLRequest
    func deleteOAuthHeaderForRequest(request: inout URLRequest) {
        request.setValue(nil, forHTTPHeaderField: "accessToken")
        request.setValue(nil, forHTTPHeaderField: "oauthConsumerKey")
        request.setValue(nil, forHTTPHeaderField: "timestamp")
        request.setValue(nil, forHTTPHeaderField: "nonce")
        request.setValue(nil, forHTTPHeaderField: "signature")
    }
}
