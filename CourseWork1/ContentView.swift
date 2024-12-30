//
//  ContentView.swift
//  CourseWork1
//
//  Created by user271431 on 12/23/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            Home()
                .tabItem{
                    Label("Home", systemImage: "sun.max.fill")
                }
            
            SavedPlaces()
                .tabItem{
                    Label("Saved Places", systemImage: "calendar")
                }
            
        }
    }
}

#Preview {
    ContentView()
}
