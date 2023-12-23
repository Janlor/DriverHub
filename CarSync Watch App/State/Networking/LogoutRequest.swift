//
//  LogoutRequest.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation
import Combine

struct LogoutRequest {
    var publisher: AnyPublisher<Bool, AppError> {
        logoutPublisher()
            .mapError { AppError.networkFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func logoutPublisher() -> AnyPublisher<Bool, AppError> {
        let urlStr = Environment.serverBaseURL + "/oauth/ucenter/loginOut"
        return Networking<Bool>()
            .requestLogout(urlStr)
            .eraseToAnyPublisher()
    }
}
