//
//  MineView.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import SwiftUI
import Kingfisher

struct MineView: View {
    @EnvironmentObject var store: Store
    
    private var mine: AppState.MineState { store.appState.mine }
    private var mineBinding: Binding<AppState.MineState> { $store.appState.mine }
    
    var body: some View {
        NavigationView {
            List {
                if mine.loginUser != nil {
                    MineUserView()
                } else {
                    MineLoadUserView()
                }
                MineSettingView()
            }
            .alert(item: mineBinding.mineError) { e in
                Alert(title: Text(e.localizedDescription))
            }
            .navigationBarTitle("账户")
        }
    }
}

struct MineUserView: View {
    @EnvironmentObject var store: Store
    private var mine: AppState.MineState { store.appState.mine }
    
    var body: some View {
        NavigationLink {
            QRCodeView()
                .navigationBarTitle("会员码")
                .navigationBarTitleDisplayMode(.inline)
        } label: {
            HStack {
                if let urlStr = mine.loginUser?.photo,
                   let url = URL(string: urlStr.jl.resizedImageURLString(40, 40)) {
                    KFImage(url)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(20)
                }
                
                Text(mine.loginUser?.nickname ?? "")
                Spacer()
                Image(systemName: "qrcode")
            }
            .frame(minHeight: 80)
        }
    }
}

struct MineLoadUserView: View {
    @EnvironmentObject var store: Store
    private var mine: AppState.MineState { store.appState.mine }
    
    var body: some View {
        if mine.mineError != nil {
            RetryButton {
                self.store.dispatch(.loadUser)
            }.offset(y: -40)
        } else {
            Text("加载中…")
                .offset(y: -40)
                .onAppear {
                    self.store.dispatch(.loadUser)
                }
        }
    }
}

struct MineSettingView: View {
    @EnvironmentObject var store: Store
    private var mine: AppState.MineState { store.appState.mine }
    private var version: String {
        var str = "V"
        if let v = Environment.appShortVersion, let b = Environment.appBuildVersion {
            str += v; str += "("; str += b; str += ")"
        }
        return str
    }
    
    var body: some View {
        Section {
            Button("清理缓存") {
                self.store.dispatch(.clearCache)
            }
            
            Button(mine.isLogoutRequesting ? "退出中…" : "退出登录") {
                self.store.dispatch(.logout)
            }.disabled(mine.isLogoutRequesting)
        } header: {
            Text("设置")
        } footer: {
            Text(version)
        }
    }
}

struct MineView_Previews: PreviewProvider {
    static var previews: some View {
        MineView()
    }
}
