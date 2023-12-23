//
//  SMSOAuthRequest.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation
import Combine

struct SMSOAuthRequest {
    let mobile: String
    let smsCode: String

    var publisher: AnyPublisher<OAuth, AppError> {
        oAuthPublisher(mobile, smsCode)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func oAuthPublisher(_ username: String, _ smsCode: String) -> AnyPublisher<OAuth, AppError> {
        let urlStr = Environment.serverBaseURL + "/oauth/ucenter/quickLogin"
        let parameters = [ "mobile": username, "smsCode": smsCode ]
        return Networking<OAuth>().requestLogin(urlStr, parameters: parameters)
            .eraseToAnyPublisher()
    }
}
