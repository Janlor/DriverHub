//
//  ContentView.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    
    private var login: AppState.LoginState {
        store.appState.login
    }
    
    var body: some View {
        Group {
            if let _ = login.loginOAuth {
                MainTab()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
