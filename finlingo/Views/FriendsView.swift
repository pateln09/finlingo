import SwiftUI

struct FriendsView: View {
    @State private var animatedText = ""
    private let fullText = "Friends"
    private let typingSpeed = 0.1  // seconds per character

    // Preloaded sample friends
    private let friends = [
        "Avery Chen",
        "Bhavana Katta",
        "Diego Estrada",
        "Rohan Gaikwad",
        "Wyatt Hansen"
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

                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    Text(animatedText)
                        .font(.custom("StarlightRune", size: 60))
                        .foregroundColor(Color(red: 1.0, green: 0.905, blue: 0.619))
                        .kerning(3)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .padding(.leading, 55)
                        .padding(.top, 50)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 1)
                        .onAppear { animateText() }

                    // Friends list
                    VStack(spacing: 14) {
                        ForEach(friends, id: \.self) { friend in
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(Color.white.opacity(0.12))
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Text(initials(for: friend))
                                            .font(.system(.headline, design: .rounded))
                                            .foregroundColor(.white.opacity(0.9))
                                    )

                                Text(friend)
                                    .foregroundColor(.white)
                                    .font(.system(.title3, design: .rounded).weight(.semibold))

                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.white.opacity(0.06))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 30)
                        }
                    }
                    .padding(.top, 10)

                    Spacer()
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    // Helper for initials
    private func initials(for name: String) -> String {
        let parts = name.split(separator: " ")
        let first = parts.first?.first.map(String.init) ?? ""
        let last = parts.dropFirst().first?.first.map(String.init) ?? ""
        return (first + last).uppercased()
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
    FriendsView()
}
