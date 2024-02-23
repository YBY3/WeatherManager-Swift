//
//  WeatherView.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/17/24.
//

import SwiftUI

struct WeatherView: View {
    @StateObject var viewModel: WeatherViewModel
    
    //Constructor
    init(viewModel: WeatherViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        let _ = print("weatherview") //reloading test
        
        if let forecastData = viewModel.forecastData { //WIP
            let _ = print(forecastData.city)
        }
    }
}


#Preview {
    WeatherView(
        viewModel: WeatherViewModel(dataManager: DataManager())
    )
}
