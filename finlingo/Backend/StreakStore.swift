import Foundation
import Combine

/// Tiny backend to track a daily login/learning streak.
/// Persists the current streak and the last active date.
final class StreakStore: ObservableObject {
    static let shared = StreakStore()

    @Published private(set) var currentStreak: Int = 0
    @Published private(set) var lastActiveDate: Date? = nil

    private let defaultsKey = "streak.data.v1"
    private let calendar = Calendar.current

    private init() {
        if let data = UserDefaults.standard.dictionary(forKey: defaultsKey) as? [String: Any] {
            if let streak = data["currentStreak"] as? Int {
                currentStreak = max(0, streak)
            }
            if let ts = data["lastActiveTimestamp"] as? TimeInterval {
                lastActiveDate = Date(timeIntervalSince1970: ts)
            }
        }
    }

    /// Call once per day when the user is active (e.g., onAppear).
    func markTodayActive(date: Date = Date()) {
        guard let last = lastActiveDate else {
            // First activation
            currentStreak = 1
            lastActiveDate = date
            persist()
            return
        }

        if calendar.isDate(last, inSameDayAs: date) {
            // Already counted today
            return
        }

        if let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: last), to: calendar.startOfDay(for: date)).day {
            if days == 1 {
                // Continued streak
                currentStreak += 1
            } else if days > 1 {
                // Missed a day, reset to 1
                currentStreak = 1
            } else {
                // date is earlier than last (clock changes, etc.) — ignore
                return
            }
            lastActiveDate = date
            persist()
        }
    }

    /// Reset streak to zero (e.g., for testing)
    func reset() {
        currentStreak = 0
        lastActiveDate = nil
        persist()
    }

    /// For debug/testing (sets streak and lastActiveDate to today).
    func setDebugStreak(_ value: Int) {
        currentStreak = max(0, value)
        lastActiveDate = Date()
        persist()
    }

    private func persist() {
        var dict: [String: Any] = ["currentStreak": currentStreak]
        if let last = lastActiveDate {
            dict["lastActiveTimestamp"] = last.timeIntervalSince1970
        }
        UserDefaults.standard.set(dict, forKey: defaultsKey)
        objectWillChange.send()
    }
}
//
//  StreakStore.swift
//  finlingo
//
//  Created by Neel Patel on 10/19/25.
//

