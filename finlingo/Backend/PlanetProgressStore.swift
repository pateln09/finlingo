import Foundation
import Combine

/// Simple persistence for per-planet progress (0.0 ... 1.0)
final class ProgressStore: ObservableObject {
    static let shared = ProgressStore()

    @Published private(set) var progressByPlanet: [String: Double] = [:]
    private let defaultsKey = "planetProgress.v1"

    private init() {
        if let data = UserDefaults.standard.dictionary(forKey: defaultsKey) as? [String: Double] {
            progressByPlanet = data
        }
    }

    func progress(for planetID: String) -> Double {
        max(0.0, min(1.0, progressByPlanet[planetID] ?? 0.0))
    }

    func setProgress(_ value: Double, for planetID: String) {
        let clamped = max(0.0, min(1.0, value))
        guard progressByPlanet[planetID] != clamped else { return }
        progressByPlanet[planetID] = clamped
        UserDefaults.standard.set(progressByPlanet, forKey: defaultsKey)
        objectWillChange.send()
    }

    func addProgress(_ delta: Double, for planetID: String) {
        setProgress(progress(for: planetID) + delta, for: planetID)
    }
}
