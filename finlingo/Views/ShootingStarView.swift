import SwiftUI

struct ShootingStarsView: View {
    @State private var stars: [ShootingStar] = []
    @Environment(\.scenePhase) private var scenePhase
    @State private var lastUpdateTime: Date = Date()

    // This is the color from your SplashView text
    var starColor: Color = Color(red: 1.0, green: 0.905, blue: 0.619)

    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation) { timelineContext in
                Canvas { context, size in
                    for star in stars {
                        var path = Path()
                        path.move(to: star.position)
                        
                        // Draw the tail *behind* the star, based on its velocity
                        let tailPosition = CGPoint(
                            x: star.position.x - star.velocity.width * 0.4, // Longer tail
                            y: star.position.y - star.velocity.height * 0.4
                        )
                        path.addLine(to: tailPosition)
                        
                        // Apply a blur/glow effect
                        context.addFilter(.blur(radius: 2.0))
                        
                        context.stroke(path,
                                       with: .color(starColor.opacity(star.opacity)),
                                       style: StrokeStyle(lineWidth: 6, lineCap: .round) // Much thicker line
                        )
                    }
                }
                .onChange(of: timelineContext.date) { _, newDate in
                    updateStars(at: newDate, screenSize: geo.size)
                }
            }
            .ignoresSafeArea()
            .task {
                // This loop adds/removes stars
                while true {
                    if scenePhase == .active {
                        addStar(in: geo.size)
                    }
                    
                    // Spawn much more frequently
                    try? await Task.sleep(for: .seconds(Double.random(in: 0.2...0.6)))
                    
                    removeOldStars(in: geo.size)
                }
            }
        }
    }

    private func updateStars(at newDate: Date, screenSize: CGSize) {
        let deltaTime = newDate.timeIntervalSince(lastUpdateTime)
        
        for i in stars.indices {
            stars[i].position.x += stars[i].velocity.width * deltaTime
            stars[i].position.y += stars[i].velocity.height * deltaTime
            stars[i].opacity -= 0.4 * deltaTime // Slower fade out
        }
        
        self.lastUpdateTime = newDate
    }
    
    private func addStar(in size: CGSize) {
        let y = CGFloat.random(in: 80...size.height - 100)
        stars.append(ShootingStar(
            position: CGPoint(x: -80, y: y), // Start further off-screen
            velocity: CGSize(width: 800, height: 250), // Much faster
            opacity: 1.0
        ))
    }

    private func removeOldStars(in size: CGSize) {
        stars.removeAll { $0.isOffScreen(screenWidth: size.width) || $0.opacity <= 0 }
    }
}

private struct ShootingStar: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGSize
    var opacity: Double

    func isOffScreen(screenWidth: CGFloat) -> Bool {
        position.x > screenWidth + 100
    }
}
