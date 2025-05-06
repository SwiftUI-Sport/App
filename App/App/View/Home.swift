//
//  Home.swift
//  App
//
//  Created by Ali An Nuur on 24/04/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    @StateObject private var router = HomeFlowRouter()
    
    var sampleReasons = [
        Reason(
            title:     "Heart Rate",
            headline:  "Your Average Heart Rate is Higher",
            message:   "This means you need more rest",
            iconName:  "heart.fill",
            color: Color("primary_1")
        ),
        Reason(
            title:     "Workout",
            headline:  "You had 10 Minutes Longer Than Usual",
            message:   "This means you need more rest",
            iconName:  "figure.run",
            color:     Color("primary_2")
        ),
        Reason(
            title:     "Sleep Duration",
            headline:  "You Don’t Have Enough Sleep",
            message:   "This means you need more rest",
            iconName:  "moon.fill",
            color:     Color("primary_3")
        )
    ]
    
    var body: some View {
        NavigationStack(path: $router.navPaths) {
            mainView
                .navigationDestination(for: HomeFlow.self) { destination in
                    destination.destinationView
                        .navigationTitle(destination.title)
                        .toolbarRole(.automatic)
                }
        }
        .environmentObject(router)
        .onAppear {
            healthKitViewModel.start()
        }
    }
    
    private var mainView: some View {
        
        ScrollView {
            ZStack (alignment: .top) {
                LinearGradient(
                    gradient: Gradient(colors: [Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"),Color("backgroundApp"), Color("backgroundApp"), Color("home_bg_color"), Color("home_bg_color")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .padding(.top, 60)
                Image("home_backgr")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 35)
                VStack() {
                    VStack{
                        HStack(alignment: .top) {
                            HeaderSectionView(
                                subtitle: "Today’s Overview",
                                title:    "You Need Some Rest Today",
                                icon:     Image("chacha")
                            )
                            .padding(.top, 10)
                            
                        }
                        Spacer()
                        
                        FatigueCard(trainingStressOfTheDay: healthKitViewModel.stressHistory42Days.last ?? TrainingStressOfTheDay.defaultValue())
                            .padding(.horizontal)
                            .padding(.top, 10)
                        //                            .offset(y: -50)
                        
                        Spacer()
                        
                    }
                   
                    HeresWhySection(reasons: sampleReasons)
                        .padding(.top,40)
                    
                }
                
            }
        }
        .background(Color("home_bg_color"))
        
        
        //        VStack {
        //            Button("Go to first screen") {
        //                router.navigate(to: .first)
        //            }
        //            // test push
        //            //dksajdks
        //            Button("Print WORKOUT DATA") {
        //                healthKitViewModel.printActivities()
        //            }
        //            Button("Print STRESS") {
        //                healthKitViewModel.printStressHistories()
        //            }
        //        }
        //        .navigationTitle("Home")
        //        .navigationBarTitleDisplayMode(.large)
    }
}

struct HeaderSectionView: View {
    let subtitle: String
    let title: String
    let icon: Image
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            Text(subtitle)
                .padding(.top, 3)
                .font(.subheadline)
                .foregroundColor(Color.black.opacity(0.7))
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            HStack(alignment: .top) {
                Text(title)
                    . font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("primary_1"))
                
                Spacer()
                
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            }
            
        }
        .padding(.horizontal)
    }
}

struct FatigueCard: View {
    var trainingStressOfTheDay: TrainingStressOfTheDay
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Level of Fatigue")
                .padding(.horizontal)
                .padding(.top, 16)
                .font(.subheadline)
                .fontWeight(.bold   )
                .foregroundColor(.primary)
            
            ATLProgressView(atl : trainingStressOfTheDay.todayATL)
                .padding(.top, 18)
                .padding(.bottom, 15)
        }
        .frame(maxHeight: 122)
        .background(Color.white)
        .cornerRadius(6)
        .shadow(color: Color("ATLBar/cardShadow").opacity(0.5), radius: 7, x: 3, y: 1)
    }
}

struct HeresWhySection: View {
    let reasons: [Reason]
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Here’s Why")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                VStack(spacing: 19) {
                    ForEach(reasons) { r in
                        Button {
                            switch r.title {
                            case "Heart Rate":
                                print("🚑 Show heart rate detail")
                                // misal: navigate(to: .heartRateDetail)
                            case "Workout":
                                print("🏃‍♂️ Show workout detail")
                            case "Sleep Duration":
                                print("😴 Show sleep tips")
                            default:
                                break
                            }
                        } label: {
                            ReasonCard(reason: r)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }
                }
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
        }
    }
}

struct ReasonCard: View {
    let reason: Reason
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(reason.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(reason.color)
                Text(reason.headline)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(reason.message)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(reason.color.opacity(0.2))
                    .frame(width: 44, height: 44)
                Image(systemName: reason.iconName)
                    .foregroundColor(reason.color)
                    .font(.system(size: 20, weight: .medium))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(6)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
    }
}


#Preview {
    HomeView()
}
