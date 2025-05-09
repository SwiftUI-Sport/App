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
    @State private var selectedHeader : HeaderContent =         HeaderContent(
        title : "You Can Run Today",
        message: "Your body is well-rested and your recovery metrics look great. It’s a perfect day to hit the road and crush your run.",
        iconName:  "chacha"
    )
    
    var sampleReasons = [
        Reason(
            title:     "Training Load hard",
            headline:  "Your Training Load Was High",
            message:   "Based on your TRIMP score, your last session was intense. Your body likely needs more recovery time.",
            iconName:  "figure.run",
            color:     Color("primary_2")
        ),
        Reason(
            title:     "Training Load normal",
            headline:  "Your Training Load Was Slightly High",
            message:   "Your last session was a bit intense based on your TRIMP score. Consider how your body feels before deciding to run again.",
            iconName:  "figure.run",
            color:     Color("primary_2")
        ),
        Reason(
            title:     "Training Load",
            headline:  "You Trained Just Enough Last Session",
            message:   "Based on your TRIMP score, your last session wasn’t too intense. Your body has a time to recover properly.",
            iconName:  "figure.run",
            color:     Color("primary_2")
        ),
        
        
        Reason(
            title:     "Resting Heart Rate",
            headline:  "Your Resting Heart Rate Is Within Normal Range",
            message:   "Your resting heart rate looks great, indicating your body is well-recovered. You're all set for today's run.",
            iconName:  "heart.fill",
            color: Color("primary_1")
        ),
        Reason(
            title:     "Resting Heart Rate 2",
            headline:  "Your Average Heart Rate is Higher",
            message:   "Your resting heart rate is elevated, which may indicate fatigue or stress. Consider taking it easy today to let your body recover fully.",
            iconName:  "heart.fill",
            color: Color("primary_1")
        ),
        Reason(
            title:     "Resting Heart Rate 3",
            headline:  "Your Average Heart Rate is Higher",
            message:   "Your resting heart rate is elevated, which may indicate fatigue or stress. Consider taking it easy today to let your body recover fully.",
            iconName:  "heart.fill",
            color: Color("primary_1")
        ),
        
        
        Reason(
            title:     "Sleep Duration Enaugh",
            headline:  "You Don’t Have Enough Sleep",
            message:   "Your sleep duration was below your normal average, which could impact your energy and recovery. It might be best to rest or do a light workout today.",
            iconName:  "moon.fill",
            color:     Color("primary_3")
        ),
        Reason(
            title:     "Sleep Duration Not Enaught",
            headline:  "You Don’t Have Enough Sleep",
            message:   "Your sleep duration was below your normal average, which could impact your energy and recovery. It might be best to rest or do a light workout today.",
            iconName:  "moon.fill",
            color:     Color("primary_3")
        ),
        Reason(
            title:     "Sleep Duration",
            headline:  "You Don’t Have Enough Sleep",
            message:   "Your sleep duration was below your normal average, which could impact your energy and recovery. It might be best to rest or do a light workout today.",
            iconName:  "moon.fill",
            color:     Color("primary_3")
        )

    ]
    
    var sampleHeader = [
        HeaderContent(
            title : "You Can Run Today",
            message: "Your body is well-rested and your recovery metrics look great. It’s a perfect day to hit the road and crush your run.",
            iconName:  "chacha"
        ),
        HeaderContent(
            title : "You Seem a Little Bit Tired Today",
            message: "Your data shows minor signs of fatigue, but you're still in decent shape. A light or moderate run could be just right today.",
            iconName:  "chachatired"
        ),
        HeaderContent(
            title : "You Need Some Rest",
            message: "Your recovery signals suggest your body needs time to recharge. Take a break today to avoid burnout and come back stronger tomorrow.",
            iconName:  "chachasleep"
        ),
        HeaderContent(
            title : "No Data \nAvailable",
            message: "Looks like we don’t have enough info yet. Keep your Health data synced, and we’ll start giving smart recommendations soon!.",
            iconName:  "empty_logo"
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
       
    }
    
    private var mainView: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("home_bg_color"),
                    Color("home_bg_color"),
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
                        BottomRoundedRectangle(radius: 50)
                            .fill(Color("home_bg_color"))
                            .frame(maxWidth: .infinity, maxHeight: 320)
                        VStack(spacing: 10){
                            HStack(alignment: .top) {
                                HeaderSectionView(
                                    title:    selectedHeader.title,
                                    message:  selectedHeader.message,
                                    iconName:  selectedHeader.iconName
                                )
                                .padding(.top, 10)
                                
                            }
                            
                            FatigueCard(
                                trainingStressOfTheDay: healthKitViewModel.stressHistory42Days.isEmpty
                                ? TrainingStressOfTheDay.defaultValue()
                                : healthKitViewModel.stressHistory42Days.last ?? TrainingStressOfTheDay.defaultValue()
                            )
                            .padding(.horizontal)
                            .padding(.top, 15)
                            //                            .offset(y: -50)
                            
                        }
                    }
                    
                    if healthKitViewModel.loadAge() == 0{
                        empty_authorized_view()
                            .padding(.top, 70)
                    }
                    else {
                        HeresWhySection(reasons: sampleReasons)
                            .padding(.top,15)
                    }
                    
                    
                    
                }
                .background(Color("backgroundApp"))
                
            }
        }
        .onAppear {
            healthKitViewModel.loadAllData()
            print("\($healthKitViewModel.stressHistory42Days)")
            print("\(healthKitViewModel.stressHistory42Days)")
            if let atl = healthKitViewModel.stressHistory42Days.last?.todayATL {
                switch atl {
                case let x where x >= 150:
                    selectedHeader = sampleHeader[2]
                case let x where x >= 50 && x < 150:
                    selectedHeader = sampleHeader[1]
                case let x where x < 50:
                    selectedHeader = sampleHeader[0]
                default:
                    if healthKitViewModel.stressHistory42Days.isEmpty && healthKitViewModel.loadAge() == 0 {
                        
                        selectedHeader = sampleHeader[3]
                    }
                }
            } else if healthKitViewModel.stressHistory42Days.isEmpty && healthKitViewModel.loadAge() == 0 {
                selectedHeader = sampleHeader[3] // fallback when no ATL data
            }
            
            healthKitViewModel.loadHeartRateVariability()
            healthKitViewModel.loadRestingHeartRateDaily()
            healthKitViewModel.loadHeartRate()
        }
        
        
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

struct BottomRoundedRectangle: Shape {
    var radius: CGFloat = 40
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        path.addArc(
            center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
            radius: radius,
            startAngle: .zero,
            endAngle: .degrees(90),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addArc(
            center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
            radius: radius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        
        return path
    }
}


struct HeaderSectionView: View {
    let title: String
    let message: String
    let iconName: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Today's Overview")
                .padding(.top, 3)
                .padding(.bottom, 8)
                .font(.subheadline)
                .foregroundColor(Color.black.opacity(0.7))
                .fontWeight(.bold)
            
            HStack(alignment: .center) {
                Text(title)
                    . font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color("primary_1"))
                
                Spacer()
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
            }
            // nyoba //lagi
            Text(message)
                .font(.callout)
                .foregroundColor(Color("headerMessage"))
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 15)
            
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
                .font(.system(.subheadline, design: .rounded))
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
        .onAppear {
            print("ATL: \(trainingStressOfTheDay.todayATL)")
        }
    }
    
}

struct HeresWhySection: View {
    let reasons: [Reason]
    @EnvironmentObject var router: HomeFlowRouter
    @EnvironmentObject var HealthKitViewModel: HealthKitViewModel
    
    func heartRateStatus(currentHR: Int?, avgHR: Double?) -> Int {
        guard let current = currentHR, let avgHR = avgHR else {
            return 3 // or a custom "no data" message
        }

        let avg = Int(avgHR)

        if current >= avg - 10 && current <= avg + 10 {
            return 3
        } else if current > avg + 10 && current <= avg + 20 {
            return 4
        } else if current > avg + 20 {
            return 5
        } else {
            return 3
        }
    }
    
    func trainingLoadStatus(lastTrainingLoad: Int?) -> Int {
        guard let load = lastTrainingLoad else {
            return 1 // fallback for missing data
        }

        if load > 100 {
            return 0
        } else {
            return 1
        }
    }
    
    func SleepStatus(SleepAmount: Double?) -> Int {
        guard let sleepamount = SleepAmount else {
            return 1 // fallback for missing data
        }
 // 6 not enaught
        if sleepamount < 21600.0 {
            return 6 // not enaught sleep
        } else {
            return 7 // sleep
        }
    }
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .leading, spacing: 20) {
                Text("What Your Fatigue Level Is Based On")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Button {
                    // navigate here
                    router.navigate(to: .second )
                } label : {
                    ReasonCard(reason: reasons[trainingLoadStatus(lastTrainingLoad: HealthKitViewModel.past7DaysWorkoutTSR.last?.value)])
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                
                Text("Supporting Insight")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Button {
                    // navigate here
                    router.navigate(to: .first )
                } label : {
                    ReasonCard(reason: reasons[heartRateStatus(currentHR: HealthKitViewModel.HeartRateDailyv2.last?.value, avgHR: HealthKitViewModel.overallAverageHR)])
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                
                Button {
                    // navigate here
                    router.navigate(to: .third )
                } label : {
                    ReasonCard(reason: reasons[SleepStatus(SleepAmount:0 )])
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

struct ReasonCard: View {
    let reason: Reason
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack() {
                Text(reason.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(reason.color)
                
                ZStack {
                    Circle()
                        .fill(reason.color.opacity(0.2))
                        .frame(width: 20, height: 20)
                    Image(systemName: reason.iconName)
                        .foregroundColor(reason.color)
                        .font(.system(size: 10, weight: .medium))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .bold))
            }
            Text(reason.headline)
                .font(.headline)
                .lineLimit(2)
                .foregroundColor(.black)
            Text(reason.message)
                .font(.footnote)
                .foregroundColor(Color("headerMessage").opacity(0.8))
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(6)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
    }
}
