//
//  Store.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Combine

class Store: ObservableObject {
    // 单例 整个 App 只有一份数据
    static let shared = Store()
    
    @Published var appState = AppState()
    
    private var disposeBag = Set<AnyCancellable>()
    
    init() {
        setupObservers()
    }
    
    func setupObservers() {
        appState.login.checker.isValid.sink { isValid in
            self.dispatch(.loginButton(enabled: isValid))
        }.store(in: &disposeBag)
        
        appState.login.checker.isUsernameValid.sink { isValid in
            self.dispatch(.usernameValid(valid: isValid))
        }.store(in: &disposeBag)
        
        appState.login.checker.isPasswordValid.sink { isValid in
            self.dispatch(.passwordValid(valid: isValid))
        }.store(in: &disposeBag)
        
        appState.login.checker.isSmsCodeValid.sink { isValid in
            self.dispatch(.smsCodeValid(valid: isValid))
        }.store(in: &disposeBag)
    }
    
    func dispatch(_ action: AppAction) {
        debugPrint("[ACTION]: \(action)")
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        if let command = result.1 {
            debugPrint("[COMMAND]: \(command)")
            command.execute(in: self)
        }
    }
    
    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand? = nil
        
        switch action {
        case .usernameValid(let isValid):
            appState.login.isUsernameValid = isValid
        case .passwordValid(let isValid):
            appState.login.isPasswordValid = isValid
        case .smsCodeValid(let isValid):
            appState.login.isSmsCodeValid = isValid
        case .loginButton(let enabled):
            appState.login.isValid = enabled
        case .switchLoginBehavior(let behavior):
            appState.login.checker.loginBehavior = behavior
        case .passwordLogin(let username, let password):
            guard !appState.login.isLoginRequesting else { break }
            appState.login.loginError = nil
            appState.login.isLoginRequesting = true
            appCommand = PwdLoginAppCommand(username: username, password: password)
        case .smsLogin(let username, let smsCode):
            guard !appState.login.isLoginRequesting else { break }
            appState.login.loginError = nil
            appState.login.isLoginRequesting = true
            appCommand = SmsLoginAppCommand(username: username, smsCode: smsCode)
        case .requestOAuthDone(let result):
            switch result {
            case .success((let oauth)):
                appState.login.loginOAuth = oauth
                appState.login.checker.password = ""
                appState.login.checker.smsCode = ""
                appState.login.isLoginRequesting = false
            case .failure(let error):
                appState.login.loginError = error
                appState.login.isLoginRequesting = false
            }
        case .loadUser:
            if appState.mine.isLoadingUser { break }
            if let _ = appState.login.loginOAuth {
                appState.mine.mineError = nil
                appState.mine.isLoadingUser = true
                appCommand = UserAppCommand()
            } else {
                appState.mine.mineError = .noLogin
            }
        case .requestUserDone(let result):
            switch result {
            case .success((let user)):
                appState.mine.loginUser = user
            case .failure(let error):
                appState.login.loginError = error
            }
        case .logout:
            if let _ = appState.login.loginOAuth {
                guard !appState.mine.isLogoutRequesting else { break }
                appState.mine.mineError = nil
                appState.mine.isLogoutRequesting = true
                appCommand = LogoutCommand()
            } else {
                appState.mine.loginUser = nil
            }
        case .logoutDone(let result):
            switch result {
            case .success((_)):
                appState.login.loginOAuth = nil
                appState.mine.loginUser = nil
                appState.car.carList = nil
                appState.car.carInfo = EVInfo()
                appState.mine.isLogoutRequesting = false
            case .failure(let error):
                appState.mine.mineError = error
                appState.mine.isLogoutRequesting = false
            }
        case .clearCache:
            appCommand = ClearCacheCommand()
        case .loadCarList:
            if appState.car.isLoadingCarList { break }
            if let _ = appState.login.loginOAuth {
                appState.car.carListLoadingError = nil
                appState.car.isLoadingCarList = true
                appCommand = LoadCarListCommand()
            } else {
                appState.car.carListLoadingError = .noLogin
            }
        case .loadCarListDone(let result):
            switch result {
            case .success((let list)):
                appState.car.carList = list
                appState.car.carListLoadingError = nil
                appState.car.isLoadingCarList = false
            case .failure(let error):
                appState.car.carListLoadingError = error
                appState.car.isLoadingCarList = false
            }
        case .loadCarInfo(let vin):
            if appState.car.isLoadingCarInfo { break }
            if let _ = appState.login.loginOAuth {
                appState.car.carInfoLoadingError = nil
                appState.car.isLoadingCarInfo = true
                appCommand = LoadCarInfoCommand(vin: vin)
            } else {
                appState.car.carInfoLoadingError = .noLogin
            }
        case .loadCarInfoDone(let result):
            switch result {
            case .success((let info)):
                appState.car.carInfo = info
                appState.car.carInfoLoadingError = nil
                appState.car.isLoadingCarInfo = false
            case .failure(let error):
                appState.car.carInfoLoadingError = error
                appState.car.isLoadingCarInfo = false
            }
        }
        
        return (appState, appCommand)
    }
}
