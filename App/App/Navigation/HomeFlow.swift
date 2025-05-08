//
//  HomeFlow.swift
//  App
//
//  Created by Ali An Nuur on 24/04/25.
//

import SwiftUI

enum HomeFlow: NavigationDestination {

    case first
    case second
    case third
    
    var title: String {
        switch self {
        case .first:
            return "Heart Rate"
        case .second:
            return "Workout Duration"
        case .third:
            return "Sleep Duration"
        }
    }
        
    var destinationView: some View {
        switch self {
        case .first: HeartRateView()
        case .second: WorkoutDurationView()
        case .third: SleepDuration()
        }
    }
}

typealias HomeFlowRouter = Router<HomeFlow>
