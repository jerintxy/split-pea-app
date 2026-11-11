import Foundation

/// One group of friends who split expenses together (a trip, flatmates, a dinner).
struct ExpenseGroup: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var memberNames: [String]
    /// Currency code for a trip abroad, such as "JPY". nil means an everyday group in S$ only.
    var foreignCurrencyCode: String?
    /// SF Symbol shown for the group. Optional so groups saved before this existed still load.
    var iconName: String?
    let createdAt: Date

    init(name: String, memberNames: [String], foreignCurrencyCode: String? = nil, iconName: String? = nil) {
        self.id = UUID()
        self.name = name
        self.memberNames = memberNames
        self.foreignCurrencyCode = foreignCurrencyCode
        self.iconName = iconName
        self.createdAt = Date()
    }

    /// "¥" for JPY, and so on. nil for everyday groups.
    var foreignSymbol: String? {
        guard let code = foreignCurrencyCode else { return nil }
        let symbols = ["JPY": "¥", "KRW": "₩", "THB": "฿", "MYR": "RM", "IDR": "Rp",
                       "USD": "$", "EUR": "€", "GBP": "£", "AUD": "A$"]
        return symbols[code] ?? code
    }
}

/// A group together with how much the current user owes or is owed in it.
/// Positive cents = you are owed. Negative = you owe.
struct GroupSummary {
    let group: ExpenseGroup
    let balanceCents: Int
}
