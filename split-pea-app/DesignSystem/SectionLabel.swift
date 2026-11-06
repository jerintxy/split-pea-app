import UIKit

/// Small grey heading above a card, such as "WHERE EVERYONE STANDS".
final class SectionLabel: UILabel {

    init(_ text: String) {
        super.init(frame: .zero)
        self.attributedText = NSAttributedString(
            string: text.uppercased(),
            attributes: [
                .font: AppFont.sectionLabel,
                .foregroundColor: AppColor.muted,
                .kern: 0.6
            ]
        )
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }
}
