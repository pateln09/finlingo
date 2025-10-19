import SwiftUI

struct SettingsView: View {
    @State private var animatedText = ""
    private let fullText = "Settings"
    private let typingSpeed = 0.1  // seconds per character for smooth pacing

    // Example options for the settings menu
    private let settingsOptions = [
        ("person.fill", "Profile"),
        ("bell.fill", "Notifications"),
        ("lock.fill", "Privacy"),
        ("paintbrush.fill", "Appearance"),
        ("info.circle.fill", "About")
    ]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                // Background image
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

                VStack(alignment: .leading, spacing: 24) {
                    // Typewriter title
                    Text(animatedText)
                        .font(.custom("StarlightRune", size: 60))
                        .foregroundColor(Color(red: 1.0, green: 0.905, blue: 0.619))
                        .kerning(3)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .padding(.leading, 55)
                        .padding(.top, 50)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 1)
                        .onAppear {
                            animateText()
                        }

                    // Settings list
                    VStack(spacing: 16) {
                        ForEach(settingsOptions, id: \.1) { icon, title in
                            HStack(spacing: 20) {
                                Image(systemName: icon)
                                    .foregroundColor(.white.opacity(0.85))
                                    .font(.system(size: 22))

                                Text(title)
                                    .font(.custom("SFProRounded-Regular", size: 22))
                                    .foregroundColor(.white.opacity(0.9))

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white.opacity(0.4))
                                    .font(.system(size: 16))
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.08))
                                    .blur(radius: 0.5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 30)
                        }
                    }
                    .padding(.top, 40)

                    Spacer()
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
    SettingsView()
}
