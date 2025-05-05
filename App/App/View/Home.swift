//
//  Home.swift
//  App
//
//  Created by Ali An Nuur on 24/04/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    @StateObject private var router = HomeFlowRouter()
    
    var body: some View {
        NavigationStack(path: $router.navPaths) {
            mainView
                .navigationDestination(for: HomeFlow.self) { destination in
                    destination.destinationView
                        .navigationTitle(destination.title)
                        .toolbarRole(.automatic)
                }
        }
        .environmentObject(router)
        .onAppear {
            healthKitViewModel.start()
          }
    }
    
    private var mainView: some View {
        VStack {
            Button("Go to first screen") {
                router.navigate(to: .first)
            }
            // test push
            Button("Print WORKOUT DATA") {
                healthKitViewModel.printActivities()
            }
            Button("Print STRESS") {
                healthKitViewModel.printStressHistories()
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    HomeView()
}
