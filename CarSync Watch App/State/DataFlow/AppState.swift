//
//  AppState.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Combine

struct AppState {
    var login = LoginState()
    var tab = TabState()
    var car = CarState()
    var mine = MineState()
}

extension AppState {
    struct LoginState {
        
        /// 登录行为 密码登录 或 验证码登录
        enum LoginBehavior: CaseIterable {
            case password, smsCode
        }
        
        /// 登录校验类
        class LoginChecker {
            @Published var loginBehavior = LoginBehavior.password
            @Published var username = ""
            @Published var password = ""
            @Published var smsCode = ""
            
            /// 用户名是否有效的发布者
            /// 目前仅在本地校验手机号规则
            var isUsernameValid: AnyPublisher<Bool, Never> {
                return $username
                    .removeDuplicates()
                    .map { $0.jl.isValidMobile }
                    .eraseToAnyPublisher()
            }
            
            /// 密码是否有效的发布者
            /// 目前仅在本地校验不为空
            var isPasswordValid: AnyPublisher<Bool, Never> {
                return $password
                    .removeDuplicates()
                    .map { !$0.isEmpty }
                    .eraseToAnyPublisher()
            }
            
            /// 验证码是否有效的发布者
            /// 目前仅在本地校验6位数字
            var isSmsCodeValid: AnyPublisher<Bool, Never> {
                return $smsCode
                    .removeDuplicates()
                    .map { $0.jl.isValidSmsCode }
                    .eraseToAnyPublisher()
            }
            
            /// 校验登录按钮是否可用
            var isValid: AnyPublisher<Bool, Never> {
                isUsernameValid
                    .combineLatest($loginBehavior, isPasswordValid, isSmsCodeValid)
                    .map { isUsername, isLoginBehavior, isPassword, isSmsCode -> Bool in
                        guard isUsername else { return false }
                        switch isLoginBehavior {
                        case .password:
                            return isPassword
                        case .smsCode:
                            return isSmsCode
                        }
                    }
                    .eraseToAnyPublisher()
            }
        }
        
        var checker = LoginChecker()
        
        var isValid: Bool = false
        var isUsernameValid: Bool = false
        var isPasswordValid: Bool = false
        var isSmsCodeValid: Bool = false
        
        var isLoginRequesting = false
        
        var loginError: AppError?
        
        @FileStorage(directory: .documentDirectory, fileName: "oauth.json")
        var loginOAuth: OAuth?
    }
}

extension AppState {
    struct TabState {
        enum Index: Hashable {
            case car, mine
        }
        
        var selection: Index = .car
    }
}

extension AppState {
    struct CarState {
        var isLoadingCarInfo = false
        var isLoadingCarList = false
        
        var carListLoadingError: AppError?
        var carInfoLoadingError: AppError?
        
        @FileStorage(directory: .cachesDirectory, fileName: "carList.json")
        var carList: [EVList]?
        
        var carInfo = EVInfo()
    }
}

extension AppState {
    struct MineState {
        var isLoadingUser = false
        var isLogoutRequesting = false
        
        var mineError: AppError?
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?
    }
}
