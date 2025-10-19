import SwiftUI

// The main HomeView which allows swiping between planets.
struct HomeView: View {
    @State private var selection: Int = 0

    var body: some View {
        // A TabView with a page style allows for a swipe-through interface.
        TabView(selection: $selection) {
            MercuryOuterView()
                .tag(0)
            EarthOuterView()
                .tag(1)
            PlutoOuterView()
                .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .id(selection) // Forces teardown/recreation on page change to reduce retained memory
        .ignoresSafeArea() // Ensures the view extends to the screen edges
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
