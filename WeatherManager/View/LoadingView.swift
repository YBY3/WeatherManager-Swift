//
//  LoadingView.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import SwiftUI

struct LoadingView: View {
    @StateObject private var viewModel = LoadingViewModel()
        
    var body: some View {
        let _ = print("loadingview") //reloading test
                
        //Shows ProgressView
        if viewModel.showProgressView {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .frame(maxWidth: .infinity, maxHeight: 25)
        }
        
        //Shows WelcomeView
        else if viewModel.showWelcomeView {
            WelcomeView()
                .environmentObject(viewModel)
        }
        
        //Shows WeatherView
        else if viewModel.showWeatherView {
            if let weatherViewModel = viewModel.weatherViewModel {
                WeatherView(viewModel: weatherViewModel)
                    .environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    LoadingView()
}
