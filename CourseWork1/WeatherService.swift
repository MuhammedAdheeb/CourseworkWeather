//
//  WeatherService.swift
//  CourseWork1
//
//  Created by user271431 on 12/23/24.
//

import Foundation
import CoreLocation
	
class WeatherService: ObservableObject {
    private let apiKey = "11c775dc12a86bafecaffc9fb6bf51f1"
    @Published var weatherData: WeatherData?
    @Published var errorMessage: String?
    @Published var dailyForecasts: [DailyForecast] = []
    @Published var weatherDataModel : WeatherDataModel?
    
    func fetchWeather(for city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            errorMessage = "Invalid URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let weather = try decoder.decode(WeatherData.self, from: data)
                    self?.weatherData = weather
                    self?.errorMessage = nil
                } catch {
                    self?.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func fetchForecast(for city: String) {
            let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric"
            
            guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
                errorMessage = "Invalid URL"
                return
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let data = data else {
                        self?.errorMessage = "No forecast data received"
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let forecast = try decoder.decode(ForecastResponse.self, from: data)
                        self?.processForecastData(forecast)
                    } catch {
                        self?.errorMessage = "Failed to decode forecast: \(error.localizedDescription)"
                    }
                }
            }.resume()
        }
        
        private func processForecastData(_ forecast: ForecastResponse) {
            let calendar = Calendar.current
            let groupedForecasts = Dictionary(grouping: forecast.list) { item in
                calendar.startOfDay(for: item.date)
            }
            
            let sortedDays = groupedForecasts.keys.sorted()
            let dailyForecasts = sortedDays.prefix(5).map { day -> DailyForecast in
                let items = groupedForecasts[day] ?? []
                let maxTemp = items.map { $0.main.tempMax }.max() ?? 0
                let minTemp = items.map { $0.main.tempMin }.min() ?? 0
                let mostFrequentWeather = items.first?.weather.first
                
                return DailyForecast(
                    date: day,
                    maxTemp: maxTemp,
                    minTemp: minTemp,
                    weatherIcon: mostFrequentWeather?.icon ?? ""
                )
            }
            
            self.dailyForecasts = dailyForecasts
        }
    
    
    
    func fetchWeatherData(for coordinates: CLLocationCoordinate2D) async {
            let lat = coordinates.latitude
            let long = coordinates.longitude
            guard let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(long)&exclude=minutely&appid=12c7d131fd382201484758ccebfaeb8d") else {
                print("Ivalid URL")
                return
            }
            print("-----------------works-------------------")
            
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    print("Invalid response code")
                    return
                }
                
                let decodedData = try JSONDecoder().decode(WeatherDataModel.self, from: data)
                
                DispatchQueue.main.async {
                    self.weatherDataModel = decodedData
                }
            } catch let decodingError as DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("Key '\(key.stringValue)' not found:", context.debugDescription)
                case .typeMismatch(let type, let context):
                    print("Type mismatch for type '\(type)':", context.debugDescription)
                case .valueNotFound(let type, let context):
                    print("Value not found for type '\(type)':", context.debugDescription)
                case .dataCorrupted(let context):
                    print("Data corrupted:", context.debugDescription)
                default:
                    print("Decoding error:", decodingError.localizedDescription)
                }
            } catch {
                print("General error:", error.localizedDescription)
            }
        }
        
         
}

struct DailyForecast: Identifiable {
    let id = UUID()
    let date: Date
    let maxTemp: Double
    let minTemp: Double
    let weatherIcon: String
}
