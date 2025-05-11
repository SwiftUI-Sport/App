//
//  HeartRateModel.swift
//  App
//
//  Created by Muhammad Abid on 07/05/25.
//
import Foundation
import HealthKit

struct HeartRateOfTheDay: Identifiable {
    let id = UUID()
    let day: String
    let averageHeartRate: Int
}

struct RestingHeartRateOfTheDay: Identifiable {
    let id = UUID()
    let date: String
    let restingHeartRate: Int
}

struct DailyRate: Identifiable, Equatable {
    let id = UUID()
    let date: String 
    let value: Int
}

final class HeartRateViewModel: ObservableObject {
    private let repository: HealthKitRepositoryProtocol
    
    @Published var dailyHeartRates: [HeartRateOfTheDay] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(repository: HealthKitRepositoryProtocol) {
        self.repository = repository
    }
    
    func loadHeartRateSamples() {
        let (start7, end7) = Date.last7DaysRange
        isLoading = true
        repository.fetchHeartRate(from: start7, to: end7) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let samples):
                    self?.dailyHeartRates = self?.computeDailyAverageHeartRates(from: samples) ?? []
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func computeDailyAverageHeartRates(from samples: [HKQuantitySample]) -> [HeartRateOfTheDay] {
        let calendar = Calendar.current
        let unit = HKUnit.count().unitDivided(by: .minute())
        let grouped = Dictionary(grouping: samples) { calendar.startOfDay(for: $0.startDate) }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        let result: [HeartRateOfTheDay] = grouped.compactMap { (date, samplesForDay) in
            let values = samplesForDay.map { $0.quantity.doubleValue(for: unit) }
            guard !values.isEmpty else { return nil }
            let average = values.reduce(0, +) / Double(values.count)
            return HeartRateOfTheDay(day: formatter.string(from: date), averageHeartRate: Int(average))
        }
        
        return result.sorted { $0.day < $1.day }
    }
}
