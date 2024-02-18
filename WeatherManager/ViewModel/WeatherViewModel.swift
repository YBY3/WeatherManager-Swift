//
//  WeatherViewModel.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/17/24.
//

import Foundation
import Combine

protocol WeatherViewModelProtocol: ObservableObject {
    var forecastData: ForecastData? { get }
    
}


class WeatherViewModel: WeatherViewModelProtocol {
    @Published var forecastData: ForecastData?
    private var locationManager = LocationManager()
    
    //Init
    init(locationManager: LocationManager, forecastData: ForecastData) {
        self.locationManager = locationManager
        self.forecastData = forecastData
    }
}
