//
//  PlanetProgressBar.swift
//  finlingo
//
//  Created by Neel Patel on 10/19/25.
//


import SwiftUI

// Minimal progress bar: gold fill, % number at side (StarlightRune), no background box.
struct PlanetProgressBar1: View {
    var progress: Double   // 0.0 ... 1.0

    private let barHeight: CGFloat = 18
    private let corner: CGFloat = 10
    private let gold = Color(red: 1.0, green: 0.905, blue: 0.619)

    var body: some View {
        HStack(spacing: 10) {
            GeometryReader { geo in
                let width = geo.size.width
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: corner, style: .continuous)
                        .fill(Color.white.opacity(0.10))
                        .overlay(
                            RoundedRectangle(cornerRadius: corner, style: .continuous)
                                .stroke(.white.opacity(0.15), lineWidth: 1)
                        )

                    RoundedRectangle(cornerRadius: corner, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [gold.opacity(0.9), gold]),
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .frame(width: width * max(0, min(1, progress)))
                        .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 1)
                }
            }
            .frame(height: barHeight)

            Text("\(Int(progress * 100))%")
                .font(.custom("StarlightRune", size: 30))
                .foregroundColor(gold)
                .accessibilityLabel("Progress \(Int(progress * 100)) percent")
        }
        .frame(height: barHeight)
        .frame(width: 275)
    }
}

struct EarthOuterView: View {
    // Typewriter
    @State private var animatedText = ""
    private let fullText = "Earth"
    private let typingSpeed = 0.1

    // Floating animation
    @State private var float = false

    // Presentation state
    @State private var showDetailView = false

    // Styling
    private let gold = Color(red: 1.0, green: 0.905, blue: 0.619)

    // Backends (separate files)
    @StateObject private var progressStore = ProgressStore.shared
    @StateObject private var moneyStore = MoneyStore.shared
    @StateObject private var streakStore = StreakStore.shared

    private let planetID = "Earth"

    // Debug knobs for quick testing
    @State private var debugCompletion: Double = 0.21
    @State private var debugMoneyStart: Int = 1231
    @State private var debugStreakStart: Int = 13   // Initial streak value set to 13

    var body: some View {
        ZStack {
            // Background
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

            // Outer content
            VStack(spacing: 20) {
                Spacer()

                Text(animatedText)
                    .font(.custom("StarlightRune", size: 120))
                    .foregroundColor(gold)
                    .padding(.top, -100)
                    .shadow(color: .black.opacity(0.6), radius: 4, x: 0, y: 2)
                    .multilineTextAlignment(.center)
                    .task(id: showDetailView) { await runTypewriter() }

                if !showDetailView {
                    // Mercury image with progress bar overlaid just below it.
                    Image("earth_planet")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .offset(y: float ? -15 : 15)
                        .shadow(color: .black.opacity(0.4), radius: 25, x: 0, y: 12)
                        .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: float)
                        .task { float = true }
                        .onTapGesture {
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.88)) {
                                showDetailView = true
                            }
                        }
                        .accessibilityLabel("Open Earth details")
                        .overlay(
                            PlanetProgressBar1(progress: progressStore.progress(for: planetID))
                                .offset(y: 36),
                            alignment: .bottom
                        )
                    
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // 🔝 Top-right money overlay
            .overlay(
                MoneyBadge(imageName: "stardust", amount: moneyStore.balance)
                    .padding(.top, 40)
                    .padding(.trailing, 50),
                alignment: .topTrailing
            )

            // 🔝 Top-left streak overlay — filled flame & shifted right
            .overlay(
                StreakBadge(count: streakStore.currentStreak)
                    .padding(.top, 40)
                    .padding(.leading, 62),
                alignment: .topLeading
            )

            // Inner overlay (NO planet here)
            if showDetailView {
                EarthInnerView(showDetailView: $showDetailView)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.98)),
                        removal: .opacity
                    ))
                    .zIndex(1)
            }

            // Close button
            if showDetailView {
                Button {
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.9)) {
                        showDetailView = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.5), radius: 6, x: 0, y: 2)
                        .padding(.all, 18)
                        .background(Color.black.opacity(0.001))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .padding(.top, 50)
                .padding(.trailing, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .zIndex(2)
                .allowsHitTesting(true)
                .accessibilityLabel("Close")
            }
        }
        .onAppear {
            // Seed debug values — adjust/remove once real logic is connected
            progressStore.setProgress(debugCompletion, for: planetID)
            moneyStore.setBalance(debugMoneyStart)

            // Initialize the streak (for demo) and mark today active.
            streakStore.setDebugStreak(debugStreakStart)
            streakStore.markTodayActive()
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Animations and Helpers

    private func runTypewriter() async {
        animatedText = ""
        for ch in fullText {
            if Task.isCancelled { return }
            animatedText.append(ch)
            try? await Task.sleep(for: .milliseconds(Int(typingSpeed * 1000)))
        }
    }

    // Example usage hooks if you want to trigger updates from elsewhere:
    private func markLessonComplete() {
        progressStore.addProgress(10, for: planetID)
    }

    private func awardCoins(_ amount: Int) {
        _ = moneyStore.add(amount)
    }

    private func markStreakToday() {
        streakStore.markTodayActive()
    }
}

//#Preview { MercurOuterView() }
