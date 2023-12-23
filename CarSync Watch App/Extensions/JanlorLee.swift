//
//  JanlorLee.swift
//  CarSync Watch App
//
//  Created by Janlor on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import Foundation

struct JanlorLeeWrapper<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol JanlorLeeCompatible { }
extension JanlorLeeCompatible {
    static var jl: JanlorLeeWrapper<Self>.Type {
        get { return JanlorLeeWrapper<Self>.self }
        set { }
    }
    var jl: JanlorLeeWrapper<Self> {
        get { return JanlorLeeWrapper(self) }
        set { }
    }
}

extension String: JanlorLeeCompatible { }
