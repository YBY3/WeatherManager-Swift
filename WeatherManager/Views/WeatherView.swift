//
//  WeatherView.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/17/24.
//

import SwiftUI

struct WeatherView: View {
    private let viewModel: AppViewModel
    private let weatherComponentViewModel: WeatherComponentViewModel
    
    init(viewModel: AppViewModel) {
        self.viewModel = viewModel
        self.weatherComponentViewModel = viewModel.getWeatherComponentViewModel()
    }

    var body: some View {
        let _ = print("weatherview") //reloading test
        
        weatherComponentViewModel.getCurrentRow()
        ForecastRows(viewModel: weatherComponentViewModel)
    }
}


//ForecastRows Struct
struct ForecastRows: View {
    let viewModel: WeatherComponentViewModel
    
    var body: some View {
        VStack(spacing: 7) {
            ForEach(0...4, id: \.self) { i in
                Button {
                    
                    //wip
//                    uM.sheetBool = true
//                    uM.setSheetList(item: [0, i])
                    
                } label: {
                    viewModel.getForecastRow(index: i)
                }
            }
        }
        .padding(7)
        .background(Color(UIColor.systemGray6))
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}


#Preview {
    WeatherView(viewModel: PreviewAppViewModel())
}
