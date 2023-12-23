//
//  CarInfoView.swift
//  CarSync Watch App
//
//  Created by Janlor Lee on 12/23/23.
//  Copyright © 2023 Janlor Lee. All rights reserved.
//

import SwiftUI
import Kingfisher

struct CarInfoView: View {
    @EnvironmentObject var store: Store
    let vin: String
    private var car: AppState.CarState { store.appState.car }
    
    var body: some View {
        CarInfoListView()
            .onAppear {
                if car.carInfo.vin == nil {
                    self.store.dispatch(.loadCarInfo(vin: vin))
                }
            }
    }
}

struct CarInfoListView: View {
    @EnvironmentObject var store: Store
    private var car: AppState.CarState { store.appState.car }
    
    var body: some View {
        List {
            Section {
                if let urlStr = car.carInfo.carTypeImage,
                   let url = URL(string: urlStr) {
                    KFImage(url)
                        .resizable()
                        .frame(height: 100)
                }
                
            } footer: {
                Text(car.carInfo.vin ?? "")
                    .font(.footnote)
            }
            
            Section {
                Text("\(car.carInfo.batSoc)")
            } header: {
                Text("剩余电量")
            }
            
            Section {
                Text("\(car.carInfo.remainMileage)")
            } header: {
                Text("续航里程")
            }
            
            Section {
                Text("\(car.carInfo.mileage)")
            } header: {
                Text("行驶里程")
            }
            
            Section {
                Text("\(car.carInfo.mileageOfLastDay)")
            } header: {
                Text("昨日里程")
            }
        }
        .listStyle(.plain)
    }
}

struct CarInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CarInfoView(vin: "")
            .environmentObject(Store.shared)
    }
}
