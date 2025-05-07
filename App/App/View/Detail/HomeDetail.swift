//
//  HomeDetail.swift
//  App
//
//  Created by Ali An Nuur on 24/04/25.
//

import SwiftUI

struct FirstScreenView: View {
    
    @EnvironmentObject var router: HomeFlowRouter
    
    var body: some View {
        VStack {
            Button("Go to Second Screen") {
                router.navigate(to: .second)
            }
        }
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SecondScreenView: View {
    @EnvironmentObject var router: HomeFlowRouter

    var body: some View {
        VStack {
            Button("Go to third Screen") {
                router.navigate(to: .third)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ThirdScreenView: View {
    @EnvironmentObject var router: HomeFlowRouter

    var body: some View {
        VStack {
            Button("Go to Home") {
                router.navigateToRoot()
            }
            
            Button("Go to first Screen") {
                router.navigateTo(.first)
            }
        }
        .navigationBarTitleDisplayMode(.large)
    }
}
//dada
