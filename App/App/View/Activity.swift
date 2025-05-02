//
//  Profile.swift
//  App
//
//  Created by Ali An Nuur on 24/04/25.
//

import SwiftUI

struct ActivityView: View {
    
    @StateObject private var router = ActivityFlowRouter()
    
    var body: some View {
        NavigationStack(path: $router.navPaths) {
            mainView
                .navigationDestination(for: ActivityFlow.self) { destination in
                    destination.destinationView
                        .navigationTitle(destination.title)
                        .toolbarRole(.automatic)
                }
        }
        .environmentObject(router)
    }
    
    private var mainView: some View {
        VStack {
            Button("Go to First Activity") {
                router.navigate(to: .firstProfile)
            }
        }
        .navigationTitle("Activity")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    ActivityView()
}
