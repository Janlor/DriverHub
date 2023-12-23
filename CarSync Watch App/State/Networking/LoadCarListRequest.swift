//
//  LoadCarListRequest.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation
import Combine

struct LoadCarListRequest {
    var publisher: AnyPublisher<[EVList], AppError> {
        carListPublisher()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func carListPublisher() -> AnyPublisher<[EVList], AppError> {
        let urlStr = Environment.serverBaseURL + "/car/getAllCars"
        return Networking<[EVList]>().request(urlStr)
    }
}
