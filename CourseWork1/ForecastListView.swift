//
//  ForecastListView.swift
//  CourseWork1
//
//  Created by user271431 on 12/24/24.
//

import SwiftUI

struct ForecastListView: View {
    let forecasts: [DailyForecast]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "calendar")
                
                Text("5-DAY FORECAST")
                    .font(.headline)
            }
            .foregroundStyle(.white.opacity(0.5))
            .padding(.bottom, 5)
            
            ForEach(forecasts) { forecast in
                HStack{
                    HStack{
                        Text(formatDay(forecast.date))
                            .frame(width: 80, alignment: .leading)
                            .font(.system(size: 18, weight: .bold))
                        
                        Image(systemName: getWeatherIcon(forecast.weatherIcon))
                            .frame(width: 50)
                            .font(.system(size: 20))
                    } 
                    Spacer()
                    HStack{
                        Text("\(Int(round(forecast.minTemp)))°")
                            .foregroundStyle(.white.opacity(0.5))
                        LinearGradient(
                            gradient: Gradient(colors: [.green, .yellow, .red]),startPoint: .leading,endPoint: .trailing)
                        .frame(height: 8, alignment: .trailing)
                        .cornerRadius(4)
                        Text("\(Int(round(forecast.maxTemp)))°")
                    }
                    .frame(width: 150)
                }
                .padding(.vertical, 8)
                
                if forecast.id != forecasts.last?.id {
                    Divider()
                        .background(Color.white.opacity(0.2))
                }
            }
        }
        .foregroundStyle(.white)
        .padding()
        .background(Color.blue.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
    
    private func formatDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"  // Full day name
        return formatter.string(from: date)
    }
    
    private func getWeatherIcon(_ code: String) -> String {
        switch code {
        case "01d", "01n": return "sun.max.fill"
        case "02d", "02n": return "cloud.sun.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "cloud.fill"
        case "09d", "09n": return "cloud.rain.fill"
        case "10d", "10n": return "cloud.sun.rain.fill"
        case "11d", "11n": return "cloud.bolt.rain.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
}

#Preview {
    ForecastListView(forecasts: [
        DailyForecast(date: Date(), maxTemp: 28, minTemp: 10, weatherIcon: "02d"),
        DailyForecast(date: Date(), maxTemp: 28, minTemp: 10, weatherIcon: "02d"),    ])
}
