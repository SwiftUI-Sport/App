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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(di.getHealthViewModel())
        }
    }
}
