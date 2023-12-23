//
//  AppAction.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation

enum AppAction {
    
    // MARK: - Login
    
    case usernameValid(valid: Bool)
    case passwordValid(valid: Bool)
    case smsCodeValid(valid: Bool)
    case loginButton(enabled: Bool)
    case switchLoginBehavior(behavior: AppState.LoginState.LoginBehavior)
    case passwordLogin(username: String, password: String)
    case smsLogin(username: String, smsCode: String)
    case requestOAuthDone(result: Result<OAuth, AppError>)
    
    // MARK: - Mine
    
    case loadUser
    case requestUserDone(result: Result<User, AppError>)
    
    case logout
    case logoutDone(result: Result<Bool, AppError>)
    case clearCache
    
    // MARK: - Car
    
    case loadCarList
    case loadCarListDone(result: Result<[EVList], AppError>)
    
    case loadCarInfo(vin: String)
    case loadCarInfoDone(result: Result<EVInfo, AppError>)
}
