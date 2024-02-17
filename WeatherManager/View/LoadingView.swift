//
//  LoadingView.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import SwiftUI

struct LoadingView: View {
    @StateObject private var viewModel = LoadingViewModel()
    @State private var showProgressView = true
    @State private var showErrorAlert = false
    @State private var showWelcomeView = false
    @State private var showWeatherView = false
    
    //Reloads LoadingView to Show New Data
    private func reload() {
        showWeatherView = false
        showWelcomeView = false
        showProgressView = true
        viewModel.status = "location"
        viewModel.reload = false
    }
    
    //Loads Data
    private func loadData() {
        if viewModel.checkLocationAuthorization() {
            //WIP
        }
        else {
            showWelcomeView = true
        }
    }
    
    var body: some View {
        let _ = print("loadingview") //reloading test
        
        //Calls Reload
        if viewModel.reload {
            Text("Reloading")
                .onAppear() {
                    reload()
                }
        }
        
        //Shows ProgressView
        if showProgressView {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .frame(maxWidth: .infinity, maxHeight: 25)
                .task {
                    loadData()
                }
        }
        
        //Shows WelcomeView
        if showWelcomeView {
            WelcomeView()
                .environmentObject(viewModel)
                .onAppear() {showProgressView = false}
        }
        
        //Shows WeatherView
        if showWeatherView {
            //WIP
        }
        
    }
}

#Preview {
    LoadingView()
}
