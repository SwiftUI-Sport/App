//
//  AppApp.swift
//  App
//
//  Created by Ali An Nuur on 24/04/25.
//

import SwiftUI

@main
struct AppApp: App {
    
    @StateObject private var di = Injection.shared
    @State private var isDarkModeEnabled: Bool = false
    
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isOnboardingCompleted {
                ContentView()
            }
            else{
                OnboardingView()
            }
//            ContentView()
//                .preferredColorScheme(.light)
        }
        .environmentObject(di.getHealthViewModel())
    }
}
