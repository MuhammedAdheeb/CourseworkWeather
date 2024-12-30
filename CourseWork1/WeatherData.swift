//
//  WeatherData.swift
//  CourseWork1
//
//  Created by user271431 on 12/23/24.
//

import Foundation

struct WeatherData: Codable {
    let main: MainWeather
    let wind: WindConditions
    let weather: [WeatherDescription]  // Changed to array
    let name: String
    let visibility: Int
}

struct WeatherDescription: Codable {
    let main: String
    let description: String
    let icon: String
}

struct MainWeather: Codable {
    let temp: Double
    let humidity: Int
    let feelsLike: Double
    let pressure: Int
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case humidity
        case feelsLike = "feels_like"
        case pressure
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct WindConditions: Codable {
    let speed: Double
    let gust: Double?      
    let degree: Int
    
    enum CodingKeys: String, CodingKey {
        case speed
        case gust
        case degree = "deg"
    }
}
