//
//  EVList.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation

struct EVList: Identifiable, Codable {
    var id: String {
        vin ?? UUID().uuidString
    }
    /// vin
    var vin: String?
    /// 车图
    var carTypeImage: String?
    /// 车名称
    var carTypeName: String?
}
