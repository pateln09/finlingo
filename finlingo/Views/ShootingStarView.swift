import SwiftUI

struct ShootingStarView: View {
    struct ShootingStar: Equatable {
        var position: CGPoint
        var size: CGFloat
        var angle: CGFloat
        var duration: Double
        var trail: [CGPoint] = []  // Store trail positions

        // Make ShootingStar equatable by comparing positions
        static func ==(lhs: ShootingStar, rhs: ShootingStar) -> Bool {
            return lhs.position == rhs.position
        }
    }
    
    @State private var stars: [ShootingStar] = []
    @State private var timer: Timer? = nil
    
    func generateShootingStar(in geometry: GeometryProxy) {
        let size: CGFloat = CGFloat.random(in: 10...20)  // Larger stars for better visibility
        let xPosition = CGFloat.random(in: 0...geometry.size.width)
        let yPosition = CGFloat.random(in: 0...(geometry.size.height / 2))
        
        let angle: CGFloat = CGFloat.random(in: -0.5...0.5)
        let duration = Double.random(in: 3.0...6.0)  // Slower speed for longer trails
        
        let star = ShootingStar(position: CGPoint(x: xPosition, y: yPosition), size: size, angle: angle, duration: duration)
        
        stars.append(star)
        
        // After a duration, remove the star
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if let index = stars.firstIndex(where: { $0.position == star.position }) {
                stars.remove(at: index)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear.ignoresSafeArea()
                
                // Create the shooting stars with a more noticeable light trail
                ForEach(stars.indices, id: \.self) { index in
                    let star = stars[index]
                    
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: star.size, height: star.size)
                        .position(star.position)
                        .rotationEffect(.degrees(Double(star.angle)))
                        .offset(x: star.position.x, y: star.position.y)
                        .foregroundColor(Color(red: 1.0, green: 0.905, blue: 0.619))  // Set star color here
                        .animation(.linear(duration: star.duration).repeatForever(autoreverses: false), value: star.position)
                        .onAppear {
                            let newPosition = CGPoint(x: star.position.x + CGFloat(cos(star.angle) * 500), y: star.position.y + CGFloat(sin(star.angle) * 500))
                            
                            withAnimation {
                                stars[index].position = newPosition
                            }
                        }
                    
                    // More noticeable light trail (larger and brighter fading dots)
                    ForEach(star.trail.indices, id: \.self) { trailIndex in
                        let trailPoint = star.trail[trailIndex]
                        
                        Circle()
                            .fill(Color.white.opacity(0.7))  // Higher opacity for better visibility
                            .frame(width: star.size / 2.5, height: star.size / 2.5)  // Larger trail dots
                            .position(trailPoint)
                            .animation(.easeOut(duration: 1.0).delay(Double(trailIndex) * 0.1), value: trailPoint)
                    }
                }
                
            }
            .onAppear {
                timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    generateShootingStar(in: geometry)
                }
            }
            .onDisappear {
                timer?.invalidate()
            }
            .onChange(of: stars) { _ in
                // Update the trail for each star
                for index in stars.indices {
                    var updatedStar = stars[index]
                    // Add new trail point near the shooting star's position
                    updatedStar.trail.append(updatedStar.position)
                    
                    // Limit the number of trail points to avoid excess
                    if updatedStar.trail.count > 20 {  // Increased trail length
                        updatedStar.trail.removeFirst()
                    }
                    
                    stars[index] = updatedStar
                }
            }
        }
    }
}

