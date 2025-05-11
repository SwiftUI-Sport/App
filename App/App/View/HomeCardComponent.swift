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
    
    var body: some View {
        
        var highlightIndex: Int? {
            

            let last3 = data.suffix(3)
            
            // Check if all last 3 values are zero
            if last3.allSatisfy({ $0.value == 0 }) {
                return nil
            }

            // Otherwise, find the index of the rightmost non-zero in the last 3
            for i in (data.count - 3..<data.count).reversed() {
                if data[i].value > 0 {
                    return i
                }
            }

            return nil  // fallback, shouldn't reach here
        }
        
        Chart {
            ForEach(Array(data.enumerated()), id: \.element.date) { index, item in
                BarMark(
                    x: .value("Day", item.date),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(index == highlightIndex ? mainColor : Color("Barx"))
                
                .cornerRadius(5)
                
            }
            
            
           
        }
        .frame(height: 75)
        .padding()
        .chartXAxis {
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine()
                    .foregroundStyle(Color("GridLineSoft"))
                    
                    
                AxisTick()
                    .foregroundStyle(Color("GridLineSoft"))
                    
                // No AxisValueLabel() → hides text
            }
        }
    }
}




struct HomeCardComponent: View {
    
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    var title:String
    var headline:String
    var data: [DailyRate]
    var mainColor: Color
    var unit: String = "bpm"
    var icon: String = "heart.fill"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack() {
                ZStack {
                    Circle()
                        .fill(mainColor.opacity(0.2))
                        .frame(width: 20, height: 20)
                    Image(systemName: icon)
                        .foregroundColor(mainColor)
                        .font(.system(size: 10, weight: .medium))
                }
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(mainColor)
                

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .bold))
            }
            Text(headline)
                .font(.headline)
                .lineLimit(2)
                .foregroundColor(.black)
            
            HStack(alignment: .center, spacing: 24) {
                HStack(alignment:.center, spacing: 8) {


                    let last3 = data.suffix(3)
                    let allLast3Zero = last3.allSatisfy { $0.value == 0 }

                    if allLast3Zero {
                        Text("") // show nothing if last 3 are all zero
                            .font(.title)
                            .bold()
                    } else if let lastNonZero = data.last(where: { $0.value > 0 }) {
                        Text(String(format: "%.0f", Double(lastNonZero.value)))
                            .font(.title)
                            .bold()
                    } else {
                        Text("0") // fallback, though realistically this won't happen unless all data are 0
                            .font(.title)
                            .bold()
                    }
                        
                        
                    Text(unit)
                        .font(.body)
                        .bold(true)
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

//#Preview {
//    HomeCardComponent()
//}



struct SleepCardComponent: View {
    
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    var title:String
    var headline:String
    var mainColor = Color("primary_3")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack() {
                ZStack {
                    Circle()
                        .fill(mainColor.opacity(0.2))
                        .frame(width: 20, height: 20)
                    Image(systemName: "moon.fill")
                        .foregroundColor(mainColor)
                        .font(.system(size: 10, weight: .medium))
                }
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(mainColor)
                
                
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .bold))
            }
            Text(headline)
                .font(.headline)
                .lineLimit(2)
                .foregroundColor(.black)
            
            HStack(alignment: .center, spacing: 24) {
                HStack(alignment:.center, spacing: 8) {
                    
                    Text("\(formatDurationSleep(healthKitViewModel.totalSleepInterval))")
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
