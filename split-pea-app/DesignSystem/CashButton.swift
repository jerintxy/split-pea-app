import UIKit

/// Round green icon button used on suggested payments to record a payment.
final class CashButton: UIButton {

    init() {
        super.init(frame: .zero)

        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "banknote",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .regular)
        )
        config.cornerStyle = .capsule
        config.contentInsets = .zero
        configuration = config

        configurationUpdateHandler = { button in
            guard var config = button.configuration else { return }
            config.baseForegroundColor = AppColor.onPrimary
            config.background.backgroundColor = AppColor.primary.withAlphaComponent(button.isHighlighted ? 0.8 : 1)
            button.configuration = config
        }

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 34),
            heightAnchor.constraint(equalToConstant: 34)
        ])

        accessibilityLabel = "Record payment"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }
}
