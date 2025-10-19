import SwiftUI

struct SplashView: View {
    @State private var animate = false
    @State private var showMainView = false
    @State private var anchor = UnitPoint(x: 0.435, y: 0.443)
    @State private var dotOffsetX: CGFloat = 0
    @State private var dotOffsetY: CGFloat = 0

    var body: some View {
        ZStack {
            Image("splashscreen_background")
                .resizable()
                .scaledToFill()
                // Exposure down slightly
                .brightness(-0.12)
                // Increase contrast
                .contrast(1.18)
                // Slightly warmer overall color temperature approximation
                .overlay(
                    Rectangle()
                        .fill(Color.orange.opacity(0.12))
                        .blendMode(.color)
                )
                // Boost highlights noticeably
                .overlay(
                    Rectangle()
                        .fill(Color.white.opacity(0.12))
                        .blendMode(.screen)
                )
                .overlay(
                    Rectangle()
                        .fill(Color.black.opacity(0.08))
                        .blendMode(.multiply)
                )
                // Lift shadows slightly (net effect after contrast)
                .brightness(0.02)
                .ignoresSafeArea()

            if !showMainView {
                Text("Finlingo")
                    .font(.custom("StarlightRune", size: 130))
                    .foregroundColor(Color(red: 1.0, green: 0.905, blue: 0.619))
                    .scaleEffect(animate ? 25 : 1, anchor: anchor)
                    .opacity(animate ? 0 : 1)
                    // Adjust these offsets so the dot on the "i" starts at screen center
                    .offset(x: dotOffsetX, y: dotOffsetY)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            withAnimation(.easeIn(duration: 1.3)) {
                                animate = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                showMainView = true
                            }
                        }
                    }
            } else {
                MainView() // next screen (placeholder)
                    .transition(.opacity)
            }
        }
    }
}
//struct myView_Previews: PreviewProvider {
//    static var previews: some View {
//        SplashView()
//    }
//}

