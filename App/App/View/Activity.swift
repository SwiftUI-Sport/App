//
//  Profile.swift
//  App
//
//  Created by Ali An Nuur on 24/04/25.
//

import SwiftUI

struct ActivityView: View {
    
    @StateObject private var router = ActivityFlowRouter()
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel

    var body: some View {
        NavigationStack(path: $router.navPaths) {
            mainView
                .navigationDestination(for: ActivityFlow.self) { destination in
                    destination.destinationView
                        .navigationTitle(destination.title)
                        .toolbarRole(.automatic)
                }
        }
        .environmentObject(router)
    }
    
    
    private var mainView: some View {
        VStack(alignment:.leading) {
            ForEach(healthKitViewModel.activities, id: \.startDate) { activity in
                
                Text(activity.startDate.formatted(.dateTime.weekday(.wide)))
                    .padding()
                    .font(.title)
                
                Button(action:{
                    router.navigate(to: .secondProfile(activity))
                }) {
                    VStack{
                        
                        HStack{
                            VStack (alignment:.leading){
                                Text(activity.name)
                                    .font(.headline)
                                Text("\(formatDuration(activity.duration))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            HStack{
                                Text("\(Int(activity.averageHeartRate))")
                                    .fontWeight(.bold)
                                    .font(.title)
                                Text("Bpm")
                                    .foregroundColor(.redTint)
                                    .fontWeight(.semibold)
                                    .font(.caption2)  .padding(.top,10)
                                        .padding(.leading,-8)
                                    
                                
                            }
                            
                            VStack{
                                Image(systemName: "arrow.right")
                            }
                        }
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth:.infinity,alignment: .leading)
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius:5)
                }
                .padding(.top,10)
                .padding(.horizontal)
            }
            
            Spacer()
        }
//        .padding()
        .navigationTitle("7-Day Run Activity")
        .navigationBarTitleDisplayMode(.large)
    }
}

func formatDuration(_ seconds: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    
    if seconds >= 3600 {
        formatter.allowedUnits = [.hour, .minute, .second]
    } else {
        formatter.allowedUnits = [.hour, .minute, .second]
    }
    
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad
    
    return formatter.string(from: seconds) ?? "00:00"
}

#Preview {
    ActivityView()
}
