import SwiftUI

struct MainView: View {
    // Define the custom gold color used for tinting
    private let goldColor = Color(red: 1.0, green: 0.905, blue: 0.619)

    var body: some View {
        TabView {
            // Home View
            MercuryOuterView()
                .tabItem {
                    Image(systemName: "house.fill")
//                    Text("Home")
                }

            // Resources tab
            FriendsView()
                .tabItem {
                    Image(systemName: "person.2.fill")
//                    Text("Friends")
                }

            // Resources View
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
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


#Preview {
    MainView()
}
