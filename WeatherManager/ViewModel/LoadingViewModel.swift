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
    
    func checkLocationAuthorization() -> Bool
    func requestLocationAuthorization()
    func getLocation() async
}


class LoadingViewModel: LoadingViewModelProtocol {
    @Published var reload = false
    private let locationManager = LocationManager()
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
    
    
    //Gets Location
    func getLocation() async {
        do {
            try await locationManager.updateCurrentLocation()
        } catch {
            //Location Error
            print("Error Loading Location: ", error)
        }
    }
    
    
    //Gets WeatherViewModel With Current LocationManager Instance
    func getWeatherViewModel() -> WeatherViewModel {
        let weatherViewModel = WeatherViewModel(locationManager: locationManager)
        return weatherViewModel
    }
}
