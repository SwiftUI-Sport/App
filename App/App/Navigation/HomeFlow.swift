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
            return "Third"
        }
    }
        
    var destinationView: some View {
        switch self {
        case .first: HeartRateView()
        case .second: SecondScreenView()
        case .third: ThirdScreenView()
        }
    }
}

typealias HomeFlowRouter = Router<HomeFlow>
