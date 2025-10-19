import SwiftUI

struct MercuryOuterView: View {
    // Typewriter
    @State private var animatedText = ""
    private let fullText = "Mercury"
    private let typingSpeed = 0.1

    // Floating animation
    @State private var float = false

    // Presentation state
    @State private var showDetailView = false

    // Styling
    private let gold = Color(red: 1.0, green: 0.905, blue: 0.619)

    var body: some View {
        ZStack {
            // Background
            Image("simple_night_sky")
                .resizable()
                .scaledToFill()
                .brightness(-0.12)
                .contrast(1.18)
                .overlay(Rectangle().fill(Color.orange.opacity(0.12)).blendMode(.color))
                .overlay(Rectangle().fill(Color.white.opacity(0.12)).blendMode(.screen))
                .overlay(Rectangle().fill(Color.black.opacity(0.08)).blendMode(.multiply))
                .brightness(0.02)
                .ignoresSafeArea()

            // Outer content
            VStack(spacing: 50) {
                Spacer()

                Text(animatedText)
                    .font(.custom("StarlightRune", size: 120))
                    .foregroundColor(gold)
                    .padding(.top, -100)
                    .shadow(color: .black.opacity(0.6), radius: 4, x: 0, y: 2)
                    .multilineTextAlignment(.center)
                    .onAppear { typewrite() }

                if !showDetailView {
                    Image("mercury_planet")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .offset(y: float ? -10 : 10)
                        .shadow(color: .black.opacity(0.4), radius: 25, x: 0, y: 12)
                        .animation(.easeInOut(duration: 1.69).repeatForever(autoreverses: true), value: float)
                        .onAppear { float = true }
                        .onTapGesture {
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.88)) {
                                showDetailView = true
                            }
                        }
                        .accessibilityLabel("Open Mercury details")
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Inner overlay (NO planet here)
            if showDetailView {
                MercuryInnerView(showDetailView: $showDetailView)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.98)),
                        removal: .opacity
                    ))
                    .zIndex(1)
            }

            // Always-on-top close button when inner is shown
            if showDetailView {
                Button {
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.9)) {
                        showDetailView = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.5), radius: 6, x: 0, y: 2)
                        .padding(.all, 18)
                        .background(Color.black.opacity(0.001)) // keeps tap area generous
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .padding(.top, 10)
                .padding(.trailing, 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .zIndex(2) // make sure it’s above everything
                .allowsHitTesting(true)
                .accessibilityLabel("Close")
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func typewrite() {
        animatedText = ""
        for (i, ch) in fullText.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * typingSpeed) {
                animatedText.append(ch)
            }
        }
    }
}

#Preview { MercuryOuterView() }
