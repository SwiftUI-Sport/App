//
//  ProfileDetail.swift
//  App
//
//  Created by Ali An Nuur on 24/04/25.
//

import SwiftUI

struct FirstActivityView: View {
    
    @EnvironmentObject var router: ActivityFlowRouter
    
    var body: some View {
        VStack {
//            Button("Go to Second Activity") {
//                router.navigate(to: .secondProfile)
//            }
        }
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SecondActivityView: View {
    @EnvironmentObject var router: ActivityFlowRouter
    let activity: WorkoutActivity
    var body: some View {
        VStack() {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .cornerRadius(10)
                
                VStack(alignment: .leading) {
                    HStack (alignment:.firstTextBaseline){
                        Image(systemName: "heart.circle.fill")
                            .foregroundColor(.orangeTint)
                        Text("Average Heart Rate")
                            .font(.title)
                    }
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(Int(activity.averageHeartRate))")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                        Text("Bpm")
                            .foregroundColor(.redTint)
                            .fontWeight(.semibold)
                            .font(.caption2)
                            .padding(.top, 10)
                    }
                }
                .foregroundColor(.black)
                .padding()
                Spacer()
            }
            
            HStack(){
                ZStack{
                    Rectangle()
                        .fill(Color.white)
                        .frame(width:.infinity, height: 150)
                        .cornerRadius(10)
                        .padding(.trailing,5)
                    VStack(alignment:.leading){
                        Text("Distance")
                            .foregroundColor(.black)
                            .font(.title3)
                        Spacer()
                        Text("\(formatDistance(activity.distance))")
                            .foregroundColor(.black)
                            .font(.largeTitle)
                        
                        Spacer()
                    }
                    .padding()
                    .frame(width:.infinity, height: 150)
                }
                .padding(.top)
                ZStack{
                    Rectangle()
                        .fill(Color.white)
                        .frame(width:.infinity, height: 150)
                        .cornerRadius(10)
                        .padding(.leading,5)
                    VStack(alignment:.leading){
                        Text("Duration")
                            .foregroundColor(.black)
                            .font(.title3)
                        Spacer()
                        Text("\(formatDuration(activity.duration))")
                            .foregroundColor(.black)
                            .font(.largeTitle)
                        Spacer()
                    }
                    .padding()
                    .frame(width:.infinity, height: 150)
                }
                .padding(.top)
                
                
            }
            VStack{
                ZStack{
                    Rectangle()
                        .fill(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .cornerRadius(10)
                    VStack(alignment:.leading){
                        ForEach(activity.zoneDurations, id: \.zone) { activity in
                            HStack{
                                Text("\(activity.zone)")
                                    .foregroundColor(.black)
                                Text("\(formatDuration(activity.duration))")
                                    .foregroundColor(.black)
                            }
                        }
//                        .padding()
                    }
                    
                }
                
                
                
                //            Button("Go to Activity") {
                //                router.navigateToRoot()
                //            }
                Spacer()
            }
            .padding(.top)
            
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func formatDistance(_ distance: Double?) -> String {
        guard let distance = distance else {
            return "0,0"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1  // Maksimal 1 digit desimal
        formatter.minimumFractionDigits = 1  // Minimal 1 digit desimal
        formatter.decimalSeparator = ","     // Menggunakan koma
        
        
        if let formattedString = formatter.string(from: NSNumber(value: distance)) {
            return formattedString
        }
        
        
        return String(format: "%.1f", distance).replacingOccurrences(of: ".", with: ",")
    }
    
    //#Preview {
    //    SecondActivityView()
    //}
}
