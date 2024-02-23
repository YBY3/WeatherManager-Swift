//
//  WeatherViewModel.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/17/24.
//

import Foundation
import Combine

protocol WeatherViewModelProtocol: ObservableObject { //WIP
    
}


class WeatherViewModel: WeatherViewModelProtocol {
    private var dataManager: DataManager
    @Published var forecastData: ForecastData?
    
    //Constructor
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.forecastData = dataManager.getForecastData()
    }
}
