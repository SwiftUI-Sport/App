//
//  WorkoutActivityModel.swift
//  App
//
//  Created by Ali An Nuur on 01/05/25.
//

import Foundation
import HealthKit


struct TrainingStressOfTheDay: Identifiable, Codable, Equatable, Hashable {
    var id: Date { date }
    
    let date: Date
    let activities: [WorkoutActivity]
    
    let totalTSR: Double
    
    let todayATL: Double
    
    let todayCTL: Double
    
    var todayTSB: Double {
        return todayCTL - todayATL
    }
    
    let deltaTSR: Double
    
    let deltaATL: Double
    
    let deltaCTL: Double
    
    init(
        date: Date,
        activities: [WorkoutActivity],
        previousTSR: Double,
        previousATL: Double,
        previousCTL: Double,
        tauATL: Double = 7.0,
        tauCTL: Double = 42.0,
        todayATL: Double = 0.0
    ) {
        self.date = Calendar.current.startOfDay(for: date)
        self.activities = activities
        
        self.totalTSR = activities.reduce(0.0) { $0 + $1.trimp }
        
        self.todayATL = previousATL + (totalTSR - previousATL) / tauATL
        
        self.todayCTL = previousCTL + (totalTSR - previousCTL) / tauCTL
        
        self.deltaTSR = totalTSR - previousTSR
        self.deltaATL = todayATL - previousATL
        self.deltaCTL = todayCTL - previousCTL
    }
}

struct HeartRateSample: Hashable,Codable {
    let timestamp: Date
    let bpm: Double
}

struct Sleep: Hashable, Codable, Identifiable {
    var id = UUID()
    let day: Date               // startOfDay
    let startTime: Date         // earliest sample.startDate
    let endTime: Date           // latest  sample.endDate
    let inBedDuration: TimeInterval
    let asleepDuration: TimeInterval
    let deepSleepDuration: TimeInterval
    let remSleepDuration: TimeInterval
    let coreSleepDuration: TimeInterval

    // (optional) helper untuk total:
    var totalDuration: TimeInterval {
        inBedDuration + asleepDuration + deepSleepDuration + remSleepDuration + coreSleepDuration
    }
}

struct WorkoutHeartRateZone: Hashable,Codable {
    let zone: Int
    let lowerBound: Int
    let upperBound: Int
    let duration: TimeInterval
}

struct WorkoutActivity: Hashable,Identifiable, Codable {
    let id: UUID
    let activityType: UInt
    let name: String
    let startDate: Date
    let endDate: Date
    let duration: TimeInterval
    let distance: Double?
    let caloriesBurned: Double
    let heartRateSamples: [HeartRateSample]
    
    private(set) var zoneDurations: [WorkoutHeartRateZone] = []
    
    private static func zoneWeight(for zone: Int) -> Double {
        switch zone {
        case 1: return 1.0
        case 2: return 2.0
        case 3: return 3.0
        case 4: return 4.0
        case 5: return 5.0
        default: return 0.5
        }
    }
    
    var trimp: Double {
        zoneDurations.reduce(0.0) { sum, zone in
            let minutes = zone.duration / 60.0
            return sum + minutes * Self.zoneWeight(for: zone.zone)
        }
    }
    
    var averageHeartRate: Double {
        guard !heartRateSamples.isEmpty else { return 0 }
        let total = heartRateSamples.reduce(0) { $0 + $1.bpm }
        return total / Double(heartRateSamples.count)
    }
    
    var pace: Double? {
        guard let d = distance, d > 0 else { return nil }
        return duration / d
    }
    
    init(
        id: UUID = .init(),
        activityType: HKWorkoutActivityType,
        name: String,
        startDate: Date,
        endDate: Date,
        duration: TimeInterval,
        distance: Double? = nil,
        caloriesBurned: Double,
        heartRateSamples: [HeartRateSample]
    ) {
        self.id               = id
        self.activityType     = activityType.rawValue
        self.name             = name
        self.startDate            = startDate
        self.endDate          = endDate
        self.duration         = duration
        self.distance         = distance
        self.caloriesBurned   = caloriesBurned
        self.heartRateSamples = heartRateSamples
    }
    
    mutating func calculateHeartRateZones(
        restingHR: Int,
        maxHR: Int
    ) {
        
        let hrr = maxHR - restingHR
        
        let zonePercents: [(low: Double, high: Double)] = [
            (0.50, 0.60),
            (0.60, 0.70),
            (0.70, 0.80),
            (0.80, 0.90),
            (0.90, 1.00)
        ]
        
        let bpmBounds: [(low: Int, high: Int)] = zonePercents.map { range in
            let low  = restingHR + Int((Double(hrr) * range.low).rounded())
            let high = restingHR + Int((Double(hrr) * range.high).rounded())
            return (low, high)
        }
        
        let zone1LowerBound = bpmBounds.first?.low ?? (restingHR + Int((Double(hrr) * 0.5).rounded()))
        
        var durations = Array(repeating: TimeInterval(0), count: zonePercents.count + 1)
        
        guard !heartRateSamples.isEmpty else {
            
            var allZones = [
                WorkoutHeartRateZone(
                    zone: 0,
                    lowerBound: 0,
                    upperBound: zone1LowerBound,
                    duration: 0
                )
            ]
            
            allZones.append(contentsOf: bpmBounds.enumerated().map { i, bounds in
                return WorkoutHeartRateZone(
                    zone: i + 1,
                    lowerBound: bounds.low,
                    upperBound: bounds.high,
                    duration: 0
                )
            })
            
            self.zoneDurations = allZones
            return
        }
        
        for idx in heartRateSamples.indices {
            let current = heartRateSamples[idx]
            
            let dt: TimeInterval
            if idx + 1 < heartRateSamples.count {
                dt = heartRateSamples[idx + 1].timestamp.timeIntervalSince(current.timestamp)
            } else if idx > 0 {
                dt = current.timestamp.timeIntervalSince(heartRateSamples[idx - 1].timestamp)
            } else {
                dt = 1.0
            }
            
            if current.bpm < Double(zone1LowerBound) {
                durations[0] += dt
            }
            else if let zoneIndex = bpmBounds.firstIndex(where: { b in
                current.bpm >= Double(b.low) && current.bpm < Double(b.high)
            }) {
                durations[zoneIndex + 1] += dt
            } else if current.bpm >= Double(bpmBounds.last!.high) {
                durations[bpmBounds.count] += dt              }
        }
        
        var allZones = [
            WorkoutHeartRateZone(
                zone: 0,
                lowerBound: 0,
                upperBound: zone1LowerBound,
                duration: durations[0]
            )
        ]
        
        allZones.append(contentsOf: bpmBounds.enumerated().map { i, bounds in
            return WorkoutHeartRateZone(
                zone: i + 1,
                lowerBound: bounds.low,
                upperBound: bounds.high,
                duration: durations[i + 1]
            )
        })
        
        self.zoneDurations = allZones
    }
}

struct DailyWorkoutSummary: Identifiable {
    let id = UUID()
    let date: Date
    let workouts: [WorkoutDetails]
    
    var hasWorkouts: Bool { !workouts.isEmpty }
    var totalDuration: TimeInterval { workouts.reduce(0) { $0 + $1.duration } }
    var totalCalories: Double { workouts.reduce(0) { $0 + $1.caloriesBurned } }
    var totalDistance: Double? {
        let distances = workouts.compactMap { $0.distance }
        return distances.isEmpty ? nil : distances.reduce(0, +)
    }
    
    static func emptyDay(date: Date) -> DailyWorkoutSummary {
        DailyWorkoutSummary(date: date, workouts: [])
    }
}

struct WorkoutDetails {
    let workout: HKWorkout
    let type: HKWorkoutActivityType
    let startDate: Date
    let endDate: Date
    let duration: TimeInterval
    let distance: Double?
    let caloriesBurned: Double
    
    init(from workout: HKWorkout) {
        self.workout = workout
        self.type = workout.workoutActivityType
        self.startDate = workout.startDate
        self.endDate = workout.endDate
        self.duration = workout.duration
        
        // Extract distance if available
        let distanceType = HKQuantityType(.distanceWalkingRunning)
        if let statsD = workout.statistics(for: distanceType),
           let sumD = statsD.sumQuantity() {
            self.distance = sumD.doubleValue(for: .meter())
        } else {
            self.distance = nil
        }
        
        // Extract calories
        let energyType = HKQuantityType(.activeEnergyBurned)
        if let stats = workout.statistics(for: energyType),
           let sumQty = stats.sumQuantity() {
            self.caloriesBurned = sumQty.doubleValue(for: .kilocalorie())
        } else {
            self.caloriesBurned = 0
        }
    }
}

extension WorkoutActivity {
    var activityTypeEnum: HKWorkoutActivityType? {
        return HKWorkoutActivityType(rawValue: activityType)
    }
}

