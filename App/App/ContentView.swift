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
          
            Tab("Home", systemImage: "music.note.house.fill") {
                HomeView()
                    .environmentObject(HealthKitViewModel)
            }
            
            Tab("Profile", systemImage: "movieclapper.fill") {
                ActivityView()
            }
            
        }
    }
}

#Preview {
    ContentView()
}
