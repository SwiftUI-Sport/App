import SwiftUI

struct Reason: Identifiable {
    let id = UUID()
    let title: String
    let headline: String
    let message: String
    let iconName: String
    let color: Color
}

struct ATLProgressView: View {
    let atl: Double
    let maxATL: Double = 200
    
    private let barHeight: CGFloat = 38
    private let handleSize: CGSize = CGSize(width: 18, height: 56)
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let clamped = min(max(atl, 0), maxATL)
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
            }
            .frame(height: handleSize.height)
        }
        .frame(height: handleSize.height)
        .padding(.horizontal)
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
