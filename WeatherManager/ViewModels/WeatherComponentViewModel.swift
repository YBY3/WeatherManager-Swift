//
//  WeatherComponentViewModel.swift
//  WeatherManager
//
//  Created by Austen Radigk on 3/1/24.
//

import Foundation

protocol WeatherComponentViewModelProtocol: ObservableObject {

}


class WeatherComponentViewModel: WeatherComponentViewModelProtocol {
    private let forecastDataLoader: ForecastDataLoader
    private var settingsUnit = UserDefaults.standard.string(forKey: "settingsUnit") ?? "fahrenheit" //WIP
    
    
    init(forecastData: ForecastData?) {
        forecastDataLoader = ForecastDataLoader(forecastData: forecastData)
    }
    
    
    func getCurrentRowData() -> ([String], [String], String, [String]) {
        let temp = convertTemp(kelvin_temp: forecastDataLoader.kelvinTempLists[0][0])
        let wind = convertWind(data: forecastDataLoader.windAvgLists[0][0])
        let icon = getConditionIcon(conditionInt: forecastDataLoader.conditionLists[0][0]) //ADD MORE DETAIL
        let sunData = getDayInfo(dayInfoList: forecastDataLoader.dayInfoList)
        
        return (temp, wind, icon, sunData)
    }
    
    
    //Converts Kelvin Temp Data
    private func convertTemp(kelvin_temp: Double) -> [String] {
        if settingsUnit == "celsius" {
            return [(kelvin_temp-273.15).roundToString() + "°", "C"]
        }
        else if settingsUnit == "kelvin" {
            return [kelvin_temp.roundToString(), "K"]
        }
        return [(1.8*(kelvin_temp-273.15)+32).roundToString() + "°", "F"]
    }
    
    
    //Converts Metric Wind Data
    private func convertWind(data: Double) -> [String] {
        if settingsUnit == "celsius" || settingsUnit == "kelvin" {
            return [(data * 3.6).roundToString(), "km/h"]
        }
        return [(data * 2.23694).roundToString(), "mph"]
    }

    
    //Gets Sunrise/Sunset Data Based on Time (WIP)
    private func getDayInfo(dayInfoList: [String]) -> [String] {
        let dayState = dayInfoList[0]
        let currentTime = dayInfoList[2]
        let sunriseTime = dayInfoList[3]
        let sunsetTime = dayInfoList[4]
        
        if dayState == "night" {
            return ["sunrise", currentTime, sunriseTime]
        }
        
        return ["sunset", currentTime, sunsetTime]
    }
    
    
    //Gets Condition Icon
    private func getConditionIcon(conditionInt: Int) -> String {
        if conditionInt == 1 {return "cloud"}
        else if conditionInt == 2 {return "cloud.drizzle"}
        else if conditionInt == 3 {return "cloud.rain"}
        else if conditionInt == 4 {return "cloud.bolt.rain"}
        else if conditionInt == 5 {return "cloud.snow"}
        return "sun.max"
    }
}
