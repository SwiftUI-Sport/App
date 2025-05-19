//
//  Extension.swift
//  App
//
//  Created by Ali An Nuur on 28/04/25.
//

import Foundation
import HealthKit
import SwiftUI

extension Date {
    private static var calendar: Calendar { Calendar.current }
    
    var startOfDay: Date {
        Self.calendar.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        let start = startOfDay
        return Self.calendar.date(byAdding: DateComponents(day: 1, second: -1), to: start)!
    }
    
    static func daysAgo(_ days: Int, from reference: Date = Date()) -> Date {
        Self.calendar.date(byAdding: .day, value: -days, to: reference)!
    }
    
    static func lastDaysRange(_ days: Int) -> (start: Date, end: Date) {
        let end   = Date()
        let start = daysAgo(days, from: end)
        return (start, end)
    }
    
    static var last24HoursRange: (start: Date, end: Date) {
        let end = Date()
        let start = Calendar.current.date(byAdding: .hour, value: -24, to: end)!
        return (start, end)
    }
    
    static var last7DaysRange: (start: Date, end: Date) {
        lastDaysRange(7)
    }
    
    static var last30DaysRange: (start: Date, end: Date) {
        lastDaysRange(30)
    }
    
    static var last42DaysRange: (start: Date, end: Date) {
        lastDaysRange(42)
    }
    
    static func lastNDates(_ n: Int, calendar: Calendar = .current) -> [Date] {
        let today = calendar.startOfDay(for: Date())
        return (0..<n)
            .compactMap { calendar.date(byAdding: .day, value: -($0), to: today) }
            .sorted()
    }
    
    static var yesterdayRange: (start: Date, end: Date) {
        let todayStart     = Date().startOfDay
        let yesterdayStart = daysAgo(1, from: todayStart)
        let yesterdayEnd   = yesterdayStart.endOfDay
        return (yesterdayStart, yesterdayEnd)
    }
    
//    static func sleepDateRange(sleepStartHour: Int = 20, wakeHour: Int = 8) -> (start: Date, end: Date) {
//        let calendar = Calendar.current
//        let now = Date()
//        
//        let todayComponents = calendar.dateComponents([.year, .month, .day], from: now)
//        var wakeComponents = todayComponents
//        wakeComponents.hour = wakeHour
//        wakeComponents.minute = 0
//        wakeComponents.second = 0
//        let wakeTime = calendar.date(from: wakeComponents)!
//        
//        var sleepComponents = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: -1, to: now)!)
//        sleepComponents.hour = sleepStartHour
//        sleepComponents.minute = 0
//        sleepComponents.second = 0
//        let sleepTime = calendar.date(from: sleepComponents)!
//        
//        return (sleepTime, wakeTime)
//    }
    
//    static func sleepDateRange(sleepStartHour: Int = 20, wakeHour: Int = 8) -> (start: Date, end: Date) {
//        let calendar = Calendar.current
//        let now = Date()
//        let today = calendar.startOfDay(for: now)
//        let currentHour = calendar.component(.hour, from: now)
//        
//        // Determine if we're looking at last night or the night before
//        // If it's before wake hour (e.g., before 8 AM), we're interested in the sleep that just happened
//        // Otherwise, we're probably asking about the previous night
//        
//        let endDay: Date
//        if currentHour < wakeHour {
//            // It's early morning, we want today's wake time
//            endDay = today
//        } else {
//            // It's later in the day, so we want today's sleep start and tomorrow's wake time
//            // But since we don't have tomorrow's data yet, we'll use today's wake time instead
//            endDay = today
//        }
//        
//        let startDay = calendar.date(byAdding: .day, value: -1, to: endDay)!
//        
//        // Create the specific times
//        var wakeComponents = calendar.dateComponents([.year, .month, .day], from: endDay)
//        wakeComponents.hour = wakeHour
//        wakeComponents.minute = 0
//        wakeComponents.second = 0
//        let wakeTime = calendar.date(from: wakeComponents)!
//        
//        var sleepComponents = calendar.dateComponents([.year, .month, .day], from: startDay)
//        sleepComponents.hour = sleepStartHour
//        sleepComponents.minute = 0
//        sleepComponents.second = 0
//        let sleepTime = calendar.date(from: sleepComponents)!
//        
//        return (sleepTime, wakeTime)
//    }
    
    static func sleepDateRange(sleepStartHour: Int = 20, wakeHour: Int = 8) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = Date()
        let today = calendar.startOfDay(for: now)
        
        let sleepStartDay = calendar.date(byAdding: .day, value: -1, to: today)!
        let wakeDay = today
        
        var sleepComponents = calendar.dateComponents([.year, .month, .day], from: sleepStartDay)
        sleepComponents.hour = sleepStartHour
        sleepComponents.minute = 0
        sleepComponents.second = 0
        let sleepTime = calendar.date(from: sleepComponents)!
        
        var wakeComponents = calendar.dateComponents([.year, .month, .day], from: wakeDay)
        wakeComponents.hour = 12
        wakeComponents.minute = 0
        wakeComponents.second = 0
        let wakeTime = calendar.date(from: wakeComponents)!
        
        return (sleepTime, wakeTime)
    }
    
    static func sleepDateRangeForLastDays(_ days: Int) -> (start: Date, end: Date) {
        let end = Date()
        let calendar = Calendar.current
        
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: -(days), to: end)!)
        dateComponents.hour = 20
        dateComponents.minute = 0
        dateComponents.second = 0
        let start = calendar.date(from: dateComponents)!
        
        return (start, end)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex.hasPrefix("#") ? String(hex.dropFirst()) : hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255
        let g = Double((rgb & 0x00FF00) >> 8)  / 255
        let b = Double( rgb & 0x0000FF       ) / 255
        self.init(red: r, green: g, blue: b)
    }
}

extension TrainingStressOfTheDay {
    static func defaultValue() -> TrainingStressOfTheDay {
        return TrainingStressOfTheDay(
            date: Date(),
            activities: [],
            previousTSR: 000,
            previousATL: 000,
            previousCTL: 000,
            tauATL: 7.0,
            tauCTL: 42.0
        )
    }
    static func emptyDefaultValue() -> TrainingStressOfTheDay {
        return TrainingStressOfTheDay(
            date: Date(),
            activities: [],
            previousTSR: 000,
            previousATL: 000,
            previousCTL: 000,
            tauATL: 0.0,
            tauCTL: 0.0
        )
    }
}


extension HKWorkoutActivityType {
    var name: String {
        switch self {
        case .americanFootball:             return "American Football"
        case .archery:                      return "Archery"
        case .australianFootball:           return "Australian Football"
        case .badminton:                    return "Badminton"
        case .baseball:                     return "Baseball"
        case .basketball:                   return "Basketball"
        case .bowling:                      return "Bowling"
        case .boxing:                       return "Boxing"
        case .climbing:                     return "Climbing"
        case .cricket:                      return "Cricket"
        case .crossTraining:                return "Cross Training"
        case .curling:                      return "Curling"
        case .cycling:                      return "Cycling"
        case .dance:                        return "Dance"
        case .danceInspiredTraining:        return "Dance Inspired Training"
        case .elliptical:                   return "Elliptical"
        case .equestrianSports:             return "Equestrian Sports"
        case .fencing:                      return "Fencing"
        case .fishing:                      return "Fishing"
        case .functionalStrengthTraining:   return "Functional Strength Training"
        case .golf:                         return "Golf"
        case .gymnastics:                   return "Gymnastics"
        case .handball:                     return "Handball"
        case .hiking:                       return "Hiking"
        case .hockey:                       return "Hockey"
        case .hunting:                      return "Hunting"
        case .lacrosse:                     return "Lacrosse"
        case .martialArts:                  return "Martial Arts"
        case .mindAndBody:                  return "Mind and Body"
        case .mixedMetabolicCardioTraining: return "Mixed Metabolic Cardio Training"
        case .paddleSports:                 return "Paddle Sports"
        case .play:                         return "Play"
        case .preparationAndRecovery:       return "Preparation and Recovery"
        case .racquetball:                  return "Racquetball"
        case .rowing:                       return "Rowing"
        case .rugby:                        return "Rugby"
        case .running:                      return "Running"
        case .sailing:                      return "Sailing"
        case .skatingSports:                return "Skating Sports"
        case .snowSports:                   return "Snow Sports"
        case .soccer:                       return "Soccer"
        case .softball:                     return "Softball"
        case .squash:                       return "Squash"
        case .stairClimbing:                return "Stair Climbing"
        case .surfingSports:                return "Surfing Sports"
        case .swimming:                     return "Swimming"
        case .tableTennis:                  return "Table Tennis"
        case .tennis:                       return "Tennis"
        case .trackAndField:                return "Track and Field"
        case .traditionalStrengthTraining:  return "Traditional Strength Training"
        case .volleyball:                   return "Volleyball"
        case .walking:                      return "Walking"
        case .waterFitness:                 return "Water Fitness"
        case .waterPolo:                    return "Water Polo"
        case .waterSports:                  return "Water Sports"
        case .wrestling:                    return "Wrestling"
        case .yoga:                         return "Yoga"
            
            // - iOS 10
            
        case .barre:                        return "Barre"
        case .coreTraining:                 return "Core Training"
        case .crossCountrySkiing:           return "Cross Country Skiing"
        case .downhillSkiing:               return "Downhill Skiing"
        case .flexibility:                  return "Flexibility"
        case .highIntensityIntervalTraining:    return "High Intensity Interval Training"
        case .jumpRope:                     return "Jump Rope"
        case .kickboxing:                   return "Kickboxing"
        case .pilates:                      return "Pilates"
        case .snowboarding:                 return "Snowboarding"
        case .stairs:                       return "Stairs"
        case .stepTraining:                 return "Step Training"
        case .wheelchairWalkPace:           return "Wheelchair Walk Pace"
        case .wheelchairRunPace:            return "Wheelchair Run Pace"
            
            // - iOS 11
            
        case .taiChi:                       return "Tai Chi"
        case .mixedCardio:                  return "Mixed Cardio"
        case .handCycling:                  return "Hand Cycling"
            
            // - iOS 13
            
        case .discSports:                   return "Disc Sports"
        case .fitnessGaming:                return "Fitness Gaming"
            
            // - iOS 14
        case .cardioDance:                  return "Cardio Dance"
        case .socialDance:                  return "Social Dance"
        case .pickleball:                   return "Pickleball"
        case .cooldown:                     return "Cooldown"
            
            // - Other
        case .other:                        return "Other"
        case .swimBikeRun:
            return "Swim Bike Run"
        case .transition:
            return "Transition"
        case .underwaterDiving:
            return "Underwater Diving"
        @unknown default:                   return "Other"
        }
    }
}
