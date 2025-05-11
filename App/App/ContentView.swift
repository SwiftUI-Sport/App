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
            Group{
//                Tab("Home", systemImage: "house.fill") {
                    HomeView()
                        .environmentObject(HealthKitViewModel)
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
//                }
                
//                Tab("Activity", systemImage: "figure.run.circle.fill") {
                    ActivityView()
                        .tabItem {
                            Label("Activity", systemImage: "figure.run.circle.fill")
                        }
//                }
            }
//            .toolbarBackground(.blue, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
//                        .toolbarColorScheme(.dark, for: .tabBar)
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
