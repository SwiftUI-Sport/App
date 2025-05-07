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
      let tabs = ["HR", "RHR", "HRV"]
    
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
        .frame(minWidth:200, maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.bottom, 16)
        
        
    }
}



//Ini CHART





struct MyChart: View {
    @Binding var averageValue7Days: Double
    @Binding var data: [DailyRate]  // Generalized data
    
    func getShortDay(for dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        formatter.dateFormat = "E" // e.g., "Tue"
        return formatter.string(from: date)
    }
    
    //    func getShortDay(for dateString: String) -> String {
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "yyyy-MM-dd"
    //        guard let date = formatter.date(from: dateString) else {
    //            return dateString
    //        }
    //
    //        let weekdaySymbols = ["S", "M", "T", "W", "T", "F", "S"] // Sunday = 1
    //        let calendar = Calendar.current
    //        let weekdayIndex = calendar.component(.weekday, from: date) - 1
    //
    //        return weekdaySymbols[weekdayIndex]
    //    }
    
    var body: some View {
        Chart {
            ForEach(Array(data.enumerated()), id: \.element.date) { index, item in
                BarMark(
                    x: .value("Day", item.date),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(index == data.count - 1 ? Color("OrangeTwox") : Color("Barx"))
                .cornerRadius(5)
                
                RuleMark(y: .value("Average", averageValue7Days))
                    .foregroundStyle(Color("OrangeOnex"))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
            }
        }
        .frame(height: 200)
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
    
    
     var body: some View {
         
         
         VStack{
             
             VStack(alignment: .leading){
                 Text("Your Average Heart Rate is Higher Than Usual ")
                     .font(.title3.bold())
                 
                 Rectangle()
                     .frame(width: 150, height: 2, alignment: .leading)
                     .foregroundStyle(Color("OrangeThreex"))
                 
                 HStack{
                     Image(systemName: "heart.circle.fill")
                         .font(.system(size: 32, weight: .bold, design: .default))
                         .foregroundStyle(Color("OrangeOnex"))
                     Text(String(format: "%.0f", HealthKitViewModel.overallAverageHR)) // Rounded to whole number
                         .font(.title)
                         .bold()
                     Text("bpm")
                         .font(.title2.bold())
                         .foregroundStyle(Color("OrangeOnex"))
                     
                     Spacer()
                     
                     Text(dateRangeText(from: HealthKitViewModel.HeartRateDailyv2))
                         .font(.caption)
                         .foregroundStyle(Color.gray)
                     
                 }
                 .padding(.top, 8)
                 
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
                        titleColor: Color("OrangeOnex"),
                        showIcon: true,
                        backgroundColor: Color("OrangeBGx"))
             
         }
         .onAppear {
             
             HealthKitViewModel.loadHeartRate()

             
             
         }
         

    }
}

struct RestingHeartRateSection: View {
    
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
        
         
         VStack{
             
             VStack(alignment: .leading){
                 Text("Your Average Heart Rate is Higher Than Usual ")
                     .font(.title3.bold())
                 
                 Rectangle()
                     .frame(width: 150, height: 2, alignment: .leading)
                     .foregroundStyle(Color("OrangeThreex"))
                 
                 HStack{
                     Image(systemName: "heart.circle.fill")
                         .font(.system(size: 32, weight: .bold, design: .default))
                         .foregroundStyle(Color("OrangeOnex"))
                     Text(String(format: "%.0f", HealthKitViewModel.overallRestingHR)) // Rounded to whole number
                         .font(.title)
                         .bold()
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
                        titleColor: Color("OrangeOnex"),
                        showIcon: true,
                        backgroundColor: Color("OrangeBGx"))
             
         }
         .onAppear {
             HealthKitViewModel.loadRestingHeartRateDaily()
         }
         
         
    }
}

struct HeartRateVariabilitySection: View {
    
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
        
         
         VStack{
             
             VStack(alignment: .leading){
                 Text("Your Average Heart Rate is Higher Than Usual ")
                     .font(.title3.bold())
                 
                 Rectangle()
                     .frame(width: 150, height: 2, alignment: .leading)
                     .foregroundStyle(Color("OrangeThreex"))
                 
                 HStack{
                     Image(systemName: "heart.circle.fill")
                         .font(.system(size: 32, weight: .bold, design: .default))
                         .foregroundStyle(Color("OrangeOnex"))
                     Text(String(format: "%.0f", HealthKitViewModel.overallAvgHRV)) // Rounded to whole number
                         .font(.title)
                         .bold()
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
                        titleColor: Color("OrangeOnex"),
                        showIcon: true,
                        backgroundColor: Color("OrangeBGx"))
             
         }
         .onAppear {
             HealthKitViewModel.loadHeartRateVariabilityDaily()
         }
         
         
    }
}








public struct HeartRateView: View {
    
    @State private var activeTab = "HR"
    @EnvironmentObject var HealthKitViewModel: HealthKitViewModel
//    @State var HeartRateOfTheDay: [HeartRateOfTheDay] = []
    
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
            
            .frame( maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            
            
            
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
