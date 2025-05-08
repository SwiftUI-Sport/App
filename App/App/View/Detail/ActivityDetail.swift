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
    @EnvironmentObject var HealthKitViewModel: HealthKitViewModel
    @State private var showingSheet = false
    @State private var currentValue = 0.0
    var body: some View {
        ScrollView{
            VStack() {
                ZStack(alignment: .topLeading){
                    Rectangle()
                        .fill(Color.white)
                        .frame(width:.infinity, height: 150)
                        .cornerRadius(10)
                        .shadow(color: Color(.black).opacity(0.2), radius: 4, x: 3, y: 1)
                    
                    VStack() {
                        HStack (alignment:.firstTextBaseline){
                            Image(systemName: "heart.circle.fill")
                                .foregroundColor(.orangeTint)
                                .font(.title3)
                            Text("Average Heart Rate")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        HStack() {
                            Text("\(Int(activity.averageHeartRate))")
                                .fontWeight(.bold)
                                .font(.largeTitle)
                            Text("Bpm")
                                .foregroundColor(.redTint)
                                .fontWeight(.semibold)
                                .font(.caption)
                                .padding(.top, 10)
                                .padding(.leading,-5)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        Spacer()
                    }
                    .padding()
                    .frame(width:.infinity, height: 150)
                    .foregroundColor(.black)
//                    .padding()
                    Spacer()
                }
                
                HStack(){
                    ZStack{
                        Rectangle()
                            .fill(Color.white)
                            .frame(width:.infinity, height: 150)
                            .cornerRadius(10)
                            .padding(.trailing,5)
                            .shadow(color: Color(.black).opacity(0.2), radius: 4, x: 3, y: 1)
                        VStack(alignment:.leading){
                            HStack{
                                Image(systemName: "map.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.orangeTint)
                                Text("Distance")
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            Spacer()
                            HStack{
                                Text("\(formatDistance(activity.distance))")
                                    .foregroundColor(.black)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Text("KM")
                                    .foregroundColor(.gray)
                                    .fontWeight(.semibold)
                                    .font(.caption)
                                    .padding(.top, 10)
                                    .padding(.leading,-5)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
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
                            .shadow(color: Color(.black).opacity(0.2), radius: 4, x: 3, y: 1)
                        VStack(alignment:.leading){
                            HStack{
                                Image(systemName: "timer.circle.fill")
                                    .foregroundColor(.orangeTint)
                                    .font(.title3)
                                Text("Duration")
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            Spacer()
                            Text("\(formatDuration(activity.duration))")
                                .foregroundColor(.black)
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .center)
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
                            .frame(maxWidth: .infinity, maxHeight: 600)
                            .cornerRadius(10)
                            .shadow(color: Color(.black).opacity(0.2), radius: 4, x: 3, y: 1)
                        VStack(alignment:.leading){
                            HStack{
                                Image(systemName: "heart.text.square.fill")
                                    .font(.title3)
                                    .foregroundColor(.orangeTint)
                                Text("Heart Rate Training Zone")
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Button(action: {
                                    showingSheet = true
                                }) {
                                    Label("", systemImage: "info.circle")
                                        .foregroundColor(.orangeTint)
                                }
                                .sheet(isPresented: $showingSheet) {
                                    // Your sheet content view
                                    VStack(alignment:.leading) {
                                        Text("Heart Rate Zones")
                                            .font(.title)
                                            .fontWeight(.bold)
                                        
                                        Text("Heart rate zones below are calculated based on your maximum HR \(Int(HealthKitViewModel.repository.userMaxHR)) bpm and resting HR \(Int(HealthKitViewModel.repository.userRestingHR)) bpm")
                                            .multilineTextAlignment(.leading)
                                            .padding(.top)
                                            .padding(.horizontal)
                                        
                                        ForEach(activity.zoneDurations, id: \.zone) { activity1 in
                                            let zoneInt = Int(activity1.zone) ?? 0

                                            ZoneCard(
                                                title: title(for: zoneInt),
                                                description: description(for: zoneInt),
                                                accentColor: color(for: zoneInt)
                                            )
                                        }


                                       
                                        
                                        
                                    }
                                    .padding()
                                    .presentationDetents([.large]) // Optional: Set sheet size
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            ForEach(activity.zoneDurations, id: \.zone) { activity1 in
                                VStack{
                                    VStack{
                                        if activity1.zone < 1 {
                                            Text("Not in Zone")
                                                .foregroundColor(.black)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                        }
                                        else{
                                            Text("Zone \(activity1.zone)")
                                                .foregroundColor(.black)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    
                                    HStack{
                                        if activity1.zone < 1{
                                            Text("<\(activity1.upperBound)")
                                            Spacer()
                                        }
                                        else{
                                            Text("< \(activity1.lowerBound) - \(activity1.upperBound)")
                                        }
                                        Spacer()
                                        
                                        if Int(activity1.duration) == 0 {
                                            Text("0 min 0 sec")
                                        }
                                        else{
                                            Text("\(formatTimeIntervalToText(activity1.duration))")
//                                                .foregroundColor(.black)
                                        }
                                        
                                    }
                                    .foregroundColor(.gray)
                                    .font(.caption)
//                                    Text("\(Int(activity.duration))")
//                                    Text("\(Int(activity1.duration))")
                                    VStack() {
                                       switch activity1.zone {
                                       case 0:
                                           UISliderView(
                                               value: Binding<Double>(
                                                   get: { Double(activity1.duration) },
                                                   set: { newValue in /* handle value change */ }
                                               ),
                                               minValue: 0.0,
                                               maxValue: Double(activity1.duration), // Changed from activity.duration to activity1.duration
                                               thumbColor: .clear,
                                               minTrackColor: .systemYellow,
                                               maxTrackColor: .gray
                                           )
                                           .frame(maxWidth: .infinity)
                                       case 1:
                                           UISliderView(
                                               value: Binding<Double>(
                                                   get: { Double(activity1.duration) },
                                                   set: { newValue in /* handle value change */ }
                                               ),
                                               minValue: 0.0,
                                               maxValue: Double(activity1.duration), // Changed from activity.duration to activity1.duration
                                               thumbColor: .clear,
                                               minTrackColor: .systemPink,
                                               maxTrackColor: .gray
                                           )
                                           .frame(maxWidth: .infinity)
                                       case 2:
                                           UISliderView(
                                               value: Binding<Double>(
                                                   get: { Double(activity1.duration) },
                                                   set: { newValue in /* handle value change */ }
                                               ),
                                               minValue: 0.0,
                                               maxValue: Double(activity1.duration), // Changed from activity.duration to activity1.duration
                                               thumbColor: .clear,
                                               minTrackColor: .systemBlue,
                                               maxTrackColor: .gray
                                           )
                                           .frame(maxWidth: .infinity)
                                       case 3:
                                           UISliderView(
                                               value: Binding<Double>(
                                                   get: { Double(activity1.duration) },
                                                   set: { newValue in /* handle value change */ }
                                               ),
                                               minValue: 0.0,
                                               maxValue: Double(activity1.duration), // Changed from activity.duration to activity1.duration
                                               thumbColor: .clear,
                                               minTrackColor: .systemGreen,
                                               maxTrackColor: .gray
                                           )
                                           .frame(maxWidth: .infinity)
                                       case 4:
                                           UISliderView(
                                               value: Binding<Double>(
                                                   get: { Double(activity1.duration) },
                                                   set: { newValue in /* handle value change */ }
                                               ),
                                               minValue: 0.0,
                                               maxValue: Double(activity1.duration), // Changed from activity.duration to activity1.duration
                                               thumbColor: .clear,
                                               minTrackColor: .systemOrange,
                                               maxTrackColor: .gray
                                           )
                                           .frame(maxWidth: .infinity)
                                       case 5:
                                           UISliderView(
                                               value: Binding<Double>(
                                                   get: { Double(activity1.duration) },
                                                   set: { newValue in /* handle value change */ }
                                               ),
                                               minValue: 0.0,
                                               maxValue: Double(activity1.duration), // Changed from activity.duration to activity1.duration
                                               thumbColor: .clear,
                                               minTrackColor: .systemRed,
                                               maxTrackColor: .gray
                                           )
                                           .frame(maxWidth: .infinity)
                                       default:
                                           Text("error")
                                       }
                                      
                                   }
                                    
                                }
                                .frame(maxWidth: .infinity, maxHeight: 600)
                                
                            }
                            
                        }
                        .padding()
                        
                        
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
        
    }
    func color(for zone: Int) -> Color {
        switch zone {
        case 0: return .gray
        case 1: return .green
        case 2: return .blue
        case 3: return .purple
        case 4: return .red
        case 5: return .orange
        default: return .black
        }
    }

    func title(for zone: Int) -> String {
        return zone < 1 ? "Zone \(zone)" : "Zone \(zone)"
    }

    func description(for zone: Int) -> String {
        switch zone {
        case 0:
            return "This is your heart rate at rest. It's generally considered to be below 50% of your maximum heart rate"
        case 1:
            return "50-60% of your maximum heart rate. This is a recovery zone and helps with building endurance."
        case 2:
            return "60-70% of your maximum heart rate. This zone is beneficial for improving overall fitness and fat burning."
        case 3:
            return "70-80% of your maximum heart rate. This zone helps improve aerobic capacity and is optimal for cardiovascular training."
        case 4:
            return "80-90% of your maximum heart rate. This zone helps improve speed and anaerobic capacity, and is considered a high-intensity zone."
        case 5:
            return "90-100% of your maximum heart rate. This zone is for short, high-intensity bursts and is often used for improving speed and power."
        default:
            return "Unknown zone. Please check your activity data."
        }
    }


    
    func formatTimeIntervalToText(_ interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        var parts: [String] = []
        if hours > 0 {
            parts.append("\(hours) jam")
        }
        if minutes > 0 {
            parts.append("\(minutes) min")
        }
        if seconds > 0 {
            parts.append("\(seconds) sec")
        }

        return parts.joined(separator: " ")
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
    

    struct ZoneCard: View {
        let title: String
        let description: String
        let accentColor: Color

        var body: some View {
            ZStack(alignment: .leading) {
                // Background accent bar
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .overlay(
                        Rectangle()
                            .fill(accentColor)
                            .frame(width: 4),
                        alignment: .leading
                    )
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)

                // Card content
                VStack(alignment: .leading ) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(accentColor)
                    Text(description)
                        .font(.footnote)
                        .foregroundColor(.primary)
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }


    //}
    struct UISliderView: UIViewRepresentable {
        @Binding var value: Double
        
        var minValue = 0.0
        var maxValue = 10000.0
        var thumbColor: UIColor = .white
        var minTrackColor: UIColor = .blue
        var maxTrackColor: UIColor = .lightGray
        
        class Coordinator: NSObject {
            var value: Binding<Double>
            
            init(value: Binding<Double>) {
                self.value = value
            }
            
            @objc func valueChanged(_ sender: UISlider) {
                self.value.wrappedValue = Double(sender.value)
            }
        }
        
        func makeCoordinator() -> UISliderView.Coordinator {
            Coordinator(value: $value)
        }
        
        func makeUIView(context: Context) -> UISlider {
            let slider = UISlider(frame: .zero)
            slider.thumbTintColor = thumbColor
            slider.minimumTrackTintColor = minTrackColor
            slider.maximumTrackTintColor = maxTrackColor
            slider.minimumValue = Float(minValue)
            slider.maximumValue = Float(maxValue)
            slider.value = Float(value)
            
            slider.addTarget(
                context.coordinator,
                action: #selector(Coordinator.valueChanged(_:)),
                for: .valueChanged
            )
            
            return slider
        }
        
        func updateUIView(_ uiView: UISlider, context: Context) {
            uiView.value = Float(value)
        }
    }
    
}
