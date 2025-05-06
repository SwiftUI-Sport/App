//
//  Router.swift
//  App
//
//  Created by Ali An Nuur on 24/04/25.
//
import Foundation
import SwiftUI

protocol NavigationDestination {
    associatedtype Destination: View
    
    var title: String { get }
    @ViewBuilder
    var destinationView: Destination { get }
}

final class Router<Destination: NavigationDestination>: ObservableObject {
    
    @Published var navPaths: [Destination] = []
    
    func navigate(to destination: Destination) {
        navPaths.append(destination)
    }
    
    func navigateBack() {
        guard !navPaths.isEmpty else { return }
        navPaths.removeLast()
    }
    
    func navigateToRoot() {
        navPaths.removeLast(navPaths.count)
    }
    
    func navigateTo(_ destination: Destination) where Destination: Equatable {
        if let index = navPaths.firstIndex(of: destination) {
            navPaths = Array(navPaths[0...index])
        } else {
            navigate(to: destination)
        }
    }
}
