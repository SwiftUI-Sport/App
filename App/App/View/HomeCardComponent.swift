//
//  HomeCardComponent.swift
//  App
//
//  Created by Muhammad Abid on 10/05/25.
//

import SwiftUI
import Charts

struct HomeChart: View {
    var data: [DailyRate]
    var mainColor: Color = Color("OrangeTwox")
    
    private var highlightIndex: Int? {
        // If all values are zero, return nil
        guard data.contains(where: { $0.value > 0 }) else {
            return nil
        }

        // Find the last non-zero value
        for i in (0..<data.count).reversed() {
            if data[i].value > 0 {
                return i
            }
        }

        return nil // Fallback, though this line should never be hit
    }
    
    var body: some View {
        Chart {
            ForEach(Array(data.enumerated()), id: \.element.date) { index, item in
                BarMark(
                    x: .value("Day", item.date),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(index == highlightIndex ? mainColor : Color("Barx"))
                .cornerRadius(6)
            }
        }
        .frame(height: 75)
        .padding()
        .chartXAxis {
            // Empty to hide X-axis labels
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine()
                    .foregroundStyle(Color("GridLineSoft"))
                AxisTick()
                    .foregroundStyle(Color("GridLineSoft"))
                // No labels
            }
        }
    }
}

struct HomeCardComponent: View {
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    var title: String
    var headline: String
    var data: [DailyRate]
    var mainColor: Color
    var unit: String = "bpm"
    var icon: String = "heart.fill"
    
    private var displayValue: String {
        // Find the most recent non-zero value
        if let lastNonZero = data.last(where: { $0.value > 0 }) {
            return String(format: "%.0f", Double(lastNonZero.value))
        } else {
            return "0"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header row
            HStack {
                ZStack {
                    Circle()
                        .fill(mainColor.opacity(0.2))
                        .frame(width: 20, height: 20)
                    Image(systemName: icon)
                        .foregroundColor(mainColor)
                        .font(.system(.caption2, weight: .medium))
                }
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(mainColor)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(.callout, weight: .bold))
            }
            
            // Headline
            Text(headline)
                .font(.headline)
                .lineLimit(2)
                .foregroundColor(.black)
            
            // Value and chart
            HStack(alignment: .center, spacing: 24) {
                HStack(alignment: .center, spacing: 8) {
                    Text(displayValue)
                        .font(.title)
                        .bold()
                    
                    Text(unit)
                        .font(.body)
                        .bold()
                        .foregroundStyle(mainColor)
                }
                
                HomeChart(data: data, mainColor: mainColor)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(6)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
    }
}

struct SleepCardComponent: View {
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    var title: String
    var headline: String
    var mainColor = Color("primary_3")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header row
            HStack {
                ZStack {
                    Circle()
                        .fill(mainColor.opacity(0.2))
                        .frame(width: 20, height: 20)
                    Image(systemName: "moon.fill")
                        .foregroundColor(mainColor)
                        .font(.system(.caption2, weight: .medium))
                }
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(mainColor)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(.callout, weight: .bold))
            }
            
            // Headline
            Text(headline)
                .font(.headline)
                .lineLimit(2)
                .foregroundColor(.black)
            
            // Sleep duration visual
            HStack(alignment: .center, spacing: 24) {
                HStack(alignment: .center, spacing: 8) {
                    Text(formatDurationSleep(healthKitViewModel.totalSleepInterval))
                        .font(.system(.largeTitle, weight: .bold))
                        .foregroundColor(mainColor)
                    
                    Spacer()
                    
                    Image(systemName: "sleep.circle.fill")
                        .font(.system(size: 75, weight: .bold))
                        .foregroundColor(mainColor).opacity(0.2)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(6)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
    }
}
