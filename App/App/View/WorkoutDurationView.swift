//
//  WorkoutDurationView.swift
//  App
//
//  Created by Muhammad Abid on 08/05/25.
//

import SwiftUI

struct WorkoutDurationView: View {
    @EnvironmentObject var HealthKitViewModel: HealthKitViewModel
    
    
    func dateRangeText(from dailyRates: [DailyRate]) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let first = dailyRates.first,
              let last = dailyRates.last,
              let startDate = formatter.date(from: first.date),
              let endDate = formatter.date(from: last.date) else {
            return ""
        }

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"

        let startDay = dayFormatter.string(from: startDate)
        let endDay = dayFormatter.string(from: endDate)

        let monthYearFormatter = DateFormatter()
        monthYearFormatter.dateFormat = "MMMM yyyy"
        let monthYear = monthYearFormatter.string(from: endDate)

        return "\(startDay)-\(endDay) \(monthYear)"
    }
    
     var body: some View {
        
         ScrollView{
             VStack{
                 
                 VStack(alignment: .leading){
                     Text("Your workout duration is 10 minutes longer than usual ")
                         .font(.title3.bold())
                     
                     Rectangle()
                         .frame(width: 150, height: 2, alignment: .leading)
                         .foregroundStyle(Color("Pink"))
                     
                     HStack{
                         Image(systemName: "figure.run.circle.fill")
                             .font(.system(size: 32, weight: .bold, design: .default))
                             .foregroundStyle(Color("Pink"))
                         Text(String(format: "%.0f", HealthKitViewModel.overallAvgWorkoutDuration)) // Rounded to whole number
                             .font(.title)
                             .bold()
                         Text(HealthKitViewModel.overallAvgWorkoutDuration <= 1 ? "minute" : "minutes")
                             .font(.title2.bold())
                             .foregroundStyle(Color("Pink"))
                         
                         Spacer()
                         
                         Text(dateRangeText(from: HealthKitViewModel.past7DaysWorkoutDuration))
                             .font(.caption)
                             .foregroundStyle(Color.gray)
                         
                     }
                     .padding(.top, 8)
                     
                     MyChart( averageValue7Days: $HealthKitViewModel.overallAvgWorkoutDuration,
                              data: $HealthKitViewModel.past7DaysWorkoutDuration,
                              mainColor: Color("Pink")
                     )
                 }
                 .padding(.top, 16)
                 .padding(.bottom, 16)
                 .padding(.horizontal, 16)
                 .background(Color.white)
                 .cornerRadius(12)
                 .frame(maxWidth: .infinity, alignment: .leading)
                 .padding(.horizontal)
                 .padding(.bottom, 16)
                 
                 
                 
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
                            titleColor: Color("Pink"),
                            showIcon: true,
                            backgroundColor: Color("OrangeBGx"))
                 
             }
         }
         .padding(.top, 24)
         .frame( maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
         .background(Color("BackgroundColorx"))
         
         .onAppear {
             HealthKitViewModel.loadPast7DaysWorkoutDuration()
         }
         
         
    }
}

#Preview {
    WorkoutDurationView()
}


