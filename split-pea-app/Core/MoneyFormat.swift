import Foundation

/// Turns whole cents into text like "S$54.80". Money is always kept as whole cents, never as decimals.
enum MoneyFormat {

    /// 5480 -> "S$54.80" (sign is ignored, use signedSGD for +/−)
    static func sgd(cents: Int) -> String {
        "S$" + number(fromCents: abs(cents))
    }

    /// 5480 -> "+S$54.80", -2300 -> "−S$23.00", 0 -> "S$0.00"
    static func signedSGD(cents: Int) -> String {
        if cents > 0 { return "+" + sgd(cents: cents) }
        if cents < 0 { return "\u{2212}" + sgd(cents: cents) }
        return sgd(cents: 0)
    }

    private static func number(fromCents cents: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_SG")
        let value = Decimal(cents) / 100
        return formatter.string(from: value as NSDecimalNumber) ?? "0.00"
    }
}
