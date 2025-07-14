//
//  HeartRateView.swift
//  App
//
//  Created by Muhammad Abid on 05/05/25.
//

import SwiftUI
import Charts


struct SegmentedControl: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var activeTab: String
    let tabs = [ "RHR", "HR" , "HRV"]
    
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs.indices, id: \.self) { index in
                let tab = tabs[index]
                
                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        activeTab = tab
                    }
                }) {
                    Text(tab)
                        .font(.system(.footnote, weight: .medium))
                        .foregroundColor(activeTab == tab ? .white : .gray)
                        .frame(maxWidth: .infinity, minHeight: 25)
                        .padding(.vertical, 8)
                        .background(
                            ZStack {
                                if activeTab == tab {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color("primary_1"))
                                        .matchedGeometryEffect(id: "tab", in: animation)
                                }
                            }
                        )
                }
                .frame(maxWidth: .infinity)
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
                .foregroundColor(Color("primary_1"))
            }
        }
        .background(EnableSwipeBack().frame(width: 0, height: 0))
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray4))
        )
        .padding()
        
    }
}



struct SimpleCard: View {
    
    var title: String
    var content : String
    var titleColor : Color = .black
    var showIcon : Bool = false
    var backgroundColor : Color = .white
    
    var showMainText:Bool = true
    
    var showSecondaryText : Bool = false
    var secondaryTitle : String = ""
    
    var isShowTip : Bool = false
    var tipTitles = [""]
    var tipmessages = [""]
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline){
                
                if showIcon {
                    Image(systemName: "exclamationmark.icloud.fill")
                        .font(.headline)
                        .foregroundColor(titleColor)
                }
                
                
                Text(title)
                    .font(.title3.bold())
                    .padding(.bottom, 8)
                    .foregroundColor(titleColor)
            }
            
            if showMainText {
                Text(content)
                    .foregroundColor(.primary)
            }
            
            
            if showSecondaryText {
                Text(secondaryTitle)
                    .font(.headline)
                    .padding(.vertical, 8)
                    .foregroundColor(titleColor)
                
            }
            
            if isShowTip{
                VStack(alignment : .leading){
                    ForEach(0..<tipTitles.count, id: \.self) { index in
                        Text(tipTitles[index])
                            .font(.headline)
                            .bold()
//                            .padding(.bottom, 2) // padding dalam loop
                        
                        Text(tipmessages[index])
                            .padding(.bottom, 8)
                    }
                    
                }
                
            }
            
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical)
        .padding(.horizontal)
        .background(backgroundColor)
        .cornerRadius(6)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.bottom, 16)
        
        
    }
}


struct AboutCard: View {
    var title: String
    var content: String
    
    var secondaryTitle: String
    var secondaryTitleColor: Color = Color("OrangeOnex")
    
    var keypoints: [String]
    var keypointdescription: [String]
    
    var body: some View {
        
        
        VStack(alignment: .leading) {
            
            
            Text(title)
                .font(.title3.bold())
                .padding(.bottom, 8)
                .foregroundColor(.primary)
            
            Text(content)
                .foregroundColor(.primary)
            
            Text(secondaryTitle)
                .font(.title3.bold())
                .padding(.vertical, 4)
                .foregroundColor(secondaryTitleColor)
            
            VStack(alignment : .leading){
                ForEach(0..<keypoints.count, id: \.self) { index in

                        Text(keypoints[index])
                            .font(.body)
                            .bold()
//                            .padding(.bottom, 2)  //padding dalam loop
                        Text(keypointdescription[index])
                            .font(.body)
                            .padding(.bottom, 8)

                }
                
            }
        }
        .padding(.vertical)
        .padding(.horizontal)
        .background(.white)
        .cornerRadius(6)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
        .frame(minWidth:200, maxWidth: .infinity, alignment: .center)
        .padding(.horizontal)
        .padding(.bottom, 16)
        
        
    }
}



struct MyChart: View {
    @Binding var averageValue7Days: Double
    @Binding var data: [DailyRate]
    @State private var selectedXValue: String? = nil
    @Binding var selectedDate: String?
    @State private var tappedIndex: Int? = nil
    @State private var animateBars = false
    var showAverage: Bool = true
    
    
    var mainColor: Color = Color("OrangeTwox")
    var isTrainingLoad: Bool = false
    @State private var hasTriggeredHaptic = false
    
    
    func getShortDay(for dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    
    
    
    var body: some View {
         let chart = Chart {
             
             
             var paddedData: [DailyRate] {
                 if showAverage {
                     return [DailyRate(date: " ", value: 0)] + data // Dummy Data
                 } else {
                     return data
                 }
             }
            
             var highlightIndex: Int? {
                 for i in (0..<data.count).reversed() {
                     if data[i].value > 0 {
                         return showAverage ? i + 1 : i
                     }
                 }
                 return nil
             }
             
             var activeHighlightIndex: Int? {
                 if let selectedDate, let index = paddedData.firstIndex(where: { $0.date == selectedDate }) {
                     return index // Highlight the tapped bar
                 } else {
                     return highlightIndex // Fallback to last non-zero bar
                 }
             }
            
            
            ForEach(Array(paddedData.enumerated()), id: \.element.date) { index, item in
                BarMark(
                    x: .value("Day", item.date),
                    y: .value("Value", animateBars ? item.value : 0)
                )
                .foregroundStyle(index == activeHighlightIndex ? mainColor : Color("Barx"))
                .cornerRadius(5)
                
//                .annotation(position: .overlay) {
//                    if index == activeHighlightIndex {
//                        VStack(spacing: 2) {
//                            Text(item.date)
//                                .font(.caption2)
//                                .foregroundColor(.white)
//                            Text("\(Int(item.value)) bpm")
//                                .font(.caption2.bold())
//                                .foregroundColor(.white)
//                        }
//                        .padding(.vertical, 4)
//                        .padding(.horizontal, 6)
//                        .background(Color.gray.opacity(0.8))
//                        .cornerRadius(4)
//                        .fixedSize()
//                        .frame(maxWidth: 100)
//                        .offset(x: index == 0 ? 20 : index == paddedData.count - 1 ? -20 : 0)
//                        .offset(y:-20)
//                    }
//                }
                
                
                
                
            }
            
            
            if showAverage {
                RuleMark(y: .value("Average", Int(averageValue7Days)))
                    .foregroundStyle(mainColor)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .annotation(position: .overlay, alignment: .leading) {
                        Text("Avg: \(Int(averageValue7Days))")
                            .font(.caption)
                            .bold(true)
                            .foregroundColor(.white)
                            .padding(.all, 4)
                            .background(Color("Orangey"))
                            .cornerRadius(4)
                            .offset(x: -5)
                    }
            }
            
        }
        .frame(height: 200)
        .padding(.vertical)
//        .padding(.horizontal)
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                animateBars = true
            }
        }
        
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                if let dateStr = value.as(String.self), dateStr.trimmingCharacters(in: .whitespaces).isEmpty == false {
                    AxisValueLabel(getShortDay(for: dateStr))
                } else {
                    // No label for dummy bar
                    AxisValueLabel("")
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing){value in
                AxisGridLine().foregroundStyle(Color.gray.opacity(0.2))
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartXSelection(value: $selectedDate)
        .onChange(of: selectedDate) { newSelectedDate, oldSelectedDate in
            guard newSelectedDate != nil else { return }

            if !hasTriggeredHaptic {
                hasTriggeredHaptic = true
            }

            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        
        
        if isTrainingLoad {
          chart.chartYScale(domain: 0...150)
      } else {
          chart
      }
 
        

    }
    
    
    
        
}


struct AverageHeartRateSection: View {
    @EnvironmentObject var HealthKitViewModel: HealthKitViewModel
    @State var current: Int? = nil
    @State private var selectedDate: String? = nil

       var data: [DailyRate] {
           HealthKitViewModel.HeartRateDailyv2
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
    
    struct AverageHeartRateMessage {
        let title: String
        let detail: String
        let secondaryTitle: String
        let tipTitles: [String]
        let tipDetails: [String]
    }
    
    // No data message
    let noDataMessage: AverageHeartRateMessage = AverageHeartRateMessage(
        title: "Not Available",
        detail: "We don't have enough information to analyze your heart rate. Make sure your device is properly synced with your Health app.",
        secondaryTitle: "Here's What You Can Do To Get Started",
        tipTitles: ["Wear Your Device", "Sync Your Data", "Check Permissions"],
        tipDetails: ["Make sure you wear your Apple Watch or compatible device regularly to track your heart rate.",
                     "Ensure your fitness device is properly synced with the Health app.",
                     "Check that you've granted the necessary permissions for heart rate monitoring."]
    )
    
    // Normal message
    let normalMessage: AverageHeartRateMessage = AverageHeartRateMessage(
        title: "Within Normal Range",
        detail: "This may indicate that <b>your body is in a good balance.</b> You can continue running, but listen to your body and adjust as needed.",
        secondaryTitle: "How to Maintain Your Heart Rate",
        tipTitles: ["Stay Active", "Prioritize Rest", "Stay Hydrated"],
        tipDetails: ["Regular exercise, like walking, jogging, or yoga, can help keep your heart rate in a healthy range.",
                     "Make sure you get enough sleep and rest to avoid unnecessary stress on your body.",
                     "Drink enough water to support circulation and heart health."]
    )
    
    // Slightly high message
    let slightlyHighMessage: AverageHeartRateMessage = AverageHeartRateMessage(
        title: "Slightly Higher Than Normal",
        detail: "Your body <b>may need a little recovery.</b> If you still want to stay active, go for something light like walking, stretching, or yoga.",
        secondaryTitle: "How to Recover Your Heart Rate",
        tipTitles: ["Prioritize high-quality sleep", "Stay hydrated", "Avoid Stimulants", "Take a recovery day"],
        tipDetails: ["Quality rest boosts recovery and overall performance.",
                     "Drink enough water to support your heart and energy levels.",
                     "Limit caffeine and alcohol, which can elevate your Heart Rate.",
                     "If you're tired, rest. Or stay active with light stretching or a gentle walk."]
    )
    
    // High message
    let highMessage: AverageHeartRateMessage = AverageHeartRateMessage(
        title: "Higher Than Normal",
        detail: "This could be a sign <b>your body is still recovering </b>from recent activity, stress, or lack of rest.",
        secondaryTitle: "How to Recover Your Heart Rate",
        tipTitles: ["Prioritize high-quality sleep", "Stay hydrated", "Avoid Stimulants", "Take a recovery day"],
        tipDetails: ["Quality rest boosts recovery and overall performance.",
                     "Drink enough water to support your heart and energy levels.",
                     "Limit caffeine and alcohol, which can elevate your Heart Rate.",
                     "If you're tired, rest. Or stay active with light stretching or a gentle walk."]
    )
    
    // Lower message
    let lowerMessage: AverageHeartRateMessage = AverageHeartRateMessage(
        title: "Lower Than Usual",
        detail: "This could mean <b>your body is well-rested or relaxed.</b> If you're feeling fatigued or dizzy, consider checking your health.",
        secondaryTitle: "How to Recover Your Heart Rate",
        tipTitles: ["Stay consistent with exercise", "Monitor your symptoms", "Stay hydrated", "Get regular check-ups"],
        tipDetails: ["Regular physical activity helps maintain a healthy heart rate.",
                     "If you experience dizziness, fatigue, or other unusual symptoms, consult a doctor.",
                     "Proper hydration supports optimal heart function.",
                     "Regular medical check-ups can help catch potential issues early."]
    )
    
    @State private var selectedMessage: AverageHeartRateMessage = AverageHeartRateMessage(
        title: "Loading...",
        detail: "We're analyzing your heart rate patterns.",
        secondaryTitle: "Here's What You Can Do To Maintain Your Heart Rate",
        tipTitles: ["Stay Active", "Prioritize Rest", "Stay Hydrated"],
        tipDetails: ["Regular exercise, like walking, jogging, or yoga, can help keep your heart rate in a healthy range.",
                     "Make sure you get enough sleep and rest to avoid unnecessary stress on your body.",
                     "Drink enough water to support circulation and heart health."]
    )
    
    func heartRateStatus(currentHR: Int?, avgHR: Double?) -> AverageHeartRateMessage {
        guard let current = currentHR, current > 0,
              let avgHR = avgHR, avgHR > 0 else {
            return noDataMessage
        }
        
        let avg = Int(avgHR)
        
        if current >= avg - 10 && current <= avg + 10 {
            return normalMessage
        } else if current > avg + 10 && current <= avg + 20 {
            return slightlyHighMessage
        } else if current > avg + 20 {
            return highMessage
        } else {
            return lowerMessage
        }
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                (
                    Text("Your Average Heart Rate is ")
                        .font(.title3.bold())
                        
                    +
                    Text(selectedMessage.title)
                        .font(.title3.bold())
                        .foregroundColor(Color("primary_1"))
                )
                
                Rectangle()
                    .frame(width: 150, height: 2, alignment: .leading)
                    .foregroundStyle(Color("OrangeThreex"))
                
                styledText(from: selectedMessage.detail)
                    .font(.body)
                    .padding(.top, 8)
                
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color("primary_1").opacity(0.2))
                            .frame(width: 32, height: 32)
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color("primary_1"))
                            .font(.system(.body, weight: .medium))
                    }
                    
                    let hasData = !data.allSatisfy { $0.value == 0 }

                    if !hasData {
                        Text("--")
                            .font(.title)
                            .bold()
                    } else {
                        Text("\(selectedValue)")
                            .font(.title)
                            .bold()
                    }
                    
                    Text("bpm")
                        .font(.title2.bold())
                        .foregroundStyle(Color("OrangeOnex"))
                    
                    Spacer()
                    
                    if let selected = selectedDate {
                        Text(formattedDate(selected))
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    } else {
                        Text(dateRangeText(from: HealthKitViewModel.HeartRateDailyv2))
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                    
                }
                .padding(.top, 12)
                
                // Conditionally show chart only if we have data
                if !HealthKitViewModel.HeartRateDailyv2.allSatisfy({ $0.value == 0 }) {
                    MyChart(
                        averageValue7Days: $HealthKitViewModel.overallAverageHR,
                        data: $HealthKitViewModel.HeartRateDailyv2,
                        selectedDate: $selectedDate // ✅ <-- Pass binding here!
                    )
                } else {
                    // Show empty state for chart
                    VStack(spacing: 12) {
                        Spacer(minLength: 40)
                        Image(systemName: "chart.xyaxis.line")
                            .font(.system(.largeTitle))
                            .foregroundColor(Color.gray.opacity(0.5))
                        Text("No heart rate data available")
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
            .padding(.bottom, 16)
            
            SimpleCard(
                title: selectedMessage.secondaryTitle,
                content: "",
                showMainText: false,
                isShowTip: true,
                tipTitles: selectedMessage.tipTitles,
                tipmessages: selectedMessage.tipDetails
            )
            
            AboutCard(
                title: "About Average Heart Rate",
                content: "An abnormal average heart rate too high or too low can signal cardiovascular stress or underlying health issues, potentially reducing the body's efficiency in recovery, energy regulation, and overall physical performance.",
                secondaryTitle: "Keypoint about Heart Rate",
                keypoints: ["An abnormally high or low", "Consistently high heart rate", "Consistently low heart rate"],
                keypointdescription: [
                    "Average heart rate may indicate cardiovascular stress, fatigue, or underlying health concerns.",
                    "Can signal overtraining, dehydration, stress, or poor sleep.",
                    "Below 60 bpm is normal for athletes, but may be a concern if accompanied by symptoms like dizziness or fatigue."
                ]
            )
            
            SimpleCard(
                title: "Disclaimer",
                content: "These recommendations are based on general health guidelines and not intended to diagnose or treat any medical condition. Please consult a healthcare professional for personalized advice.",
                titleColor: Color("OrangeOnex"),
                showIcon: true,
                backgroundColor: Color("OrangeBGx")
            )
        }
        .onAppear {
            HealthKitViewModel.loadHeartRate()
            updateMessageBasedOnData()
        }
        .onChange(of: HealthKitViewModel.HeartRateDailyv2) { _, _ in
            updateMessageBasedOnData()
        }
    }
    
    // Helper function to update the displayed message based on the available data
    private func updateMessageBasedOnData() {
        let data = HealthKitViewModel.HeartRateDailyv2
        let hasData = !data.allSatisfy { $0.value == 0 }
        
        if !hasData {
            // No heart rate data available
            selectedMessage = noDataMessage
            return
        }
        
        // Find the last non-zero value
        guard let lastNonZero = data.last(where: { $0.value > 0 }) else {
            selectedMessage = noDataMessage
            return
        }
        
        current = lastNonZero.value
        selectedMessage = heartRateStatus(currentHR: lastNonZero.value, avgHR: HealthKitViewModel.overallAverageHR)
    }
}



struct RestingHeartRateSection: View {
    @EnvironmentObject var HealthKitViewModel: HealthKitViewModel
    @State var current: Int? = nil
    @State private var selectedDate: String? = nil

       var data: [DailyRate] {
           HealthKitViewModel.restingHeartRateDailyv2
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
    
    struct RestingHeartRateMessage {
        let title: String
        let detail: String
        let secondaryTitle: String
        let tipTitles: [String]
        let tipDetails: [String]
    }
    
    // No data message
    let noDataMessage: RestingHeartRateMessage = RestingHeartRateMessage(
        title: "Not Available",
        detail: "We don't have enough information to analyze your resting heart rate. Make sure your device is properly synced with your Health app.",
        secondaryTitle: "Here's What You Can Do To Get Started",
        tipTitles: ["Wear Your Device", "Sync Your Data", "Check Permissions"],
        tipDetails: ["Make sure you wear your Apple Watch or compatible device regularly, especially when at rest or sleeping.",
                     "Ensure your fitness device is properly synced with the Health app.",
                     "Check that you've granted the necessary permissions for heart rate monitoring."]
    )
    
    let normalMessage: RestingHeartRateMessage = RestingHeartRateMessage(
        title: "Within Normal Range",
        detail: "This is may indicate that <b>your body is in a healthy state. </b>Your heart is functioning well, and you're maintaining a balanced level of physical recovery.",
        secondaryTitle: "How to Maintain Your Resting Heart Rate",
        tipTitles: ["Stay Active", "Priroritize Rest", "Stay Hydrated"],
        tipDetails: ["Regular exercise, like walking, jogging, or yoga, can help keep your heart rate in a healthy range.", "Make sure you get enough sleep and rest to avoid unnecessary stress on your body", "Drink enough water to support circulation and heart health."]
    )
    
    let slightlyHighMessage: RestingHeartRateMessage = RestingHeartRateMessage(
        title: "Slightly Higher Than Usual",
        detail: "This is may indicate that <b>your body is not fully rested.</b> It's a good idea to take it easy today and give yourself time to recover.",
        secondaryTitle: "How to Recover Your Resting Heart Rate",
        tipTitles: ["Prioritize high-quality sleep", "Stay hydrated", "Avoid Stimulants", "Take a recovery day"],
        tipDetails: ["Quality rest boosts recovery and overall performance.", "Drink enough water to support your heart and energy levels.", "Limit caffeine and alcohol, which can elevate your RHR.", "If you're tired, rest. Or stay active with light stretching or a gentle walk."]
    )
    
    let highMessage: RestingHeartRateMessage = RestingHeartRateMessage(
        title: "Higher Than Usual",
        detail: "This could be a sign that your <b>body is still recovering, under stress, or not fully rested.</b>",
        secondaryTitle: "How to Recover Your Resting Heart Rate",
        tipTitles: ["Prioritize high-quality sleep", "Stay hydrated", "Avoid Stimulants", "Take a recovery day"],
        tipDetails: ["Quality rest boosts recovery and overall performance.", "Drink enough water to support your heart and energy levels.", "Limit caffeine and alcohol, which can elevate your RHR.", "If you're tired, rest. Or stay active with light stretching or a gentle walk."]
    )
    
    let lowMessage: RestingHeartRateMessage = RestingHeartRateMessage(
        title: "Lower Than Usual",
        detail: "This can indicate<b> good cardiovascular fitness or relaxation.</b> If you're feeling dizzy or unwell, it may be worth checking in with your health.",
        secondaryTitle: "How to Recover Your Resting Heart Rate",
        tipTitles: ["Stay consistent with exercise", "Monitor your symptoms", "Stay hydrated", "Get regular check-ups"],
        tipDetails: ["Regular physical activity helps maintain a healthy heart rate.",
                     "If you experience dizziness, fatigue, or other unusual symptoms, consult a doctor.",
                     "Proper hydration supports optimal heart function.",
                     "Regular medical check-ups can help catch potential issues early."]
    )
    
    @State private var selectedMessage: RestingHeartRateMessage = RestingHeartRateMessage(
        title: "Loading ...",
        detail: "We're analyzing your resting heart rate patterns.",
        secondaryTitle: "Here's What You Can Do To Maintain Your Resting Heart Rate",
        tipTitles: ["Stay Active", "Prioritize Rest", "Stay Hydrated"],
        tipDetails: ["Regular exercise, like walking, jogging, or yoga, can help keep your heart rate in a healthy range.",
                     "Make sure you get enough sleep and rest to avoid unnecessary stress on your body",
                     "Drink enough water to support circulation and heart health."]
    )
    
    func heartRateStatus(currentHR: Int?, avgHR: Double?) -> RestingHeartRateMessage {
        guard let current = currentHR, current > 0,
              let avgHR = avgHR, avgHR > 0 else {
            return noDataMessage
        }
        
        let avg = Int(avgHR)
        
        if current >= avg - 10 && current <= avg + 10 {
            return normalMessage
        } else if current > avg + 10 && current <= avg + 20 {
            return slightlyHighMessage
        } else if current > avg + 20 {
            return highMessage
        } else {
            return lowMessage
        }
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                (
                    Text("Your Current Resting Heart Rate is ")
                        .font(.title3.bold())
                        
                    +
                    Text(selectedMessage.title)
                        .font(.title3.bold())
                        .foregroundColor(Color("primary_1"))
                )
                
                Rectangle()
                    .frame(width: 150, height: 2, alignment: .leading)
                    .foregroundStyle(Color("OrangeThreex"))
                
                styledText(from: selectedMessage.detail)
                    .font(.body)
                    .padding(.top, 8)
                
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color("primary_1").opacity(0.2))
                            .frame(width: 32, height: 32)
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color("primary_1"))
                            .font(.system(.body, weight: .medium))
                    }
                    
                    let hasData = !data.allSatisfy { $0.value == 0 }

                    if !hasData {
                        Text("--")
                            .font(.title)
                            .bold()
                    } else {
                        Text("\(selectedValue)")
                            .font(.title)
                            .bold()
                    }
                    
                    Text("bpm")
                        .font(.title2.bold())
                        .foregroundStyle(Color("OrangeOnex"))
                    
                    Spacer()
                    
                    if let selected = selectedDate {
                        Text(formattedDate(selected))
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    } else {
                        Text(dateRangeText(from: HealthKitViewModel.restingHeartRateDailyv2))
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                }
                .padding(.top, 8)
                
                // Conditionally show chart only if we have data
                if !HealthKitViewModel.restingHeartRateDailyv2.allSatisfy({ $0.value == 0 }) {
                    MyChart(
                        averageValue7Days: $HealthKitViewModel.overallRestingHR,
                        data: $HealthKitViewModel.restingHeartRateDailyv2,
                        selectedDate: $selectedDate // ✅ <-- Pass binding here!
                    )
                } else {
                    // Show empty state for chart
                    VStack(spacing: 12) {
                        Spacer(minLength: 40)
                        Image(systemName: "chart.xyaxis.line")
                            .font(.system(.largeTitle))
                            .foregroundColor(Color.gray.opacity(0.5))
                        Text("No resting heart rate data available")
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
            .padding(.bottom, 16)
            
            SimpleCard(
                title: selectedMessage.secondaryTitle,
                content: "",
                showMainText: false,
                isShowTip: true,
                tipTitles: selectedMessage.tipTitles,
                tipmessages: selectedMessage.tipDetails
            )
            
            AboutCard(
                title: "About Resting Heart Rate",
                content: "Resting Heart Rate (RHR) is the number of times your heart beats per minute (bpm) when your body is at complete rest. RHR is typically measured after you wake up, before any physical activity.",
                secondaryTitle: "Keypoint about Resting Heart Rate",
                keypoints: ["Normal range", "Lower RHR", "Higher RHR"],
                keypointdescription: ["For most adults, a healthy RHR is between 60–100 bpm. Athletes or very fit individuals may have lower RHRs, around 40–60 bpm.",
                                      "Often indicates good cardiovascular fitness and efficient heart function.",
                                      "Can be a sign of fatigue, stress, dehydration, illness, or overtraining."]
            )
            
            SimpleCard(
                title: "Disclaimer",
                content: "These recommendations are based on general health guidelines and not intended to diagnose or treat any medical condition. Please consult a healthcare professional for personalized advice.",
                titleColor: Color("OrangeOnex"),
                showIcon: true,
                backgroundColor: Color("OrangeBGx")
            )
        }
        .onAppear {
            HealthKitViewModel.loadRestingHeartRateDaily()
            updateMessageBasedOnData()
        }
        .onChange(of: HealthKitViewModel.restingHeartRateDailyv2) { _, _ in
            updateMessageBasedOnData()
        }
    }
    
    // Helper function to update the displayed message based on the available data
    private func updateMessageBasedOnData() {
        let data = HealthKitViewModel.restingHeartRateDailyv2
        let hasData = !data.allSatisfy { $0.value == 0 }
        
        if !hasData {
            // No resting heart rate data available
            selectedMessage = noDataMessage
            return
        }
        
        // Find the last non-zero value
        guard let lastNonZero = data.last(where: { $0.value > 0 }) else {
            selectedMessage = noDataMessage
            return
        }
        
        current = lastNonZero.value
        selectedMessage = heartRateStatus(currentHR: lastNonZero.value, avgHR: HealthKitViewModel.overallRestingHR)
    }
}


struct HeartRateVariabilitySection: View {
    @EnvironmentObject var HealthKitViewModel: HealthKitViewModel
    @State var current: Int? = nil
    @State private var selectedDate: String? = nil

       var data: [DailyRate] {
           HealthKitViewModel.HeartRateVariabilityDaily
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
    
    struct HeartRateVariabilityMessage {
        let title: String
        let detail: String
        let secondaryTitle: String
        let tipTitles: [String]
        let tipDetails: [String]
    }
    
    // No data message
    let noDataMessage: HeartRateVariabilityMessage = HeartRateVariabilityMessage(
        title: "Not Available",
        detail: "We don't have enough information to analyze your heart rate variability. Make sure your device is properly synced with your Health app.",
        secondaryTitle: "Here's What You Can Do To Get Started",
        tipTitles: ["Wear Your Device", "Sync Your Data", "Check Permissions"],
        tipDetails: ["Make sure you wear your Apple Watch or compatible device regularly, especially when at rest or sleeping.",
                     "Ensure your fitness device is properly synced with the Health app.",
                     "Check that you've granted the necessary permissions for heart rate monitoring."]
    )
    
    // Normal message
    let normalMessage: HeartRateVariabilityMessage = HeartRateVariabilityMessage(
        title: "Within Normal Range",
        detail: "This may indicate <b>your body is recovering well </b>and your autonomic nervous system is balanced.",
        secondaryTitle: "How to Maintain Your Heart Rate Variability",
        tipTitles: ["Stay Active", "Prioritize Rest", "Stay Hydrated"],
        tipDetails: ["Regular exercise, like walking, jogging, or yoga, can help keep your heart rate in a healthy range.",
                     "Make sure you get enough sleep and rest to avoid unnecessary stress on your body",
                     "Drink enough water to support circulation and heart health."]
    )
    
    // Slightly low message
    let slightlyLowMessage: HeartRateVariabilityMessage = HeartRateVariabilityMessage(
        title: "Slightly Lower Than Usual",
        detail: "This may be a sign <b>your body is under stress or still recovering, </b>take it slow for today.",
        secondaryTitle: "How to Recover Your Heart Rate Variability",
        tipTitles: ["Prioritize high-quality sleep", "Stay hydrated", "Practice mindfulness", "Take a recovery day"],
        tipDetails: ["Quality rest boosts recovery and overall performance.",
                     "Drink enough water to support your heart and energy levels.",
                     "Breathing exercises, meditation, or calm walks can boost HRV.",
                     "If you're tired, rest. Or stay active with light stretching or a gentle walk."]
    )
    
    // Low message
    let lowMessage: HeartRateVariabilityMessage = HeartRateVariabilityMessage(
        title: "Lower Than Usual",
        detail: "This may be a sign of <b>current or future health problems</b> because it shows that your body isn't adapting to changes well.",
        secondaryTitle: "How to Recover Your Heart Rate Variability",
        tipTitles: ["Prioritize high-quality sleep", "Stay hydrated", "Practice mindfulness", "Take a recovery day"],
        tipDetails: ["Quality rest boosts recovery and overall performance.",
                     "Drink enough water to support your heart and energy levels.",
                     "Breathing exercises, meditation, or calm walks can boost HRV.",
                     "If you're tired, rest. Or stay active with light stretching or a gentle walk."]
    )
    
    // High message
    let highMessage: HeartRateVariabilityMessage = HeartRateVariabilityMessage(
        title: "Higher Than Usual",
        detail: "This is a <b>positive sign that your body is adapting well</b> to physical and emotional demands.",
        secondaryTitle: "How to Recover Your Heart Rate Variability",
        tipTitles: ["Stay Active", "Prioritize Rest", "Stay Hydrated"],
        tipDetails: ["Regular exercise, like walking, jogging, or yoga, can help keep your heart rate in a healthy range.",
                     "Make sure you get enough sleep and rest to avoid unnecessary stress on your body",
                     "Drink enough water to support circulation and heart health."]
    )
    
    @State private var selectedMessage: HeartRateVariabilityMessage = HeartRateVariabilityMessage(
        title: "Loading...",
        detail: "We're analyzing your heart rate variability patterns.",
        secondaryTitle: "Here's What You Can Do To Maintain Your Heart Rate Variability",
        tipTitles: ["Stay Active", "Prioritize Rest", "Stay Hydrated"],
        tipDetails: ["Regular exercise, like walking, jogging, or yoga, can help keep your heart rate in a healthy range.",
                     "Make sure you get enough sleep and rest to avoid unnecessary stress on your body",
                     "Drink enough water to support circulation and heart health."]
    )
    
    func heartRateVariabilityStatus(currentHRV: Int?, avgHRV: Double?) -> HeartRateVariabilityMessage {
        guard let current = currentHRV, current > 0,
              let avgHRV = avgHRV, avgHRV > 0 else {
            return noDataMessage
        }
        
        let avg = Int(avgHRV)
        
        if current >= avg - 10 && current <= avg + 10 {
            return normalMessage
        } else if current < avg - 10 && current >= avg - 20 {
            return slightlyLowMessage
        } else if current < avg - 20 {
            return lowMessage
        } else {
            return highMessage
        }
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                (
                    Text("Your Current Heart Rate Variability is ")
                        .font(.title3.bold())
                        
                    +
                    Text(selectedMessage.title)
                        .font(.title3.bold())
                        .foregroundColor(Color("primary_1"))
                )
                
                Rectangle()
                    .frame(width: 150, height: 2, alignment: .leading)
                    .foregroundStyle(Color("OrangeThreex"))
                
                styledText(from: selectedMessage.detail)
                    .font(.body)
                    .padding(.top, 8)
                
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color("primary_1").opacity(0.2))
                            .frame(width: 32, height: 32)
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color("primary_1"))
                            .font(.system(.body, weight: .medium))
                    }
                    
                    let hasData = !data.allSatisfy { $0.value == 0 }

                    if !hasData {
                        Text("--")
                            .font(.title)
                            .bold()
                    } else {
                        Text("\(selectedValue)")
                            .font(.title)
                            .bold()
                    }
                    
                    Text("ms")
                        .font(.title2.bold())
                        .foregroundStyle(Color("OrangeOnex"))
                    
                    Spacer()
                    
                    if let selected = selectedDate {
                        Text(formattedDate(selected))
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    } else {
                        Text(dateRangeText(from: HealthKitViewModel.HeartRateVariabilityDaily))
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                    
                }
                .padding(.top, 8)
                
                // Conditionally show chart only if we have data
                if !HealthKitViewModel.HeartRateVariabilityDaily.allSatisfy({ $0.value == 0 }) {
                    MyChart(
                        averageValue7Days: $HealthKitViewModel.overallAvgHRV,
                        data: $HealthKitViewModel.HeartRateVariabilityDaily,
                        selectedDate: $selectedDate // ✅ <-- Pass binding here!
                    )
                } else {
                    // Show empty state for chart
                    VStack(spacing: 12) {
                        Spacer(minLength: 40)
                        Image(systemName: "chart.xyaxis.line")
                            .font(.system(.largeTitle))
                            .foregroundColor(Color.gray.opacity(0.5))
                        Text("No heart rate variability data available")
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
            .padding(.bottom, 16)
            
            SimpleCard(
                title: selectedMessage.secondaryTitle,
                content: "",
                showMainText: false,
                isShowTip: true,
                tipTitles: selectedMessage.tipTitles,
                tipmessages: selectedMessage.tipDetails
            )
            
            AboutCard(
                title: "About Heart Rate Variability",
                content: "Heart Rate Variability (HRV) is the variation in time between each heartbeat. It reflects how well your body adapts to stress, recovers from exercise, and maintains balance in your nervous system. In healthy adults, average heart rate variability is 42 milliseconds. The range is between 19 and 75 milliseconds. Athletes and other people who are very fit may have a much higher heart rate variability.",
                secondaryTitle: "Keypoint about HRV",
                secondaryTitleColor: Color("primary_1"),
                keypoints: ["Higher HRV", "Low HRV", "People with low HRV", "HRV is personal and fluctuates daily."],
                keypointdescription: [
                    "May indicate better heart health and greater adaptability to stress.",
                    "Can be linked to a high resting heart rate and may suggest your body is under stress or not recovering well.",
                    "Are sometimes at higher risk for conditions like diabetes, high blood pressure, arrhythmias, asthma, anxiety, and depression. Consult professional healthcare if you have concerns.",
                    "What's considered \"normal\" can vary greatly from person to person."
                ]
            )
            
            SimpleCard(
                title: "Disclaimer",
                content: "These recommendations are based on general health guidelines and not intended to diagnose or treat any medical condition. Please consult a healthcare professional for personalized advice.",
                titleColor: Color("OrangeOnex"),
                showIcon: true,
                backgroundColor: Color("OrangeBGx")
            )
        }
        .onAppear {
            HealthKitViewModel.loadHeartRateVariabilityDaily()
            updateMessageBasedOnData()
        }
        .onChange(of: HealthKitViewModel.HeartRateVariabilityDaily) { _, _ in
            updateMessageBasedOnData()
        }
    }
    
    // Helper function to update the displayed message based on the available data
    private func updateMessageBasedOnData() {
        let data = HealthKitViewModel.HeartRateVariabilityDaily
        let hasData = !data.allSatisfy { $0.value == 0 }
        
        if !hasData {
            // No heart rate variability data available
            selectedMessage = noDataMessage
            return
        }
        
        // Find the last non-zero value
        guard let lastNonZero = data.last(where: { $0.value > 0 }) else {
            selectedMessage = noDataMessage
            return
        }
        
        current = lastNonZero.value
        selectedMessage = heartRateVariabilityStatus(currentHRV: lastNonZero.value, avgHRV: HealthKitViewModel.overallAvgHRV)
    }
}

public struct HeartRateView: View {
    
    @State private var activeTab = "RHR"
    @EnvironmentObject var HealthKitViewModel: HealthKitViewModel
    
    
    public var body: some View {
        ScrollView{
            
            VStack() {
                
                SegmentedControl(activeTab: $activeTab)
                
                
                
                
                Group {
                    if activeTab == "HR" {
                        AverageHeartRateSection()
                    } else if activeTab == "RHR" {
                        RestingHeartRateSection()
                    } else if activeTab == "HRV" {
                        HeartRateVariabilitySection()
                    }
                }
                
                Spacer()
            }
        }
        .background(Color("BackgroundColorx"))
    }
    
}
