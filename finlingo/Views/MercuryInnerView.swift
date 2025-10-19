import SwiftUI

struct MercuryInnerView: View {
    @Binding var showDetailView: Bool

    @State private var animatedText = ""
    private let fullText = "Mercury"
    private let typingSpeed = 0.1

    var body: some View {
        ZStack(alignment: .topLeading){
            // Background (your style)
            Image("mercury_background_2")
                .resizable()
                .brightness(-0.15)
                .contrast(1.18)
                .overlay(Rectangle().fill(Color.orange.opacity(0.12)).blendMode(.color))
                .overlay(Rectangle().fill(Color.white.opacity(0.12)).blendMode(.screen))
                .overlay(Rectangle().fill(Color.black.opacity(0.08)).blendMode(.multiply))
//                .blur(radius: 2)
                .ignoresSafeArea()

            // Content (no planet)
            // Typewriter text
            Text(animatedText)
                .font(.custom("StarlightRune", size: 60))
//                .foregroundColor(Color(red: 1.0, green: 0.905, blue: 0.619))
                .foregroundColor(.white)
                .kerning(3)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .padding(.leading, 55)
                .padding(.top, 50)
                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 1)
                .onAppear { animateText() }

//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .padding(.top, 80)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func animateText() {
        animatedText = ""
        for (i, ch) in fullText.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * typingSpeed) {
                animatedText.append(ch)
            }
        }
    }
}

// Preview helper
#Preview {
    MercuryInnerView(showDetailView: .constant(true))
}
