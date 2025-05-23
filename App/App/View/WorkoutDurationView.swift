//
//  WorkoutDurationView.swift
//  App
//
//  Created by Muhammad Abid on 08/05/25.
//

import SwiftUI

struct WorkoutDurationView: View {
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate: String? = nil

       var data: [DailyRate] {
           healthKitViewModel.past7DaysWorkoutTSR
       }

       var lastNonZeroValue: Int {
           data.reversed().first(where: { $0.value > 0 })?.value ?? 0
       }

       var selectedValue: Int {
           if let date = selectedDate,
              let match = data.first(where: { $0.date == date }) {
               return match.value
           } else {
               return lastNonZeroValue
           }
       }
    
    func dateRangeText(from dailyRates: [DailyRate]) -> String {
        guard !dailyRates.isEmpty else { return "No data available" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let first = dailyRates.first,
              let last = dailyRates.last,
              let startDate = formatter.date(from: first.date),
              let endDate = formatter.date(from: last.date) else {
            return "Date range unavailable"
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
    
    // Default message shown initially
    @State private var selectedMessage: WorkoutStressMessage = WorkoutStressMessage(
        title: "Loading Your Workout Data...",
        detail: "We're analyzing your recent workout patterns.",
        tipsTitle: ["Prioritize Quality Sleep", "Stay Hydrated", "Move Gently", "Listen to Your Body"],
        tipsDetail: ["Aim for 7–9 hours to allow your body to fully repair.", "Water supports muscle recovery and energy regulation.", "Try light stretching, yoga, or walking to boost circulation without added stress.", "If you're still feeling sore or fatigued, take another rest day — recovery is part of progress."]
    )
    
    // Message for normal workout stress levels
    let normalMessage: WorkoutStressMessage = WorkoutStressMessage(
        title: "is Within Normal Range",
        detail: "Your training load is balanced. Continue to listen to your body and adjust intensity as needed.",
        tipsTitle: ["Prioritize Quality Sleep", "Stay Hydrated", "Move Gently", "Listen to Your Body"],
        tipsDetail: ["Aim for 7–9 hours to allow your body to fully repair.", "Water supports muscle recovery and energy regulation.", "Try light stretching, yoga, or walking to boost circulation without added stress.", "If you're still feeling sore or fatigued, take another rest day — recovery is part of progress."]
    )
    
    // Message for high workout stress levels
    let highMessage: WorkoutStressMessage = WorkoutStressMessage(
        title: "is High",
        detail: "You've been pushing harder than normal. This can be great for progress, but make sure your body has enough time to recover to avoid injury.",
        tipsTitle: ["Prioritize Quality Sleep", "Stay Hydrated", "Move Gently", "Listen to Your Body"],
        tipsDetail: ["Aim for 7–9 hours to allow your body to fully repair.", "Water supports muscle recovery and energy regulation.", "Try light stretching, yoga, or walking to boost circulation without added stress.", "If you're still feeling sore or fatigued, take another rest day — recovery is part of progress."]
    )
    
    // Message for no workout data
    let noDataMessage: WorkoutStressMessage = WorkoutStressMessage(
        title: "No Recent Workout Data Available",
        detail: "We don't have enough workout information to analyze your training load. Try syncing your fitness data or recording a workout.",
        tipsTitle: ["Record Your Workouts", "Sync Your Devices", "Start Small", "Be Consistent"],
        tipsDetail: ["Make sure to log all your exercise sessions to get accurate insights.", "Ensure your fitness tracker is properly connected to your Health app.", "Even short workouts count! Begin with manageable sessions if you're just starting.", "Aim for regular activity rather than occasional intense sessions for better health outcomes."]
    )
    
    
    

    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    (
                        Text("Your Recent Training Load ")
                            .font(.title3.bold())
                            
                        +
                        Text(selectedMessage.title)
                            .font(.title3.bold())
                            .foregroundColor(Color("primary_2"))
                    )
                    
                    Rectangle()
                        .frame(width: 150, height: 2, alignment: .leading)
                        .foregroundStyle(Color("Pinky"))
                    
                    Text(selectedMessage.detail)
                        .padding(.top, 8)
                    
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color("primary_2").opacity(0.2))
                                .frame(width: 32, height: 32)
                            Image(systemName: "figure.run")
                                .foregroundColor(Color("primary_2"))
                                .font(.system(size: 18, weight: .medium))
                        }
                        
                        let data = healthKitViewModel.past7DaysWorkoutTSR
                        let hasData = !data.allSatisfy { $0.value == 0 }

                        if !hasData {
                            Text("--")
                                .font(.title)
                                .bold()
                        } else if let selectedDate,
                                  let selected = data.first(where: { $0.date == selectedDate }) {
                            Text("\(selected.value)")
                                .font(.title)
                                .bold()
                        } else if let lastNonZero = data.last(where: { $0.value > 0 }) {
                            Text("\(lastNonZero.value)")
                                .font(.title)
                                .bold()
                        } else {
                            Text("0")
                                .font(.title)
                                .bold()
                        }
                        
                        Text("TRIMP")
                            .font(.title2.bold())
                            .foregroundStyle(Color("Pinky"))
                        
                        Spacer()
                        
                        if let selected = selectedDate {
                            Text(formattedDate(selected))
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        } else {
                            Text(dateRangeText(from: healthKitViewModel.past7DaysWorkoutTSR))
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                        
                        
                    }
                    .padding(.top, 8)
                    
                    // Conditionally show chart only if we have data
                    if !healthKitViewModel.past7DaysWorkoutTSR.allSatisfy({ $0.value == 0 }) {
                        MyChart(
                            averageValue7Days: $healthKitViewModel.overallAvgWorkoutTSR,
                            data: $healthKitViewModel.past7DaysWorkoutTSR,
                            selectedDate: $selectedDate, // ✅ <-- Pass binding here!
                            showAverage: false,
                            mainColor: Color("Pinky"),
                            isTrainingLoad: true
                        )
                    } else {
                        // Show empty state for chart
                        VStack(spacing: 12) {
                            Spacer(minLength: 40)
                            Image(systemName: "chart.xyaxis.line")
                                .font(.system(size: 36))
                                .foregroundColor(Color.gray.opacity(0.5))
                            Text("No workout data available")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                            Spacer(minLength: 40)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                }
                .padding(.vertical)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(6)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 16)
                
                SimpleCard(
                    title: "How to Recover After a Running Exercise",
                    content: "",
                    showMainText: false,
                    isShowTip: true,
                    tipTitles: selectedMessage.tipsTitle,
                    tipmessages: selectedMessage.tipsDetail
                )
                
                AboutCard(
                    title: "About Training Load",
                    content: "Your training load is calculated using a formula called TRIMP (TRaining IMPulse), a method that measures both the intensity and duration of your workout. It helps estimate how much stress your body experiences during and after exercise allowing you to balance training and recovery more effectively..",
                    secondaryTitle: "Keypoint about Trimp Score",
                    secondaryTitleColor: Color("primary_2"),
                    keypoints: ["Normal TRIMP (0–100)", "High TRIMP (>100)", "Recovery Time"],
                    keypointdescription: [
                        "This range indicates moderate intensity workouts with manageable stress on your body.",
                        "Workouts in this range are intense and may require additional recovery days to prevent overtraining.",
                        "After high-intensity sessions, it's crucial to monitor how your body feels and ensure proper rest, sleep, and hydration to optimize recovery and avoid burnout"
                    ]
                )
                
                SimpleCard(
                    title: "Disclaimer",
                    content: "These recommendations are based on general health guidelines and not intended to diagnose or treat any medical condition. Please consult a healthcare professional for personalized advice.",
                    titleColor: Color("Pinky"),
                    showIcon: true,
                    backgroundColor: Color("OrangeBGx")
                )
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
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
                .foregroundColor(Color("primary_2"))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(EnableSwipeBack().frame(width: 0, height: 0))
        .background(Color("BackgroundColorx"))
        .onAppear {
            healthKitViewModel.loadPast7DaysWorkoutTSR()
            updateMessageBasedOnData()
        }
        .onChange(of: healthKitViewModel.past7DaysWorkoutTSR) { _, _ in
            updateMessageBasedOnData()
        }
    }
    
    // Helper function to update the displayed message based on the available data
    private func updateMessageBasedOnData() {
        let data = healthKitViewModel.past7DaysWorkoutTSR
        let hasData = !data.allSatisfy { $0.value == 0 }
        
        if !hasData {
            // No workout data available
            selectedMessage = noDataMessage
            return
        }
        
        // Find the last non-zero value
        guard let lastNonZero = data.last(where: { $0.value > 0 }) else {
            selectedMessage = noDataMessage
            return
        }
        
        let status = trainingLoadStatus(lastTrainingLoad: lastNonZero.value)
        
        switch status {
        case "High":
            selectedMessage = highMessage
        case "Normal":
            selectedMessage = normalMessage
        case "Missing":
            selectedMessage = noDataMessage
        default:
            selectedMessage = normalMessage
        }
    }
}
