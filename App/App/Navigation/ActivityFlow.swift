//
//  ProfileFlow.swift
//  App
//
//  Created by Ali An Nuur on 24/04/25.
//

import SwiftUI

enum ActivityFlow: NavigationDestination, Hashable {
    
    case firstProfile
    case secondProfile(WorkoutActivity)
    
    var title: String {
        switch self {
        case .firstProfile:
            return "FirstProfile"
        case .secondProfile:
            return "Detail Activity"
        }
    }
    
    var destinationView: some View {
        switch self {
        case .firstProfile:
            FirstActivityView()
        case .secondProfile(let activity):
            SecondActivityView(activity:activity)
        }
    }
}

typealias ActivityFlowRouter = Router<ActivityFlow>
