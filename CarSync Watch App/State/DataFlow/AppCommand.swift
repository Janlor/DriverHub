//
//  AppCommand.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation
import Combine
import Kingfisher

protocol AppCommand {
    func execute(in store: Store)
}

struct PwdLoginAppCommand: AppCommand {
    let username: String
    let password: String
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        PwdOAuthRequest(
            mobile: username,
            password: password
        ).publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.requestOAuthDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { oauth in
                    store.dispatch(.requestOAuthDone(result: .success(oauth)))
                }
            )
            .seal(in: token)
    }
}

struct SmsLoginAppCommand: AppCommand {
    let username: String
    let smsCode: String
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        SMSOAuthRequest(
            mobile: username,
            smsCode: smsCode
        ).publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.requestOAuthDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { oauth in
                    store.dispatch(.requestOAuthDone(result: .success(oauth)))
                }
            )
            .seal(in: token)
    }
}

struct UserAppCommand: AppCommand {    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        UserRequest()
            .publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.requestUserDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { user in
                    store.dispatch(.requestUserDone(result: .success(user)))
                }
            )
            .seal(in: token)
    }
}

struct LogoutCommand: AppCommand {
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LogoutRequest()
            .publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.logoutDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { succeed in
                    store.dispatch(.logoutDone(result: .success(succeed)))
                }
            )
            .seal(in: token)
    }
}

struct ClearCacheCommand: AppCommand {
    func execute(in store: Store) {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        store.appState.car.carList = nil
        store.appState.car.carInfo = EVInfo()
    }
}

struct LoadCarListCommand: AppCommand {
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoadCarListRequest()
            .publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.loadCarListDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { list in
                    store.dispatch(.loadCarListDone(result: .success(list)))
                }
            )
            .seal(in: token)
    }
}

struct LoadCarInfoCommand: AppCommand {
    let vin: String
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoadCarInfoRequest(vin: vin)
            .publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.loadCarInfoDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { info in
                    store.dispatch(.loadCarInfoDone(result: .success(info)))
                }
            )
            .seal(in: token)
    }
}

class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() { cancellable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}
