//
//  LoadingViewModel.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import SwiftUI
import CoreLocation

protocol LoadingViewModelProtocol: ObservableObject {
    var showProgressView: Bool { get }
    var showErrorAlert: Bool { get }
    var showWelcomeView: Bool { get }
    
    func loadData() async
    func getLocation() async
    func getWeatherData()
}

class LoadingViewModel: LoadingViewModelProtocol {

    @Published var showProgressView = true
    @Published var showErrorAlert = false
    @Published var showWelcomeView = false
    private var locationManager = LocationManager()
    
    
    func loadData() async {
        checkAuthorization()
        if showWelcomeView == false {
            await getLocation()
        }
    }
    
    private func checkAuthorization() {
        locationManager.checkAuthorization()
        if locationManager.status == "nil" {
            showWelcomeView = true
        }
    }
    
    func getLocation() async { //WIP
        do {
            try await locationManager.updateCurrentLocation()
        } catch {
            showErrorAlert = true
        }
    }
    
    func getWeatherData() {
    }
}
