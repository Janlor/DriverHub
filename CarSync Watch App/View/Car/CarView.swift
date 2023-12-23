//
//  CarView.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import SwiftUI

struct CarView: View {
    @EnvironmentObject var store: Store
    private var car: AppState.CarState { store.appState.car }
    
    var body: some View {
        NavigationView {
            if car.carList == nil {
                CarLoadingView()
            } else if let carList = car.carList, carList.isEmpty {
                Text("请检查车辆绑定信息")
            } else if let model = car.carList?.first, let vin = model.vin {
                CarInfoView(vin: vin)
                    .navigationBarTitle(model.carTypeName ?? "")
            }
        }
    }
}

struct CarLoadingView: View {
    @EnvironmentObject var store: Store
    private var car: AppState.CarState { store.appState.car }
    
    var body: some View {
        if car.carListLoadingError != nil {
            RetryButton {
                self.store.dispatch(.loadCarList)
            }.offset(y: -40)
        } else {
            Text("加载中…")
                .offset(y: -40)
                .onAppear {
                    self.store.dispatch(.loadCarList)
                }
        }
    }
}

struct CarView_Previews: PreviewProvider {
    static var previews: some View {
        CarView()
    }
}
