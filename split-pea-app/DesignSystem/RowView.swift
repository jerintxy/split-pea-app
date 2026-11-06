import UIKit

/// One list row: optional leading view (avatar), title with optional subtitle, optional trailing view.
/// Put rows inside a `CardView` with `card.addRow(...)`.
final class RowView: UIView {

    init(title: String,
         subtitle: String? = nil,
         leading: UIView? = nil,
         trailing: UIView? = nil) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = AppFont.bodyMedium
        titleLabel.textColor = AppColor.text
        titleLabel.numberOfLines = 0

        let textStack = UIStackView(arrangedSubviews: [titleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        if let subtitle {
            let subtitleLabel = UILabel()
            subtitleLabel.text = subtitle
            subtitleLabel.font = AppFont.caption
            subtitleLabel.textColor = AppColor.muted
            subtitleLabel.numberOfLines = 0
            textStack.addArrangedSubview(subtitleLabel)
        }

        var items: [UIView] = []
        if let leading { items.append(leading) }
        items.append(textStack)
        // A flexible gap so the trailing view sits on the right edge.
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        items.append(spacer)
        if let trailing { items.append(trailing) }

        let row = UIStackView(arrangedSubviews: items)
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = AppSpacing.m
        row.translatesAutoresizingMaskIntoConstraints = false
        addSubview(row)

        // Text keeps its width, the avatar and trailing views never get squeezed.
        textStack.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        leading?.setContentHuggingPriority(.required, for: .horizontal)
        trailing?.setContentHuggingPriority(.required, for: .horizontal)
        trailing?.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: topAnchor, constant: AppSpacing.m),
            row.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppSpacing.m),
            row.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppSpacing.l),
            row.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppSpacing.l)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }
}
