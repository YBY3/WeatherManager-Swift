//
//  WelcomeView.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    private var viewModel: AppViewModel
    
    init(viewModel: AppViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        let _ = print("welcomeview") //reloading test
        
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
                    viewModel.requestLocationAuthorization()
                }
            }
            .cornerRadius(30)
            .symbolVariant(.fill)
            
        }
        .frame(maxWidth: .infinity, maxHeight: . infinity)
    }
}


#Preview {
    WelcomeView(viewModel: AppViewModel())
}
