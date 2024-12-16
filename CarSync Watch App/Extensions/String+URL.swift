//
//  String+URL.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation

extension JanlorLeeWrapper where Base == String {
    var encodeQuery: String? {
        base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
