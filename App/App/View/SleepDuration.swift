//
//  SleepDuration.swift
//  App
//
//  Created by Michael on 08/05/25.
//

import SwiftUI

struct SleepDuration: View {
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    @State private var calculatedTotal: TimeInterval = 0
    
//    var duration: TimeInterval
    var body: some View {
        
        
//        let total = healthKitViewModel.sleepDuration.reduce(0) {
//            $0 + $1.asleepDuration + $1.coreSleepDuration + $1.remSleepDuration + $1.deepSleepDuration
//                    }

        
//        if total == 0 {
//            
//        }
//        Text("Total Sleep Time: \(formatDuration( total))")
//        Text("\(healthKitViewModel.sleepDuration.first?.date)")
//        Text("\(healthKitViewModel.sleepDuration.first?.deepSleepDuration)")
//        Text("\(healthKitViewModel.sleepDuration.second?.deepSleepDuration)")
//        Text("\(healthKitViewModel.sleepDuration.first?.asleepDuration)")
//        Text("\(healthKitViewModel.sleepDuration.first?.coreSleepDuration)")
//        Text("\(healthKitViewModel.sleepDuration.first?.remSleepDuration)")
//        Text("\(healthKitViewModel.sleepDuration.first?.inBedDuration)")
//        Text("\(healthKitViewModel.sleepDuration.first?.remSleepDuration)")
            
        ScrollView{
            VStack(alignment: .leading){
                Text("You Have A Good Sleep ")
                    .font(.title3.bold())
                
                Rectangle()
                    .frame(width: 150, height: 2, alignment: .leading)
                    .foregroundStyle(Color("blueTint"))
                
                HStack{
                    Image(systemName: "powersleep")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundStyle(Color("blueTint"))
                    Text("\(formatDuration(calculatedTotal))")
                        .font(.title)
                        .bold()
//                        .foregroundStyle(Color("OrangeOnex"))
                    
                    Spacer()
                    
                    Text("\(healthKitViewModel.sleepDuration.first?.date ?? "No Data")")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                        
                }
                .padding(.top, 8)
            }
            .padding(.vertical)
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color(.black).opacity(0.2), radius: 4, x: 3, y: 1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom, 16)
            .padding(.top,30)
            .onAppear {
                calculatedTotal = 0
                calculateTotal()
            }
            .onChange(of: healthKitViewModel.sleepDuration) { _ in
                calculatedTotal = 0
                calculateTotal()
            }
            
            SimpleCard(title: "Highlight",
                       content: "Based on your health record, your average heart rate higher than usual. This can be a sign your body still recovering",
                       showSecondaryText: true,
                       secondaryTitle: "Here’s What You Can Do To Recover Your Body",
                       secondaryText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            )
            SimpleCard(title: "About Average Heart Rate",
                       content: "An abnormal average heart rate too high or too low can signal cardiovascular stress or underlying health issues, potentially reducing the body’s efficiency in recovery, energy regulation, and overall physical performance."
                       
            )
            
            SimpleCard(title: "Disclaimer",
                       content: "These recomendation are based on general health and not intended to diagnose or treat any medical condition. Please consult a healthcare professional.",
                       titleColor: Color("blueTint"),
                       showIcon: true,
                       backgroundColor: Color("OrangeBGx"))
        }
       
    }
    
    // Fixed implementation
    private func calculateTotal() {
        // Always reset before calculation to prevent accumulation
        var calculatedTotal1 = 0.0
        calculatedTotal=0.0
        
        // Calculate fresh total each time
        healthKitViewModel.sleepDuration.forEach { item in
            calculatedTotal1 += item.asleepDuration + item.coreSleepDuration + item.remSleepDuration + item.deepSleepDuration
        }
        
        calculatedTotal=calculatedTotal1
    }
    
    struct SimpleCard: View {
        
        var title: String
        var content : String
        var titleColor : Color = .black
        var showIcon : Bool = false
        var backgroundColor : Color = .white
        var showSecondaryText : Bool = false
        var secondaryTitle : String = ""
        var secondaryText : String = ""
        
        
        var body: some View {
            
            
            
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline){
                    
                    if showIcon {
                        Image(systemName: "exclamationmark.icloud.fill")
                       .font(.headline)
                       .foregroundColor(titleColor)
                    }
                    
                    
                    Text(title)
                        .font(.headline)
                        .padding(.bottom, 8)
                        .foregroundColor(titleColor)
                }

                Text(content)
                    .foregroundColor(.primary)
                
                if showSecondaryText {
                    Text(secondaryTitle)
                        .font(.headline)
                        .padding(.vertical, 8)
                        .foregroundColor(titleColor)
                    Text(secondaryText)
                        .foregroundColor(.primary)
                }
                
                
            }
            .padding(24)
            .background(backgroundColor)
            .cornerRadius(12)
            .shadow(color: Color(.black).opacity(0.2), radius: 4, x: 3, y: 1)
            .frame(minWidth:200, maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom, 16)
            
            
            
        }
    }
    func formatDuration(_ interval: TimeInterval) -> String {
        let hours = Int(interval / 3600)
        let minutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
        return "\(hours)h \(minutes)m"
    }
}


//#Preview {
//    SleepDuration()
//}
