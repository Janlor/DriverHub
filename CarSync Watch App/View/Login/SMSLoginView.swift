//
//  SMSLoginView.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import SwiftUI

struct SMSLoginView: View {
    
    @EnvironmentObject var store: Store
    
    private var login: AppState.LoginState { store.appState.login }
    private var loginBinding: Binding<AppState.LoginState> { $store.appState.login }
    
    var body: some View {
        Form {
            Section {
                TextField("验证码", text: loginBinding.checker.smsCode)
                    .textContentType(.oneTimeCode)
                    .foregroundColor(login.isSmsCodeValid ? .green : .red)
                VStack {
                    Button("获取") {
                        getSmsCode()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            } header: {
                Text("欢迎加入 \(Environment.appName)！")
            }
            
            Section {
                HStack {
                    Spacer()
                    Button(login.isLoginRequesting ? "注册/登录中…" :"注册/登录") {
                        let checker = self.login.checker
                        self.store.dispatch(.smsLogin(username: checker.username, smsCode: checker.smsCode))
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
            self.store.dispatch(.switchLoginBehavior(behavior: .smsCode))
        }
    }
    
    private func getSmsCode() {
        
    }
}

struct SMSLoginView_Previews: PreviewProvider {
    static var previews: some View {
        SMSLoginView()
    }
}
