import SwiftUI

struct SplashView: View {
    @State private var animate = false
    @State private var showMainView = false

    // Typewriter
    @State private var animatedText = ""
    private let fullText = "Finlingo."
    private let typingSpeed = 0.1
    private let typingStartDelay = 0.4
    private let postTypingPause = 0.35

    // Zoom anchor + dot alignment
    @State private var anchor = UnitPoint(x: 0.435, y: 0.443)
    @State private var dotOffsetX: CGFloat = 0
    @State private var dotOffsetY: CGFloat = 0

    // Cross-dissolve duration
    private let crossFadeDuration = 0.25

    var body: some View {
        ZStack {
            // Background (shared)
            Image("splashscreen_background")
                .resizable()
                .scaledToFill()
                .brightness(-0.12)
                .contrast(1.18)
                .overlay(Rectangle().fill(Color.orange.opacity(0.12)).blendMode(.color))
                .overlay(Rectangle().fill(Color.white.opacity(0.12)).blendMode(.screen))
                .overlay(Rectangle().fill(Color.black.opacity(0.08)).blendMode(.multiply))
                .brightness(0.02)
                .ignoresSafeArea()
            
            ShootingStarView()

            // Splash layer
            Text(animatedText)
                .font(.custom("StarlightRune", size: 120))
                .foregroundColor(Color(red: 1.0, green: 0.905, blue: 0.619))
                .kerning(3)
                .scaleEffect(animate ? 25 : 1, anchor: anchor)
                .opacity(showMainView ? 0 : 1) // fades OUT
                .zIndex(1)
                .allowsHitTesting(!showMainView)

            // Main layer — LAZY mount so HomeView appears *after* splash
            if showMainView {
                MainView()
                    .transition(.opacity) // fade IN when it mounts
                    .zIndex(0)
            }
        }
        // Drives the opacity transition of the Main layer
        .animation(.easeInOut(duration: crossFadeDuration), value: showMainView)
        .onAppear { runSequence() }
    }

    private func runSequence() {
        // 1) Typewriter
        animatedText = ""
        let totalTypingTime = typingStartDelay + Double(fullText.count) * typingSpeed
        DispatchQueue.main.asyncAfter(deadline: .now() + typingStartDelay) {
            for (i, ch) in fullText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * typingSpeed) {
                    animatedText.append(ch)
                }
            }
        }

        // 2) Zoom + cross dissolve trigger
        DispatchQueue.main.asyncAfter(deadline: .now() + totalTypingTime + postTypingPause) {
            withAnimation(.easeIn(duration: 1.3)) {
                animate = true
            }
            // Flip the flag to *create* MainView (and thus HomeView) slightly before zoom ends
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                showMainView = true
            }
        }
    }
}
