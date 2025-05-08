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
    @State private var showHeader = true

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
        ScrollView{
            if healthKitViewModel.activities.isEmpty {
                VStack(spacing: 16) {
                    VStack{
                        if showHeader {
                            headerView // Ekstrak header ke komponen terpisah
                        }
                    }
                    .padding(.bottom,20)
                    
                    VStack(alignment: .center){
                        Image("ImgEmpty")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.gray)
                        Text("No Activity Data")
                            .font(.title.bold())
                            .foregroundColor(.orangeTint)
                        
                        Text("Looks like we don’t have enough info yet. Keep your Health data synced, and we’ll start giving smart recommendations soon!")
                            .font(.caption)
//                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.top,100)
                }
            } else {
                VStack(alignment: .leading ) {
                    VStack{
                        if showHeader {
                            headerView // Ekstrak header ke komponen terpisah
                        }
                    }
                    .padding(.bottom,20)
                    VStack(alignment:.leading) {
                        ForEach(Array(healthKitViewModel.activities.enumerated()), id: \.element.startDate) { index, activity in
                            if index == 0 || !Calendar.current.isDate(healthKitViewModel.activities[index-1].startDate, inSameDayAs: activity.startDate) {
                                HStack {
                                    Text(activity.startDate.formatted(.dateTime.weekday(.wide)))
                                        .padding(.horizontal)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text(activity.startDate.formatted(.dateTime.day().month(.wide)))
                                        .padding(.horizontal)
                                        .font(.subheadline)
                                        .fontWeight(.light)
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, index == 0 ? 0 : 16)
                            }
                            
                            // Tampilkan card aktivitas
                            Button(action: {
                                router.navigate(to: .secondProfile(activity))
                            }) {
                                if(activity.name == "Running"){
                                    VStack {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(activity.name)
                                                    .font(.headline)
                                                Text("\(formatDuration(activity.duration))")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                            HStack {
                                                Text("\(Int(activity.averageHeartRate))")
                                                    .fontWeight(.bold)
                                                    .font(.title)
                                                Text("Bpm")
                                                    .foregroundColor(.redTint)
                                                    .fontWeight(.semibold)
                                                    .font(.caption)
                                                    .padding(.top, 10)
                                                    .padding(.leading, -8)
                                            }
                                            VStack {
                                                Image(systemName: "arrow.right")
                                            }
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(20)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color("ATLBar/cardShadow").opacity(0.5), radius: 4, x: 3, y: 1)
                                }
                            }
                            .padding(.top, 5)
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                    .padding(.top,70)
                    .navigationBarTitleDisplayMode(.large)
                    //                .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
    private var headerView: some View {
               ZStack(alignment: .bottomLeading) {
                   Image("Image")
                       .resizable()
                       .scaledToFit()
                       .frame(width: UIScreen.main.bounds.width, height: 300)
                       .clipped()
                       .ignoresSafeArea(edges: .top)
                       .offset(y: -10)
                   
                   VStack {
                       Text("Your Run Activity")
                           . font(.system(.largeTitle, design: .rounded))
                           .fontWeight(.bold)
                           .foregroundColor(Color("primary_1"))
                       
                       Text("Last 7 Days")
                           . font(.system(.largeTitle, design: .rounded))
                           .fontWeight(.bold)
                           .foregroundColor(Color("primary_1"))
                   }
                   .frame(maxWidth: .infinity, alignment: .center)
                   .padding(.horizontal)
                   .padding(.bottom, 60)
               }
               .frame(height: 100)
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
