//
//  LoadingViewModel.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import SwiftUI
import Combine
import CoreLocation

protocol LoadingViewModelProtocol: ObservableObject {
    var status: String { get }
    var showProgressView: Bool { get }
    var showWelcomeView: Bool { get }
    var showWeatherView: Bool { get }
    var weatherViewModel: WeatherViewModel? { get }
    
    func loadLocationStatusBasedData(status: String) async
    func loadStatusBasedData(status: String) async
    func getLocation() async
    func requestLocationAuthorization()
    func getWeatherData() async
    func getWeatherViewModel() async
}


class LoadingViewModel: LoadingViewModelProtocol {
    @Published var status = "update_location"
    @Published var showProgressView = true
    @Published var showWelcomeView = false
    @Published var showWeatherView = false
    @Published var weatherViewModel: WeatherViewModel?
    private let locationManager = LocationManager()
    private var cancellables: Set<AnyCancellable> = []
    private var weatherAPIManager = WeatherAPIManager()
    private var forecastData: ForecastData?
    
    
    init() {
        //Observes Changes in LocationManager Status
        locationManager.$status
            .sink { newValue in
                Task {
                    await self.loadLocationStatusBasedData(status: newValue)
                }
            }
            .store(in: &cancellables)
        
        //Observes Changes in LoadingViewModel Status
        $status
            .sink { newValue in
                Task {
                    await self.loadStatusBasedData(status: newValue)
                }
            }
            .store(in: &cancellables)
    }
    
    
    //Loads Data Based on LocationManager Status
    func loadLocationStatusBasedData(status: String) async {
        //Reloads LoadingView if Location Authorization Is Updated
        if status == "auth_updated" {
            await reload()
        }
        
        //Gets WeatherData when Location is Updated
        else if status == "location_updated" {
            await getWeatherData()
        }
    }
    
    
    //Loads Data Based on LoadingViewModel Status
    func loadStatusBasedData(status: String) async {
        //Gets Location if Status is get_location
        if status == "update_location" {
            await getLocation()
        }
        
        //Gets WeatherViewModel After WeatherData is Updated
        if status == "weatherdata_updated" {
            await getWeatherViewModel()
        }
        
        //Shows WeatherView in LoadingView After WeatherViewModel is Updated
        else if status == "weatherviewmodel_updated" {
            await MainActor.run {
                showProgressView = false
                showWeatherView = true
            }
        }
    }
    
    
    private func reload() async {
        await MainActor.run {
            showWeatherView = false
            showWelcomeView = false
            showProgressView = true
            locationManager.status = "idle"
            status = "update_location"
        }
    }
    
    
    //Gets Location and Shows Welcome View If not Authorized
    func getLocation() async {
        if locationManager.checkAuthorization() {
            await locationManager.updateCurrentLocation()
        }
        else {
            await MainActor.run {
                showProgressView = false
                showWelcomeView = true
            }
        }
    }
    
    
    //Requests Location Authorization from LocationManager
    func requestLocationAuthorization() {
        locationManager.requestAuthorization()
    }
    
    
    //Gets Weather Data
    func getWeatherData() async {
        do {
            if let location = locationManager.location {
                let forecastData = try await weatherAPIManager.loadForecastData(latitude: location.latitude, longitude: location.longitude)
                await MainActor.run {
                    self.forecastData = forecastData
                    status = "weatherdata_updated"
                }
            }
        } catch {
            //weather data error
            print("error geting weatherdata: ", error)
        }
    }

    
    //Gets WeatherViewModel with Current LocationManager Instance and ForecastData
    func getWeatherViewModel() async {
        if let forecastData = self.forecastData {
            let weatherViewModel = WeatherViewModel(locationManager: locationManager, forecastData: forecastData)
            await MainActor.run {
                self.weatherViewModel = weatherViewModel
                status = "weatherviewmodel_updated"
            }
        }
    }
}
