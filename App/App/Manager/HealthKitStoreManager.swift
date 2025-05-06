//
//  HealthKitStoreManager.swift
//  App
//
//  Created by Ali An Nuur on 28/04/25.
//

import HealthKit

protocol HealthKitStoreProtocol {
    
    var isAvailable: Bool { get }
    
    func requestAuthorization(
        toShare writeTypes: Set<HKSampleType>,
        toRead readTypes: Set<HKObjectType>,
        completion: @escaping (Result<Bool, HealthKitError>) -> Void
    )
    
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
    
    func fetchHeartRateSamples(
        for workout: HKWorkout,
        completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
    )
    
    func fetchHeartRates(
        for workouts: [HKWorkout],
        completion: @escaping (Result<[(workout: HKWorkout, hrSamples: [HKQuantitySample])], HealthKitError>) -> Void
    )
    
    func fetchAllWorkouts(
        completion: @escaping (Result<[HKWorkout], HealthKitError>) -> Void
    )
    
    
    
    func fetchRestingHeartRateWithinRange(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
    )
    
    func fetchAge(completion: @escaping (Result<Int, HealthKitError>) -> Void)
    
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


enum HealthKitError: Error {
    case notAvailableOnDevice
    case typeUnavailable
    case authorizationDenied
    case underlying(Error)
}

final class HealthKitStore: HealthKitStoreProtocol {
    
    static let shared: HealthKitStoreProtocol = HealthKitStore()
    
    private let store = HKHealthStore()
    
    private init() {}
    
    var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    func requestAuthorization(
        toShare writeTypes: Set<HKSampleType> = [],
        toRead readTypes: Set<HKObjectType>,
        completion: @escaping (Result<Bool, HealthKitError>) -> Void
    ) {
        guard isAvailable else {
            return       DispatchQueue.main.async {
                completion(.failure(HealthKitError.notAvailableOnDevice))
            }
        }
        
        store.requestAuthorization(toShare: writeTypes, read: readTypes) { success, err in
            DispatchQueue.main.async {
                if let e = err {
                    completion(.failure(HealthKitError.underlying(e)))
                } else if success {
                    completion(.success(true))
                } else {
                    completion(.failure(HealthKitError.authorizationDenied))
                }
            }
        }
    }
    
    func fetchTotalCalories(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<Double, HealthKitError>) -> Void
    ) {
        
        guard let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return       DispatchQueue.main.async {
                completion(.failure(HealthKitError.typeUnavailable))
            }
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: start,
            end: end,
            options: .strictStartDate
        )
        let query = HKStatisticsQuery(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, stats, err in
            DispatchQueue.main.async {
                if let e = err {
                    completion(.failure(HealthKitError.underlying(e)))
                } else {
                    let total = stats?
                        .sumQuantity()?
                        .doubleValue(for: .kilocalorie()) ?? 0
                    completion(.success(total))
                }
            }
        }
        store.execute(query)
    }
    
    func fetchRunningWorkouts(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKWorkout], HealthKitError>) -> Void
    ) {
        
        guard isAvailable else {
            return       DispatchQueue.main.async {
                completion(.failure(.notAvailableOnDevice))
            }
        }
        
        let workoutType = HKObjectType.workoutType()
        
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        
        let sort = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: false
        )
        
        let query = HKSampleQuery(
            sampleType: workoutType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sort]
        ) { _, samples, error in
            DispatchQueue.main.async {
                if let err = error {
                    completion(.failure(.underlying(err)))
                } else {
                    let runs = (samples as? [HKWorkout]) ?? []
                    completion(.success(runs))
                }
            }
        }
        
        store.execute(query)
    }
    
    
    func fetchHeartRates(
        for workouts: [HKWorkout],
        completion: @escaping (Result<[(workout: HKWorkout, hrSamples: [HKQuantitySample])], HealthKitError>) -> Void
    ) {
        
        guard isAvailable else {
            return       DispatchQueue.main.async {
                completion(.failure(.notAvailableOnDevice))
            }
        }
        
        let group = DispatchGroup()
        var results: [(HKWorkout, [HKQuantitySample])] = []
        var firstError: HealthKitError?
        
        for workout in workouts {
            group.enter()
            
            fetchHeartRateSamples(for: workout) { hrResult in
                switch hrResult {
                case .success(let samples):
                    results.append((workout, samples))
                case .failure(let err):
                    if firstError == nil {
                        firstError = err
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let err = firstError {
                completion(.failure(err))
            } else {
                completion(.success(results))
            }
        }
    }
    
    
    func fetchHeartRateSamples(
        for workout: HKWorkout,
        completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
    ) {
        
        guard isAvailable else {
            return       DispatchQueue.main.async {
                completion(.failure(.notAvailableOnDevice))
            }
        }
        
        
        guard let hrType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            return completion(.failure(.typeUnavailable))
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: workout.startDate,
            end:   workout.endDate,
            options: .strictStartDate
        )
        
        let sort = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: true
        )
        
        let query = HKSampleQuery(
            sampleType: hrType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [
                NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            ]
        ) { _, samples, error in
            DispatchQueue.main.async {
                if let err = error {
                    completion(.failure(.underlying(err)))
                } else {
                    
                    let hrSamples = (samples as? [HKQuantitySample]) ?? []
                    completion(.success(hrSamples))
                }
            }
        }
        store.execute(query)
    }
    
    func fetchAllWorkouts(
        completion: @escaping (Result<[HKWorkout], HealthKitError>) -> Void
    ) {
        
        guard isAvailable else {
            return       DispatchQueue.main.async {
                completion(.failure(.notAvailableOnDevice))
            }
        }
        
        let workoutType = HKObjectType.workoutType()
        
        let predicate: NSPredicate? = nil
        
        let sort = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: true
        )
        
        let query = HKSampleQuery(
            sampleType: workoutType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sort]
        ) { _, samples, error in
            DispatchQueue.main.async {
                if let err = error {
                    completion(.failure(.underlying(err)))
                } else {
                    let allWorkouts = (samples as? [HKWorkout]) ?? []
                    completion(.success(allWorkouts))
                }
            }
        }
        
        store.execute(query)
    }
    
    func fetchRestingHeartRateWithinRange(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
    ) {
        guard isAvailable,
              let rhrType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)
        else {
            return       DispatchQueue.main.async {
                completion(.failure(.notAvailableOnDevice))
            }
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: start, end: end, options: .strictStartDate
        )
        
        let sort = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate, ascending: true
        )
        
        let query = HKSampleQuery(
            sampleType: rhrType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sort]
        ) { _, samples, error in
            DispatchQueue.main.async {
                if let err = error {
                    completion(.failure(.underlying(err)))
                } else {
                    let rhrSamples = (samples as? [HKQuantitySample]) ?? []
                    completion(.success(rhrSamples))
                }
            }
        }
        store.execute(query)
    }
    
    func fetchAge(
        completion: @escaping (Result<Int, HealthKitError>
        ) -> Void) {
        
        guard isAvailable else {
            return DispatchQueue.main.async {
                completion(.failure(.notAvailableOnDevice))
            }
        }
        
        do {
            
            let components = try self.store.dateOfBirthComponents()
            let calendar   = Calendar.current
            
            guard let dob = calendar.date(from: components) else {
                throw HealthKitError.typeUnavailable
            }
            
            let ageComponents = calendar.dateComponents([.year], from: dob, to: Date())
            if let age = ageComponents.year {
                DispatchQueue.main.async {
                    completion(.success(age))
                }
            } else {
                throw HealthKitError.typeUnavailable
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(.underlying(error)))
            }
        }
    }
    
    func fetchAllWorkoutsWithinRange(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKWorkout], HealthKitError>) -> Void
    ) {
        
        guard isAvailable else {
            return DispatchQueue.main.async {
                completion(.failure(.notAvailableOnDevice))
            }
        }
        
        let workoutType = HKObjectType.workoutType()
        
        let datePredicate = HKQuery.predicateForSamples(
            withStart: start,
            end: end,
            options: .strictStartDate
        )
        
        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: false
        )
        
        let query = HKSampleQuery(
            sampleType: workoutType,
            predicate: datePredicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        ) { _, samples, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.underlying(error)))
                } else {
                    let workouts = (samples as? [HKWorkout]) ?? []
                    completion(.success(workouts))
                }
            }
        }
        
        store.execute(query)
    }
    
    func fetchHeartRateSamplesForWorkout(
        for workout: HKWorkout,
        completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
    ) {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            return       DispatchQueue.main.async {
                completion(.failure(.notAvailableOnDevice))
            }
        }
        
        guard let hrType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            return completion(.failure(.typeUnavailable))
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: workout.startDate,
            end:   workout.endDate,
            options: .strictStartDate
        )
        
        let sort = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: true
        )
        
        let query = HKSampleQuery(
            sampleType: hrType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sort]
        ) { _, samples, error in
            DispatchQueue.main.async {
                if let e = error {
                    completion(.failure(.underlying(e)))
                } else {
                    let hrSamples = (samples as? [HKQuantitySample]) ?? []
                    completion(.success(hrSamples))
                }
            }
        }
        
        store.execute(query)
    }
    
    func fetchHeartRateVariability(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
    ) {
        guard isAvailable,
              let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)
        else {
            return DispatchQueue.main.async {
                completion(.failure(.notAvailableOnDevice))
            }
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: start, end: end, options: .strictStartDate
        )
        
        let sort = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate, ascending: true
        )
        
        let query = HKSampleQuery(
            sampleType: hrvType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sort]
        ) { _, samples, error in
            DispatchQueue.main.async {
                if let err = error {
                    completion(.failure(.underlying(err)))
                } else {
                    let hrvSamples = (samples as? [HKQuantitySample]) ?? []
                    completion(.success(hrvSamples))
                }
            }
        }
        store.execute(query)
    }
    
    func fetchHeartRate(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKQuantitySample], HealthKitError>) -> Void
    ) {
        guard isAvailable,
              let hrType = HKQuantityType.quantityType(forIdentifier: .heartRate)
        else {
            return DispatchQueue.main.async {
                completion(.failure(.notAvailableOnDevice))
            }
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: start, end: end, options: .strictStartDate
        )
        
        let sort = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate, ascending: true
        )
        
        let query = HKSampleQuery(
            sampleType: hrType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sort]
        ) { _, samples, error in
            DispatchQueue.main.async {
                if let err = error {
                    completion(.failure(.underlying(err)))
                } else {
                    let hrSamples = (samples as? [HKQuantitySample]) ?? []
                    completion(.success(hrSamples))
                }
            }
        }
        store.execute(query)
    }
    
    func fetchSleepData(
        from start: Date,
        to end: Date,
        completion: @escaping (Result<[HKCategorySample], HealthKitError>) -> Void
    ) {
        guard isAvailable,
              let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
        else {
            return DispatchQueue.main.async {
                completion(.failure(.notAvailableOnDevice))
            }
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: start, end: end, options: .strictStartDate
        )
        
        let sort = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate, ascending: true
        )
        
        let query = HKSampleQuery(
            sampleType: sleepType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sort]
        ) { _, samples, error in
            DispatchQueue.main.async {
                if let err = error {
                    completion(.failure(.underlying(err)))
                } else {
                    let sleepSamples = (samples as? [HKCategorySample]) ?? []
                    completion(.success(sleepSamples))
                }
            }
        }
        store.execute(query)
    }
    
}
