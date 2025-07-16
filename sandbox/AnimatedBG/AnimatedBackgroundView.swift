import SwiftUI

struct AnimatedBackgroundView: View {
    @State private var offsets: [CGSize] = .init(repeating: .zero, count: 3)
    
    private let colorOpacity = 0.8
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width * 0.7
            ZStack {
                Circle()
                    .fill(.cyan.opacity(colorOpacity))
                    .offset(offsets[0])
                    .frame(width: width)
                    .blendMode(.screen)
                
                Circle()
                    .fill(.yellow.opacity(colorOpacity))
                    .offset(offsets[1])
                    .frame(width: width)
                    .blendMode(.screen)
                
                Circle()
                    .fill(.pink.opacity(colorOpacity))
                    .offset(offsets[2])
                    .frame(width: width)
                    .blendMode(.screen)
            }
            .position(
                x: proxy.size.width / 2,
                y: proxy.size.height / 2
            )
            .task {
                for index in offsets.indices {
                    animateCircles(at: index, in: proxy.size)
                }
            }
        }
    }
    
    private func animateCircles(at index: Int, in size: CGSize, movingSpeed speed: CGFloat = 20) {
        let destination: CGSize = .randomEdgePoint(
            maxX: size.height * 0.4,
            maxY: size.height * 0.4
        )
        let current = offsets[index]
        let distance = hypot(
            destination.width - current.width,
            destination.height - current.height
        )
        let travelTime = Double(distance / speed)
        
        withAnimation(.linear(duration: travelTime)) {
            offsets[index] = destination
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + travelTime) {
            animateCircles(at: index, in: size)
        }
    }
}


struct CardView: View {
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                
                AnimatedBackgroundView()
                    .ignoresSafeArea()
                
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center) {
                        Text("Swift Testing")
                            .font(Font.system(.title).smallCaps())
                            .bold()
                    }
                    
                    Text("Swift Testing has a clear and expressive API built using macros, so you can declare complex behaviors with a small amount of code. The #expect API uses Swift expressions and operators, and captures the evaluated values so you can quickly understand what went wrong when a test fails. Parameterized tests help you run the same test over a sequence of values so you can write less code. And all tests integrate seamlessly with Swift Concurrency and run in parallel by default.")
                        .font(.callout.smallCaps())
                        .monospaced()
                    
                }
                .padding()
                
            }
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        }
    }
}

private extension CGSize {
    
    static func randomEdgePoint(maxX: CGFloat, maxY: CGFloat) -> Self {
        switch Int.random(in: 0..<4) {
        case 0:
            return .init(width: .random(in: -maxX...maxX), height: -maxY)
        case 1:
            return .init(width: .random(in: -maxX...maxX), height:  maxY)
        case 2:
            return .init(width: -maxX, height: .random(in: -maxY...maxY))
        default:
            return .init(width:  maxX, height: .random(in: -maxY...maxY))
        }
    }
}

#Preview {
    ZStack(alignment: .center) {
        Color.black
            .ignoresSafeArea()
        
        CardView()
            .frame(width: .infinity, height: UIScreen.main.bounds.height / 3)
    }
}
