//
//  Home.swift
//  CourseWork1
//
//  Created by user271431 on 12/23/24.
//

import SwiftUI

struct Home: View {
    @State var city: String = "Colombo"
    @StateObject private var weatherService = WeatherService()
    
    var body: some View {
        ZStack {
            Image("background1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ScrollView(.vertical) {
                if let weatherData = weatherService.weatherData {
                    VStack {
                        TitleDesc(weatherData: weatherData)
                        
                        ForecastListView(forecasts: weatherService.dailyForecasts)
                        
                        HStack {
                            HomeCards(value: Int(weatherData.main.feelsLike), symbol: "°", title: "FEELS LIKE", description: "It is very sunny that no one wanrts to go out", icon: "thermometer")
                            HomeCards(value: weatherData.main.humidity, symbol: "%", title: "HUMIDITY", description: "", icon: "humidity.fill")
                        }
                        
                        HStack {
                            HomeCards(value:weatherData.main.pressure, symbol: " hPa", title: "PRESSURE", description: "", icon: "speedometer")
                            HomeCards(value: weatherData.visibility, symbol: " km", title: "VISIBILITY", description: "", icon: "humidity.fill")
                        }
                        
                        WindCard()
                        
                        Spacer()
                    }
                    .padding(.top, 30)
                    
                } else {
                    ProgressView("Fetching weather data.....")
                }
                
                if let error = weatherService.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .onAppear {  // Moved onAppear here
            weatherService.fetchWeather(for: city)
            weatherService.fetchForecast(for: city)
        }
    }
}

#Preview {
    Home()
}

struct HomeCards: View {
    var value : Int
    var symbol : String
    var title : String
    var description : String
    var icon : String
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: icon)
                Text("\(title)            ")
            }
            .foregroundStyle(Color.white.opacity(0.5))
            
            Text("\(value)\(symbol)                              ")
                .font(.largeTitle)
                .padding(.top,1)
            
            Text("\(description)")
            Spacer()
            
        }
        .padding()
        .frame(minWidth: 150, maxWidth: 180, minHeight: 150, maxHeight: 180 ,alignment: .topLeading)
        .foregroundStyle(.white)
        .background(Color.blue.opacity(0.2), in: RoundedRectangle(cornerRadius: 20))
    }
}

struct TitleDesc: View {
    @StateObject private var weatherService = WeatherService()
    let weatherData: WeatherData
    
    var body: some View {
            VStack{
                Text("MY LOCATION")
                    .font(.caption)
                Text("\(weatherData.name)")
                    .font(.largeTitle)
                Text("\(String(format: "%.0f°C", weatherData.main.temp))")
                    .font(.system(size: 80))
                if let firstWeather = weatherData.weather.first {
                    Text("\(firstWeather.main)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.cyan)
                }
                Text("H:\(String(format: "%.2f°C",weatherData.main.tempMax))  L:\(String(format:"%.2f°C",weatherData.main.tempMin))")
                    .font(.title2)
                    .fontWeight(.bold)
                
            }
            .padding()
            .foregroundStyle(Color(.white))
        
    }
}

struct WindCard: View {
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image(systemName: "wind")
                Text("WIND")
            }
            .foregroundStyle(Color.white.opacity(0.5))
            
            HStack{			
                VStack {
                    HStack{
                        Text("Wind")
                            .font(.headline)
                        
                        Spacer()
                        Text("9 km/h") 
                            .foregroundStyle(Color.white.opacity(0.5))
                        
                    }
                    .padding(2)
                    Divider()
                    
                    HStack{
                        Text("Gusts")
                            .font(.headline)
                        Spacer()
                        Text("17 km/h")
                            .foregroundStyle(Color.white.opacity(0.5))
                    }
                    .padding(2)
                    Divider()
                    
                    HStack{
                        Text("Direction")
                            .font(.headline)
                        Spacer()
                        Text("237° WSW")
                            .foregroundStyle(Color.white.opacity(0.5))
                    }
                    .padding(2)
                }
                .frame(minWidth:200)
                
                Spacer()
                
                ZStack{
                    Circle()
                        .stroke(.white, lineWidth: 2)
                        .frame(width: 120, height: 120)
                    
                    // Basic cardinal points
                    Text("N").offset(y: -45)
                    Text("E").offset(x: 45)
                    Text("S").offset(y: 45)
                    Text("W").offset(x: -45)
                    // Simple arrow
                    
                    ZStack {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(237))
                        Text("\(Int(237)) km/h")
                            .font(.system(size: 10))
                            .foregroundStyle(.blue)
                            .background(.white)
                            .padding(.top, 8)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: 370, alignment: .topLeading)
        .foregroundStyle(.white)
        .background(Color.blue.opacity(0.2), in: RoundedRectangle(cornerRadius: 20))
    }
}


