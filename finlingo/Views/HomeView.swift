import SwiftUI

struct HomeView: View {
    private let goldColor = Color(red: 1.0, green: 0.905, blue: 0.619)

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                // Background image
                Image("simple_night_sky")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // Top-left title
                Text("Welcome back, Neel!")
                    .font(.custom("StarlightRune", size: 50))
                    .foregroundColor(goldColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .padding(.leading, 35)
                    .padding(.top, 50)
                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 1)
            }
            .toolbar(.hidden, for: .navigationBar)  // hides gray nav bar entirely
        }
    }
}

#Preview {
    HomeView()
}

