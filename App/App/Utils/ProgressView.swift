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
    
    // This will store the animated value
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
            // Start with the current ATL value when the view appears
            animatedATL = atl
        }
        .onChange(of: atl) { _, newValue in
            // Animate to the new value whenever atl changes
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

//struct HeaderBlobView: View {
//    let subtitle: String
//    let title: String
//    let icon: Image
//    
//    var body: some View {
//        ZStack (alignment: .top) {
//            BlobHeaderShape()
//                .fill(Color(red: 1.0, green: 0.96, blue: 0.85))
//                .frame(height: 450)
//                .ignoresSafeArea(edges: .top)
//            
//            VStack(alignment: .leading, spacing: 15) {
//
//                Text(subtitle)
//                    .padding(.top, 50)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                
//                HStack(alignment: .top) {
//                    Text(title)
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(Color(red: 0.93, green: 0.38, blue: 0.33))
//                    
//                    Spacer()
//                    
//                    icon
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 80, height: 80)
//                }
//                .padding(.horizontal)
//                FatigueCard()
//                    .padding(.horizontal)
//            }
//        }
//    }
//}

struct Empty_authorized_view: View {
    var body: some View {
        VStack (spacing: 0){
            Image("empty_health")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.bottom, 20)
            
            Text("Connect to Health")
                . font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(Color("primary_1"))
                .padding(.bottom, 20)
            
            Text("Allow All Requirements !")
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Text("Runday uses your workout history, heart rate, and sleep data from Apple Health to give you the best recomendation")
                .font(.callout)
                .foregroundColor(.gray.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .frame(width: 270)
            
        }
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

struct FatigueCard: View {
    var trainingStressOfTheDay: TrainingStressOfTheDay
    var message: String
    var iconName: String
    @State private var showingInfoPopover = false
    
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
                        showingInfoPopover.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.gray)
                    }
                    .popover(isPresented: $showingInfoPopover, arrowEdge: .top) {
                        FatigueInfoPopover()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 18)
                .padding(.bottom, 18)
                
                ATLProgressView(atl: logScalePercentage(value: trainingStressOfTheDay.todayATL))

                Text(message)
                    .font(.callout)
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
            .offset(x: 0, y: 115)
            .onAppear {
                print("ATL: \(trainingStressOfTheDay.todayATL)")
            }
        }
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
            
            Text("Your fatigue level is calculated using your training load, heart rate data, and sleep quality.")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 8)
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
//#Preview {
//    FatigueCard()
//}
