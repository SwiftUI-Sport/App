//
//  SleepDuration.swift
//  App
//
//  Created by Michael on 08/05/25.
//

import SwiftUI

struct SleepDuration: View {
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    @Environment(\.dismiss) private var dismiss
    
    // Computed property to determine sleep quality message
    private var sleepQualityMessage: String {
        let duration = healthKitViewModel.totalSleepInterval
        
        if duration == 0 {
            return "No Sleep Data Available"
        } else if duration < 21600 { // Less than 6 hours
            return "You Did'nt Get Enough Sleep Last Night"
        } else if duration < 25200 { // 6-7 hours
            return "You Got Enough Sleep Last Night"
        } else { // 7+ hours
            return "You Have Good Sleep Quality Last Night"
        }
    }
    
    // Computed property for the most recent sleep record
    private var latestSleep: Sleep? {
        healthKitViewModel.sleepDuration.sorted { $0.day > $1.day }.first
    }
    
    private func formatSleepTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
    
    var body: some View {
        ScrollView {
            // Sleep summary card
            VStack(alignment: .leading) {
                Text(sleepQualityMessage)
                    .font(.title3.bold())
                
                Rectangle()
                    .frame(width: 150, height: 2, alignment: .leading)
                    .foregroundStyle(Color("primary_3"))
                
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color("primary_3").opacity(0.2))
                            .frame(width: 32, height: 32)
                        Image(systemName: "moon.fill")
                            .foregroundColor(Color("primary_3"))
                            .font(.system(size: 18, weight: .medium))
                    }
                    
                    Text("\(formatDurationSleep(healthKitViewModel.totalSleepInterval))")
                        .foregroundStyle(Color("primary_3"))
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    if let sleep = latestSleep {
                        
                        VStack(alignment: .trailing) {
                            //                             Text(sleep.day, format: .dateTime.weekday(.wide).month().day())
                            //                                 .font(.caption)
                            //                                 .foregroundColor(.gray)
                            
                            Text("Last Sleep")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text("\(formatSleepTime(sleep.startTime)) - \(formatSleepTime(sleep.endTime))")
                                .font(.subheadline)
                            
                            
                        }
                        
//                        VStack(alignment: .trailing) {
//                            Text(sleep.day, format: .dateTime.weekday(.wide).month().day())
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            
//                            Text(sleep.sleepTimeRange)
//                                .font(.subheadline)
//                        }
                    } else {
                        Text("No Data")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 6)
                
                Text(getSleepAnalysisMessage())
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 6)
                

            }
            .padding(.vertical)
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(6)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            .padding(.horizontal)
            .padding(.bottom, 16)
            .padding(.top, 16)
            
            VStack(alignment: .leading) {
                Text(healthKitViewModel.totalSleepInterval < 21600 ?
                     "How to Improve Your Sleep" :
                        "How to Maintain Good Sleep Quality")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 8)
                .foregroundColor(.black)
                
                ForEach(getSleepTips(), id: \.0) { tip in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(tip.0)
                            .fontWeight(.bold)
                        Text(tip.1)
                            .padding(.bottom, 8)
                    }
                }
            }
            .padding(.vertical)
            .padding(.horizontal)
            .background(.white)
            .cornerRadius(6)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            .padding(.horizontal)
            .padding(.bottom, 16)
            
            // Sleep science info card
            VStack(alignment: .leading) {
                Text("About Sleep Duration")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                    .foregroundColor(.black)
                
                Text("The ideal sleep duration for most adults is 7 to 9 hours per night. Staying within this range supports physical recovery, mental clarity, hormonal balance, and heart health.")
                
                Text("Key Points About Sleep Duration")
                    .font(.title3.bold())
                    .padding(.vertical, 8)
                    .foregroundColor(Color("primary_3"))
                
                VStack(alignment: .leading, spacing: 8) {
                    keyPointRow(
                        title: "Too little sleep (less than 6 hours)",
                        description: "can lead to increased stress, elevated resting heart rate, reduced heart rate variability (HRV), impaired recovery, and decreased performance."
                    )
                    
                    keyPointRow(
                        title: "Too much sleep (more than 9–10 hours)",
                        description: "may be linked to low energy levels, sluggishness, or even underlying health issues."
                    )
                    
                    if let sleep = latestSleep, hasDetailedSleepData(sleep) {
                        let percentage = sleep.asleepDuration > 0 ? Int((sleep.deepSleepDuration/sleep.asleepDuration)*100) : 0
                        keyPointRow(
                            title: "Deep sleep (\(percentage)% of your sleep)",
                            description: "is crucial for physical recovery, immune function, and memory consolidation."
                        )
                    }
                    
                }
            }
            .padding(.vertical)
            .padding(.horizontal)
            .background(.white)
            .cornerRadius(6)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            .padding(.horizontal)
            .padding(.bottom, 16)
            
            // Disclaimer card
            SimpleCardest(
                title: "Disclaimer",
                content: "These recommendations are based on general health guidelines and not intended to diagnose or treat any medical condition. Please consult a healthcare professional for personalized advice.",
                titleColor: Color("primary_3"),
                showIcon: true,
                backgroundColor: Color("OrangeBGx")
            )
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Sleep Duration")
                    .font(.headline)
                    .foregroundColor(Color("primary_3"))
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                        Text("Back")
                    }
                }
                .foregroundColor(Color("primary_3"))
            }
        }
        .background(EnableSwipeBack().frame(width: 0, height: 0))
        .background(Color("backgroundApp"))
    }
    
    // Helper for sleep phase display items
    private func sleepPhaseItem(label: String, value: String, color: Color) -> some View {
        VStack {
            Text(value)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 60)
    }
    
    // Helper for key point rows
    private func keyPointRow(title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text(title + " ")
                .fontWeight(.bold)
            +
            Text(description)
        }
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    // Helper to check if we have detailed sleep phase data
    private func hasDetailedSleepData(_ sleep: Sleep) -> Bool {
        return sleep.deepSleepDuration > 0 || sleep.remSleepDuration > 0 || sleep.coreSleepDuration > 0
    }
    
    // Generate sleep analysis message based on data
    private func getSleepAnalysisMessage() -> String {
        let duration = healthKitViewModel.totalSleepInterval
        
        if duration == 0 {
            return "No sleep data for the last 24 hours is available. Make sure your Apple Health is properly set up and recording sleep data."
        } else if duration < 21600 { // Less than 6 hours
            return "Your sleep duration is below the recommended range, which may affect your recovery, focus, and performance. Aim for 7-9 hours for optimal health."
        } else if duration < 25200 { // 6-7 hours
            return "Your sleep duration is slightly good but could be improved. Quality rest helps regulate heart rate and improve recovery. Try to get closer to 8 hours."
        } else if duration < 32400 { // 7-9 hours
            return "Your sleep duration falls within the ideal range for recovery. Quality rest helps regulate heart rate, improve recovery, and boost overall performance. Keep it up!"
        } else { // More than 9 hours
            return "Your sleep duration is longer than typical recommendations. While this may indicate good recovery, consistently sleeping more than 9 hours might be worth discussing with a healthcare provider."
        }
    }
    
    // Complete the getSleepTips function
    private func getSleepTips() -> [(String, String)] {
        let duration = healthKitViewModel.totalSleepInterval
        
        if duration < 21600 { // Poor sleep - focus on improvement
            return [
                ("Consistent Schedule", "Go to bed and wake up at the same time every day, even on weekends."),
                ("Bedtime Routine", "Create a relaxing routine 30-60 minutes before bed - try reading, gentle stretching, or meditation."),
                ("Optimize Environment", "Keep your bedroom dark, quiet, and cool (around 65-68°F or 18-20°C)."),
                ("Limit Screen Time", "Avoid screens at least 1 hour before bed to reduce blue light exposure.")
            ]
        } else if duration < 25200 { // Adequate sleep - focus on optimization
            return [
                ("Consistent Schedule", "You're doing well, but reinforcing your sleep-wake timing can further improve quality."),
                ("Nutrition Timing", "Avoid heavy meals, caffeine, and alcohol within 3 hours of bedtime."),
                ("Optimize Environment", "Consider blackout curtains and white noise to create an ideal sleep setting."),
                ("Wind Down", "Try a 10-minute relaxation exercise before bed to improve sleep quality.")
            ]
        } else { // Good sleep - focus on maintenance
            return [
                ("Maintain Consistency", "Your good sleep routine is working - keep it consistent even when life gets busy."),
                ("Morning Light", "Continue getting natural light exposure in the morning to reinforce your circadian rhythm."),
                ("Physical Activity", "Regular exercise supports good sleep - aim for at least 30 minutes most days."),
                ("Stress Management", "Practice relaxation techniques to prevent stress from disrupting your good sleep pattern.")
            ]
        }
    }
    
    // Helper to format sleep duration in hours and minutes
    
}

func formatDurationSleep(_ seconds: TimeInterval) -> String {
    let hours = Int(seconds) / 3600
    let minutes = (Int(seconds) % 3600) / 60
    
    // Alternative
    //    if hours == 0 {
    //        return "\(minutes)m"
    //    } else if minutes == 0 {
    //        return "\(hours)h"
    //    } else {
    //        return "\(hours)h \(minutes)m"
    //    }
    
    return "\(hours)h \(minutes)m"
}

// Simpler version for sleep phases
func formatDurationSimple(_ seconds: TimeInterval) -> String {
    let minutes = Int(round(seconds / 60))
    
    if minutes >= 60 {
        let hours = minutes / 60
        let mins = minutes % 60
        return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
    } else {
        return "\(minutes)m"
    }
}


struct SimpleCardest: View {
    
    var title: String
    var content : String
    var titleColor : Color = .black
    var titleColor2 : Color = .black
    var titleColor3 : Color = .black
    var showIcon : Bool = false
    var backgroundColor : Color = .white
    var showSecondaryText : Bool = false
    var showThirdText : Bool = false
    var secondaryTitle : String = ""
    var thirdTitle : String = ""
    var secondaryText : String = ""
    var thirdText : String = ""
    
    
    var body: some View {
        
        
        
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline){
                
                if showIcon {
                    Image(systemName: "exclamationmark.icloud.fill")
                        .font(.headline)
                        .foregroundColor(titleColor)
                }
                
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                    .foregroundColor(titleColor)
            }
            
            Text(content)
                .foregroundColor(.primary)
            
            if showSecondaryText {
                Text(secondaryTitle)
                //                .font(.headline)
                    .font(.title3.bold())
                    .padding(.vertical, 8)
                    .foregroundColor(Color("primary_3"))
                Text(secondaryText)
                    .foregroundColor(.primary)
            }
            if showThirdText {
                Text(thirdTitle)
                    .font(.headline)
                    .padding(.vertical, 8)
                    .foregroundColor(titleColor3)
                Text(thirdText)
                    .foregroundColor(.primary)
            }
            
            
        }
        .padding(.vertical)
        .padding(.horizontal)
        .background(backgroundColor)
        .cornerRadius(6)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
        .frame(minWidth:200, maxWidth: .infinity, alignment: .center)
        .padding(.horizontal)
        .padding(.bottom, 16)
        
        
        
    }
}
