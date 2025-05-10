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
        Chart {
            ForEach(Array(data.enumerated()), id: \.element.date) { index, item in
                BarMark(
                    x: .value("Day", item.date),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(index == data.count - 1 ? mainColor : Color("Barx"))
                
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
    
//    @EnvironmentObject var HealthKitViewModel: HealthKitViewModel
    var title:String
    var headline:String
    var data: [DailyRate]
    var mainColor: Color 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack() {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(mainColor)
                
                ZStack {
                    Circle()
                        .fill(mainColor.opacity(0.2))
                        .frame(width: 20, height: 20)
                    Image(systemName: "heart.fill")
                        .foregroundColor(mainColor)
                        .font(.system(size: 10, weight: .medium))
                }
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
                    if let lastValue = data.last?.value {
                        Text(String(format: "%.0f", Double(lastValue)))
                            .font(.title)
                            .bold(true)
                    } else {
                        Text("–") // fallback for empty array
                            .font(.title)
                            .bold(true)
                    }
                        
                        
                    Text("bpm")
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
