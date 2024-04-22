//
//  WeatherComponentUtils.swift
//  WeatherManager
//
//  Created by Austen Radigk on 3/6/24.
//

import Foundation

class WeatherComponentUtils {
    private var settingsUnit = UserDefaults.standard.string(forKey: "settingsUnit") ?? "fahrenheit" //WIP
    
    
    //Gets Sunrise/Sunset Data with Current Time
    func getSunData(dayInfoList: [String]) -> [String] {
        let dayState = dayInfoList[0]
        let currentTime = dayInfoList[2]
        let sunriseTime = dayInfoList[3]
        let sunsetTime = dayInfoList[4]
        
        if dayState == "night" {
            return [currentTime, "sunrise", sunriseTime]
        }
        
        return [currentTime, "sunset", sunsetTime]
    }
    

    //Gets Temperature/Wind Units
    func getUnits() -> [String] {
        if settingsUnit == "celsius" {
            return ["°C", "km/h"]
        }
        else if settingsUnit == "kelvin" {
            return ["K", "km/h"]
        }
        return ["°F", "mph"]
    }
    
    
    //Converts Kelvin Temperature
    func convertTemp(kelvinData: Double) -> String {
        if settingsUnit == "celsius" {
            return (kelvinData-273.15).roundToString()
        }
        else if settingsUnit == "kelvin" {
            return kelvinData.roundToString()
        }
        return (1.8*(kelvinData-273.15)+32).roundToString()
    }
    
    
    //Converts Metric Wind Data
    func convertWind(metricData: Double) -> String {
        if settingsUnit == "celsius" || settingsUnit == "kelvin" {
            return (metricData * 3.6).roundToString()
        }
        return (metricData * 2.23694).roundToString()
    }
    
    
    //Gets Condition Icon
    func getConditionIcon(conditionInt: Int) -> String {
        if conditionInt == 1 {return "cloud"}
        else if conditionInt == 2 {return "cloud.drizzle"}
        else if conditionInt == 3 {return "cloud.rain"}
        else if conditionInt == 4 {return "cloud.bolt.rain"}
        else if conditionInt == 5 {return "cloud.snow"}
        return "sun.max"
    }
    
    
    //Smart Average of List (Excludes 0)
    func smartAverage(list_item: [Double]) -> String {
        var avg_item = 0.0
        var count = 0.0
        for item in list_item {
            if item > 0 {
                count += 1
                avg_item += item
            }
        }
        if avg_item > 0 {return (avg_item / count).roundToString()}
        return "0"
    }
}
