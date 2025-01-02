//
//  HourlyForecastView.swift
//  CourseWork1
//
//  Created by user271431 on 12/24/24.
//

import SwiftUI

struct HourlyForecastView: View {
    
    @State var hour : Int
    @State var hourTemp : Double
    var body: some View {
        VStack{
            Text("\(hour)")
                .font(.headline)
            Image(systemName: "cloud.fill")
            Text("\(hourTemp)")
                .font(.title2)
                .fontWeight(.bold)
        }
        .foregroundStyle(.white)
        .padding()
        .background(Color.blue.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
}

#Preview {
    HourlyForecastView(hour: 19, hourTemp: 95.0)
}
