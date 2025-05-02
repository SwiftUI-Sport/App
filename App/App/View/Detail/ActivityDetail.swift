//
//  ProfileDetail.swift
//  App
//
//  Created by Ali An Nuur on 24/04/25.
//

import SwiftUI

struct FirstActivityView: View {
    
    @EnvironmentObject var router: ActivityFlowRouter
    
    var body: some View {
        VStack {
            Button("Go to Second Activity") {
                router.navigate(to: .secondProfile)
            }
        }
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SecondActivityView: View {
    @EnvironmentObject var router: ActivityFlowRouter
    
    var body: some View {
        VStack {
            Button("Go to Activity") {
                router.navigateToRoot()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
