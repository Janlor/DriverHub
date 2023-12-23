//
//  PwdOAuthRequest.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation
import Combine

struct PwdOAuthRequest {
    let mobile: String
    let password: String

    var publisher: AnyPublisher<OAuth, AppError> {
        oAuthPublisher(mobile, password)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func oAuthPublisher(_ username: String, _ password: String) -> AnyPublisher<OAuth, AppError> {
        let urlStr = Environment.serverBaseURL + "/oauth/ucenter/login"
        let parameters = [ "mobile": username, "password": password ]
        return Networking<OAuth>().requestLogin(urlStr, parameters: parameters)
            .eraseToAnyPublisher()
    }
}
