//
//  HealthKitRepository.swift
//  App
//
//  Created by Ali An Nuur on 28/04/25.
//

import HealthKit


protocol HealthKitRepositoryProtocol {
    
    var isHealthDataAvailable: Bool { get }
    
    var userAge: Int { get }
    
    var userMaxHR: Int { get }
    
    var userRestingHR: Int { get }
    
    var userHRR: Int { get }
    
    func setUserAge(_ age: Int)
    
    func setUserMaxHR(_ maxHR: Int)
    
    func setUserRestingHR(_ restingHR: Int)
    
    func requestAuthorization(completion: @escaping (Result<Bool, HealthKitError>) -> Void)
    
    
    func fetchTotalCalories(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<Double, HealthKitError>) -> Void
    )
    
    func fetchRunningWorkouts(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKWorkout], HealthKitError>) -> Void
    )
    
    func fetchHeartRates(
        for workouts: [HKWorkout],
        completion: @escaping (Result<[(workout: HKWorkout, hrSamples: [HKQuantitySample])], HealthKitError>) -> Void
    )
    
    func fetchHeartRateSamples(
        for workout: HKWorkout,
        completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
    )
    
    func fetchAllWorkouts(
        completion: @escaping (Result<[HKWorkout], HealthKitError>) -> Void
    )
    
    func fetchRestingHeartRateWithinRange(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
    )
    
    func fetchAge(
        completion: @escaping (Result<Int, HealthKitError>
        ) -> Void)
    
    func fetchAllWorkoutsWithinRange(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKWorkout], HealthKitError>) -> Void
      )
    
    func fetchHeartRateSamplesForWorkout(
       for workout: HKWorkout,
       completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
     )
    
    func fetchHeartRateVariability(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
    )
    
    func fetchHeartRate(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
    )
    
    func fetchSleepData(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKCategorySample], HealthKitError>) -> Void
    )

    
}

final class HealthKitRepository: HealthKitRepositoryProtocol {
    
    func fetchHeartRateSamples(for workout: HKWorkout, completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void) {
        //     Temp
    }
    
    private let store: HealthKitStoreProtocol
    
    private let userDefaultsManager: UserDefaultsManager
    
    private let readTypes: Set<HKObjectType>
    
    init(store: HealthKitStoreProtocol, userDefaultsManager: UserDefaultsManager) {
        self.store = store
        self.userDefaultsManager = userDefaultsManager
        
        var types = Set<HKObjectType>()
        if let hr = HKQuantityType.quantityType(forIdentifier: .heartRate) {
            types.insert(hr)
        }
        if let rhr = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) {
            types.insert(rhr)
        }
        if let hrv = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) {
            types.insert(hrv)
        }
        if let cal = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) {
            types.insert(cal)
        }
        if let sleep = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) {
            types.insert(sleep)
        }
        
        if let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth){
            types.insert(dateOfBirth)
        }
        
        types.insert(HKObjectType.workoutType())
        self.readTypes = types
    }
    
    var isHealthDataAvailable: Bool {
        store.isAvailable
    }
    
    var userAge: Int {
        userDefaultsManager.age
    }
    
    var userMaxHR: Int {
        userDefaultsManager.maxHR
    }
    
    var userRestingHR: Int {
        userDefaultsManager.restingHR
    }
    
    var userHRR: Int {
        userDefaultsManager.hrr
    }
    
    func setUserAge(_ age: Int) {
        userDefaultsManager.age = age
    }
    
    func setUserMaxHR(_ maxHR: Int) {
        userDefaultsManager.maxHR = maxHR
    }
    
    func setUserRestingHR(_ restingHR: Int) {
        userDefaultsManager.restingHR = restingHR
    }
    
    func requestAuthorization(
        completion: @escaping (Result<Bool, HealthKitError>) -> Void
    ) {
        store.requestAuthorization(
            toShare: [],
            toRead: readTypes
        ) { result in
            
            completion(result)
        }
    }
    
    func fetchTotalCalories(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<Double, HealthKitError>) -> Void
    ) {
        store.fetchTotalCalories(from: start, to: end) { result in
            completion(result)
        }
    }
    
    func fetchRunningWorkouts(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKWorkout], HealthKitError>) -> Void
    ) {
        store.fetchRunningWorkouts(from: start, to: end) { result in
            completion(result)
        }
    }
    
    func fetchHeartRates(
        for workouts: [HKWorkout],
        completion: @escaping (Result<[(workout: HKWorkout, hrSamples: [HKQuantitySample])], HealthKitError>) -> Void
    ) {
        
        store.fetchHeartRates(for: workouts) { result in
            completion(result)
        }
    }
    
    func fetchAllWorkouts(
        completion: @escaping (Result<[HKWorkout], HealthKitError>) -> Void
    ) {
        store.fetchAllWorkouts { result in
            completion(result)
        }
    }
    
    func fetchRestingHeartRateWithinRange(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
    ) {
        store.fetchRestingHeartRateWithinRange(from: start, to: end) { result in
            completion(result)
        }
    }
    
    func fetchAge(
        completion: @escaping (Result<Int, HealthKitError>
        ) -> Void) {
        store.fetchAge { result in
            completion(result)
        }
    }
    
    func fetchAllWorkoutsWithinRange(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKWorkout], HealthKitError>) -> Void
    ) {
        store.fetchAllWorkoutsWithinRange(from: start, to: end) { result in
            completion(result)
        }
    }
    
    func fetchHeartRateSamplesForWorkout(
       for workout: HKWorkout,
       completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
    ) {
        store.fetchHeartRateSamplesForWorkout(for: workout) { result in
            completion(result)
        }
    }
    
    func fetchHeartRateVariability(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
    ) {
        store.fetchHeartRateVariability(from: start, to: end) { result in
            completion(result)
        }
    }
    
    func fetchHeartRate(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
    ) {
        store.fetchHeartRate(from: start, to: end) { result in
            completion(result)
        }
    }
    
    func fetchSleepData(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKCategorySample], HealthKitError>) -> Void
    ) {
        store.fetchSleepData(from: start, to: end) { result in
            completion(result)
        }
    }
    
    
}
