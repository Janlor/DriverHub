//
//  LoadCarInfoRequest.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation
import Combine

struct LoadCarInfoRequest {
    let vin: String

    var publisher: AnyPublisher<EVInfo, AppError> {
        carInfoPublisher(vin)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func carInfoPublisher(_ vin: String) -> AnyPublisher<EVInfo, AppError> {
        let urlStr = Environment.serverBaseURL + "/car/getCarBasicInfo"
        let params = ["vin": vin]
        return Networking<EVInfo>()
            .request(urlStr, parameters: params)
            .eraseToAnyPublisher()
    }
}
