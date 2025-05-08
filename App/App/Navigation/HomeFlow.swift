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
            return "First Screen"
        case .second:
            return "Second Screen"
        case .third:
            return "Sleep Duration"
        }
    }
        
    var destinationView: some View {
        switch self {
        case .first: FirstScreenView()
        case .second: SecondScreenView()
        case .third: SleepDuration()
        }
    }
}

typealias HomeFlowRouter = Router<HomeFlow>
