//
//  ForecastData.swift
//  CourseWork1
//
//  Created by user271431 on 12/24/24.
//

import Foundation

struct ForecastResponse: Codable {
    let list: [ForecastItem]
    let city: City
}

struct City: Codable {
    let name: String
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct ForecastItem: Codable {
    let dt: Int // timestamp
    let main: ForecastMain
    let weather: [WeatherDescription]
    
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(dt))
    }
}

struct ForecastMain: Codable {
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}
