import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea() // Background
            Text("Welcome to FINLINGO!")
                .font(.custom("YourFontInternalName", size: 36))
                .foregroundColor(.white)
        }
    }
}


