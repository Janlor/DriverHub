//
//  EVList.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation
import ClockKit

struct EVInfo: Codable {
    /// vin
    var vin: String?
    /// 剩余电量百分比
    var batSoc: Int = 0
    /// 剩余里程
    var remainMileage: Int = 0
    /// 总行驶里程
    var mileage: Int = 0
    /// 昨日里程
    var mileageOfLastDay: Int = 0
    /// 车型图片
    var carTypeImage: String?
    /// 车型名
    var carTypeName: String?
    
    public func batSoc(atDate date: Date) -> Int {
        batSoc
    }
    
    public func batSocString(atDate date: Date) -> String {
        "\(batSoc(atDate: date))"
    }
    
    public var remainMileageString: String {
        "\(remainMileage)"
    }
    
    public var showCarName: String {
        carTypeName ?? Environment.appName
    }
    
    // Return green, yellow, or red depending on the caffeine dose.
    public func color(forBatSoc batSoc: Int) -> UIColor {
        if batSoc < 30 {
            return .red
        } else if batSoc < 60 {
            return .yellow
        } else {
            return .green
        }
    }
}
