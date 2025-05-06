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
                                 .frame(maxWidth: .infinity, maxHeight: 30)
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.bottom, 16)
        
        
    }
}



//Ini CHART

struct AverageHeartRate: Identifiable {
    var day: String
    var averageHeartRate: Double
    var id = UUID()
}



struct MyChart: View {
    
    var data: [AverageHeartRate] = [
        .init(day: "Monday", averageHeartRate: 92),
        .init(day: "Tuesday", averageHeartRate: 105),
        .init(day: "Wednesday", averageHeartRate: 107),
        .init(day: "Thursday", averageHeartRate: 140),
        .init(day: "Friday", averageHeartRate: 88),
        .init(day: "Saturday", averageHeartRate: 120),
        .init(day: "Sunday", averageHeartRate: 120)
    ]
    
    var body: some View {
        Chart {
            ForEach(Array(data.enumerated()), id: \.element.day) { index, item in
            BarMark(
                x: .value("Day", item.day),
                y: .value("Average Heart Rate", item.averageHeartRate)
            )
            .foregroundStyle(index == data.count - 1 ? Color("OrangeTwox") : Color("Barx"))
            .cornerRadius(5)
                
                RuleMark(y: .value("Average Heart Rate", 80))
                    .foregroundStyle(Color("OrangeOnex"))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                
            }

        }
        .frame(height: 200)
        .padding()
        .chartXAxis {
              AxisMarks(values: .stride(by: 1)) // Customize the x-axis if needed
              
          }
     
        
        
    }
}


//INI SECTION PERTAMA
struct AverageHeartRateSection: View {
    
     var body: some View {
         
         ScrollView {
   
             
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
                     Text("123")
                         .font(.title)
                         .bold()
                     Text("bpm")
                         .font(.title2.bold())
                         .foregroundStyle(Color("OrangeOnex"))
                     
                     Spacer()
                     
                     Text("12-19 April 2025")
                         .font(.caption)
                         .foregroundStyle(Color.gray)
                         
                 }
                 .padding(.top, 8)
                 
                 
                 
                     
                 
                 MyChart()
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

    }
}

struct RestingHeartRateSection: View {
    
     var body: some View {
         
         Text("Resting Heart Rate Section")
             .padding()
         
         
    }
}

struct HeartRateVariabilitySection: View {
    
     var body: some View {
         
         Text("Heart Rate Variability Section")
             .padding()
         
         
    }
}








public struct HeartRateView: View {
    
    @State private var activeTab = "HR"

    
    public var body: some View {
        
        VStack() {
       
            SegmentedControl(activeTab: $activeTab)
                .background(Color.blue)
                
            
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
        
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("BackgroundColorx"))
        
        
    }
        
}

#Preview {
    HeartRateView()
}
