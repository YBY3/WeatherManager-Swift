//
//  LoadingView.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import SwiftUI

struct LoadingView: View {
    @StateObject private var viewModel = LoadingViewModel()
    
    var body: some View {
        
        //Shows Loading Icon
        if viewModel.showProgressView == true {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .frame(maxWidth: .infinity, maxHeight: 25)
                .onAppear {
                    Task {await viewModel.loadData()}
                }
        }
        
        //Shows WelcomeView
        if viewModel.showWelcomeView == true {
            WelcomeView()
        }
    }
}

#Preview {
    LoadingView()
}
