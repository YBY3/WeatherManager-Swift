//
//  RootViewModel.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/28/24.
//

import SwiftUI
import Combine

enum AppViewState {
    case loading
    case welcome
    case weather
}


protocol AppViewModelProtocol: ObservableObject {
    var viewState: AppViewState { get }
    
    func requestLocationAuthorization()
}


class AppViewModel: AppViewModelProtocol {
    @Published var viewState = AppViewState.loading
    private var dataManager: DataManager
    private let locationManager = LocationManager()
    private let appCancellables = AppCancellables() //WIP
    
    
    init() {
        self.dataManager = DataManager(locationManager: locationManager, appCancellables: appCancellables)
        observeStatusChanges()
    }
    
    
    //Observes DataManager Status
    func observeStatusChanges() {
        dataManager.$status
            .sink { state in
                Task {
                    await self.getViewState(state: state)
                }
            }
            .store(in: &appCancellables.cancellables) //WIP
    }
    
    
    private func getViewState(state: DataManagerState) async {
        await MainActor.run {
            switch state {
            case .loading:
                viewState = .loading
            case .waitingForAuth:
                viewState = .welcome
            case .weatherUpdated:
                viewState = .weather
            }
        }
    }
    

    //Requests Location Authorization from LocationManager
    func requestLocationAuthorization() {
        locationManager.requestAuthorization()
    }
    
    
    //Gets ForecastData (wip)
    func getForecastData() -> ForecastData? {
        if let forecastData = dataManager.getForecastData() {
            return forecastData
        }
        return nil
    }

}

