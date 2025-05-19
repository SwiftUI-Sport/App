//
//  Profile.swift
//  App
//
//  Created by Ali An Nuur on 24/04/25.
//

import SwiftUI

struct DailyActivitySummary: Identifiable {
    let id = UUID()
    let date: Date
    let activities: [WorkoutActivity]
    
    var hasRunningActivity: Bool {
        return !activities.isEmpty
    }
    
    var weekdayName: String {
        return date.formatted(.dateTime.weekday(.wide))
    }
    
    var dateString: String {
        return date.formatted(.dateTime.day().month(.wide))
    }
}


struct ActivityView: View {
    @StateObject private var router = ActivityFlowRouter()
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    @State private var showHeader = true
    @State private var dailySummaries: [DailyActivitySummary] = []
    
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
        .onAppear {
            generateDailySummaries()
        }
        .onChange(of: healthKitViewModel.activities) { _,_ in
            generateDailySummaries()
        }
    }
    
    private func generateDailySummaries() {
        let calendar = Calendar.current
        let today = Date()
        
        var summaries: [DailyActivitySummary] = []
        for dayOffset in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            
            let activitiesForDay = healthKitViewModel.activities.filter { activity in
                return activity.name == "Running" &&
                calendar.isDate(activity.startDate, inSameDayAs: date)
            }
            
            let summary = DailyActivitySummary(date: date, activities: activitiesForDay)
            summaries.append(summary)
        }
        
        dailySummaries = summaries.sorted { $0.date > $1.date }
    }
    
    private var mainView: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("home_bg_color"),
                    Color("home_bg_color"),
                    Color("home_bg_color"),
                    Color("home_bg_color"),
                    Color("backgroundApp"),
                    Color("backgroundApp"),
                    Color("backgroundApp"),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            ScrollView {
                VStack() {
                    ZStack(alignment: .top){
                        headerView
                    }
                    
                    if healthKitViewModel.activities.isEmpty {
                        VStack (alignment: .center) {
                            Empty_activity_view()
                                .padding(.top, 70)
                            Spacer()
                        }
                        .frame(height: 500)
                    }
                    else {
                        VStack(alignment: .center) {
                            ForEach(dailySummaries) { summary in
                                DaySummaryView(summary: summary, router: router)
                            }
                            Spacer()
                        }
                        .padding(.bottom, 20)
                        
                    }
                }
                .background(Color("backgroundApp"))
            }
        }
    }
    
    private var headerView: some View {
        ZStack(alignment: .bottomLeading) {
            Image("actv_head")
                .resizable()
                .scaledToFit()
                .clipped()
            
            VStack {
                Text("Running Activities in")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("primary_1"))
                
                Text("the Last 7 Days")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("primary_1"))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
            .padding(.bottom, 70)
        }
    }
}


struct DaySummaryView: View {
    let summary: DailyActivitySummary
    @ObservedObject var router: ActivityFlowRouter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(summary.weekdayName)
                    .padding(.horizontal)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text(summary.dateString)
                    .padding(.horizontal)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
            }
            .padding(.top, 16)
            
            if summary.hasRunningActivity {
                ForEach(summary.activities, id: \.startDate) { activity in
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
                                        .font(.caption)
                                        .padding(.top, 10)
                                        .padding(.leading, -8)
                                }
                                .padding(.trailing, 15)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .bold))
                            }
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(6)
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 5)
                    .padding(.horizontal)
                }
            } else {
                HStack {
                    Text("No running activity")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("-")
                        .fontWeight(.bold)
                }
                .padding(20)
                .background(Color.white.opacity(0.8))
                .cornerRadius(6)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                .padding(.top, 5)
                .padding(.horizontal)
            }
        }
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
