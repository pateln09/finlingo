import SwiftUI

struct HomeView: View {
    @State private var animatedText = ""
    private let fullText = "Welcome back, Neel!"
    private let typingSpeed = 0.1  // seconds per character

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                // Background image and effects
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

                // Typewriter text
                Text(animatedText)
                    .font(.custom("StarlightRune", size: 50))
                    .foregroundColor(Color(red: 1.0, green: 0.905, blue: 0.619))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .padding(.leading, 35)
                    .padding(.top, 50)
                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 1)
                    .onAppear {
                        animateText()
                    }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private func animateText() {
        animatedText = ""
        for (index, char) in fullText.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * typingSpeed) {
                animatedText.append(char)
            }
        }
    }
}

#Preview {
    HomeView()
}
