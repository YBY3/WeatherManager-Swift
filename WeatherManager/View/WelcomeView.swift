//
//  WelcomeView.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    private var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("WeatherManager")
                    .bold().font(.title)
                Text("Allow Location Services for local forcast")
                    .padding()
            }
            .padding()
            LocationButton(.shareCurrentLocation) {
                locationManager.requestLocation() //WIP
            }
            .cornerRadius(30)
            .symbolVariant(.fill)
        }
        .frame(maxWidth: .infinity, maxHeight: . infinity)
    }
    
}

#Preview {
    WelcomeView()
}
