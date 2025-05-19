import SwiftUI

struct Reason: Identifiable {
    let id = UUID()
    let title: String
    let headline: String
    let message: String
    let iconName: String
    let color: Color
}

struct HeaderContent: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let iconName: String
}

struct ATLProgressView: View {
    let atl: Double
    let maxATL: Double = 100
    
    private let barHeight: CGFloat = 38
    private let handleSize: CGSize = CGSize(width: 18, height: 56)
    
    @State private var animatedATL: Double = 0
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let clamped = min(max(animatedATL, 0), maxATL)
            let fraction = maxATL > 0 ? clamped / maxATL : 0
            let xPos = fraction * width
            
            ZStack(alignment: .topLeading) {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color("ATLBar/leftBar"),Color("ATLBar/secondLeftBar"),Color("ATLBar/thirdLeftBar"), Color("ATLBar/centerBar"), Color("ATLBar/thirdRightBar") ,Color("ATLBar/secondRightBar"), Color("ATLBar/rightBar")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(height: barHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .shadow(color: Color("ATLBar/barShadow").opacity(50), radius: 4, x: 2, y: 2)
                    
                    HStack {
                        Image(systemName: "bolt.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding(.leading, 4)
                        Spacer()
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding(.trailing, 4)
                    }
                    .frame(height: barHeight)
                }
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
                    .frame(width: handleSize.width, height: handleSize.height)
                    .shadow(color: Color("ATLBar/thumbShadow").opacity(0.7), radius: 7, x: 0, y: 0)
                    .offset(
                        x: xPos - handleSize.width/2,
                        y: -(handleSize.height - barHeight)/2
                    )
                // Make sure the handle animates smoothly
                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: animatedATL)
            }
            .frame(height: handleSize.height)
        }
        .frame(height: handleSize.height)
        .padding(.horizontal)
        .onAppear {
            animatedATL = atl
        }
        .onChange(of: atl) { _, newValue in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                animatedATL = newValue
            }
        }
    }
}


#Preview {
    ATLProgressView(
        atl: 20
    )
}

struct BlobHeaderShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.86 ))
        
        path.addCurve(
            to: CGPoint(x: rect.width * 0.65 - 70, y: (rect.height + 30) * 0.65 + 50),
            control1: CGPoint(x: rect.width * 0.1, y: rect.height + 20),
            control2: CGPoint(x: rect.width * 0.5/2, y: rect.height * 0.9)
        )
        
        path.addCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.6),
            control1: CGPoint(x: rect.width * 0.99/1.5, y: rect.height  * 0.76),
            control2: CGPoint(x: rect.width * 0.9, y: rect.height * 0.9)
        )
        
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.closeSubpath()
        
        return path
    }
}
struct Empty_authorized_view: View {
    @State private var showingPermissionsHelp = false
    
    var body: some View {
        VStack (spacing: 0){
            Image("empty_health")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.bottom, 20)
            
            Text("Connect to Health")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(Color("primary_1"))
                .padding(.bottom, 20)
            
            HStack(spacing: 8) {
                Text("Allow All Requirements!")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Button(action: {
                    showingPermissionsHelp.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(Color("primary_1"))
                }
                .popover(isPresented: $showingPermissionsHelp, arrowEdge: .top) {
                    HealthPermissionsGuide()
                }
            }
            
            Text("Runday uses your workout history, heart rate, and sleep data from Apple Health to give you the best recomendation")
                .font(.callout)
                .foregroundColor(.gray.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .frame(width: 270)
                .padding(.vertical, 12)
            
        }
    }
    
}

struct HealthPermissionsGuide: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.4))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 8)
            Spacer()
            Text("How to Allow Health Permissions")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 16) {
                PermissionStep(
                    number: "1",
                    title: "Open Settings App",
                    description: "Tap the Open Settings button below",
                    imageName: "gear",
                    isSystemImage: true
                )
                
                PermissionStep(
                    number: "2",
                    title: "Go to Health App",
                    description: "Scroll down and tap on the Health app",
                    imageName: "heart.fill",
                    isSystemImage: true
                )
                
                PermissionStep(
                    number: "3",
                    title: "Data Access & Devices",
                    description: "Tap on Data Access & Devices",
                    imageName: "arrow.up.right.square.fill",
                    isSystemImage: true
                )
                
                PermissionStep(
                    number: "4",
                    title: "Select Runday",
                    description: "Find and tap on Runday in the apps list",
                    imageName: "app.badge.fill",
                    isSystemImage: true
                )
                
                PermissionStep(
                    number: "5",
                    title: "Enable All Categories",
                    description: "Toggle ON all categories to allow full access",
                    imageName: "checkmark.circle.fill",
                    isSystemImage: true
                )
            }
            
            Divider()
                .padding(.vertical, 8)
            
            Text("These permissions allow Runday to access your health data to calculate your fatigue level and recommend appropriate workouts")
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack {
                Spacer()
                Button(action: openAppSettings) {
                    HStack {
                        Image(systemName: "gear")
                        Text("Open Settings")
                            .fontWeight(.medium)
                    }
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .background(Color("primary_1"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.top, 12)
            Spacer()
        }
        .padding(.horizontal)
    }
    
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

struct PermissionStep: View {
    var number: String
    var title: String
    var description: String
    var imageName: String
    var isSystemImage: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color("primary_1"))
                    .frame(width: 28, height: 28)
                Text(number)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    if isSystemImage {
                        Image(systemName: imageName)
                            .font(.system(size: 18))
                            .foregroundColor(Color("primary_1"))
                            .frame(width: 24, height: 24)
                    } else {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    
                    Text(title)
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.semibold)
                }
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }
}

struct Empty_activity_view: View {
    var body: some View {
        VStack (spacing: 20){
            Image("empty_activity")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Text("No Activity Available")
                . font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(Color("primary_1"))
            
            Text("Looks like we don’t have enough info yet. Keep your Health data synced, and we’ll start giving smart recommendations soon!")
                .font(.callout)
                .foregroundColor(.gray.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .frame(width: 270)
        }
    }
}

#Preview {
    Empty_activity_view()
}

#Preview {
    Empty_authorized_view()
}

struct FatigueCardempty: View {
    var trainingStressOfTheDay: Double
    var message: String
    var iconName: String
    @State private var showingInfo = false
    
    var body: some View {
        ZStack{
            VStack(alignment: .center) {
                HStack {
                    Text("Level of Fatigue")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        showingInfo.toggle()
                    }) {
                        Image(systemName: "info.square.fill")
                            .font(.system(.title2, design: .rounded))
                            .foregroundColor(Color.gray)
                    }
                    .sheet(isPresented: $showingInfo) {
                        FatigueLevelSheet()                                   .presentationDetents([.height(600)])
                            .presentationDragIndicator(.hidden)
                            .interactiveDismissDisabled(false)
                    }
                    
                }
                .padding(.horizontal)
                .padding(.top, 18)
                .padding(.bottom, 38)
                
                FatigueProgressBarView(atl: trainingStressOfTheDay)
                //                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                Text(message)
                    .font(.system(.callout, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("headerMessage"))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                    .padding(.bottom, 18)
                
            }
            .background(Color.white)
            .cornerRadius(6)
            .shadow(color: Color("ATLBar/cardShadow").opacity(0.5), radius: 7, x: 3, y: 1)
            //            .offset(x: 0, y: 130)
        }
    }
}


struct FatigueCard: View {
    var trainingStressOfTheDay: TrainingStressOfTheDay
    var message: String
    var iconName: String
    @State private var showingInfo = false
    
    var body: some View {
        ZStack{
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 230, height: 230)
                .padding(.leading, 32)
            VStack(alignment: .center) {
                HStack {
                    Text("Level of Fatigue")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        showingInfo.toggle()
                    }) {
                        Image(systemName: "info.square.fill")
                            .font(.system(.title2, design: .rounded))
                            .foregroundColor(Color.gray)
                    }
                    .sheet(isPresented: $showingInfo) {
                        FatigueLevelSheet()                                   .presentationDetents([.height(600)])
                            .presentationDragIndicator(.hidden)
                            .interactiveDismissDisabled(false)
                    }
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                .padding(.top, 18)
                .padding(.bottom, 18)
                
                FatigueProgressBarView(atl: logScalePercentage(value: trainingStressOfTheDay.todayATL))
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                Text(message)
                    .font(.system(.callout, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("headerMessage"))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                    .padding(.bottom, 18)
                
            }
            .background(Color.white)
            .cornerRadius(6)
            .shadow(color: Color("ATLBar/cardShadow").opacity(0.5), radius: 7, x: 3, y: 1)
            .offset(x: 0, y: 120)
        }
    }
}

struct FatigueLevelSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Garis horisontal di atas
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.4))
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                Text("Fatigue Level")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 30, height: 30)
                        Image(systemName: "xmark")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 15, weight: .bold))
                    }
                }
                .buttonStyle(.plain)
            }
            
            VStack(alignment: .leading){
                Text("Your Fatigue Level is calculated based on your training load over the past 7 days.")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                    .padding(.bottom, 6)
                
                Text("This metric reflects how much physical stress your body has accumulated recently. A higher fatigue level may indicate the need for recovery, while a lower level suggests you're well-rested and ready for more intense activity. Balancing fatigue with proper rest helps prevent injury and supports consistent performance improvement.")
                    .font(.body)
                    .padding(.bottom, 8)
                
                HStack(alignment: .firstTextBaseline){
                    Image(systemName: "exclamationmark.icloud.fill")
                        .font(.headline)
                        .foregroundColor(Color("primary_1"))
                    Text("Disclaimer")
                        .font(.title3.bold())
                        .foregroundColor(Color("primary_1"))
                }
                .padding(.bottom, 4)
                
                Text("This recommendation should not be used as the sole basis for your training decisions. Always listen to your body and adjust accordingly. If you’re experiencing unusual discomfort, pain, or health concerns, consult a medical professional for proper guidance.")
                    .font(.body)
                
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
        }
        .padding(.horizontal)
    }
}

struct FatigueInfoPopover: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About Fatigue Level")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 12) {
                FatigueInfoRow(
                    color: Color("ATLBar/leftBar"),
                    title: "Low Fatigue (0-33%)",
                    description: "Your body is well-rested and ready for training. Perfect time for a challenging workout."
                )
                
                FatigueInfoRow(
                    color: Color("ATLBar/centerBar"),
                    title: "Moderate Fatigue (34-66%)",
                    description: "Some accumulated fatigue. Consider a moderate workout or active recovery."
                )
                
                FatigueInfoRow(
                    color: Color("ATLBar/rightBar"),
                    title: "High Fatigue (67-100%)",
                    description: "Your body needs recovery. Rest or very light activity recommended."
                )
            }
            
            Divider()
                .padding(.vertical, 8)
            
            Text("Your fatigue level is calculated using your training load, heart rate data, and sleep quality.")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: 300)
    }
}

struct FatigueInfoRow: View {
    var color: Color
    var title: String
    var description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
                .padding(.top, 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

/// Custom handle view: bubble persen + image di bawahnya
struct ATLHandleView: View {
    let percent: Int
    let icon: Image
    let bubbleColor: Color = Color("primary_1")
    
    var body: some View {
        ZStack {
            
            Image("tear")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 50, maxHeight: 50)
            
            Text("\(percent)%")
                .font(.system( .caption2, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 15)
                .background(bubbleColor)
                .cornerRadius(8)
                .padding(.bottom, 8)
            
        }
    }
}


struct FatigueProgressBarView: View {
    let atl: Double
    private let barHeight: CGFloat = 38
    var body: some View {
        ZStack(alignment: .center){
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("ATLBar/thumbBorder"))
                .frame(maxHeight: barHeight + 15)
            
            ATLProgressBarView(atl: atl, barHeight: barHeight)
        }
        .padding(.horizontal)
        
    }
}

struct ATLProgressBarView: View {
    let atl: Double
    let maxATL: Double = 100.0
    let barHeight: CGFloat
    
    @State private var animatedATL: Double = 0
    
    var body: some View {
        GeometryReader { geo in
            let width      = geo.size.width
            let clamped    = min(max(animatedATL, 0), maxATL)
            let fraction   = maxATL > 0 ? clamped / maxATL : 0
            
            let barPadding = CGFloat(9)
            let usableWidth = width - barPadding
            let xPos = barPadding + usableWidth * fraction
            
            ZStack(alignment: .topLeading) {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [
                        Color("ATLBar/leftBar"),
                        Color("ATLBar/secondLeftBar"),
                        Color("ATLBar/thirdLeftBar"),
                        Color("ATLBar/centerBar"),
                        Color("ATLBar/thirdRightBar"),
                        Color("ATLBar/secondRightBar"),
                        Color("ATLBar/rightBar")
                    ]), startPoint: .leading, endPoint: .trailing)
                    .frame(height: barHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    HStack {
                        Image(systemName: "bolt.circle.fill")
                            .font(.system(.title))
                            .foregroundColor(.white)
                            .padding(.leading, 2)
                        Spacer()
                        
                    }
                    .frame(height: barHeight)
                }
                
                ATLHandleView(
                    percent: Int(clamped / maxATL * 100),
                    icon: Image(systemName: "bolt.fill")
                )
                .offset(
                    x: xPos - 30,
                    y: -(57 - barHeight/2)
                )
                
                .animation(.spring(response: 0.6, dampingFraction: 0.7),
                           value: animatedATL)
            }
            .frame(height: barHeight)
        }
        .frame(height: barHeight)
        .padding(.horizontal,8)
        .onAppear {
            animatedATL = atl
        }
        .onChange(of: atl) { _, newValue in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                animatedATL = newValue
            }
        }
    }
}

#Preview {
    FatigueProgressBarView(
        atl: 0
    )
}
