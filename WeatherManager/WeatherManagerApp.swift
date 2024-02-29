//
//  WeatherManagerApp.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/13/24.
//

import SwiftUI

@main
struct WeatherManagerApp: App {
    @StateObject private var viewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            switch viewModel.viewState {
                case .loading:
                    LoadingView()
                case .welcome:
                    WelcomeView(viewModel: viewModel)
                case .weather:
                    WeatherView(viewModel: viewModel)
            }
        }
    }
}
