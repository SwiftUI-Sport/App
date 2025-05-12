//
//  ContentView.swift
//  App
//
//  Created by Ali An Nuur on 24/04/25.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var HealthKitViewModel: HealthKitViewModel
    
    var body: some View {
        TabView {
            Group {
                HomeView()
                    .environmentObject(HealthKitViewModel)
                
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                
                
                ActivityView()
                
                    .tabItem {
                        Label("Activity", systemImage: "figure.run.circle.fill")
                    }
            }
            .toolbarBackground(.visible, for: .tabBar)
        }
        .accentColor(Color("primary_1"))
    }
}
#Preview {
    ContentView()
}
