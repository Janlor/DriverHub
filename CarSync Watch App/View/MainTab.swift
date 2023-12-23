//
//  MainTab.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import SwiftUI

struct MainTab: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        TabView(selection: $store.appState.tab.selection) {
            CarView().tabItem {
                Image(systemName: "car")
            }.tag(AppState.TabState.Index.car)

            MineView().tabItem {
                Image(systemName: "person")
            }.tag(AppState.TabState.Index.mine)
        }
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
