import SwiftUI

// Placeholder for Earth's outer view.
// NOTE: You should replace this with your actual view in its own file.
struct EarthOuterView: View {
    var body: some View {
        ZStack {
            Image("simple_night_sky")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Text("Earth")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Our Home Planet")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
    }
}

// Placeholder for Pluto's outer view.
// NOTE: You should replace this with your actual view in its own file.
struct PlutoOuterView: View {
    var body: some View {
        ZStack {
            Image("simple_night_sky")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Text("Pluto")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("The Distant Dwarf Planet")
                    .font(.headline)
                    .foregroundColor(.cyan)
            }
        }
    }
}

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
