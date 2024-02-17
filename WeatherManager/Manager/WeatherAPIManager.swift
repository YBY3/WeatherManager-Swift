//
//  WeatherAPIManager.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/17/24.
//

import Foundation

import CoreLocation

class WeatherAPIManager {
    let config = WeatherAPIConfig()
            
    //Loads Weather API Data into ForcastData ResponseBody
    func loadForecastData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ForecastData {
        let forecastURL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(config.getWeatherAPIKey())"
        guard let url = URL(string: forecastURL) else { fatalError("Missing URL")}
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Could Not Load Weather Data") }
        let decodeData = try JSONDecoder().decode(ForecastData.self, from: data)
        return decodeData
    }
}

//Forecast Data Format
struct ForecastData: Decodable {
    
    var city: CityResponse
    var list: [ListResponse]
    
    struct CityResponse: Decodable {
        var name: String
        var timezone: Int
        var sunrise: Double
        var sunset: Double
    }
    
    struct ListResponse: Decodable {
        var dt: Double
        var main: MainResponse
        var weather: [WeatherResponse]
        var wind: WindResponse
        var pop: Double
    }
    
    struct MainResponse: Decodable {
        var temp: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WeatherResponse: Decodable {
        var main: String
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
        var gust: Double
    }
}
