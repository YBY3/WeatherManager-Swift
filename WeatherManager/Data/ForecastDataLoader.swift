//
//  ForecastDataLoader.swift
//  WeatherManager
//
//  Created by Austen Radigk on 3/1/24.
//

import Foundation

class ForecastDataLoader: ObservableObject {
    
    private let dateFormatter = DateFormatter()
    private let forecastData: ForecastData?
    @Published var dayInfoList = [String]()
    @Published var dateLists = [[String]]()
    @Published var kelvinTempLists = [[Double]]()
    @Published var precipitationLists = [[Double]]()
    @Published var pressureLists = [[Double]]()
    @Published var humidityLists = [[Double]]()
    @Published var conditionLists = [[Int]]()
    @Published var windAvgLists = [[Double]]()
    @Published var windGustLists = [[Double]]()
    @Published var windDegreeLists = [[Double]]()
    
    
    init(forecastData: ForecastData?) {
        self.forecastData = forecastData
        loadData()
    }
    
 
    //Loads All Data into Lists
    func loadData() {
        if let forecastData = forecastData {
            initializeData()
            loadMisc()
            var militaryHour = (convertTimestamp(timestamp: forecastData.list[0].dt, date_format: "HH") as NSString).integerValue
            var startingIndex = -1
            while militaryHour < 24 {
                militaryHour += 3
                startingIndex += 1
            }
            for i in 0...(startingIndex) {
                appendHourlyData(index1: 0, index2: i)
            }
            appendDailyData(index1: 0, index2: 0)
            for n in 1...4 {
                for i in (startingIndex+1+(8*(n-1)))...(startingIndex+(8*n)) {
                    appendHourlyData(index1: n, index2: i)
                }
                appendDailyData(index1: n, index2: (startingIndex+1+(8*(n-1))))
            }
        }
    }
    
    
    //Sets Lists to Correct Size
    private func initializeData() {
        dayInfoList = []
        dateLists = [[],[],[],[],[]]
        kelvinTempLists = [[],[],[],[],[],[],[]]
        precipitationLists = [[],[],[],[],[]]
        pressureLists = [[],[],[],[],[],[],[]]
        humidityLists = [[],[],[],[],[],[]]
        conditionLists = [[],[],[],[],[]]
        windAvgLists = [[],[],[],[],[]]
        windGustLists = [[],[],[],[],[],[]]
        windDegreeLists = [[],[],[],[],[]]
    }
    
        
    //Loads Day Info Data [day, city_name, current_time, sunrise_time, sunset_time]
    private func loadMisc() {
        if let forecastData = forecastData {
            var militaryTimes = [Int]()
            militaryTimes.append((convertTimestamp(timestamp: Date().timeIntervalSince1970, date_format: "HH") as NSString).integerValue)
            militaryTimes.append((convertTimestamp(timestamp: forecastData.city.sunrise, date_format: "HH") as NSString).integerValue)
            militaryTimes.append((convertTimestamp(timestamp: forecastData.city.sunset, date_format: "HH") as NSString).integerValue)
            if militaryTimes[1] <= militaryTimes[0] && militaryTimes[2] >= militaryTimes[0] {
                dayInfoList.append("day")
            }
            else {dayInfoList.append("night")}
            dayInfoList.append(forecastData.city.name)
            dayInfoList.append(convertTimestamp(timestamp: Date().timeIntervalSince1970, date_format: "EEEE h:mm a"))
            dayInfoList.append(convertTimestamp(timestamp: forecastData.city.sunrise, date_format: "h:mm a"))
            dayInfoList.append(convertTimestamp(timestamp: forecastData.city.sunset, date_format: "h:mm a"))
        }
    }
    
    
    //Appends Hourly Data to Each List
    private func appendHourlyData(index1: Int, index2: Int) {
        if let forecastData = forecastData {
            dateLists[index1].append(convertTimestamp(timestamp: forecastData.list[index2].dt, date_format: "h a"))
            kelvinTempLists[index1].append(forecastData.list[index2].main.temp)
            precipitationLists[index1].append(forecastData.list[index2].pop*100)
            pressureLists[index1].append(forecastData.list[index2].main.pressure)
            humidityLists[index1].append(forecastData.list[index2].main.humidity)
            conditionLists[index1].append(convertCondition(conditionString: forecastData.list[index2].weather[0].main))
            windAvgLists[index1].append(forecastData.list[index2].wind.speed)
            windGustLists[index1].append(forecastData.list[index2].wind.gust)
            windDegreeLists[index1].append(forecastData.list[index2].wind.deg)
        }
    }
    
    
    //Appends Daily Data to Each List
    private func appendDailyData(index1: Int, index2: Int) {
        if let forecastData = forecastData {
            dateLists[index1].insert((convertTimestamp(timestamp: forecastData.list[index2].dt, date_format: "d")), at: 0)
            dateLists[index1].insert((convertTimestamp(timestamp: forecastData.list[index2].dt, date_format: "EE")), at: 0)
            dateLists[index1].insert((convertTimestamp(timestamp: forecastData.list[index2].dt, date_format: "EEEE")), at: 0)
            if let kelvinMin = kelvinTempLists[index1].min() {kelvinTempLists[5].append(kelvinMin)}
            if let kelvinMax = kelvinTempLists[index1].max() {kelvinTempLists[6].append(kelvinMax)}
            if let pressureMin = pressureLists[index1].min() {pressureLists[5].append(pressureMin)}
            if let pressureMax = pressureLists[index1].max() {pressureLists[6].append(pressureMax)}
            if let humidityMax = humidityLists[index1].max() {humidityLists[5].append(humidityMax)}
            if let windGustMax = windGustLists[index1].max() {windGustLists[5].append(windGustMax)}
        }
    }
    
            
   //Converts Timestamp to String in Corresponding Format
    private func convertTimestamp(timestamp: Double, date_format: String) -> String {
        if let forecastData = forecastData {
            dateFormatter.timeZone = TimeZone(secondsFromGMT: forecastData.city.timezone)
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = date_format
            return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
        }
        return "none"
    }
    
       
    //Converts Condition String to Double (Add own Symbols) (Make Universal Function With Ints)
    private func convertCondition(conditionString: String) -> Int {
        if conditionString == "Clouds" {return 1}
        else if conditionString == "Drizzle" {return 2}
        else if conditionString == "Rain" {return 3}
        else if conditionString == "Thunderstorm" {return 4}
        else if conditionString == "Snow" {return 5}
        return 0
    }
}
