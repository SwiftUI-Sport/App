//
//  HealthKitViewModel.swift
//  App
//
//  Created by Ali An Nuur on 28/04/25.
//

import SwiftUI
import HealthKit
import Combine

@MainActor
final class HealthKitViewModel: ObservableObject {

    @Published var isAuthorized: Bool = false
    @Published var caloriesToday: Double = 0
    @Published var errorMessage: String?
    
    @Published var activities: [WorkoutActivity] = []
  
    @Published var sleepDuration: [Sleep] = []

    @Published var HeartRateDaily: [HeartRateOfTheDay] = []
    @Published var HeartRateDailyv2: [DailyRate] = []
    
    @Published var restingHeartRateDaily: [RestingHeartRateOfTheDay] = []
    @Published var restingHeartRateDailyv2: [DailyRate] = []
    
    @Published var HeartRateVariabilityDaily: [DailyRate] = []
    
    @Published var overallAverageHR: Double = 0
    @Published var overallRestingHR: Double = 0
    @Published var overallAvgHRV: Double = 0
    
    
    
    @Published var stressHistory42Days: [TrainingStressOfTheDay] = []
    @Published var stressHistory7Days:  [TrainingStressOfTheDay] = []
    
    @Published var past7DaysWorkouts: [DailyWorkoutSummary] = []
    @Published var past7DaysWorkoutDuration : [DailyRate] = []
    @Published var past7DaysWorkoutTSR: [DailyRate] = []
    
    @Published var overallAvgWorkoutDuration: Double = 0
    @Published var overallAvgWorkoutTSR: Double = 0
    
    @Published var repository: HealthKitRepositoryProtocol
    
    init(repository: HealthKitRepositoryProtocol) {
        self.repository = repository
    }
    
    func start() {
        guard repository.isHealthDataAvailable else {
            errorMessage = "HealthKit tidak tersedia di perangkat ini."
            return
        }
      
        authorizeAndLoadData()

    }
    
    private func authorizeAndLoadData() {
        repository.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let granted):
                self.isAuthorized = granted
                print("HealthKit authorized: \(granted)")
                if granted {
                    //          self.loadTodayCalories()
                    //            self.loadRunningWorkout()
                    //            self.loadAllWorkouts()
//                    //            self.loadHeartRatesForAllWorkouts()
//                    self.loadRestingHeartRateWithinRange()
//                    self.loadAge()
//                    repository.checkAllAuthorizationStatuses()
//                    self.loadAllData()
                } else {
                    self.errorMessage = "Akses HealthKit ditolak."
                }
            case .failure(let error):
                self.errorMessage = "Error auth: \(error)"
                print("\(isAuthorized) \(error)")
            }
        }
    }
    
    private func loadTodayCalories() {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        repository.fetchTotalCalories(from: startOfDay, to: Date()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let total):
                self.caloriesToday = total
            case .failure(let error):
                self.errorMessage = "Gagal load kalori: \(error)"
            }
        }
    }
    
    private func loadHeartRates(for workouts: [HKWorkout]) {
        repository.fetchHeartRates(for: workouts) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let unit = HKUnit.count().unitDivided(by: .minute())
                for (workout, samples) in data {
                    let start = DateFormatter.localizedString(
                        from: workout.startDate,
                        dateStyle: .short,
                        timeStyle: .short
                    )
                    print("🏃‍♂️ Workout at \(start):")
                    for sample in samples {
                        let bpm = sample.quantity.doubleValue(for: unit)
                        let time = DateFormatter.localizedString(
                            from: sample.startDate,
                            dateStyle: .none,
                            timeStyle: .medium
                        )
                        print("   • \(Int(bpm)) bpm @ \(time)")
                    }
                }
                
            case .failure(let error):
                self.errorMessage = "Gagal load heart rate samples: \(error)"
            }
        }
    }
    
    func loadHeartRatesForAllWorkouts() {
        repository.fetchAllWorkouts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.errorMessage = "Gagal load workout: \(error)"
                
            case .success(let workouts):

                self.repository.fetchHeartRates(for: workouts) { hrResult in
                    switch hrResult {
                    case .failure(let error):
                        self.errorMessage = "Gagal load HR samples: \(error)"
                        
                    case .success(let data):

                        let unit = HKUnit.count().unitDivided(by: .minute())
                        data.forEach { workout, samples in
                            let start = DateFormatter.localizedString(
                                from: workout.startDate,
                                dateStyle: .short,
                                timeStyle: .short
                            )
                            
                            let end = DateFormatter.localizedString(
                                from: workout.endDate,
                                dateStyle: .short,
                                timeStyle: .short
                            )
                            print("🏃‍♂️ Workout \(workout.workoutActivityType.name) @ \(start) and \(end):")
                            samples.forEach { sample in
                                let bpm  = Int(sample.quantity.doubleValue(for: unit))
                                let time = DateFormatter.localizedString(
                                    from: sample.startDate,
                                    dateStyle: .none,
                                    timeStyle: .medium
                                )
                                print("   • \(bpm) bpm @ \(time)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func loadAllWorkouts() {
        repository.fetchAllWorkouts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let workouts):
                print("Total workouts: \(workouts.count)\n")
                
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm"

                let energyType   = HKQuantityType(.activeEnergyBurned)
                let distanceType = HKQuantityType(.distanceWalkingRunning)
                
                for workout in workouts {
                    let id       = workout.uuid.uuidString
                    let typeName = workout.workoutActivityType.name
                    let start    = df.string(from: workout.startDate)
                    let end      = df.string(from: workout.endDate)
                    let durSec   = Int(workout.duration)
                    
                    print("""
                    ─────────────────────────────────────────────
                    🆔 UUID     : \(id)
                    🏷️ Type     : \(typeName)
                    ⏱️ Start    : \(start)
                    ⏲️ End      : \(end)
                    ⏳ Duration : \(durSec) sec
                    """)
                    
                    //                    // Energi
                    //                    if let stats = workout.statistics(for: energyType),
                    //                       let sum   = stats.sumQuantity() {
                    //                        let cals = sum.doubleValue(for: .kilocalorie())
                    //                        print("  • Energy Burned : \(Int(cals)) kcal")
                    //                    }
                    //
                    //                    // Jarak
                    //                    if let statsD = workout.statistics(for: distanceType),
                    //                       let sumD   = statsD.sumQuantity() {
                    //                        let dist = sumD.doubleValue(for: .meter())
                    //                        print("  • Distance      : \(Int(dist)) m")
                    //                    }
                    //
                    //                    // Metadata
                    //                    if let md = workout.metadata, !md.isEmpty {
                    //                        print("  • Metadata:")
                    //                        md.forEach { key, value in
                    //                            print("      – \(key): \(value)")
                    //                        }
                    //                    }
                    //
                    //                    // SourceRevision
                    //                    let rev        = workout.sourceRevision
                    //                    let sourceName = rev.source.name
                    //                    let os         = rev.operatingSystemVersion
                    //                    print("  • SourceRevision: \(sourceName) [\(String(describing: rev.productType)) iOS \(os.majorVersion).\(os.minorVersion).\(os.patchVersion)]")
                    //
                    //                    // Device info
                    //                    if let dev = workout.device {
                    //                        print("  • Device:")
                    //                        print("      – Name         : \(dev.name ?? "n/a")")
                    //                        print("      – Model        : \(dev.model ?? "n/a")")
                    //                        print("      – Manufacturer : \(dev.manufacturer ?? "n/a")")
                    //                    }
                    //
                    //                    // Events
                    //                    if let events = workout.workoutEvents, !events.isEmpty {
                    //                        print("  • Events:")
                    //                        for ev in events {
                    //                            // 1. Get the DateInterval
                    //                            let interval = ev.dateInterval  // use the new API :contentReference[oaicite:0]{index=0}
                    //
                    //                            // 2. Format start and end times
                    //                            let startStr = df.string(from: interval.start)
                    //                            let endStr   = df.string(from: interval.end)
                    //                            let durSec   = Int(interval.duration)
                    //
                    //                            print("      – \(ev.type) from \(startStr) to \(endStr) (\(durSec)s)")
                    //
                    //                            // 3. If you need any metadata on the event
                    //                            if let emd = ev.metadata, !emd.isEmpty {
                    //                                emd.forEach { key, value in
                    //                                    print("          • \(key): \(value)")
                    //                                }
                    //                            }
                    //                        }
                    //                    }
                    //                    print("────────────────────────────────────────────")
                }
                
            case .failure(let error):
                self.errorMessage = "Gagal load semua workout: \(error)"
            }
        }
    }
    
    private func loadRunningWorkout() {
        let (month, startOfDay) = Date.last30DaysRange
        repository.fetchRunningWorkouts(from: month, to: startOfDay) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let workouts):
                self.loadHeartRates(for: workouts)
                
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm"
                
                let energyType = HKQuantityType(.activeEnergyBurned)
                let distanceType = HKQuantityType(.distanceWalkingRunning)
                
                for workout in workouts {
                    let start = df.string(from: workout.startDate)
                    let end = df.string(from: workout.endDate)
                    
                    var caloriesStr = "—"
                    if let stats = workout.statistics(for: energyType),
                       let sumQty = stats.sumQuantity() {
                        let c = sumQty.doubleValue(for: .kilocalorie())
                        caloriesStr = String(format: "%.0f kcal", c)
                    }
                    
                    var distanceStr = "—"
                    if let statsD = workout.statistics(for: distanceType),
                       let sumD = statsD.sumQuantity() {
                        let d = sumD.doubleValue(for: .meter())
                        distanceStr = String(format: "%.0f m", d)
                    }
                    
                    print("""
                    🏃‍♂️ Workout: \(start) → \(end)
                      • Calories : \(caloriesStr)
                      • Distance : \(distanceStr)
                    """)
                    
                    let rev = workout.sourceRevision
                    let device = rev.productType ?? "Unknown Device"
                    let osVersion = "\(rev.operatingSystemVersion.majorVersion).\(rev.operatingSystemVersion.minorVersion).\(rev.operatingSystemVersion.patchVersion)"
                    
                    let md = workout.metadata ?? [:]
                    
                    let metValue = md["HKAverageMETs"]
                    let metStr = metValue != nil ? "\(metValue!)" : "—"
                    
                    let indoorValue = md["HKIndoorWorkout"] as? Int ?? 0
                    let indoor = indoorValue == 1
                    
                    let timeZone = md["HKTimeZone"] as? String ?? TimeZone.current.identifier
                    
                    let humidityValue = md["HKWeatherHumidity"]
                    let humidityStr = humidityValue != nil ? "\(humidityValue!)" : "—"
                    
                    let temperatureValue = md["HKWeatherTemperature"]
                    let temperatureStr = temperatureValue != nil ? "\(temperatureValue!)" : "—"
                    
                    print("""
                    ─────────────────────────────────────────────
                    🏃‍♂️ Running Workout
                    • Start     : \(start)
                    • End       : \(end)
                    • METs      : \(metStr)
                    • Indoor    : \(indoor ? "Yes" : "No")
                    • TimeZone  : \(timeZone)
                    • Humidity  : \(humidityStr)
                    • Temp      : \(temperatureStr)
                    • Device    : \(device) (iOS \(osVersion))
                    ─────────────────────────────────────────────
                    """)
                }
                
            case .failure(let error):
                self.errorMessage = "Gagal load workout: \(error)"
            }
        }
    }
    
    private func loadRestingHeartRateWithinRange() {

        let (start, end) = Date.last30DaysRange
        
        repository.fetchRestingHeartRateWithinRange(from: start, to: end) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let samples):

                guard let lastSample = samples.sorted(by: { $0.startDate > $1.startDate }).first else {
                    print("Tidak ada data resting heart rate")
                    return
                }
                
                
                
                let unit = HKUnit.count().unitDivided(by: .minute())
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let lastBpm = lastSample.quantity.doubleValue(for: unit)
                print("🏥 Last Resting Heart Rate: \(Int(lastBpm)) bpm")
                
                print("🔎 Resting Heart Rate Samples: \(samples.count) entries\n")
                for sample in samples {

                    let timestamp = df.string(from: sample.startDate)
                    let bpm       = sample.quantity.doubleValue(for: unit)
                    print("• \(timestamp): \(Int(bpm)) bpm")
                    
                    print("  • UUID     : \(sample.uuid.uuidString)")
                    
                    let rev        = sample.sourceRevision
                    let sourceName = rev.source.name
                    let os         = rev.operatingSystemVersion
                    print("  • Source   : \(sourceName) [\(String(describing: rev.productType)) iOS \(os.majorVersion).\(os.minorVersion).\(os.patchVersion)]")
                    
                    if let dev = sample.device {
                        print("  • Device   :")
                        print("      – Name         : \(dev.name ?? "n/a")")
                        print("      – Model        : \(dev.model ?? "n/a")")
                        print("      – Manufacturer : \(dev.manufacturer ?? "n/a")")
                    }
                    
                    if let md = sample.metadata, !md.isEmpty {
                        print("  • Metadata :")
                        md.forEach { key, value in
                            print("      – \(key): \(value)")
                        }
                    }
                    
                    print("")
                }
                
            case .failure(let error):
                self.errorMessage = "Gagal load resting heart rate: \(error)"
            }
        }
    }
    
    func loadAge() -> Int {
//        repository.fetchAge { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let age):
//                print("Usia: \(age) tahun")
//            case .failure(let error):
//                self.errorMessage = "Gagal load usia: \(error)"
//            }
//        }
//        print("USER EG: \(repository.userAge) dasndka")
        return repository.userAge
    }
  
    func loadRestingHeartRateDaily() {
        let (start, end) = Date.last30DaysRange

        repository.fetchRestingHeartRateWithinRange(from: start, to: end) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let samples):
                if samples.isEmpty {
                    print("No resting heart rate data available")
                    return
                }

                let unit = HKUnit.count().unitDivided(by: .minute())
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd"

                // Group values by date string
                var dailyData: [String: [Double]] = [:]
                for sample in samples {
                    let dateString = df.string(from: sample.startDate)
                    let bpm = sample.quantity.doubleValue(for: unit)
                    dailyData[dateString, default: []].append(bpm)
                }

                // Compute daily averages and convert to DailyRate
                var dailyRates: [DailyRate] = dailyData.map { (date, values) in
                    let avg = values.reduce(0, +) / Double(values.count)
                    return DailyRate(date: date, value: Int(avg))
                }

                // Sort by date and take the last 7
                let sorted = dailyRates.sorted {
                    guard let d1 = df.date(from: $0.date),
                          let d2 = df.date(from: $1.date) else { return false }
                    return d1 < d2
                }

                let last7Days = Array(sorted.suffix(7))
                

                let overallAvg = last7Days.isEmpty
                    ? 0
                    : Double(last7Days.map(\.value).reduce(0, +)) / Double(last7Days.count)

                DispatchQueue.main.async {
                    self.restingHeartRateDailyv2 = last7Days
                    self.overallRestingHR = overallAvg
                }
                

            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Gagal load resting heart rate: \(error)"
                }
            }
        }
    }
    
    private func buildStressHistory(forLast days: Int) -> [TrainingStressOfTheDay] {
        let cal      = Calendar.current
        let dates    = Date.lastNDates(days)
        var prevTSR  = 0.0
        var prevATL  = 0.0
        var prevCTL  = 0.0
        var history: [TrainingStressOfTheDay] = []

        for date in dates {
            let dayActs = activities.filter {
                cal.isDate($0.startDate, inSameDayAs: date)
            }

            let dayStress = TrainingStressOfTheDay(
                date:         date,
                activities:   dayActs,
                previousTSR:  prevTSR,
                previousATL:  prevATL,
                previousCTL:  prevCTL
            )
            history.append(dayStress)

            prevTSR = dayStress.totalTSR
            prevATL = dayStress.todayATL
            prevCTL = dayStress.todayCTL
        }

        return history
    }
    
    func loadWorkData() {
        stressHistory42Days = loadStressHistoryFromUserDefaults()
    }
    
    func loadAllData() {
        
        stressHistory42Days = loadStressHistoryFromUserDefaults()
    
        let (start42, end42) = Date.last42DaysRange
        let (start7, end7) = Date.last7DaysRange
        
        let userDataGroup = DispatchGroup()
        
        if repository.userAge == 0 {
            userDataGroup.enter()
            repository.fetchAge { [weak self] result in
                defer { userDataGroup.leave() }
                guard let self = self else { return }
                
                if case let .success(age) = result {
                    repository.setUserAge(age)
                    repository.setUserMaxHR(220 - age)
                } else {
//                    repository.setUserAge(30)
//                    repository.setUserMaxHR(190)
                }
            }
        }
        
        if repository.userRestingHR == 0 {
            userDataGroup.enter()
            repository.fetchRestingHeartRateWithinRange(from: start7, to: end7) { [weak self] result in
                defer { userDataGroup.leave() }
                guard let self = self else { return }
                
                if case let .success(rhrSamples) = result, !rhrSamples.isEmpty {
                    let unit = HKUnit.count().unitDivided(by: .minute())
                    let totalRHR = rhrSamples.reduce(0.0) { sum, sample in
                        return sum + sample.quantity.doubleValue(for: unit)
                    }
                    let avgRHR = Int(totalRHR / Double(rhrSamples.count))
                    repository.setUserRestingHR(avgRHR)
                } else {
//                    repository.setUserRestingHR(60)?\
                }
            }
        }
        
        userDataGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            let maxHR = repository.userMaxHR
            let restingHR = repository.userRestingHR
            
            self.repository.fetchAllWorkoutsWithinRange(from: start42, to: end42) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .failure(let err):
                    self.errorMessage = "Gagal load workouts: \(err)"
                    if self.activities.isEmpty {
                                        self.activities = []
                                    }
                    
                case .success(let workouts):
                    if workouts.isEmpty {
                        if self.activities.isEmpty {
                            self.activities = []
                        }
                    } else {
                        self.processWorkouts(workouts, maxHR: maxHR, restingHR: restingHR)
                        print(activities.count)
                    }
                }
            }
        }
    }
    
    private func processWorkouts(_ workouts: [HKWorkout], maxHR: Int, restingHR: Int) {
        let group = DispatchGroup()
        var built: [WorkoutActivity] = []
        
        for workout in workouts {
            group.enter()
            repository.fetchHeartRateSamplesForWorkout(for: workout) { [weak self] hrResult in
                defer { group.leave() }
                guard let self = self else { return }
                
                let hrSamples: [HeartRateSample]
                if case let .success(samples) = hrResult, !samples.isEmpty {
                    hrSamples = samples.map {
                        HeartRateSample(
                            timestamp: $0.startDate,
                            bpm: $0.quantity.doubleValue(
                                for: .count().unitDivided(by: .minute())
                            )
                        )
                    }
                } else {
                    hrSamples = []
                }
                
                let energyType = HKQuantityType(.activeEnergyBurned)
                let distanceType = HKQuantityType(.distanceWalkingRunning)
                let calories = workout.statistics(for: energyType)?
                    .sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                let distance = workout.statistics(for: distanceType)?
                    .sumQuantity()?.doubleValue(for: .meter())
                
                var activity = WorkoutActivity(
                    activityType: workout.workoutActivityType,
                    name: workout.workoutActivityType.name,
                    startDate: workout.startDate,
                    endDate: workout.endDate,
                    duration: workout.duration,
                    distance: distance,
                    caloriesBurned: calories,
                    heartRateSamples: hrSamples
                )
                
                activity.calculateHeartRateZones(
                    restingHR: restingHR,
                    maxHR: maxHR
                )
                
                built.append(activity)
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.activities = built.sorted(by: { $0.startDate > $1.startDate })
            self?.stressHistory42Days = self?.buildStressHistory(forLast: 42) ?? []
            self?.saveStressHistoryToUserDefaults()
        }
    }
    
    func loadHeartRateVariability() {
        let (start7, end7) = Date.last7DaysRange
        repository.fetchHeartRateVariability(from: start7, to: end7) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let samples):
                // Process HRV samples
                if !samples.isEmpty {
                    let unit = HKUnit.secondUnit(with: .milli)
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd HH:mm"
                    
//                    print("📊 HRV Samples: \(samples.count) entries")
                    for sample in samples {
                        let timestamp = df.string(from: sample.startDate)
                        let hrvValue = sample.quantity.doubleValue(for: unit)
//                        print("• \(timestamp): \(hrvValue) ms")
                    }
                    
                    // MARK: You can store these values in a published property
                    // self.hrvSamples = samples.map { ... }
                } else {
                    print("No HRV data available")
                }
                
            case .failure(let error):
                self.errorMessage = "Failed to load HRV data: \(error)"
            }
        }
    }
    
    func loadHeartRateVariabilityDaily() {
        let (start7, end7) = Date.last7DaysRange
        repository.fetchHeartRateVariability(from: start7, to: end7) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let samples):
                guard !samples.isEmpty else {
                    print("No HRV data available")
                    return
                }

                let unit = HKUnit.secondUnit(with: .milli)
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd"

                var dailyData: [String: [Double]] = [:]
                for sample in samples {
                    let dateKey = df.string(from: sample.startDate)
                    let hrvValue = sample.quantity.doubleValue(for: unit)
                    dailyData[dateKey, default: []].append(hrvValue)
                }

                var dailyRates: [DailyRate] = dailyData.map { (date, values) in
                    let avg = values.reduce(0, +) / Double(values.count)
                    return DailyRate(date: date, value: Int(avg))
                }

                // Sort by date and keep last 7 days
                let sorted = dailyRates.sorted {
                    guard let d1 = df.date(from: $0.date),
                          let d2 = df.date(from: $1.date) else { return false }
                    return d1 < d2
                }

                let last7 = Array(sorted.suffix(7))
                let avgHRV = last7.isEmpty ? 0 : Double(last7.map(\.value).reduce(0, +)) / Double(last7.count)

                DispatchQueue.main.async {
                    self.HeartRateVariabilityDaily = last7
                    self.overallAvgHRV = avgHRV
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load HRV data: \(error)"
                }
            }
        }
    }
    
//    func loadHeartRate() {
//        let (start7, end7) = Date.last7DaysRange
//        repository.fetchHeartRate(from: start7, to: end7) { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//            case .success(let samples):
//                if !samples.isEmpty {
//                    let unit = HKUnit.count().unitDivided(by: .minute())
//                    let df = DateFormatter()
//                    df.dateFormat = "yyyy-MM-dd HH:mm"
//                    
//                    print("❤️ Heart Rate Samples: \(samples.count) entries")
//                    for sample in samples {
//                        let timestamp = df.string(from: sample.startDate)
//                        let hrValue = sample.quantity.doubleValue(for: unit)
//                        print("• \(timestamp): \(Int(hrValue)) bpm")
//                    }
//                    
//                    // MARK: You can store these values in a published property
//                    // self.heartRateSamples = samples.map { ... }
//                } else {
//                    print("No heart rate data available")
//                }
//                
//            case .failure(let error):
//                self.errorMessage = "Failed to load heart rate data: \(error)"
//            }
//        }
//    }
    
    // Modify the loadHeartRate function to accept a Binding
    func loadHeartRate() {
        let (start7, end7) = Date.last7DaysRange

        repository.fetchHeartRate(from: start7, to: end7) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let samples):
                guard !samples.isEmpty else {
                    DispatchQueue.main.async {
                        self.errorMessage = "No heart rate data available."
                    }
                    return
                }

                let unit = HKUnit.count().unitDivided(by: .minute())
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"

                var groupedRates: [String: [Double]] = [:]
                var allRates: [Double] = []

                for sample in samples {
                    let dateKey = dateFormatter.string(from: sample.startDate)
                    let value = sample.quantity.doubleValue(for: unit)
                    groupedRates[dateKey, default: []].append(value)
                    allRates.append(value)
                }

                var dailyRates: [DailyRate] = groupedRates.compactMap { (date, values) in
                    guard !values.isEmpty else { return nil }
                    let avg = values.reduce(0, +) / Double(values.count)
                    return DailyRate(date: date, value: Int(avg))
                }

                dailyRates.sort {
                    guard let d1 = dateFormatter.date(from: $0.date),
                          let d2 = dateFormatter.date(from: $1.date) else { return false }
                    return d1 < d2
                }

                let averageOfAll = allRates.isEmpty ? 0 : allRates.reduce(0, +) / Double(allRates.count)

                DispatchQueue.main.async {
                    self.HeartRateDailyv2 = Array(dailyRates.suffix(7))
                    self.overallAverageHR = averageOfAll
                }
                


            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    
    
    
    func loadSleepData() {
        let (start24h, end24h) = Date.last24HoursRange
        repository.fetchSleepData(from: start24h, to: end24h) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let samples):
                if !samples.isEmpty {
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd HH:mm"
                    
                    print("😴 Sleep Data: \(samples.count) entries")
                    
                    // Group sleep samples by day
                    let calendar = Calendar.current
                    var sleepByDay: [Date: [HKCategorySample]] = [:]
                    
                    for sample in samples {
                        // Get start date with time components zeroed out (just the day)
                        let day = calendar.startOfDay(for: sample.startDate)
                        
                        if sleepByDay[day] == nil {
                            sleepByDay[day] = []
                        }
                        sleepByDay[day]?.append(sample)
                    }
                    
                    // Process each day's sleep data
                    for (day, daySamples) in sleepByDay.sorted(by: { $0.key > $1.key }) {
                        let dateString = df.string(from: day)
                        
                        var inBedDuration: TimeInterval = 0
                        var asleepDuration: TimeInterval = 0
                        var deepSleepDuration: TimeInterval = 0
                        var remSleepDuration: TimeInterval = 0
                        var coreSleepDuration: TimeInterval = 0
                        
                        for sample in daySamples {
                            let duration = sample.endDate.timeIntervalSince(sample.startDate)
                            let value = sample.value
                            
                            // Get sleep stage based on the category value
                            switch value {
                            case HKCategoryValueSleepAnalysis.inBed.rawValue:
                                inBedDuration += duration
                            case HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue:
                                asleepDuration += duration
                            case HKCategoryValueSleepAnalysis.awake.rawValue:
                                // Awake time during sleep
                                break
                            case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                                deepSleepDuration += duration
                            case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                                remSleepDuration += duration
                            case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                                coreSleepDuration += duration
                            default:
                                break
                            }
                            
                            
                        }
                        
                        var sleep = Sleep(
                            date: dateString,
                            inBedDuration: inBedDuration,
                            asleepDuration: asleepDuration,
                            deepSleepDuration: deepSleepDuration,
                            remSleepDuration: remSleepDuration,
                            coreSleepDuration: coreSleepDuration
                            
                        )
                        
                        sleepDuration.append(sleep)
                        // Format durations in hours and minutes
                        func formatDuration(_ interval: TimeInterval) -> String {
                            let hours = Int(interval / 3600)
                            let minutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
                            return "\(hours)h \(minutes)m"
                        }
                        
                        print("• \(dateString):")
                        print("  - In Bed: \(formatDuration(inBedDuration))")
                        print("  - Asleep: \(formatDuration(asleepDuration))")
                        
                        // Only print detailed sleep stages if available
                        if deepSleepDuration > 0 || remSleepDuration > 0 || coreSleepDuration > 0 {
                            print("  - Deep Sleep: \(formatDuration(deepSleepDuration))")
                            print("  - REM Sleep: \(formatDuration(remSleepDuration))")
                            print("  - Core Sleep: \(formatDuration(coreSleepDuration))")
                        }
                    }
                    
                    
                    
                    // MARK: You can store these values in published properties
                    // self.sleepData = ...
                } else {
                    print("No sleep data available")
                }
                
            case .failure(let error):
                self.errorMessage = "Failed to load sleep data: \(error)"
            }
        }
    }

    func loadAllPast7DaysWorkout() {
        let (start, end) = Date.last7DaysRange
        let calendar = Calendar.current
        
        // Create empty day entries for all 7 days
        var dailySummaries: [Date: DailyWorkoutSummary] = [:]
        
        // Generate entries for each day in the range
        for dayOffset in 0..<7 {
            let day = calendar.date(byAdding: .day, value: -dayOffset, to: calendar.startOfDay(for: Date()))!
            dailySummaries[calendar.startOfDay(for: day)] = DailyWorkoutSummary.emptyDay(date: day)
        }
        
        repository.fetchAllWorkoutsWithinRange(from: start, to: end) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let workouts):
                // Group workouts by day
                var workoutsByDay: [Date: [WorkoutDetails]] = [:]
                
                for workout in workouts {
                    let dayStart = calendar.startOfDay(for: workout.startDate)
                    if workoutsByDay[dayStart] == nil {
                        workoutsByDay[dayStart] = []
                    }
                    workoutsByDay[dayStart]?.append(WorkoutDetails(from: workout))
                }
                
                // Merge with empty days
                for (day, workouts) in workoutsByDay {
                    dailySummaries[day] = DailyWorkoutSummary(date: day, workouts: workouts)
                }
                
                // Sort by date (newest first) and update published property
                self.past7DaysWorkouts = dailySummaries.values.sorted(by: { $0.date > $1.date })
                
                
                print("📅 Loaded workout summaries for the past 7 days:")
                for summary in self.past7DaysWorkouts {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .none
                    
                    let dateStr = dateFormatter.string(from: summary.date)
                    if summary.hasWorkouts {
                        let totalDurationMinutes = Int(summary.totalDuration / 60)
                        let workoutCount = summary.workouts.count
                        let totalCalories = Int(summary.totalCalories)
                        
                        var distanceStr = "N/A"
                        if let distance = summary.totalDistance {
                            distanceStr = String(format: "%.2f km", distance / 1000)
                        }
                        
                        print("• \(dateStr): \(workoutCount) workout(s), \(totalDurationMinutes) minutes, \(totalCalories) kcal, \(distanceStr)")
                    } else {
                        print("• \(dateStr): No workouts")
                    }
                }
                
            case .failure(let error):
                self.errorMessage = "Failed to load past 7 days workouts: \(error)"
                
                // Even on error, still populate with empty data
                self.past7DaysWorkouts = dailySummaries.values.sorted(by: { $0.date > $1.date })
            }
        }
    }
    
    
    func loadPast7DaysWorkoutDuration() {
        let (start, end) = Date.last7DaysRange
        let calendar = Calendar.current
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        // Initialize an empty dictionary with all 7 days
        var durationByDay: [Date: Int] = [:]
        for dayOffset in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: -dayOffset, to: calendar.startOfDay(for: Date())) {
                durationByDay[calendar.startOfDay(for: day)] = 0
            }
        }

        repository.fetchAllWorkoutsWithinRange(from: start, to: end) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let workouts):
                for workout in workouts {
                    let dayStart = calendar.startOfDay(for: workout.startDate)
                    let durationMinutes = Int(workout.duration / 60)
                    durationByDay[dayStart, default: 0] += durationMinutes
                }

                let dailyRates: [DailyRate] = durationByDay.map { (date, totalMinutes) in
                    let dateStr = df.string(from: date)
                    return DailyRate(date: dateStr, value: totalMinutes)
                }.sorted {
                    guard let d1 = df.date(from: $0.date),
                          let d2 = df.date(from: $1.date) else { return false }
                    return d1 < d2 // newest first
                }

                let total = dailyRates.reduce(0) { $0 + $1.value }
                let workoutDays = dailyRates.filter { $0.value > 0 }
                let avg = workoutDays.isEmpty ? 0 : Double(workoutDays.reduce(0) { $0 + $1.value }) / Double(workoutDays.count)

                DispatchQueue.main.async {
                    self.past7DaysWorkoutDuration = dailyRates
                    self.overallAvgWorkoutDuration = avg
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load workout durations: \(error)"
                }
            }
        }
    }
    
    func printActivities() {
        if activities.isEmpty {
            print("No workout activities found.")
            return
        }

        print("📊 WORKOUT ACTIVITIES (\(activities.count) total)")
        print("═════════════════════════════════════════════")

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        for (index, activity) in activities.enumerated() {
            let startDateStr = dateFormatter.string(from: activity.startDate)
            let endDateStr = dateFormatter.string(from: activity.endDate)
            let durationMinutes = Int(activity.duration / 60)
            let durationSeconds = Int(activity.duration.truncatingRemainder(dividingBy: 60))

            print("\n🏋️ ACTIVITY #\(index + 1): \(activity.name)")
            print("  • Start Date: \(startDateStr)")
            print("  • End Date: \(endDateStr)")
            print("  • Duration: \(durationMinutes)m \(durationSeconds)s")

            if let distance = activity.distance {
                let distanceKm = distance / 1000
                print("  • Distance: \(String(format: "%.2f", distanceKm)) km")
            } else {
                print("  • Distance: N/A")
            }

            print("  • Calories: \(Int(activity.caloriesBurned)) kcal")

            print("  • Heart Rate Zones:")
            if activity.zoneDurations.isEmpty {
                print("    - No zone data available")
            } else {
                for zone in activity.zoneDurations {
                    let minutes = Int(zone.duration / 60)
                    let seconds = Int(zone.duration.truncatingRemainder(dividingBy: 60))
                    print("    - Zone \(zone.zone) (\(zone.lowerBound)-\(zone.upperBound) bpm): \(minutes)m \(seconds)s")
                }
            }


            if !activity.heartRateSamples.isEmpty {
                let bpms = activity.heartRateSamples.map { $0.bpm }
                let minBPM = Int(bpms.min() ?? 0)
                let maxBPM = Int(bpms.max() ?? 0)
                let avgBPM = Int(bpms.reduce(0, +) / Double(bpms.count))

                print("  • Heart Rate:")
                print("    - Min: \(minBPM) bpm")
                print("    - Avg: \(avgBPM) bpm")
                print("    - Max: \(maxBPM) bpm")
                print("    - Samples: \(activity.heartRateSamples.count)")
            } else {
                print("  • Heart Rate: No data available")
            }

            print("─────────────────────────────────────────────")
        }
    }
    
    func printStressHistories() {
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .none
            
            func printHistory(_ history: [TrainingStressOfTheDay], title: String) {
                print("\n=== \(title) ===")
                for day in history {
                    let dateStr = df.string(from: day.date)
                    let tsr  = String(format: "%.1f", day.totalTSR)
                    let atl  = String(format: "%.1f", day.todayATL)
                    let ctl  = String(format: "%.1f", day.todayCTL)
                    let tsb  = String(format: "%.1f", day.todayTSB)
                    let dTSR = String(format: "%+.1f", day.deltaTSR)
                    let dATL = String(format: "%+.1f", day.deltaATL)
                    let dCTL = String(format: "%+.1f", day.deltaCTL)
                    
                    print("""
                    • \(dateStr)
                      – TSR: \(tsr)
                      – ATL: \(atl)
                      – CTL: \(ctl)
                      – TSB: \(tsb)
                      – ΔTSR: \(dTSR), ΔATL: \(dATL), ΔCTL: \(dCTL)
                    """)
                }
            }
            
            printHistory(stressHistory42Days, title: "Training Stress (Last 42 Days)")

            printHistory(stressHistory7Days,  title: "Training Stress (Last 7 Days)")
        }
    
    func loadPast7DaysWorkoutTSR() {
        print("🔄 Loading past 7 days TSR from 42-day history...")
        print("stressHistory42Days count: \(stressHistory42Days.count)")

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -6, to: today)! // 7 days including today
        
        let filtered = stressHistory42Days.filter {
            $0.date >= sevenDaysAgo && $0.date <= today
        }

        print("Filtered last 7 days count: \(filtered.count)")

        let rates: [DailyRate] = filtered.map { entry in
            DailyRate(date: df.string(from: entry.date), value: Int(entry.totalTSR.rounded()))
        }.sorted {
            guard let d1 = df.date(from: $0.date),
                  let d2 = df.date(from: $1.date) else { return false }
            return d1 < d2 // oldest to newest
        }

        // Only average non-zero days
        let nonZeroRates = rates.filter { $0.value > 0 }
        var avg: Double = 0

        if !nonZeroRates.isEmpty {
            avg = Double(nonZeroRates.reduce(0) { $0 + $1.value }) / Double(nonZeroRates.count)
            if avg > 0 && avg < 1 {
                avg = 1
            }
        }

        DispatchQueue.main.async {
            self.past7DaysWorkoutTSR = rates
            self.overallAvgWorkoutTSR = avg

            print("✅ Finished loading TSR from filtered 7 days.")
            print("Average TSR: \(avg)")
            print("Daily TSR values:")
            for rate in rates {
                print("• \(rate.date): \(rate.value)")
            }
        }
    }

    private func saveStressHistoryToUserDefaults() {
        do {
            let data = try JSONEncoder().encode(self.stressHistory42Days)
            UserDefaults.standard.set(data, forKey: "stressHistory42Days")
            print("Successfully saved stress history to UserDefaults")
        } catch {
            print("Failed to save stress history: \(error)")
        }
    }

    private func loadStressHistoryFromUserDefaults() -> [TrainingStressOfTheDay] {
        guard let data = UserDefaults.standard.data(forKey: "stressHistory42Days") else {
            print("No saved stress history found in UserDefaults")
            return []
        }
        
        do {
            let history = try JSONDecoder().decode([TrainingStressOfTheDay].self, from: data)
            print("Successfully loaded \(history.count) stress history days from UserDefaults")
            return history
        } catch {
            print("Failed to load stress history: \(error)")
            return []
        }
    }
}
