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
    @State private var isRunning = false
    @State private var tick: Int = 0
    
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
            TimelineView(.animation) { timeline in
                ZStack {
                    Color.clear.ignoresSafeArea()
                    
                    ForEach(stars.indices, id: \.self) { index in
                        let star = stars[index]
                        
                        // Main shooting star (icon)
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: star.size, height: star.size)
                            .position(star.position)
                            .rotationEffect(.degrees(Double(star.angle)))
                            .foregroundColor(Color(red: 1.0, green: 0.905, blue: 0.619))  // Star color
                        
                        // Light trail (small dots following the shooting star)
                        ForEach(star.trail.indices, id: \.self) { trailIndex in
                            let trailPoint = star.trail[trailIndex]
                            
                            Circle()
                                .fill(Color.white.opacity(0.7))  // Higher opacity for better visibility
                                .frame(width: star.size / 2.5, height: star.size / 2.5)  // Larger trail dots
                                .position(trailPoint)
                        }
                    }
                }
                .onAppear {
                    isRunning = true
                }
                .onDisappear {
                    isRunning = false
                }
                .onChange(of: timeline.date) { _ in
                    guard isRunning else { return }
                    
                    tick += 1
                    
                    // Occasionally generate a new shooting star (every ~10 ticks, about 1 second)
                    if tick % 10 == 0 {
                        generateShootingStar(in: geometry)
                    }
                    
                    // Update stars positions and trails
                    for index in stars.indices {
                        var star = stars[index]
                        
                        // Move star position based on angle and speed (distance per tick)
                        // Calculate distance per tick to match duration roughly
                        let totalDistance: CGFloat = 500
                        let steps = star.duration / 0.1
                        let distancePerTick = totalDistance / CGFloat(steps)
                        
                        let newX = star.position.x + CGFloat(cos(star.angle)) * distancePerTick
                        let newY = star.position.y + CGFloat(sin(star.angle)) * distancePerTick
                        
                        let newPosition = CGPoint(x: newX, y: newY)
                        star.position = newPosition
                        
                        // Append new trail point
                        star.trail.append(newPosition)
                        
                        // Limit trail length
                        if star.trail.count > 20 {
                            star.trail.removeFirst()
                        }
                        
                        stars[index] = star
                    }
                }
            }
        }
    }
}
