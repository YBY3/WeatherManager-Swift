//
//  DataManager.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/22/24.
//

import Foundation
import Combine

enum DataManagerStatus {
    case idle
    case waitingForAuthorization
    case weatherDataUpdated
}


protocol DataManagerProtocol: ObservableObject {
    var status: DataManagerStatus { get }
    
    func processLocationBasedData(status: LocationManagerStatus) async
    func processWeatherAPIBasedData(status: WeatherAPIManagerStatus)
    func getLocation()
    func loadWeatherAPIData() async
    func reload()
}


class DataManager: DataManagerProtocol {
    @Published var status = DataManagerStatus.idle
    private var cancellables: Set<AnyCancellable> = []
    private let locationManager = LocationManager()
    private let weatherAPIManager = WeatherAPIManager()
    
    
    //Constructor
    init() {
        //Gets Location While Initializing
        getLocation()
        
        //Observes Changes in LocationManager Status
        locationManager.$status
            .sink { newValue in
                Task {
                    await self.processLocationBasedData(status: newValue)
                }
            }
            .store(in: &cancellables)
        
        //Observes Changes in WeatherAPIManager Status
        weatherAPIManager.$status
            .sink { newValue in
                Task {
                    self.processWeatherAPIBasedData(status: newValue)
                }
            }
            .store(in: &cancellables)
    }
    
    
    //Loads Data Based on LocationManager Status
    func processLocationBasedData(status: LocationManagerStatus) async {
        switch status {
            case .idle:
                break
            case .authRequest:
                break
            case .authUpdated:
                reload()
                break
            case .locationRequest:
                break
            case .locationUpdated:
                await loadWeatherAPIData()
                break
        }
    }
    
    
    //Loads Data Based on WeatherAPIManager Status
    func processWeatherAPIBasedData(status: WeatherAPIManagerStatus) {
        switch status {
            case .idle:
                break
            case .updatedForecastData:
                self.status = .weatherDataUpdated
                break
        }
    }
    
    
    //Checks Authorization and Gets Location
    func getLocation() {
        if locationManager.checkAuthorization() {
            locationManager.updateCurrentLocation()
        }
        else {
            status = .waitingForAuthorization
        }
    }
    
    
    //Requests Location Authorization
    func requestLocationAuthorization() {
        locationManager.requestAuthorization()
    }
    
    
    //Gets Weather Data
    func loadWeatherAPIData() async {
        do {
            if let location = locationManager.location {
                try await weatherAPIManager.loadForecastData(latitude: location.latitude, longitude: location.longitude)
            }
        } catch {
            //weather data error
            print("error geting weatherdata: ", error)
        }
    }
    
    
    //Gets ForecastData
    func getForecastData() -> ForecastData? {
        if let forecastData = weatherAPIManager.forecastData {
            return forecastData
        }
        return nil
    }
    
    
    //Reloads DataManager
    func reload() {
        status = .idle
        locationManager.status = .idle
        weatherAPIManager.status = .idle
        getLocation()
    }
}
