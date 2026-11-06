import UIKit

/// The stacked currency display: main amount on top, orange "≈" converted amount underneath.
/// Leave `converted` as nil for single-currency groups.
final class AmountStackView: UIStackView {

    enum Tone {
        case normal      // plain text colour
        case positive    // you are owed (green)
        case negative    // you owe (orange)
    }

    init(main: String,
         converted: String? = nil,
         tone: Tone = .normal,
         alignment: UIStackView.Alignment = .trailing,
         mainFont: UIFont = AppFont.bodyMedium) {
        super.init(frame: .zero)
        axis = .vertical
        spacing = 1
        self.alignment = alignment

        let mainLabel = UILabel()
        mainLabel.text = main
        mainLabel.font = mainFont
        mainLabel.textColor = AmountStackView.color(for: tone)
        addArrangedSubview(mainLabel)

        if let converted {
            let sub = UILabel()
            sub.text = "≈ " + converted
            sub.font = AppFont.caption
            sub.textColor = AppColor.accent
            addArrangedSubview(sub)
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) { fatalError("init(coder:) is not used") }

    private static func color(for tone: Tone) -> UIColor {
        switch tone {
        case .normal:   return AppColor.text
        case .positive: return AppColor.primaryText
        case .negative: return AppColor.accent
        }
    }
}
