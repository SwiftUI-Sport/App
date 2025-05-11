//
//  HeartRateView.swift
//  App
//
//  Created by Muhammad Abid on 05/05/25.
//

import SwiftUI
import Charts


struct SegmentedControl: View {
    
      @Binding var activeTab: String
      let tabs = [ "RHR", "HR" , "HRV"]
    
    @Namespace private var animation
    

      var body: some View {
          
           

//              Picker("Options", selection: $activeTab) {
//                  ForEach(tabs, id: \.self) { option in
//                      Text(option)
//                  }
//              }
//              .pickerStyle(.segmented)
//              .padding()
              

          
          
          HStack(spacing: 0) {
              ForEach(tabs.indices, id: \.self) { index in
                        let tab = tabs[index]
                  
                         Button(action: {
                             withAnimation(.easeOut(duration: 0.2)) {
                                 activeTab = tab
                             }
                         }) {
                             Text(tab)
                                 .font(.system(size: 14, weight: .medium))
                                 .foregroundColor(activeTab == tab ? .white : .gray)
                                 .frame(maxWidth: .infinity, minHeight: 25)
                                 .padding(.vertical, 8)
                                 .background(
                                     ZStack {
                                         if activeTab == tab {
                                             RoundedRectangle(cornerRadius: 8)
                                                 .fill(Color("OrangeOnex"))
                                                 .matchedGeometryEffect(id: "tab", in: animation)
                                         }
                                     }
                                 )
                         }
                         .frame(maxWidth: .infinity)
                         
//                         // Add separator if not the last item
//                         if index < tabs.count - 1 {
//                             Divider()
//                                 .frame(width: 1, height: 20)
//                                 .background(Color.white.opacity(0.7)) // You can adjust opacity or color
//                         }
                     }
                 }
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
                            
                        Text(tipmessages[index])
                            .padding(.bottom, 8)
                    }
                    
                }

            }
            
            
        }
        .padding(24)
        .background(backgroundColor)
        .cornerRadius(12)
        .frame(minWidth:200, maxWidth: .infinity, alignment: .leading)
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
//                .font(.headline)
                .font(.title3.bold())
                .padding(.vertical, 8)
                .foregroundColor(secondaryTitleColor)
            
            VStack(alignment : .leading){
                    ForEach(0..<keypoints.count, id: \.self) { index in
                        (
                            Text(keypoints[index])
                                .font(.body)
                                .bold()
                            + Text(" \(keypointdescription[index])")
                                .font(.body)
                        )
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 8)
                    }
                    
                }
                
            
            
        }
        .padding(24)
        .background(.white)
        .cornerRadius(12)
        .frame(minWidth:200, maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.bottom, 16)
        
        
    }
}



//Ini CHART





struct MyChart: View {
    @Binding var averageValue7Days: Double
    @Binding var data: [DailyRate]  // Generalized data
    @State private var selectedXValue: String? = nil
    @State private var selectedDate: String? = nil // ← This is persistent
    var showAverage: Bool = true

    var mainColor: Color = Color("OrangeTwox")
    
    func getShortDay(for dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        formatter.dateFormat = "E" // e.g., "Tue"
        return formatter.string(from: date)
    }
    
    
    var body: some View {
        Chart {
            
            let highlightIndex: Int? = {
                if data.indices.contains(6) {
                    return 6 // Prefer 7th (index 6) if available
                } else if data.indices.contains(5) {
                    return 5 // Otherwise use 6th (index 5)
                } else {
                    return 6 // If both are missing, highlight nothing
                }
            }()
            
            ForEach(Array(data.enumerated()), id: \.element.date) { index, item in
                BarMark(
                    x: .value("Day", item.date),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(index == highlightIndex ? mainColor : Color("Barx"))
                .cornerRadius(5)
                
            }
            
            if showAverage {
                RuleMark(y: .value("Average", Int(averageValue7Days)))
                    .foregroundStyle(mainColor)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .annotation(position: .top, alignment: .leading) {
                        Text("Avg: \(Int(averageValue7Days))")
                            .font(.caption)
                            .foregroundColor(mainColor)
                            .padding(.horizontal, 4)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(4)
                    }
            }
            
            
           
        }
        .frame(height: 200)
//        .chartXSelection(value: $selectedXValue)
//        .onChange(of: selectedXValue) { _, newValue in
//            if let newDate = newValue {
//                selectedDate = newDate
//            }
//        }
//        
//
//        .onAppear {
//            if selectedDate == nil {
//                selectedDate = data.last?.date  // Initial highlight on last bar
//            }
//        }
    
        .padding()
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                if let dateStr = value.as(String.self) {
                    AxisValueLabel(getShortDay(for: dateStr))
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
    }
}


//INI SECTION PERTAMA
struct AverageHeartRateSection: View {
    
    @EnvironmentObject var HealthKitViewModel: HealthKitViewModel
    @State var current: Int? = nil
    

    
    func calculateAverageHeartRate(from data: [HeartRateOfTheDay]) -> Double {
        // Check if there is any data to prevent division by zero
        guard data.count > 0 else {
            print("No data available to calculate average heart rate.")
            return 0.0 // Return 0 or any default value you prefer
        }
        
        let totalHeartRate = data.reduce(0) { $0 + $1.averageHeartRate }
        let averageHeartRate = totalHeartRate / data.count
        print("Total Heart Rate:", totalHeartRate)
        
        return Double(averageHeartRate)
    }
    
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
    
    struct AverageHeartRateMessage {
        let title: String
        let detail: String
        
        let secondaryTitle: String
        let tipTitles: [String]
        let tipDetails: [String]
    }
    
    @State private var selectedMessage: AverageHeartRateMessage = AverageHeartRateMessage(
           title: "Your Current Heart Rate Is Within Normal Range",
           detail: "This may indicate that your body is in a good balance. You can continue running, but listen to your body and adjust as needed.",
           
           secondaryTitle: "Here’s What You Can Do To Maintain Your Heart Rate",
           
           tipTitles: ["Stay Active", "Priroritize Rest", "Stay Hydrated"],
           tipDetails: ["Regular exercise, like walking, jogging, or yoga, can help keep your heart rate in a healthy range.", "Make sure you get enough sleep and rest to avoid unnecessary stress on your body", "Drink enough water to support circulation and heart health."]
       )
    
   let normalMessage: AverageHeartRateMessage = AverageHeartRateMessage(
        title: "Your Current Heart Rate Is Within Normal Range",
        detail: "This may indicate that your body is in a good balance. You can continue running, but listen to your body and adjust as needed.",
        
        secondaryTitle: "Here’s What You Can Do To Maintain Your Heart Rate",
        tipTitles: ["Stay Active", "Priroritize Rest", "Stay Hydrated"],
        tipDetails: ["Regular exercise, like walking, jogging, or yoga, can help keep your heart rate in a healthy range.", "Make sure you get enough sleep and rest to avoid unnecessary stress on your body", "Drink enough water to support circulation and heart health."]
       
    )
    
    let slightlyHighMessage: AverageHeartRateMessage = AverageHeartRateMessage(
        title: "Your Current Heart Rate Is Slightly Higher Than Your Average",
        detail: "Your body may need a little recovery. If you still want to stay active, go for something light like walking, stretching, or yoga.",
        secondaryTitle: "Here’s What You Can Do To Recover Your Heart Rate",
        tipTitles: ["Prioritize high-quality sleep", "Stay hydrated", "Avoid Stimulants", "Take a recovery day"],
        tipDetails: ["Quality rest boosts recovery and overall performance.", "Drink enough water to support your heart and energy levels.", "Limit caffeine and alcohol, which can elevate your Heart Rate.", "If you’re tired, rest. Or stay active with light stretching or a gentle walk."]
    )
    
    let highMessage: AverageHeartRateMessage = AverageHeartRateMessage(
        title: "Your Current Heart Rate is Higher Than Average Heart Rate",
        detail: "This could be a sign your body is still recovering from recent activity, stress, or lack of rest.",
        secondaryTitle: "Here’s What You Can Do To Recover Your Heart Rate",
        tipTitles: ["Prioritize high-quality sleep", "Stay hydrated", "Avoid Stimulants", "Take a recovery day"],
        tipDetails: ["Quality rest boosts recovery and overall performance.", "Drink enough water to support your heart and energy levels.", "Limit caffeine and alcohol, which can elevate your Heart Rate.", "If you’re tired, rest. Or stay active with light stretching or a gentle walk."]
    )
    
    let lowerMessage: AverageHeartRateMessage = AverageHeartRateMessage(
        title: "Your Current Heart Rate is Lower Than Average Heart Rate",
        detail: "This could mean your body is well-rested or relaxed. If you’re feeling fatigued or dizzy, consider checking your health.",
        secondaryTitle: "Here’s What You Can Do To Recover Your Heart Rate",
        tipTitles: ["Prioritize high-quality sleep", "Stay hydrated", "Avoid Stimulants", "Take a recovery day"],
        tipDetails: ["Quality rest boosts recovery and overall performance.", "Drink enough water to support your heart and energy levels.", "Limit caffeine and alcohol, which can elevate your Heart Rate.", "If you’re tired, rest. Or stay active with light stretching or a gentle walk."]
    )
    
    
    func heartRateStatus(currentHR: Int?, avgHR: Double?) -> AverageHeartRateMessage {
        guard let current = currentHR, let avgHR = avgHR else {
            return normalMessage // or a custom "no data" message
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
         
         
         VStack{
             
             VStack(alignment: .leading){
                 Text(selectedMessage.title)
                     .font(.title3.bold())
                 
                 Rectangle()
                     .frame(width: 150, height: 2, alignment: .leading)
                     .foregroundStyle(Color("OrangeThreex"))
                 
                 Text(selectedMessage.detail)
                     .padding(.top, 8)
                 
                 HStack{
                     Image(systemName: "heart.circle.fill")
                         .font(.system(size: 32, weight: .bold, design: .default))
                         .foregroundStyle(Color("OrangeOnex"))
                     
                     
                     if let lastValue = HealthKitViewModel.HeartRateDailyv2.last?.value {
                         Text(String(format: "%.0f", Double(lastValue)))
                             .font(.title)
                             .bold()
                     } else {
                         Text("–") // fallback for empty array
                             .font(.title)
                             .bold()
                     }
                     
                     
                     Text("bpm")
                         .font(.title2.bold())
                         .foregroundStyle(Color("OrangeOnex"))
                     
                     Spacer()
                     
                     Text(dateRangeText(from: HealthKitViewModel.HeartRateDailyv2))
                         .font(.caption)
                         .foregroundStyle(Color.gray)
                     
                 }
                 .padding(.top, 12)
                 
                 MyChart( averageValue7Days: $HealthKitViewModel.overallAverageHR,
                          data: $HealthKitViewModel.HeartRateDailyv2
                 )
             }
             .padding(.vertical)
             .padding(.horizontal, 16)
             .background(Color.white)
             .cornerRadius(12)
             .frame(maxWidth: .infinity, alignment: .leading)
             .padding(.horizontal)
             .padding(.bottom, 16)
             
             
             SimpleCard(title: selectedMessage.secondaryTitle,
                        content: "",
                        showMainText: false,
                        isShowTip: true,
                        tipTitles: selectedMessage.tipTitles,
                        tipmessages: selectedMessage.tipDetails
             )
             
             AboutCard(title: "About Average Heart Rate",
                       content: "An abnormal average heart rate too high or too low can signal cardiovascular stress or underlying health issues, potentially reducing the body’s efficiency in recovery, energy regulation, and overall physical performance.",
                       secondaryTitle: "Keypoint about Heart Rate",
                       keypoints: ["An abnormally high or low", "Consistently high heart rate", "Consistently low heart rate"],
                       keypointdescription: ["average heart rate may indicate cardiovascular stress, fatigue, or underlying health concerns.", "can signal overtraining, dehydration, stress, or poor sleep.", "(below 60 bpm) is normal for athletes, but may be a concern if accompanied by symptoms like dizziness or fatigue."])
             
             
             SimpleCard(title: "Disclaimer",
                        content: "These recomendation are based on general health and not intended to diagnose or treat any medical condition. Please consult a healthcare professional.",
                        titleColor: Color("OrangeOnex"),
                        showIcon: true,
                        backgroundColor: Color("OrangeBGx"))
             
         }
         .onAppear {
             HealthKitViewModel.loadHeartRate()
             if let currentValue = HealthKitViewModel.HeartRateDailyv2.last?.value {
                 current = currentValue
                 selectedMessage = heartRateStatus(currentHR: currentValue, avgHR: HealthKitViewModel.overallAverageHR)
             }
         }
         .onChange(of: HealthKitViewModel.HeartRateDailyv2.last?.value) { oldValue, newValue in
             if let currentValue = HealthKitViewModel.HeartRateDailyv2.last?.value {
                 current = currentValue
                 selectedMessage = heartRateStatus(currentHR: currentValue, avgHR: HealthKitViewModel.overallAverageHR)
             }
         }
         

    }
}

struct RestingHeartRateSection: View {
    
    @EnvironmentObject var HealthKitViewModel: HealthKitViewModel
    @State var current: Int? = nil
    
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
    
    struct RestingHeartRateMessage {
        let title: String
        let detail: String
        let secondaryTitle: String
        let tipTitles: [String]
        let tipDetails: [String]
    }
    
    @State private var selectedMessage: RestingHeartRateMessage = RestingHeartRateMessage(
           title: "Your Current Resting Heart Rate Is Within Normal Range",
           detail: "This is may indicate that your body is in a healthy state. Your heart is functioning well, and you're maintaining a balanced level of physical recovery.",
           secondaryTitle: "Here’s What You Can Do To Maintain Your Resting Heart Rate",
           
           tipTitles: ["Stay Active", "Priroritize Rest", "Stay Hydrated"],
           tipDetails: ["Regular exercise, like walking, jogging, or yoga, can help keep your heart rate in a healthy range.", "Make sure you get enough sleep and rest to avoid unnecessary stress on your body", "Drink enough water to support circulation and heart health."]
       )
    
    
    let normalMessage: RestingHeartRateMessage = RestingHeartRateMessage(
        title: "Your Current Resting Heart Rate Is Within Normal Range",
        detail: "This is may indicate that your body is in a healthy state. Your heart is functioning well, and you're maintaining a balanced level of physical recovery.",
        secondaryTitle: "Here’s What You Can Do To Maintain Your Resting Heart Rate",
        
        tipTitles: ["Stay Active", "Priroritize Rest", "Stay Hydrated"],
        tipDetails: ["Regular exercise, like walking, jogging, or yoga, can help keep your heart rate in a healthy range.", "Make sure you get enough sleep and rest to avoid unnecessary stress on your body", "Drink enough water to support circulation and heart health."]
    )
    
    let slightlyHighMessage: RestingHeartRateMessage = RestingHeartRateMessage(
        title: "Your Current Resting Heart Rate Is Slightly Higher Than Usual",
        detail: "This is may indicate that your body is not fully rested. It’s a good idea to take it easy today and give yourself time to recover.",
        secondaryTitle: "Here’s What You Can Do To Recover Your Resting Heart Rate",
        
        tipTitles: ["Prioritize high-quality sleep", "Stay hydrated", "Avoid Stimulants", "Take a recovery day"],
        tipDetails: ["Quality rest boosts recovery and overall performance.", "Drink enough water to support your heart and energy levels.", "Limit caffeine and alcohol, which can elevate your RHR.", "If you’re tired, rest. Or stay active with light stretching or a gentle walk."]
    )
    
    let highMessage: RestingHeartRateMessage = RestingHeartRateMessage(
        title: "Your Current Resting Heart Rate Is Higher Than Usual",
        detail: "This could be a sign that your body is still recovering, under stress, or not fully rested.",
        secondaryTitle: "Here’s What You Can Do To Recover Your Resting Heart Rate",
        tipTitles: ["Prioritize high-quality sleep", "Stay hydrated", "Avoid Stimulants", "Take a recovery day"],
        tipDetails: ["Quality rest boosts recovery and overall performance.", "Drink enough water to support your heart and energy levels.", "Limit caffeine and alcohol, which can elevate your RHR.", "If you’re tired, rest. Or stay active with light stretching or a gentle walk."]
    )
    
    let lowMessage: RestingHeartRateMessage = RestingHeartRateMessage(
        title: "Your Current Resting Heart Rate Is Lower Than Usual",
        detail: "This can indicate good cardiovascular fitness or relaxation. If you're feeling dizzy or unwell, it may be worth checking in with your health.",
        secondaryTitle: "Here’s What You Can Do To Recover Your Resting Heart Rate",
        tipTitles: ["Prioritize high-quality sleep", "Stay hydrated", "Avoid Stimulants", "Take a recovery day"],
        tipDetails: ["Quality rest boosts recovery and overall performance.", "Drink enough water to support your heart and energy levels.", "Limit caffeine and alcohol, which can elevate your RHR.", "If you’re tired, rest. Or stay active with light stretching or a gentle walk."]
    )
    
    func heartRateStatus(currentHR: Int?, avgHR: Double?) -> RestingHeartRateMessage {
        guard let current = currentHR, let avgHR = avgHR else {
            return normalMessage // or a custom "no data" message
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
        
         
         VStack{
             
             VStack(alignment: .leading){
                 Text(selectedMessage.title)
                     .font(.title3.bold())
                 
                 Rectangle()
                     .frame(width: 150, height: 2, alignment: .leading)
                     .foregroundStyle(Color("OrangeThreex"))
                 
                 Text(selectedMessage.detail)
                     .padding(.top, 8)
                 
                 HStack{
                     Image(systemName: "heart.circle.fill")
                         .font(.system(size: 32, weight: .bold, design: .default))
                         .foregroundStyle(Color("OrangeOnex"))
                     
                     
                     if let lastValue = HealthKitViewModel.restingHeartRateDailyv2.last?.value {
                         Text(String(format: "%.0f", Double(lastValue)))
                             .font(.title)
                             .bold()
                     } else {
                         Text("–") // fallback for empty array
                             .font(.title)
                             .bold()
                     }
                     
                     
                     Text("bpm")
                         .font(.title2.bold())
                         .foregroundStyle(Color("OrangeOnex"))
                     
                     Spacer()
                     
                     Text(dateRangeText(from: HealthKitViewModel.restingHeartRateDailyv2))
                         .font(.caption)
                         .foregroundStyle(Color.gray)
                     
                 }
                 .padding(.top, 8)
                 
                 MyChart( averageValue7Days: $HealthKitViewModel.overallRestingHR,
                          data: $HealthKitViewModel.restingHeartRateDailyv2
                 )
             }
             .padding(.vertical)
             .padding(.horizontal, 16)
             .background(Color.white)
             .cornerRadius(12)
             .frame(maxWidth: .infinity, alignment: .leading)
             .padding(.horizontal)
             .padding(.bottom, 16)
             
             SimpleCard(title: selectedMessage.secondaryTitle,
                        content: "",
                        showMainText: false,
                        isShowTip: true,
                        tipTitles: selectedMessage.tipTitles,
                        tipmessages: selectedMessage.tipDetails
             )
             
             
            
             
             AboutCard(title: "About Resting Heart Rate",
                       content: "Resting Heart Rate (RHR) is the number of times your heart beats per minute (bpm) when your body is at complete rest. RHR is typically measured after you wake up, before any physical activity.",
                       secondaryTitle: "Keypoint about Resting Heart Rate",
                       keypoints: ["Normal range", "Lower RHR", "Higher RHR"],
                       keypointdescription: ["for most adults, a healthy RHR is between 60–100 bpm. Athletes or very fit individuals may have lower RHRs, around 40–60 bpm.", "often indicates good cardiovascular fitness and efficient heart function.", "can be a sign of fatigue, stress, dehydration, illness, or overtraining."])
             
             
             SimpleCard(title: "Disclaimer",
                        content: "These recomendation are based on general health and not intended to diagnose or treat any medical condition. Please consult a healthcare professional.",
                        titleColor: Color("OrangeOnex"),
                        showIcon: true,
                        backgroundColor: Color("OrangeBGx"))
             
         }
         .onAppear {
             HealthKitViewModel.loadRestingHeartRateDaily()
             if let currentValue = HealthKitViewModel.HeartRateDailyv2.last?.value {
                 current = currentValue
                 selectedMessage = heartRateStatus(currentHR: currentValue, avgHR: HealthKitViewModel.overallAverageHR)
             }
         }
         .onChange(of: HealthKitViewModel.restingHeartRateDailyv2.last?.value) { oldValue, newValue in
             if let currentValue = HealthKitViewModel.restingHeartRateDailyv2.last?.value {
                 current = currentValue
                 selectedMessage = heartRateStatus(currentHR: currentValue, avgHR: HealthKitViewModel.overallRestingHR)
             }
         }
         
         
    }
}

struct HeartRateVariabilitySection: View {
    
    @EnvironmentObject var HealthKitViewModel: HealthKitViewModel
    @State var current: Int? = nil
    
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
    
    struct HeartRateVariabilityMessage {
        let title: String
        let detail: String
        let secondaryTitle: String
        let tipTitles: [String]
        let tipDetails: [String]
    }
    
    @State private var selectedMessage: HeartRateVariabilityMessage = HeartRateVariabilityMessage(
           title: "Your Heart Rate Variability is Within Normal Range",
           detail: "This is may indicate your body is recovering well and your autonomic nervous system is balanced.",
           secondaryTitle: "Here’s What You Can Do To Maintain Your Heart Rate Variability",
           tipTitles: ["Stay Active", "Priroritize Rest", "Stay Hydrated"],
           tipDetails: ["Regular exercise, like walking, jogging, or yoga, can help keep your heart rate in a healthy range.", "Make sure you get enough sleep and rest to avoid unnecessary stress on your body", "Drink enough water to support circulation and heart health."]
       )
    
    
    let normalMessage: HeartRateVariabilityMessage = HeartRateVariabilityMessage(
        title: "Your Heart Rate Variability is Within Normal Range",
        detail: "This is may indicate your body is recovering well and your autonomic nervous system is balanced.",
        secondaryTitle: "Here’s What You Can Do To Maintain Your Heart Rate Variability",
        tipTitles: ["Stay Active", "Priroritize Rest", "Stay Hydrated"],
        tipDetails: ["Regular exercise, like walking, jogging, or yoga, can help keep your heart rate in a healthy range.", "Make sure you get enough sleep and rest to avoid unnecessary stress on your body", "Drink enough water to support circulation and heart health."]
    )
    
    let slightlyLowMessage: HeartRateVariabilityMessage = HeartRateVariabilityMessage(
        title: "Your Heart Rate Variability is Slightly Lower Than Usual",
        detail: "This is may be a sign your body is under stress or still recovering, take it slow for today.",
        secondaryTitle: "Here’s What You Can Do To Recover Your Heart Rate Variability",
        tipTitles: ["Prioritize high-quality sleep", "Stay hydrated", "Practice mindfulness", "Take a recovery day"],
        tipDetails: ["Quality rest boosts recovery and overall performance.", "Drink enough water to support your heart and energy levels.", "Breathing exercises, meditation, or calm walks can boost HRV.", "If you’re tired, rest. Or stay active with light stretching or a gentle walk."]
    )
    
    let lowMessage: HeartRateVariabilityMessage = HeartRateVariabilityMessage(
        title: "Your Heart Rate Variability is Lower Than Usual",
        detail: "This may be a sign of current or future health problems because it shows that your body isn't adapting to changes well.",
        secondaryTitle: "Here’s What You Can Do To Recover Your Heart Rate Variability",
        tipTitles: ["Prioritize high-quality sleep", "Stay hydrated", "Practice mindfulness", "Take a recovery day"],
        tipDetails: ["Quality rest boosts recovery and overall performance.", "Drink enough water to support your heart and energy levels.", "Breathing exercises, meditation, or calm walks can boost HRV.", "If you’re tired, rest. Or stay active with light stretching or a gentle walk."]
    )
    
    let highMessage: HeartRateVariabilityMessage = HeartRateVariabilityMessage(
        title: "Your Heart Rate Variability is Higher Than Usual",
        detail: "This is a positive sign that your body is adapting well to physical and emotional demands.",
        secondaryTitle: "Here’s What You Can Do To Maintain Your Heart Rate Variability",
        tipTitles: ["Stay Active", "Priroritize Rest", "Stay Hydrated"],
        tipDetails: ["Regular exercise, like walking, jogging, or yoga, can help keep your heart rate in a healthy range.", "Make sure you get enough sleep and rest to avoid unnecessary stress on your body", "Drink enough water to support circulation and heart health."]
    )
    
    func heartRateStatus(currentHRV: Int?, avgHRV: Double?) -> HeartRateVariabilityMessage {
        guard let current = currentHRV, let avgHRV = avgHRV else {
            return normalMessage // or a custom fallback message
        }

        let avg = Int(avgHRV)

        if current >= avg - 10 && current <= avg + 10 {
            return normalMessage
        } else if current < avg - 20 {
            return lowMessage
        } else if current < avg - 10 {
            return slightlyLowMessage
        } else {
            return highMessage
        }
    }
    
    
    
     var body: some View {
        
         
         VStack{
             
             VStack(alignment: .leading){
                 Text(selectedMessage.title)
                     .font(.title3.bold())
                 
                 Rectangle()
                     .frame(width: 150, height: 2, alignment: .leading)
                     .foregroundStyle(Color("OrangeThreex"))
                 
                 Text(selectedMessage.detail)
                     .padding(.top, 8)
                 
                 HStack{
                     Image(systemName: "heart.circle.fill")
                         .font(.system(size: 32, weight: .bold, design: .default))
                         .foregroundStyle(Color("OrangeOnex"))
                     
                     if let lastValue = HealthKitViewModel.HeartRateVariabilityDaily.last?.value {
                         Text(String(format: "%.0f", Double(lastValue)))
                             .font(.title)
                             .bold()
                     } else {
                         Text("–") // fallback for empty array
                             .font(.title)
                             .bold()
                     }
                     
                     
                     Text("bpm")
                         .font(.title2.bold())
                         .foregroundStyle(Color("OrangeOnex"))
                     
                     Spacer()
                     
                     Text(dateRangeText(from: HealthKitViewModel.HeartRateVariabilityDaily))
                         .font(.caption)
                         .foregroundStyle(Color.gray)
                     
                 }
                 .padding(.top, 8)
                 
                 MyChart( averageValue7Days: $HealthKitViewModel.overallAvgHRV,
                          data: $HealthKitViewModel.HeartRateVariabilityDaily
                 )
             }
             .padding(.vertical)
             .padding(.horizontal, 16)
             .background(Color.white)
             .cornerRadius(12)
             .frame(maxWidth: .infinity, alignment: .leading)
             .padding(.horizontal)
             .padding(.bottom, 16)
             
             
             SimpleCard(title: "Here’s What You Can Do To Maintain Your Heart Rate",
                        content: "",
                        showMainText: false,
                        isShowTip: true,
                        tipTitles: selectedMessage.tipTitles,
                        tipmessages: selectedMessage.tipDetails
             )
             
             
             
             AboutCard(title: "About Heart Rate Variability",
                       content: "Heart Rate Variability (HRV) is the variation in time between each heartbeat. It reflects how well your body adapts to stress, recovers from exercise, and maintains balance in your nervous system. In healthy adults, average heart rate variability is 42 milliseconds. The range is between 19 and 75 milliseconds. Athletes and other people who are very fit may have a much higher heart rate variability.",
                       secondaryTitle: "Key Point about HRV",
                       keypoints: ["Higher HRV", "Low HRV", "People with low HRV", "HRV is personal and fluctuates daily."],
                       keypointdescription: ["may indicate better heart health and greater adaptability to stress.", "can be linked to a high resting heart rate and may suggest your body is under stress or not recovering well.", "are sometimes at higher risk for conditions like diabetes, high blood pressure, arrhythmias, asthma, anxiety, and depression. Consult professional healthcare if you have concerns.", "What’s considered “normal” can vary greatly from person to person."])
             
             SimpleCard(title: "Disclaimer",
                        content: "These recomendation are based on general health and not intended to diagnose or treat any medical condition. Please consult a healthcare professional.",
                        titleColor: Color("OrangeOnex"),
                        showIcon: true,
                        backgroundColor: Color("OrangeBGx"))
             
         }
         .onAppear {
             HealthKitViewModel.loadHeartRateVariabilityDaily()
             if let currentValue = HealthKitViewModel.HeartRateVariabilityDaily.last?.value {
                 current = currentValue
                 selectedMessage = heartRateStatus(currentHRV: currentValue, avgHRV: HealthKitViewModel.overallAvgHRV)
             }
            
         }
         .onChange(of: HealthKitViewModel.HeartRateVariabilityDaily.last?.value) { oldValue, newValue in
             if let currentValue = HealthKitViewModel.HeartRateVariabilityDaily.last?.value {
                 current = currentValue
                 selectedMessage = heartRateStatus(currentHRV: currentValue, avgHRV: HealthKitViewModel.overallAvgHRV)
             }
         }
        
         
         
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
//        .onAppear {
//            
//            HealthKitViewModel.loadHeartRate(target: HeartRateOfTheDay)
//            print("Ini sebenernya udah jalan 2")
//        }
    }
        
}

//#Preview {
//    HeartRateView()
//}
