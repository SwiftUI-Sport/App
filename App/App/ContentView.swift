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
          
            Tab("Home", systemImage: "house.fill") {
                HomeView()
                    .environmentObject(HealthKitViewModel)
            }
            
            Tab("Profile", systemImage: "figure.run.circle.fill") {
                ActivityView()
            }
            
        }
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        }
        .accentColor(Color("primary_1"))
    }
}

#Preview {
    ContentView()
}
