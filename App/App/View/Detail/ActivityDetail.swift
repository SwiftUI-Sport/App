//
//  ActivityDetail.swift
//  App
//
//  Created by Ali An Nuur on 24/04/25.
//

import SwiftUI

struct FirstActivityView: View {
    @EnvironmentObject var router: ActivityFlowRouter
    
    var body: some View {
        VStack {
            // Empty view
        }
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SecondActivityView: View {
    @EnvironmentObject var router: ActivityFlowRouter
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    
    @Environment(\.dismiss) private var dismiss

    
    let activity: WorkoutActivity
    
    @State private var showingSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Heart Rate Card
                heartRateCard
                
                // MARK: - Stats Row
                HStack(spacing: 10) {
                    distanceCard
                    durationCard
                }
                
                // MARK: - Heart Rate Zones
                heartRateZonesCard
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(Color("backgroundApp").ignoresSafeArea())
    }
    
    // MARK: - UI Components
    
    private var heartRateCard: some View {
        CardView(height: 150) {
            VStack {
                HStack(alignment: .center) {
                    ZStack {
                        Circle()
                            .fill(Color("primary_1").opacity(0.2))
                            .frame(width: 30, height: 30)
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color("primary_1"))
                            .font(.system(.subheadline, weight: .medium))
                    }
                    
                    Text("Average Heart Rate")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                HStack {
                    Text("\(Int(activity.averageHeartRate))")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                    Text("Bpm")
                        .foregroundColor(.redTint)
                        .fontWeight(.semibold)
                        .font(.footnote)
                        .padding(.top, 10)
                        .padding(.leading, -5)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            }
            .foregroundColor(.black)
        }
    }
    
    private var distanceCard: some View {
        CardView(height: 150) {
            VStack(alignment: .leading) {
                HStack (alignment: .center) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 30, height: 30)
                        Image(systemName: "map.fill")
                            .foregroundColor(Color.green)
                            .font(.system(.subheadline, weight: .medium))
                    }
                    
                    Text("Distance")
                        .foregroundColor(.black)
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                HStack(alignment: .firstTextBaseline) {
                    Text(formatDistance(activity.distance))
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(activity.distance ?? 0.0 < 1000 ? "M" : "KM")
                        .foregroundColor(.gray)
                        .fontWeight(.semibold)
                        .font(.footnote)
                        .offset(y: -2)
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            }
        }
        .padding(.trailing, 5)
    }
    
    private var durationCard: some View {
        CardView(height: 150) {
            VStack(alignment: .leading) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.yellow.opacity(0.2))
                            .frame(width: 30, height: 30)
                        Image(systemName: "timer")
                            .foregroundColor(Color.yellow)
                            .font(.system(.subheadline, weight: .medium))
                    }
                    Text("Duration")
                        .foregroundColor(.black)
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                Text(formatDuration(activity.duration))
                    .foregroundColor(.black)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            }
        }
        .padding(.leading, 5)
    }
    
    private var heartRateZonesCard: some View {
        CardView(maxHeight: 600) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color("primary_1").opacity(0.2))
                            .frame(width: 30, height: 30)
                        Image(systemName: "heart.text.square.fill")
                            .foregroundColor(Color("primary_1"))
                            .font(.system(.subheadline, weight: .medium))
                    }
                    
                    Text("Heart Rate Training Zone")
                        .foregroundColor(.black)
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        showingSheet = true
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(.orangeTint)
                    }
                    .sheet(isPresented: $showingSheet) {
                        heartRateZonesInfoSheet
                    }
                }
                
                ForEach(activity.zoneDurations, id: \.zone) { zoneData in
                    zoneRow(for: zoneData)
                }
            }
        }
    }
    
    private var heartRateZonesInfoSheet: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                
                Capsule()
                    .frame(width: 40, height: 5)
                    .foregroundColor(.gray.opacity(0.4))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)
                
                HStack {
                    Text("Heart Rate Zones")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                        showingSheet = false
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 30, height: 30)
                            Image(systemName: "xmark")
                                .foregroundColor(Color.gray)
                                .font(.system(.subheadline, weight: .bold))
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 6)
                
                (
                    Text("Heart rate zones below are calculated based on your ")
                    + Text("maximum HR \(Int(healthKitViewModel.repository.userMaxHR)) bpm").bold()
                    + Text(" and ")
                    + Text("resting HR \(Int(healthKitViewModel.repository.userRestingHR)) bpm").bold()
                )
                .multilineTextAlignment(.leading)
                .padding(.top)
                
                ForEach(activity.zoneDurations, id: \.zone) { zoneData in
                    let zoneInt = Int(zoneData.zone)
                    
                    ZoneCard(
                        title: title(for: zoneInt),
                        description: description(for: zoneInt),
                        accentColor: color(for: zoneInt)
                    )
                    .padding(.bottom, 4)
                }
            }
            .padding(.horizontal)
            
        }
        .background(Color("backgroundApp"))
        .presentationDetents([.large])
    }
    
    private func zoneRow(for zoneData: WorkoutHeartRateZone) -> some View {
        VStack(spacing: 0) {
            // Zone title
            if zoneData.zone < 1 {
                Text("Zone 0")
                    .foregroundColor(.black)
                    .font(.system(.footnote, design: .rounded))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)
            } else {
                Text("Zone \(zoneData.zone)")
                    .foregroundColor(.black)
                    .font(.system(.footnote, design: .rounded))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)
            }
            
            HStack {
                if zoneData.zone < 1 {
                    Text("< \(zoneData.upperBound)")
                } else {
                    Text("< \(zoneData.lowerBound) - \(zoneData.upperBound)")
                }
                
                Spacer()
                
                if Int(zoneData.duration) == 0 {
                    Text("0 min 0 sec")
                } else {
                    Text(formatTimeIntervalToText(zoneData.duration))
                }
            }
            .foregroundColor(.gray)
            . font(.system(.footnote, design: .rounded))
            .padding(.bottom, 10)
            
            zoneSlider(for: zoneData)
                .padding(.bottom, 6)
        }
    }
    
    private func zoneSlider(for zoneData: WorkoutHeartRateZone) -> some View {
        
        let totalDuration = activity.zoneDurations.reduce(0) { $0 + $1.duration }
        
        let percentage = totalDuration > 0 ? (zoneData.duration / totalDuration) * 100 : 0
        
        let value = Binding<Double>(
            get: { percentage },
            set: { _ in /* No changes needed */ }
        )
        
        let trackColor: UIColor = {
            switch zoneData.zone {
            case 0: return UIColor.systemYellow.withAlphaComponent(0.2)
            case 1: return UIColor.systemPink.withAlphaComponent(0.2)
            case 2: return UIColor.systemBlue.withAlphaComponent(0.2)
            case 3: return UIColor.systemGreen.withAlphaComponent(0.2)
            case 4: return UIColor.systemOrange.withAlphaComponent(0.2)
            case 5: return UIColor.systemRed.withAlphaComponent(0.2)
            default: return UIColor.systemGray.withAlphaComponent(0.2)
            }
        }()
        
        let fillColor: UIColor = {
            switch zoneData.zone {
            case 0: return .systemYellow
            case 1: return .systemPink
            case 2: return .systemBlue
            case 3: return .systemGreen
            case 4: return .systemOrange
            case 5: return .systemRed
            default: return .systemGray
            }
        }()
        
        return UISliderView(
            value: value,
            minValue: 0.0,
            maxValue: 100.0,
            thumbColor: .clear,
            minTrackColor: fillColor,
            maxTrackColor: trackColor,
            height: 10
        )
        .frame(maxWidth: .infinity)
    }
    
    func color(for zone: Int) -> Color {
        switch zone {
        case 0: return .yellow
        case 1: return .pink
        case 2: return .blue
        case 3: return .green
        case 4: return .orange
        case 5: return .red
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
        
        let distanceInMeters = distance
        
        if distanceInMeters < 1000 {
            return "\(Int(distanceInMeters))"
        } else {
            let distanceInKm = distanceInMeters / 1000.0
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 1
            formatter.minimumFractionDigits = 1
            formatter.decimalSeparator = ","
            
            if let formattedString = formatter.string(from: NSNumber(value: distanceInKm)) {
                return formattedString
            }
            
            return String(format: "%.1f", distanceInKm).replacingOccurrences(of: ".", with: ",")
        }
    }
    
}

// MARK: - Supporting Views
struct CardView<Content: View>: View {
    let content: Content
    var height: CGFloat?
    var maxHeight: CGFloat?
    
    init(height: CGFloat? = nil, maxHeight: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.height = height
        self.maxHeight = maxHeight
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color.white)
                .frame(height: height)
                .frame(maxHeight: maxHeight)
                .cornerRadius(6)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            
            content
                .padding()
                .frame(height: height)
                .frame(maxHeight: maxHeight)
        }
    }
}

struct ZoneCard: View {
    let title: String
    let description: String
    let accentColor: Color
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background accent bar
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemBackground))
                .overlay(
                    Rectangle()
                        .fill(accentColor)
                        .frame(width: 4),
                    alignment: .leading
                )
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
            
            // Card content
            VStack(alignment: .leading) {
                Text(title)
                    . font(.system(.subheadline, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(accentColor)
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
            .padding()
        }
    }
}

struct UISliderView: UIViewRepresentable {
    @Binding var value: Double
    
    var minValue = 0.0
    var maxValue = 10000.0
    var thumbColor: UIColor = .white
    var minTrackColor: UIColor = .blue
    var maxTrackColor: UIColor = .lightGray
    var height: CGFloat = 6 // Default height
    
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
        let slider = CustomHeightSlider(frame: .zero)
        slider.trackHeight = height
        slider.thumbTintColor = thumbColor
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.minimumValue = Float(minValue)
        slider.maximumValue = Float(maxValue)
        slider.value = Float(value)
        slider.setThumbImage(UIImage(), for: .normal)
        
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
        if let customSlider = uiView as? CustomHeightSlider {
            customSlider.trackHeight = height
        }
    }
}

class CustomHeightSlider: UISlider {
    var trackHeight: CGFloat = 6
    private var trackLayer: CALayer?
    private var progressLayer: CALayer?
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Return a zero rect to hide the default track
        return CGRect(x: 0, y: 0, width: bounds.width, height: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCustomTrack()
    }
    
    private func updateCustomTrack() {
        trackLayer?.removeFromSuperlayer()
        progressLayer?.removeFromSuperlayer()
        
        let bounds = self.bounds
        let trackRect = CGRect(
            x: 0,
            y: (bounds.height - trackHeight) / 2,
            width: bounds.width,
            height: trackHeight
        )
        
        let trackLayer = CALayer()
        trackLayer.frame = trackRect
        trackLayer.backgroundColor = maximumTrackTintColor?.cgColor
        trackLayer.cornerRadius = trackHeight / 2
        self.layer.insertSublayer(trackLayer, at: 0)
        self.trackLayer = trackLayer
        
        let progressWidth = trackRect.width * CGFloat((value - minimumValue) / (maximumValue - minimumValue))
        let progressRect = CGRect(
            x: trackRect.minX,
            y: trackRect.minY,
            width: progressWidth,
            height: trackRect.height
        )
        
        let progressLayer = CALayer()
        progressLayer.frame = progressRect
        progressLayer.backgroundColor = minimumTrackTintColor?.cgColor
        progressLayer.cornerRadius = trackHeight / 2
        self.layer.insertSublayer(progressLayer, at: 1)
        self.progressLayer = progressLayer
    }
    
    override var value: Float {
        didSet {
            updateCustomTrack()
        }
    }
    
    override var minimumTrackTintColor: UIColor? {
        didSet {
            updateCustomTrack()
        }
    }
    
    override var maximumTrackTintColor: UIColor? {
        didSet {
            updateCustomTrack()
        }
    }
}
