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
    
    struct WorkoutStressMessage {
        let title: String
        let detail: String
        
        let tipsTitle: [String]
        let tipsDetail: [String]
    }
    
    @State private var selectedMessage: WorkoutStressMessage = WorkoutStressMessage(
        title: "Your Recent Workouts Level Is Within Normal Range",
        detail: "You are good though, make sure to keep listen to your bodddyee.",
        tipsTitle: ["Prioritize Quality Sleep", "Stay Hydrated", "Move Gently", "Listen to Your Body"],
        tipsDetail: ["Aim for 7–9 hours to allow your body to fully repair.", "Water supports muscle recovery and energy regulation.", "Try light stretching, yoga, or walking to boost circulation without added stress.", "If you're still feeling sore or fatigued, take another rest day — recovery is part of progress."]
       )
    
    let normalMessage: WorkoutStressMessage = WorkoutStressMessage(
        title: "Your Recent Workouts Level Is Within Normal Range",
        detail: "You are good though, make sure to keep listen to your bodddyee.",
        tipsTitle: ["Prioritize Quality Sleep", "Stay Hydrated", "Move Gently", "Listen to Your Body"],
        tipsDetail: ["Aim for 7–9 hours to allow your body to fully repair.", "Water supports muscle recovery and energy regulation.", "Try light stretching, yoga, or walking to boost circulation without added stress.", "If you're still feeling sore or fatigued, take another rest day — recovery is part of progress."]
    )
    
    let highMessage: WorkoutStressMessage = WorkoutStressMessage(
        title: "Your Recent Workouts Level Is Higher Than Usual",
        detail: "You've been pushing harder than normal this can be great for progress, but make sure your body has enough time to recover to avoid injury.",
        tipsTitle: ["Prioritize Quality Sleep", "Stay Hydrated", "Move Gently", "Listen to Your Body"],
        tipsDetail: ["Aim for 7–9 hours to allow your body to fully repair.", "Water supports muscle recovery and energy regulation.", "Try light stretching, yoga, or walking to boost circulation without added stress.", "If you're still feeling sore or fatigued, take another rest day — recovery is part of progress."]
       )
        
    
     var body: some View {
        
         ScrollView{
             VStack{
                 
                 VStack(alignment: .leading){
                     Text(selectedMessage.title)
                         .font(.title3.bold())
                     
                     Rectangle()
                         .frame(width: 150, height: 2, alignment: .leading)
                         .foregroundStyle(Color("Pink"))
                     
                     Text(selectedMessage.detail)
                         .padding(.top, 8)
                     
                     HStack{
                         Image(systemName: "figure.run.circle.fill")
                             .font(.system(size: 32, weight: .bold, design: .default))
                             .foregroundStyle(Color("Pink"))
                         
                         
                         if let lastValue = HealthKitViewModel.past7DaysWorkoutTSR.last?.value {
                             Text(String(format: "%.0f", Double(lastValue)))
                                 .font(.title)
                                 .bold()
                         } else {
                             Text("–") // fallback for empty array
                                 .font(.title)
                                 .bold()
                         }
                         
                         Text(HealthKitViewModel.overallAvgWorkoutTSR <= 1 ? "trimp" : "trimp")
                             .font(.title2.bold())
                             .foregroundStyle(Color("Pink"))
                         
                         Spacer()
                         
                         Text(dateRangeText(from: HealthKitViewModel.past7DaysWorkoutTSR))
                             .font(.caption)
                             .foregroundStyle(Color.gray)
                         
                     }
                     .padding(.top, 8)
                     
                     MyChart( averageValue7Days: $HealthKitViewModel.overallAvgWorkoutTSR,
                              data: $HealthKitViewModel.past7DaysWorkoutTSR,
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
                 
                 
                 
                 SimpleCard(title: "Here’s What You Can Do to Help You Recover Well",
                            content: "",
                            showMainText: false,
                            isShowTip: true,
                            tipTitles: selectedMessage.tipsTitle,
                            tipmessages: selectedMessage.tipsDetail
                 )
                 
                 AboutCard(title: "About Trimp Score",
                           content: "Training Stress Score (TSS) is a measurement used to quantify the intensity and duration of your workout. It helps gauge how much stress your body is under during and after exercise, helping you balance effort and recovery.",
                           secondaryTitle: "Keypoint about Trimp Score",
                           keypoints: ["Normal TSS (50–100)", "High TSS (>150)", "Recovery Time"],
                           keypointdescription: ["\nThis range indicates moderate intensity workouts with manageable stress on your body.", "\nWorkouts in this range are intense and may require additional recovery days to prevent overtraining.", "\nAfter high-intensity sessions, it’s crucial to monitor how your body feels and ensure proper rest, sleep, and hydration to optimize recovery and avoid burnout"])
                 
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
//             HealthKitViewModel.loadPast7DaysWorkoutDuration()
//             HealthKitViewModel.printStressHistories()
             HealthKitViewModel.loadPast7DaysWorkoutTSR()
             selectedMessage = normalMessage
         }
         
         
    }
}

#Preview {
    WorkoutDurationView()
}


