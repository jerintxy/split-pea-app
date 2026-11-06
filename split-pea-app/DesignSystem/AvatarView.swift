import UIKit

/// Round avatar with initials. Use `isYou: true` for the current user (solid green).
final class AvatarView: UIView {

    private let label = UILabel()
    private let diameter: CGFloat

    init(name: String, isYou: Bool = false, diameter: CGFloat = 36) {
        self.diameter = diameter
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = isYou ? AppColor.primary : AppColor.tint
        layer.cornerRadius = diameter / 2
        clipsToBounds = true

        label.text = AvatarView.initials(from: name)
        label.font = .systemFont(ofSize: diameter * 0.36, weight: .medium)
        label.textColor = isYou ? AppColor.onPrimary : AppColor.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: diameter),
            heightAnchor.constraint(equalToConstant: diameter),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        isAccessibilityElement = true
        accessibilityLabel = name
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }

    /// "Julie" -> "JU", "Mary Tan" -> "MT"
    static func initials(from name: String) -> String {
        let parts = name.split(separator: " ")
        if parts.count >= 2, let a = parts[0].first, let b = parts[1].first {
            return "\(a)\(b)".uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }
}
