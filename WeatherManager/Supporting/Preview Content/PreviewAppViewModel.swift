//
//  PreviewAppViewModel.swift
//  WeatherManager
//
//  Created by Austen Radigk on 3/4/24.
//

class PreviewAppViewModel: AppViewModel {
    private let previewData = PreviewDataLoader()
    
    
    override func observeStatusChanges() {}
    
    
    //Prints Message if Location Button is Pressed
    override func requestLocationAuthorization() {
        print("Location Button Pressed")
    }
    
    
    //Returns WeatherComponentViewModel with ModelForecastData
    override func getWeatherComponentViewModel() -> WeatherComponentViewModel {
        let forecastData = previewData.forecastData
        return WeatherComponentViewModel(forecastData: forecastData)
    }
}
