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
    var body: some View {
        
        
        
        ScrollView{
            VStack(alignment: .leading){
                Text("You Have A Good Sleep ")
                    .font(.title3.bold())
                
                Rectangle()
                    .frame(width: 150, height: 2, alignment: .leading)
                    .foregroundStyle(Color("blueTint"))
                
                HStack{
                    
                    ZStack {
                        Circle()
                            .fill(Color("primary_3").opacity(0.2))
                            .frame(width: 32, height: 32)
                        Image(systemName: "moon.fill")
                            .foregroundColor(Color("primary_3"))
                            .font(.system(size: 18, weight: .medium))
                    }
                    Text("\(formatDurationSleep(healthKitViewModel.totalSleepInterval))")
                        .font(.title)
                        .bold()
                    //                        .foregroundStyle(Color("OrangeOnex"))
                    
                    Spacer()
                    
                    if let sleep = healthKitViewModel.sleepDuration.first {
                        // Tanggal
                        VStack(alignment: .center){
                            Text(sleep.day, format: .dateTime.weekday(.wide).month().day())
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            // Rentang jam tidur
                            Text("\(sleep.startTime, format: .dateTime.hour().minute()) – \(sleep.endTime, format: .dateTime.hour().minute())")
                                .font(.subheadline)
                        }
                        
                        
                    } else {
                        // Jika belum ada data
                        Text("No Data")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                }
                .padding(.top, 6)
                VStack{
                    if healthKitViewModel.totalSleepInterval < 21600.0{
                        Text("Your sleep duration is below the recommended range, which may affect your recovery, focus, and performance. ")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                            .frame(maxWidth: .infinity)
                    }
                    else{
                        Text("Your sleep duration falls within the ideal range for recovery. Quality rest helps regulate heart rate, improve recovery, and boost overall performance. Keep it up! ")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                            .frame(maxWidth: .infinity)
                        
                    }
                }
                .padding(.top, 6)
            }
            .padding(.vertical)
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(6)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
            .padding(.bottom, 16)
            .padding(.top,30)
            
            VStack(alignment:.leading){
                Text("Here’s What You Can Do to Help You Sleep Well")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                    .foregroundColor(.black)
                Text("Limit Screen Time")
                    .fontWeight(.bold)
                Text("Avoid phones or screens at least 30 minutes before bed to reduce blue light exposure.")
                Text("Create a Restful Environment")
                    .fontWeight(.bold)
                Text("Keep your room cool, dark, and quiet to promote better sleep.")
                Text("Avoid Caffeine Late in the Day")
                    .fontWeight(.bold)
                Text("Stimulants like coffee or energy drinks can disrupt your ability to fall asleep.")
                Text("Wind Down")
                    .fontWeight(.bold)
                Text("Try relaxing activities before bed like reading, stretching, or deep breathing.")
            }
            .padding(24)
            .background(.white)
            .cornerRadius(6)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            .frame(minWidth:200, maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
            .padding(.bottom, 16)
            
            VStack(alignment:.leading){
                Text("Here’s What You Can Do to Help You Sleep Well")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                    .foregroundColor(.black)
                Text("The ideal sleep duration for most adults is 7 to 9 hours per night. Staying within this range supports physical recovery, mental clarity, hormonal balance, and heart health.")
                
                Text("Keypoint about Sleep Duration")
    //                .font(.headline)
                    .font(.title3.bold())
                    .padding(.vertical, 8)
                    .foregroundColor(Color("primary_3"))
                HStack(alignment: .top, spacing: 0) {
                    Text("Too little sleep (less than 6 hours)  ")
                        .fontWeight(.bold)
                    +
                    Text("can lead to increased stress, elevated resting heart rate, reduced heart rate variability (HRV), impaired recovery, and decreased performance. ")
                }
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                HStack(alignment: .top, spacing: 0) {
                    Text("Too much sleep (more than 9–10 hours) ")
                        .fontWeight(.bold)
                    +
                    Text("may be linked to low energy levels, sluggishness, or even underlying health issues. ")
                    
                    
                }
                .multilineTextAlignment(.leading)
                //                .frame(width:300)
                .fixedSize(horizontal: false, vertical: true)
                
            }
            .padding(24)
            .background(.white)
            .cornerRadius(6)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            .frame(minWidth:200, maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
            .padding(.bottom, 16)
            
            SimpleCardest(title: "Disclaimer",
                       content: "These recomendation are based on general health and not intended to diagnose or treat any medical condition. Please consult a healthcare professional.",
                       titleColor: Color("blueTint"),
                       showIcon: true,
                       backgroundColor: Color("OrangeBGx"))
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
                .foregroundColor(Color("primary_3"))
            }
        }        .background(Color("backgroundApp"))
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
            .padding(24)
            .background(backgroundColor)
            .cornerRadius(6)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            .frame(minWidth:200, maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
            .padding(.bottom, 16)
            
            
            
        }
}

func formatDurationSleep(_ interval: TimeInterval) -> String {
    let hours = Int(interval / 3600)
    let minutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
    return "\(hours)h \(minutes)m"
}




//#Preview {
//    SleepDuration()
//}
