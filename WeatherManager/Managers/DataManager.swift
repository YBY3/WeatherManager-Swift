//
//  DataManager.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/22/24.
//

import Combine

enum DataManagerState {
    case loading
    case waitingForAuth
    case weatherUpdated
}


protocol DataManagerProtocol: ObservableObject {
    var status: DataManagerState { get }
    
    func observeStatusChanges()
    func getLocation()
    func fetchForecastData() async
    func reload()
}


class DataManager: DataManagerProtocol {
    @Published var status = DataManagerState.loading
    private var locationManager: LocationManager
    private let appCancellables: AppCancellables //WIP
    private var networkManager = NetworkManager()
    
    
    init(locationManager: LocationManager, appCancellables: AppCancellables) {
        self.locationManager = locationManager
        self.appCancellables = appCancellables
        
        getLocation()
        observeStatusChanges()
    }
    
    
    //Observes LocationManager and NetworkManager Status
    func observeStatusChanges() {
        locationManager.$status
            .sink { state in
                Task {
                    await self.processLocationBasedData(state: state)
                }
            }
            .store(in: &appCancellables.cancellables) //WIP
        
        networkManager.$status
            .sink { state in
                Task {
                    await self.processNetworkBasedData(state: state)
                }
            }
            .store(in: &appCancellables.cancellables) //WIP
    }
    
    
    //Loads Data Based on LocationManager Status
    private func processLocationBasedData(state: LocationManagerState) async {
        switch state {
            case .idle, .authRequest, .locationRequest:
                break
            case .authUpdated:
                reload()
                break
            case .locationUpdated:
                await fetchForecastData()
                break
        }
    }
    
    
    //Loads Data Based on NetworkManager Status
    private func processNetworkBasedData(state: NetworkManagerState) async {
        switch state {
            case .idle:
                break
            case .forecastUpdated:
                status = .weatherUpdated
                break
        }
    }
    
    
    //Checks Authorization and Gets Location
    func getLocation() {
        if locationManager.checkAuthorization() {
            locationManager.updateCurrentLocation()
        }
        else {
            status = .waitingForAuth
        }
    }
    
    
    //Fetches Forecast Data
    func fetchForecastData() async {
        do {
            if let location = locationManager.location {
                try await networkManager.fetchForecastData(latitude: location.latitude, longitude: location.longitude)
            }
        } catch {
            //weather data error
            print("error geting weatherdata: ", error)
        }
    }
    
    
    //Reloads All Data
    func reload() {
        locationManager.status = .idle
        networkManager.status = .idle
        status = .loading
        getLocation()
    }
    
    
    //Gets ForecastData (wip)
    func getForecastData() -> ForecastData? {
        if let forecastData = networkManager.forecastData {
            return forecastData
        }
        return nil
    }
}
