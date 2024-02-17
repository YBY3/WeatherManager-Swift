//
//  WeatherViewModel.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/17/24.
//

import Foundation

protocol WeatherViewModelProtocol: ObservableObject {
    var forecastData: ForecastData? { get }
    
    func getWeatherData() async
}


class WeatherViewModel: WeatherViewModelProtocol {
    @Published var forecastData: ForecastData?
    private var locationManager = LocationManager()
    private var weatherAPIManager = WeatherAPIManager()
    
    
    //Gets LocationManager Instance from LoadingViewModel
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
    }
    
    
    //Loads Weather Data
    func getWeatherData() async {
        do {
            if let location = locationManager.location {
                let forecastData = try await weatherAPIManager.loadForecastData(latitude: location.latitude, longitude: location.longitude)
                await MainActor.run {
                    self.forecastData = forecastData
                }
            }
        } catch {
            //Weather Data Error
            print("Error Loading Weather Data: ", error)
        }
    }
}
