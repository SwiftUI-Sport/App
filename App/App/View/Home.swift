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
    @State private var selectedHeader: HeaderContent? = nil
    
    var sampleReasons = [
        Reason(
            title:     "Training Load",
            headline:  "Your Training Load Was High",
            message:   "Based on your TRIMP score, your last session was intense. Your body likely needs more recovery time.",
            iconName:  "figure.run",
            color:     Color("primary_2")
        ),
        Reason(
            title:     "Training Load",
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
        .onAppear {
            // Just trigger loading data
            healthKitViewModel.loadAllData()
            healthKitViewModel.loadHeartRateVariability()
            healthKitViewModel.loadHeartRate()
            healthKitViewModel.loadRestingHeartRateDaily()
            healthKitViewModel.loadPast7DaysWorkoutTSR()
            healthKitViewModel.loadSleepData()

            // Set initial header based on current data
            updateSelectedHeader()
        }
        .onChange(of: healthKitViewModel.stressHistory42Days) { _, _ in
            // Update when data changes
            updateSelectedHeader()
            healthKitViewModel.loadPast7DaysWorkoutTSR()

        }
    }
    
    private func updateSelectedHeader() {
        if let lastDay = healthKitViewModel.stressHistory42Days.last, healthKitViewModel.loadAge() > 0 {
            let percentage = logScalePercentage(value: lastDay.todayATL)
            
            if percentage >= 66 {
                selectedHeader = sampleHeader[2] // Need rest
            } else if percentage >= 33 {
                selectedHeader = sampleHeader[1] // Bit tired
            } else {
                selectedHeader = sampleHeader[0] // Can run
            }
        } else {
            selectedHeader = sampleHeader[3] // No data
        }
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
                
                if healthKitViewModel.loadAge() <= 0{
                    VStack(spacing: 0) {
                        ZStack(alignment: .top){
                            BottomRoundedRectangle(radius: 50)
                                .fill(Color("home_bg_color"))
                                .frame(maxWidth: .infinity, maxHeight: 320)
                            VStack(spacing: 10){
                                HStack(alignment: .top) {
                                    EmptyHeaderSectionView(
                                        title:    sampleHeader[3].title,
                                        message:  sampleHeader[3].message,
                                        iconName:  sampleHeader[3].iconName
                                    )
                                    .padding(.top, 10)
                                    
                                }
                                
                                EmptyFatigueCard(
                                    trainingStressOfTheDay:
                                        TrainingStressOfTheDay.emptyDefaultValue()
                                )
                                .padding(.horizontal)
                                .padding(.top, 15)
                                //                            .offset(y: -50)
                                
                            }
                        }
                        
                        VStack(alignment: .center){
                            Empty_authorized_view()
                        }
                        .frame(height: 500)
                        
                        
                        
                    }
                    .background(Color("backgroundApp"))
                }
                else {
                    VStack(spacing: 0) {
                        ZStack(alignment: .top){
                            Color("backgroundApp")
                            Image("rech")
                                .resizable()
                                .scaledToFit()
                            VStack(spacing: 0){
                                
                                
                                    HeaderSectionView(
                                        trainingStressOfTheDay: healthKitViewModel.stressHistory42Days.isEmpty
                                        ? TrainingStressOfTheDay.defaultValue()
                                        : healthKitViewModel.stressHistory42Days.last ?? TrainingStressOfTheDay.defaultValue(),
                                        title:  selectedHeader?.title ?? sampleHeader[1].title,
                                        message:  selectedHeader?.message ?? sampleHeader[1].message,
                                        iconName: selectedHeader?.iconName ?? sampleHeader[1].iconName
//                                        title:  sampleHeader[1].title,
//                                        message:  sampleHeader[1].message,
//                                        iconName: sampleHeader[1].iconName
                                    )
                                
                                
                                .padding(.top, 30)
                            }
                            
                        }
//                        
                        HeresWhySection(reasons: sampleReasons)
//
                            
                            
                        }
                        .background(Color("backgroundApp"))
                    }
                    
                }
            }
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
    var trainingStressOfTheDay: TrainingStressOfTheDay
    let title: String
    let message: String
    let iconName: String
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            Text(title)
                . font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(Color("primary_1"))
                .padding(.bottom, 25)
            
            FatigueCard(
                trainingStressOfTheDay: trainingStressOfTheDay,
                message: message,
                iconName: iconName
            )
            
        }
        .padding(.horizontal)
    }
}

struct HeresWhySection: View {
    let reasons: [Reason]
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    @EnvironmentObject var router: HomeFlowRouter
    @EnvironmentObject var HealthKitViewModel: HealthKitViewModel
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Your Level of Fatigue Is Calculated With")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Button {
                    // navigate here
                    router.navigate(to: .second )
                } label : {
//                    
//                    var trainingLoadHeadline: String {
//                        let data = healthKitViewModel.past7DaysWorkoutTSR
//                        let last3 = data.suffix(3)
//                        let allLast3Zero = last3.allSatisfy { $0.value == 0 }
//                        let lastNonZero = data.last(where: { $0.value > 0 })
//                        let status = trainingLoadStatus(lastTrainingLoad: allLast3Zero ? nil : Int(lastNonZero?.value ?? 0))
//
//                        switch status {
//                        case "Hard":
//                            return "Your Training Load Is Quite High"
//                        case "Normal":
//                            return "You Trained Just Enough Last Session"
//                        default:
//                            return "Training Load Data Missing"
//                        }
//                    }
                    
                    HomeCardComponent(title: "Training Load",
                                      headline: trainingLoadHeadline,
                                      data: healthKitViewModel.past7DaysWorkoutTSR,
                                      mainColor: Color("primary_2"),
                                      unit: "TRIMP",
                                      icon: "figure.run"
                    )

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
//                    var restingHRHeadline: String {
//                        let data = healthKitViewModel.restingHeartRateDailyv2
//                        let last3 = data.suffix(3)
//                        let allLast3Zero = last3.allSatisfy { $0.value == 0 }
//                        let lastNonZero = data.last(where: { $0.value > 0 })
//                        
//                        let currentHR = allLast3Zero ? nil : Int(lastNonZero?.value ?? 0)
//                        let avgHR = healthKitViewModel.overallRestingHR
//
//                        let status = restingHeartRateStatus(currentHR: currentHR, avgHR: avgHR)
//
//                        switch status {
//                        case "Normal":
//                            return "Your Resting Heart Rate Is Within a Healthy Range"
//                        case "Slightly High":
//                            return "Your Resting Heart Rate Is Slightly Elevated"
//                        case "High":
//                            return "Your Elevated Resting Heart Rate May Signal Fatigue"
//                        default:
//                            return "Your Resting Heart Rate Is Within a Healthy Range"
//                        }
//                    }
                    
                    
                    HomeCardComponent(title: "Resting Heart Rate",
                                      headline: restingHRHeadline(),
                                      data: healthKitViewModel.restingHeartRateDailyv2,
                                      mainColor: Color("primary_1")
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                
                Button {
                    // navigate here
                    router.navigate(to: .third )
                } label : {
                    
                    SleepCardComponent(title: "Sleep Duration",
                                      headline: sleepHeadlineStatus(),
                                      mainColor: Color("primary_3")
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal)

                
                Spacer()
            }
        }
    }
    
    private func restingHRHeadline() -> String {
        let data = healthKitViewModel.restingHeartRateDailyv2
        let lastNonZero = data.last(where: { $0.value > 0 })
        
        let currentHR = lastNonZero?.value ?? 0
        let avgHR = healthKitViewModel.overallRestingHR
        
        let status = restingHeartRateStatus(currentHR: currentHR > 0 ? currentHR : nil, avgHR: avgHR)
        
        switch status {
        case "Normal":
            return "Your Resting Heart Rate Is Within a Healthy Range"
        case "Slightly High":
            return "Your Resting Heart Rate Is Slightly Elevated"
        case "High":
            return "Your Elevated Resting Heart Rate May Signal Fatigue"
        case "Low":
            return "Your Resting Heart Rate Is Lower Than Average"
        case "No Data":
            return "No Resting Heart Rate Data Available"
        default:
            return "Your Resting Heart Rate Status Is Unknown"
        }
    }

    private func restingHeartRateStatus(currentHR: Int?, avgHR: Double?) -> String {
        guard let current = currentHR, current > 0,
              let avgHR = avgHR, avgHR > 0 else {
            return "No Data"
        }

        let avg = Int(avgHR)
        
        if current >= avg - 10 && current <= avg + 10 {
            return "Normal"
        } else if current > avg + 10 && current <= avg + 20 {
            return "Slightly High"
        } else if current > avg + 20 {
            return "High"
        } else {
            return "Low"
        }
    }
    
    private var trainingLoadHeadline: String {
        let data = healthKitViewModel.past7DaysWorkoutTSR
        let lastNonZero = data.last(where: { $0.value > 0 })
        let lastValue = lastNonZero?.value ?? 0
        
        let status = trainingLoadStatus(lastTrainingLoad: lastValue > 0 ? lastValue : nil)
        
        switch status {
        case "Hard":
            return "Your Training Load Is Quite High"
        case "Normal":
            return "You Trained Just Enough Last Session"
        case "Light":
            return "Your Training Load Is Light"
        case "Rest":
            return "No Recent Training Load Detected"
        default:
            return "No Training Load Data Available"
        }
    }
    
    func sleepHeadlineStatus() -> String {
        // Check if we have any sleep data
        guard !healthKitViewModel.sleepDuration.isEmpty else {
            return "No Sleep Data Available"
        }
        
        // Sort sleep data by date (newest first) and get the latest entry
        let latestSleep = healthKitViewModel.sleepDuration.sorted { $0.day > $1.day }.first
        
        // Calculate the average sleep duration from all available data
        let totalSleepHours = healthKitViewModel.sleepDuration.reduce(0) { $0 + $1.asleepDuration / 3600 }
        let avgSleepHours = healthKitViewModel.sleepDuration.isEmpty ? 0 :
                             totalSleepHours / Double(healthKitViewModel.sleepDuration.count)
        
        // Get the latest sleep duration in hours
        guard let latestSleep = latestSleep else {
            return "Sleep Data Incomplete"
        }
        let latestSleepHours = latestSleep.asleepDuration / 3600
        
        // Determine sleep status based on latest sleep compared to recommended guidelines
        // Adult recommendation is generally 7-9 hours
        let status = sleepStatus(currentSleepHours: latestSleepHours, avgSleepHours: avgSleepHours)
        
        switch status {
        case "Good":
            return "You Got Enough Sleep Last Night"
        case "Moderate":
            return "Your Sleep Duration Was Slightly Below Ideal"
        case "Poor":
            return "You Didn't Get Enough Sleep Last Night"
        default:
            return "Sleep Data Not Available"
        }
    }

    func sleepStatus(currentSleepHours: Double, avgSleepHours: Double) -> String {
        // Guidelines suggest 7-9 hours for adults
        let recommendedMin = 7.0
        let recommendedMax = 9.0
        
        if currentSleepHours >= recommendedMin {
            return "Good"
        } else if currentSleepHours >= recommendedMin - 1.5 {
            return "Moderate"
        } else {
            return "Poor"
        }
        
        // Alternative approach using personal average as baseline
        // If you want to compare to the person's own average instead:
        /*
        let percentDiff = (currentSleepHours - avgSleepHours) / avgSleepHours * 100
        
        if percentDiff >= -5 {
            return "Good"
        } else if percentDiff >= -15 {
            return "Moderate"
        } else {
            return "Poor"
        }
        */
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

struct EmptyHeaderSectionView: View {
    let title: String
    let message: String
    let iconName: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack( spacing: 0) {
                VStack(alignment: .center) {
                    Text("Today's Overview")
                        .padding(.top, 3)
                        .padding(.bottom, 8)
                        .font(.subheadline)
                        .foregroundColor(Color.black.opacity(0.7))
                        .fontWeight(.bold)
                    
                    Text(title)
                        . font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color("primary_1"))
                    
                }
                Spacer()
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                
            }
            Text(message)
                .font(.callout)
                .foregroundColor(Color("headerMessage"))
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal)
    }
}

struct EmptyFatigueCard: View {
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

