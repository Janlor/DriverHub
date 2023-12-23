//
//  LoginView.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import SwiftUI

struct LoginView: View {
        
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                Text("欢迎来到 \(Environment.appName)！")
                    .multilineTextAlignment(.center)
                
                Divider()
                
                HStack {
                    NavigationLink("密码", destination: {
                        PwdLoginView()
                            .navigationBarTitle("密码登录")
                            .navigationBarTitleDisplayMode(.inline)
                    })
                    
                    NavigationLink("验证码", destination: {
                        SMSLoginView()
                            .navigationBarTitle("注册/登录")
                            .navigationBarTitleDisplayMode(.inline)
                    })
                }
            }
            .padding(.horizontal)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
