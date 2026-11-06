import UIKit

/// Full-width button. `.filled` is the main green button ("Get started"),
/// `.outlined` is the secondary one ("Record payment" on Balances).
final class PrimaryButton: UIButton {

    enum Style { case filled, outlined }

    private let style: Style

    init(title: String, symbol: String? = nil, style: Style = .filled) {
        self.style = style
        super.init(frame: .zero)

        var config = UIButton.Configuration.plain()
        config.title = title
        config.cornerStyle = .fixed
        config.background.cornerRadius = AppSpacing.buttonRadius
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        config.imagePadding = 8
        if let symbol {
            config.image = UIImage(systemName: symbol)
        }
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var out = incoming
            out.font = AppFont.button
            return out
        }
        configuration = config

        // Colours are set in updateConfiguration so they follow light/dark and the pressed state.
        configurationUpdateHandler = { [weak self] button in
            guard let self, var config = button.configuration else { return }
            let pressed = button.isHighlighted
            switch self.style {
            case .filled:
                config.baseForegroundColor = AppColor.onPrimary
                config.background.backgroundColor = AppColor.primary.withAlphaComponent(pressed ? 0.8 : 1)
                config.background.strokeWidth = 0
            case .outlined:
                config.baseForegroundColor = AppColor.primaryText
                config.background.backgroundColor = pressed ? AppColor.tint : .clear
                config.background.strokeColor = AppColor.primary
                config.background.strokeWidth = 1.5
            }
            button.alpha = button.isEnabled ? 1 : 0.4   // dim when disabled
            button.configuration = config
        }

        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: AppSpacing.buttonHeight).isActive = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }
}
