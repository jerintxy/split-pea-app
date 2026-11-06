import UIKit

/// Colour tokens from the SplitPea mockups. Each one switches between light and dark automatically.
enum AppColor {
    static let background  = dynamic(light: 0xF7F9F0, dark: 0x0F1A12)
    static let card        = dynamic(light: 0xFFFFFF, dark: 0x19261C)
    static let text        = dynamic(light: 0x1B2A1E, dark: 0xE9F2EA)
    static let muted       = dynamic(light: 0x667568, dark: 0x8FA394)
    static let line        = dynamic(light: 0xE4EAD9, dark: 0x243627)

    /// Main green: filled buttons, avatars of "you".
    static let primary     = dynamic(light: 0x2F7A3E, dark: 0x5FB36E)
    /// Green used for text and icons on a plain background.
    static let primaryText = dynamic(light: 0x2F7A3E, dark: 0x8FD39A)
    /// Text or icon colour on top of `primary`.
    static let onPrimary   = dynamic(light: 0xFFFFFF, dark: 0x08140E)
    static let tint        = dynamic(light: 0xE3F2D9, dark: 0x223A27)

    static let segment         = dynamic(light: 0xE8EEDC, dark: 0x19261C)
    static let segmentSelected = dynamic(light: 0xFFFFFF, dark: 0x2F4A35)

    /// Orange accent: amounts owed, the "≈" converted amount, warnings.
    static let accent      = dynamic(light: 0xC2540A, dark: 0xFF9A57)
    static let accentTint  = dynamic(light: 0xFDE6D2, dark: 0x3D2818)

    private static func dynamic(light: UInt32, dark: UInt32) -> UIColor {
        UIColor { traits in
            UIColor(hex: traits.userInterfaceStyle == .dark ? dark : light)
        }
    }
}

extension UIColor {
    convenience init(hex: UInt32) {
        self.init(
            red:   CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue:  CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
}
