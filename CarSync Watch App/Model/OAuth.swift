//
//  OAuth.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation

struct OAuth: Codable {
    var accessToken: String?
    var expiresIn: TimeInterval?
    var state: String?
    var refreshToken: String?
}
