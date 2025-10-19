import SwiftUI

struct MainView: View {
    // Define the custom gold color used for tinting
    private let goldColor = Color(red: 1.0, green: 0.905, blue: 0.619)

    var body: some View {
        TabView {
            // Home tab with glass navigation bar
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
//                    Text("Home")
                }

            // Resources tab
            ResourcesTab()
                .tabItem {
                    Image(systemName: "person.2.fill")
//                    Text("Friends")
                }

            // Book tab
            BookTab()
                .tabItem {
                    Image(systemName: "book.fill")
//                    Text("Resources")
                }
        }
        .tint(goldColor)
        .background(
            Image("simple_night_sky")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}

// MARK: - Inline subviews used only by MainView

private struct ResourcesTab: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Text("Resources View")
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
    }
}

private struct BookTab: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Text("Book View")
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    MainView()
}
