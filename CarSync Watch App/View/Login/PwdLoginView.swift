//
//  LoginView.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import SwiftUI

struct PwdLoginView: View {
    
    @EnvironmentObject var store: Store
    
    private var login: AppState.LoginState { store.appState.login }
    private var loginBinding: Binding<AppState.LoginState> { $store.appState.login }
    
    var body: some View {
        Form {
            Section {
                SecureField("密码", text: loginBinding.checker.password)
                    .textContentType(.password)
                    .foregroundColor(login.isPasswordValid ? .green : .red)
            } header: {
                Text("欢迎回到 \(Environment.appName)！")
            }
            
            Section {
                HStack {
                    Spacer()
                    Button(login.isLoginRequesting ? "登录中…" :"登录") {
                        let checker = self.login.checker
                        self.store.dispatch(.passwordLogin(username: checker.username, password: checker.password))
                    }
                    .disabled(!login.isValid || login.isLoginRequesting)
                    Spacer()
                }
            }
        }
        .alert(item: loginBinding.loginError) { e in
            Alert(title: Text(e.localizedDescription))
        }
        .padding(.horizontal)
        .onAppear {
            self.store.dispatch(.switchLoginBehavior(behavior: .password))
        }
    }
}

struct PwdLoginView_Previews: PreviewProvider {
    static var previews: some View {
        PwdLoginView()
    }
}
