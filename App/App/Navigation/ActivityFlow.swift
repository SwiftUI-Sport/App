//
//  ProfileFlow.swift
//  App
//
//  Created by Ali An Nuur on 24/04/25.
//
import SwiftUI

enum ActivityFlow: NavigationDestination {
    case firstProfile
    case secondProfile
    
    
    var title: String {
        switch self {
        case .firstProfile:
            return "FirstProfile"
        case .secondProfile:
            return "SecondProfile"
        }
    }
    
    var destinationView: some View {
        switch self {
        case .firstProfile:
            FirstActivityView()
        case .secondProfile:
            SecondActivityView()
        }
    }
}

typealias ActivityFlowRouter = Router<ActivityFlow>
