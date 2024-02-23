//
//  WelcomeView.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    private var dataManager: DataManager
    
    //Constructor
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    var body: some View {
        VStack {
            
            //Welcome Text
            VStack(spacing: 20) {
                Text("WeatherManager")
                    .bold().font(.title)
                Text("Allow Location Services for local forcast")
                    .padding()
            }
            .padding()
            
            //Location Request Button
            LocationButton(.shareCurrentLocation) {
                Task {
                    dataManager.requestLocationAuthorization()
                }
            }
            .cornerRadius(30)
            .symbolVariant(.fill)
            
        }
        .frame(maxWidth: .infinity, maxHeight: . infinity)
    }
}


#Preview {
    WelcomeView(dataManager: DataManager())
}
