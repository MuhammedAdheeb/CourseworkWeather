//
//  AirQualityCard.swift
//  CourseWork1
//
//  Created by user271431 on 12/31/24.
//

import SwiftUI

struct AirQualityCard: View {
    @State private var so2: Double = 0.0
    @State private var no2: Double = 0.0
    @State private var pm: Double = 0.0
    @State private var voc: Double = 0.0
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Image(systemName: "engine.emission.and.exclamationmark")
                Text("CURRENT AIR QUALITY")
                    .foregroundStyle(Color.white.opacity(0.5))
            }
            HStack {
                Spacer()
                VStack {
                    ZStack {
                        Image(systemName: "smoke.fill")
                            .resizable()
                            .frame(width: 50, height: 40)
                            .scaledToFit()
                        Text("S02")
                            .foregroundStyle(Color.blue.opacity(0.5))
                            .fontWeight(.bold)
                    }
                    Text("\(String(format: "%.1f", so2))")
                }
                Spacer()
                VStack {
                    ZStack {
                        Image(systemName: "smoke.fill")
                            .resizable()
                            .frame(width: 50, height: 40)
                            .scaledToFit()
                        Text("NO2")
                            .foregroundStyle(Color.blue.opacity(0.5))
                            .fontWeight(.bold)
                    }
                    Text("\(String(format: "%.1f", no2))")
                }
                Spacer()
                VStack {
                    ZStack {
                        Image(systemName: "aqi.low")
                            .resizable()
                            .frame(width: 50, height: 40)
                            .scaledToFit()
                        Text("PM")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                    }
                    Text("\(String(format: "%.1f", pm))")
                }
                Spacer()
                VStack {
                    ZStack {
                        Image(systemName: "aqi.low")
                            .resizable()
                            .frame(width: 50, height: 40)
                            .scaledToFit()
                        Text("VOC")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                    }
                    Text("\(String(format: "%.1f", voc))")
                }
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: 370, alignment: .topLeading)
        .foregroundStyle(.white)
        .background(Color.blue.opacity(0.2), in: RoundedRectangle(cornerRadius: 20))
        .onAppear {
            fetchAirQuality()
        }
    }
    
    func fetchAirQuality() {
        // Replace with your API key
        let apiKey = "11c775dc12a86bafecaffc9fb6bf51f1"
        let urlString = "https://api.openweathermap.org/data/2.5/air_pollution?lat=40.7128&lon=-74.0060&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let list = json["list"] as? [[String: Any]],
                   let firstItem = list.first,
                   let components = firstItem["components"] as? [String: Double] {
                    
                    DispatchQueue.main.async {
                        self.so2 = components["so2"] ?? 0
                        self.no2 = components["no2"] ?? 0
                        self.pm = components["pm10"] ?? 0
                        self.voc = components["co"] ?? 0
                    }
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}
