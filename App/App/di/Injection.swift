//
//  Injection.swift
//  App
//
//  Created by Ali An Nuur on 28/04/25.
//
import Foundation
import SwiftUI

@MainActor
final class Injection: ObservableObject {
  static let shared = Injection()
    
  private init() {
  }

  private lazy var healthRepo: HealthKitRepositoryProtocol = {
    HealthKitRepository(store: HealthKitStore.shared, userDefaultsManager: UserDefaultsManager.shared)
  }()

  private lazy var healthVM: HealthKitViewModel = {
    HealthKitViewModel(repository: healthRepo)
  }()

  func getHealthViewModel() -> HealthKitViewModel {
    return healthVM
  }

}
