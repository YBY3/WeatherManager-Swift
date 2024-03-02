//
//  WeatherView.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/17/24.
//

import SwiftUI

struct WeatherView: View {
    private let viewModel: AppViewModel
    private let weatherComponentViewModel: WeatherComponentViewModel
    
    init(viewModel: AppViewModel) {
        self.viewModel = viewModel
        self.weatherComponentViewModel = viewModel.getWeatherComponentViewModel()
    }

    var body: some View {
        let _ = print("weatherview") //reloading test
        
        CurrentRow(viewModel: weatherComponentViewModel)
        
    }
}


#Preview {
    WeatherView(viewModel: AppViewModel())
}
