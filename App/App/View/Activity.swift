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
            VStack(alignment: .leading ) {
                VStack{
                    if showHeader {
                        headerView // Ekstrak header ke komponen terpisah
                    }
                }
                .padding(.bottom,20)
                VStack(alignment:.leading) {
                    ForEach(Array(healthKitViewModel.activities.enumerated()), id: \.element.startDate) { index, activity in
                        // Tampilkan header tanggal hanya jika ini aktivitas pertama atau tanggal berbeda dengan sebelumnya
                        if index == 0 || !Calendar.current.isDate(healthKitViewModel.activities[index-1].startDate, inSameDayAs: activity.startDate) {
                            HStack {
                                Text(activity.startDate.formatted(.dateTime.weekday(.wide)))
                                    .padding(.horizontal)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Spacer()
                                Text(activity.startDate.formatted(.dateTime.day().month(.wide)))
                                    .padding(.horizontal)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, index == 0 ? 0 : 16) // Kurangi padding atas untuk item pertama
                        }
                        
                        // Tampilkan card aktivitas
                        Button(action: {
                            router.navigate(to: .secondProfile(activity))
                        }) {
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
                                            .font(.caption2)
                                            .padding(.top, 10)
                                            .padding(.leading, -8)
                                    }
                                    VStack {
                                        Image(systemName: "arrow.right")
                                    }
                                }
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
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
    private var headerView: some View {
           ZStack(alignment: .bottomLeading) {
               Image("Image")
                   .scaledToFill()
                   .frame(width: UIScreen.main.bounds.width, height: 300)
                   .clipped()
                   .ignoresSafeArea(edges: .top)
                   .offset(y: 10)
               
               VStack {
                   Text("Your Run Activity")
                       .font(.largeTitle)
                       .fontWeight(.bold)
                       .foregroundColor(.orange)
                   
                   Text("Last 7 Days")
                       .font(.title3)
                       .fontWeight(.bold)
                       .foregroundColor(.orange)
               }
               .frame(maxWidth: .infinity, alignment: .center)
               .padding(.horizontal)
               .padding(.bottom, 50)
           }
           .frame(height: 50)
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
