import Foundation
import Combine

/// Tiny backend for an app-wide money/coin balance.
final class MoneyStore: ObservableObject {
    static let shared = MoneyStore()

    @Published private(set) var balance: Int = 0
    private let defaultsKey = "money.balance.v1"

    private init() {
        balance = UserDefaults.standard.integer(forKey: defaultsKey)
    }

    /// Replace the current balance (clamped at 0+)
    func setBalance(_ value: Int) {
        let v = max(0, value)
        guard v != balance else { return }
        balance = v
        UserDefaults.standard.set(v, forKey: defaultsKey)
    }

    /// Add (or subtract with a negative value). Returns the new balance.
    @discardableResult
    func add(_ delta: Int) -> Int {
        setBalance(balance + delta)
        return balance
    }

    /// Spend `amount` if possible. Returns true on success.
    @discardableResult
    func spend(_ amount: Int) -> Bool {
        guard amount >= 0, balance >= amount else { return false }
        setBalance(balance - amount)
        return true
    }
}

