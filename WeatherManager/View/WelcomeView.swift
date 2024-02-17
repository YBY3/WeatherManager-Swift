//
//  WelcomeView.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    @EnvironmentObject private var loadingViewModel: LoadingViewModel
    
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
                    loadingViewModel.requestLocationAuthorization()
                }
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
