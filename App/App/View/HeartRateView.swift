//
//  HeartRateView.swift
//  App
//
//  Created by Muhammad Abid on 05/05/25.
//

import SwiftUI

//struct SegmentControl: View {
//    @State private var selected = "HR"
//    let options = ["HR", "RHR", "HRV"]
//
//    var body: some View {
//        HStack(spacing: 0) {
//            ForEach(options, id: \.self) { option in
//                Text(option)
//                    .fontWeight(.medium)
//                    .foregroundColor(selected == option ? .white : .white.opacity(0.6))
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(selected == option ? Color.red : Color.gray)
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//                    .onTapGesture {
//                        selected = option
//                    }
//            }
//        }
//        .padding(4)
//        .background(Color.gray.opacity(0.5))
//        .clipShape(RoundedRectangle(cornerRadius: 16))
//    }
//}


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
        .background(Color.white)
        .cornerRadius(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.bottom, 16)
        
        
    }
}




//INI SECTION PERTAMA
struct AverageHeartRateSection: View {
    
     var body: some View {
         
         ScrollView {
             
             
             
             Text("Average Heart Rate Section")
                 .padding()
             
             SimpleCard(title: "Highlight",
                        content: "Based on your health record, your average heart rate higher than usual. This can be a sign your body still recovering"
                        
             )
             
             SimpleCard(title: "About Average Heart Rate",
                        content: "An abnormal average heart rate too high or too low can signal cardiovascular stress or underlying health issues, potentially reducing the body’s efficiency in recovery, energy regulation, and overall physical performance."
                        
             )
             
             SimpleCard(title: "Disclaimer",
                        content: "These recomendation are based on general health and not intended to diagnose or treat any medical condition. Please consult a healthcare professional.",
                        titleColor: Color("OrangeOnex"),
                        showIcon: true)
             
             
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
