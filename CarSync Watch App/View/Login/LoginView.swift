//
//  LoginView.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var store: Store
    
    private var login: AppState.LoginState { store.appState.login }
    private var loginBinding: Binding<AppState.LoginState> { $store.appState.login }
        
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                Text("欢迎来到 \(Environment.appName)！")
                    .multilineTextAlignment(.center)
                
                Divider()
                
                TextField("手机号码", text: loginBinding.checker.username)
                    .textContentType(.username)
                    .foregroundColor(login.isUsernameValid ? .green : .red)
                
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
                .disabled(!login.isUsernameValid)
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
