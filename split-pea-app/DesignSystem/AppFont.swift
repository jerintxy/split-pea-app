import UIKit

/// Type styles. They use the system font and scale with the user's Dynamic Type setting.
enum AppFont {
    static let largeTitle = scaled(28, .medium, style: .largeTitle)   // "Hi, John"
    static let title      = scaled(20, .medium, style: .title3)       // screen titles
    static let body       = scaled(15, .regular, style: .body)
    static let bodyMedium = scaled(15, .medium, style: .body)         // names, row titles
    static let button     = scaled(14, .medium, style: .callout)
    static let caption    = scaled(12, .regular, style: .caption1)    // helper text
    static let sectionLabel = scaled(11, .medium, style: .caption2)   // WHERE EVERYONE STANDS
    static let amountHero = scaled(40, .medium, style: .largeTitle)   // big amount on Record payment

    private static func scaled(_ size: CGFloat, _ weight: UIFont.Weight, style: UIFont.TextStyle) -> UIFont {
        UIFontMetrics(forTextStyle: style).scaledFont(for: .systemFont(ofSize: size, weight: weight))
    }
}

/// Spacing and corner sizes, so screens line up the same way everywhere.
enum AppSpacing {
    static let xs: CGFloat = 4
    static let s: CGFloat = 8
    static let m: CGFloat = 12
    static let l: CGFloat = 16
    static let xl: CGFloat = 24

    static let screenInset: CGFloat = 16
    static let cardRadius: CGFloat = 16
    static let buttonRadius: CGFloat = 12
    static let buttonHeight: CGFloat = 48
}
