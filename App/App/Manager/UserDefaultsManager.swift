//
//  UserDefaultsManager.swift
//  App
//
//  Created by Ali An Nuur on 30/04/25.
//

import Foundation
import Combine

final class UserDefaultsManager: ObservableObject {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard

    private enum Keys {
        static let age       = "age"
        static let maxHR     = "maxHR"
        static let restingHR = "restingHR"
    }
//adada
    @Published var age: Int {
        didSet {
            defaults.set(age, forKey: Keys.age)
        }
    }

    @Published var maxHR: Int {
        didSet {
            defaults.set(maxHR, forKey: Keys.maxHR)
            objectWillChange.send()
        }
    }

    @Published var restingHR: Int {
        didSet {
            defaults.set(restingHR, forKey: Keys.restingHR)
            objectWillChange.send()
        }
    }

    var hrr: Int {
        return maxHR - restingHR
    }

    private init() {
        self.age       = defaults.integer(forKey: Keys.age)
        self.maxHR     = defaults.integer(forKey: Keys.maxHR)
        self.restingHR = defaults.integer(forKey: Keys.restingHR)
    }

    func reset() {
        defaults.removeObject(forKey: Keys.age)
        defaults.removeObject(forKey: Keys.maxHR)
        defaults.removeObject(forKey: Keys.restingHR)
        age       = 0
        maxHR     = 0
        restingHR = 0
    }
    
}
