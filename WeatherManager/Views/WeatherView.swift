//
//  WeatherView.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/17/24.
//

import SwiftUI

struct WeatherView: View {
    private var viewModel: AppViewModel
    
    init(viewModel: AppViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        let _ = print("weatherview") //reloading test
        
        if let forecastData = viewModel.getForecastData() { //WIP
            let _ = print(forecastData.city)
        }
    }
}


#Preview {
    WeatherView(viewModel: AppViewModel())
}
