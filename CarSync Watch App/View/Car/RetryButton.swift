//
//  RetryButton.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import SwiftUI

struct RetryButton: View {

    let block: () -> Void

    var body: some View {
        Button(action: {
            self.block()
        }) {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text("重试")
            }
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(.gray)
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray)
            )
        }
    }
}
