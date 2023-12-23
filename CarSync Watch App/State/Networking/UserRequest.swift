//
//  UserRequest.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation
import Combine

struct UserRequest {
    var publisher: AnyPublisher<User, AppError> {
        userPublisher()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func userPublisher() -> AnyPublisher<User, AppError> {
        let urlStr = Environment.serverBaseURL + "/account/getSelfInfo"
        return Networking<User>().request(urlStr, method: .post)
            .eraseToAnyPublisher()
    }
    
}
