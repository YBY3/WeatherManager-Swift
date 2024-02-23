//
//  LoadingViewModel.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import SwiftUI
import Combine

protocol LoadingViewModelProtocol: ObservableObject {
    var showProgressView: Bool { get }
    var showWelcomeView: Bool { get }
    var showWeatherView: Bool { get }
    
    func processData(status: DataManagerStatus) async
    func getWelcomeView() -> WelcomeView
    func getWeatherView() -> WeatherView
}


class LoadingViewModel: LoadingViewModelProtocol {
    @Published var showProgressView = true
    @Published var showWelcomeView = false
    @Published var showWeatherView = false
    private var cancellables: Set<AnyCancellable> = []
    private var dataManager = DataManager()
    
    
    //Constructor
    init() {
        //Observes Changes in DataManager Status
        dataManager.$status
            .sink { newValue in
                Task {
                    await self.processData(status: newValue)
                }
            }
            .store(in: &cancellables)
    }
    
    
    //Shows Views Based DataManager Status
    func processData(status: DataManagerStatus) async {
        await MainActor.run {
            switch status {
            case .idle:
                showWeatherView = false
                showWelcomeView = false
                showProgressView = true
                break
            case .waitingForAuthorization:
                showProgressView = false
                showWelcomeView = true
                break
            case .weatherDataUpdated:
                showProgressView = false
                showWeatherView = true
                break
            }
        }
    }
    
    
    //Gets Current LocationManager Instance
    func getWelcomeView() -> WelcomeView {
        return WelcomeView(dataManager: self.dataManager)
    }
    
    
    //Gets WeatherView and WeatherViewModel with Current DataManager Instance
    func getWeatherView() -> WeatherView {
        let weatherViewModel = WeatherViewModel(dataManager: self.dataManager)
        return WeatherView(viewModel: weatherViewModel)
    }
}
