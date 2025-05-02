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
    
    @Published var stressHistory42Days: [TrainingStressOfTheDay] = []
    @Published var stressHistory7Days:  [TrainingStressOfTheDay] = []
    
    private let repository: HealthKitRepositoryProtocol
    
    init(repository: HealthKitRepositoryProtocol) {
        self.repository = repository
    }
    
    func start() {
        guard repository.isHealthDataAvailable else {
            errorMessage = "HealthKit tidak tersedia di perangkat ini."
            return
        }
        authorizeAndLoadCalories()
    }
    
    private func authorizeAndLoadCalories() {
        repository.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let granted):
                self.isAuthorized = granted
                if granted {
                    //          self.loadTodayCalories()
                    //            self.loadRunningWorkout()
                    //            self.loadAllWorkouts()
//                    //            self.loadHeartRatesForAllWorkouts()
//                    self.loadRestingHeartRateWithinRange()
//                    self.loadAge()
                    self.loadAllData()
                    
                } else {
                    self.errorMessage = "Akses HealthKit ditolak."
                }
            case .failure(let error):
                self.errorMessage = "Error auth: \(error)"
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
                    print("  • Source   : \(sourceName) [\(rev.productType) iOS \(os.majorVersion).\(os.minorVersion).\(os.patchVersion)]")
                    
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
    
    private func loadAge() {
        repository.fetchAge { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let age):
                print("Usia: \(age) tahun")
            case .failure(let error):
                self.errorMessage = "Gagal load usia: \(error)"
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
    
    private func loadAllData() {
    
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
                    repository.setUserAge(30)
                    repository.setUserMaxHR(190)
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
                    repository.setUserRestingHR(60)
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
                    self.activities = []
                    
                case .success(let workouts):
                    if workouts.isEmpty {
                        self.activities = []
                    } else {
                        self.processWorkouts(workouts, maxHR: maxHR, restingHR: restingHR)
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
}
