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

      var body: some View {
          
           

              Picker("Options", selection: $activeTab) {
                  ForEach(tabs, id: \.self) { option in
                      Text(option)
                  }
              }
              .pickerStyle(.segmented)
              .padding()
          
      }
}



struct SimpleCard: View {
    
    var title: String
    var content : String
    var titleColor : Color = .black
    var showIcon : Bool = false
    var backgroundColor : Color = .white
    
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
        .init(day: "Sunday", averageHeartRate: 115)
    ]
    
    var body: some View {
        Chart {
            ForEach(Array(data.enumerated()), id: \.element.day) { index, item in
            BarMark(
                x: .value("Day", item.day),
                y: .value("Average Heart Rate", item.averageHeartRate)
            )
            .foregroundStyle(index == data.count - 1 ? Color("OrangeOnex") : Color("Barx"))
            .cornerRadius(5)
                
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
             Text("Average Heart Rate Section")
                 .padding()
             
             VStack{
                 Text("Average Heart Rate")
                 
                 HStack{
                     Image(systemName: "exclamationmark.icloud.fill")
                     Text("123")
                     Text("bpm")
                         .font(.caption)
                     
                     Spacer()
                     
                     Text("12-19 April 2025")
                         
                 }
                 
                 
                     
                 
                 MyChart()
             }
             .padding(.vertical)
             .background(Color.white)
             .cornerRadius(12)
             .frame(maxWidth: .infinity, alignment: .leading)
             .padding(.horizontal)
             .padding(.bottom, 16)
             
             
             
             SimpleCard(title: "Highlight",
                        content: "Based on your health record, your average heart rate higher than usual. This can be a sign your body still recovering"
                        
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
