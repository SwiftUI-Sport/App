//
//  ProfileFlow.swift
//  App
//
//  Created by Ali An Nuur on 03/09/25.
//

import SwiftUI

enum ProfileFlow: NavigationDestination {
    
    case faq
    
    var title: String {
        switch self {
        case .faq:
            return "FAQ"
        }
    }
    
    var destinationView: some View {
        switch self {
        case .faq: FaqDetail()
        }
    }
}

typealias ProfileFlowRouter = Router<ProfileFlow>
