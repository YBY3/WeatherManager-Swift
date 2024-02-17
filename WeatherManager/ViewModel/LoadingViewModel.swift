//
//  LoadingViewModel.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import SwiftUI
import Combine

protocol LoadingViewModelProtocol: ObservableObject {
    var reload: Bool { get }
    var status: String { get }
    
    func checkLocationAuthorization() -> Bool
    func requestLocationAuthorization()
    func getLocation() async
    func getWeatherData()
}


class LoadingViewModel: LoadingViewModelProtocol {
    @Published var reload = false
    @Published var status = "location"
    private var locationManager = LocationManager()
    private var cancellables: Set<AnyCancellable> = []
    
    
    init() {
        //Observes Changes in LocationManager Status
        locationManager.$status
            .sink { [weak self] newValue in
                self?.checkLocationStatus(status: newValue)
            }
            .store(in: &cancellables)
    }
    
    
    //Performs Actions Based on LocationManager Status
    private func checkLocationStatus(status: String) {
        if status == "auth_updated" {
            reload = true
        }
    }
    
    
    //Checks Access to Obtain Current Location
    func checkLocationAuthorization() -> Bool {
        return locationManager.checkAuthorization()
    }
    
    
    //Requests Location Authorization from LocationManager
    func requestLocationAuthorization() {
        locationManager.requestAuthorization()
    }
    
    
    func getLocation() async {
        do {
            try await locationManager.updateCurrentLocation()
        } catch {
            //Location Error
        }
    }
    
    
    func getWeatherData() {
    }
}
