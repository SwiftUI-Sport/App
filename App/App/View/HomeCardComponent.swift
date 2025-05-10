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
        
        let highlightIndex: Int? = {
            if data.indices.contains(6) {
                return 6 // Prefer 7th (index 6) if available
            } else if data.indices.contains(5) {
                return 5 // Otherwise use 6th (index 5)
            } else {
                return 6 // If both are missing, highlight nothing
            }
        }()
        
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
    
//    @EnvironmentObject var HealthKitViewModel: HealthKitViewModel
    var title:String
    var headline:String
    var data: [DailyRate]
    var mainColor: Color
    var unit: String = "bpm"
    var icon: String = "heart.fill"
    
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
                    Image(systemName: icon)
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


                    if data.indices.contains(6) {
                        
                        let value = data[6].value
                        Text(String(format: "%.0f", Double(value)))
                            .font(.title)
                            .bold()
                    } else if data.indices.contains(5) {
                        
                        let value = data[5].value
                        Text(String(format: "%.0f", Double(value)))
                            .font(.title)
                            .bold()
                    } else {
                        
                        Text("0")
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
