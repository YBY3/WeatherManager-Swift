//
//  WeatherView.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/17/24.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject private var loadingViewModel: LoadingViewModel
    @StateObject var viewModel: WeatherViewModel

    init(viewModel: WeatherViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    func loadData() async {
        await viewModel.getWeatherData()
    }
    
    var body: some View {
        let _ = print("weatherview") //reloading test
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task { await loadData() }
        
        if let forecastData = viewModel.forecastData {
            let _ = print(forecastData.city)
        }
    }
}

#Preview {
    WeatherView(
        viewModel: WeatherViewModel(locationManager: LocationManager())
    )
}
