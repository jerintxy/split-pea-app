import Foundation

/// One group of friends who split expenses together (a trip, flatmates, a dinner).
struct ExpenseGroup: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var memberNames: [String]
    /// Currency code for a trip abroad, such as "JPY". nil means an everyday group in S$ only.
    var foreignCurrencyCode: String?
    let createdAt: Date

    init(name: String, memberNames: [String], foreignCurrencyCode: String? = nil) {
        self.id = UUID()
        self.name = name
        self.memberNames = memberNames
        self.foreignCurrencyCode = foreignCurrencyCode
        self.createdAt = Date()
    }

    /// "¥" for JPY, and so on. nil for everyday groups.
    var foreignSymbol: String? {
        guard let code = foreignCurrencyCode else { return nil }
        let symbols = ["JPY": "¥", "USD": "$", "EUR": "€", "GBP": "£", "KRW": "₩", "THB": "฿", "MYR": "RM"]
        return symbols[code] ?? code
    }
}

/// A group together with how much the current user owes or is owed in it.
/// Positive cents = you are owed. Negative = you owe.
struct GroupSummary {
    let group: ExpenseGroup
    let balanceCents: Int
}
