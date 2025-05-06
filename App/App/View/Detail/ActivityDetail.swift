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
    @State private var currentValue = 0.0
    var body: some View {
        ScrollView{
            VStack() {
                ZStack(alignment: .topLeading){
                    Rectangle()
                        .fill(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: 170)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    
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
                    .frame(maxWidth: .infinity, maxHeight: 170)
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
                            .shadow(radius: 5)
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
                            .shadow(radius: 5)
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
                            .shadow(radius: 5)
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
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            ForEach(activity.zoneDurations, id: \.zone) { activity in
                                VStack{
                                    VStack{
                                        if activity.zone < 1 {
                                            Text("Not in Zone")
                                                .foregroundColor(.black)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                        }
                                        else{
                                            Text("Zone \(activity.zone)")
                                                .foregroundColor(.black)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    
                                    HStack{
                                        Text("< \(activity.lowerBound) - \(activity.upperBound)")
                                        Spacer()
                                        
                                        Text("\(formatTimeIntervalToText(activity.duration))")
                                            .foregroundColor(.black)
                                        
                                    }
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    
                                    VStack() {
                                        switch activity.zone {
//                                            currentValue=activity.averageHeartRate
                                        case 0:
                                            UISliderView(value: $currentValue,
                                                         minValue: Double(activity.lowerBound),
                                                         maxValue: Double(activity.upperBound),
                                                         thumbColor: .clear,
                                                         minTrackColor: .orange,
                                                         maxTrackColor: .clear)
                                            .frame(maxWidth: .infinity)
                                        case 1:
                                            UISliderView(value: $currentValue,
                                                         minValue: Double(activity.lowerBound),
                                                         maxValue: Double(activity.upperBound),
                                                         thumbColor: .clear,
                                                         minTrackColor: .systemPink,
                                                         maxTrackColor: .clear)
                                            .frame(maxWidth: .infinity)
                                        case 2:
                                            UISliderView(value: $currentValue,
                                                         minValue: Double(activity.lowerBound),
                                                         maxValue: Double(activity.upperBound),
                                                         thumbColor: .clear,
                                                         minTrackColor: .blue,
                                                         maxTrackColor: .clear)
                                            .frame(maxWidth: .infinity)
                                        case 3:
                                            UISliderView(value: $currentValue,
                                                         minValue: Double(activity.lowerBound),
                                                         maxValue: Double(activity.upperBound),
                                                         thumbColor: .clear,
                                                         minTrackColor: .green,
                                                         maxTrackColor: .clear)
                                            .frame(maxWidth: .infinity)
                                        case 4:
                                            UISliderView(value: $currentValue,
                                                         minValue: Double(activity.lowerBound),
                                                         maxValue: Double(activity.upperBound),
                                                         thumbColor: .clear,
                                                         minTrackColor: .orange,
                                                         maxTrackColor: .clear)
                                            .frame(maxWidth: .infinity)
                                        case 5:
                                            UISliderView(value: $currentValue,
                                                         minValue: Double(activity.lowerBound),
                                                         maxValue: Double(activity.upperBound),
                                                         thumbColor: .clear,
                                                         minTrackColor: .red,
                                                         maxTrackColor: .clear)
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
    //}
    struct UISliderView: UIViewRepresentable {
        @Binding var value: Double
        
        var minValue = 1.0
        var maxValue = 100.0
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
