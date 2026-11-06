import UIKit

/// Rounded white container that holds rows. Thin divider lines are added between rows automatically.
final class CardView: UIView {

    private let stack = UIStackView()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColor.card
        layer.cornerRadius = AppSpacing.cardRadius
        layer.borderWidth = 1
        clipsToBounds = true
        updateBorderColor()

        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        // CGColor doesn't switch with dark mode by itself, so refresh it when the style changes.
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: CardView, _) in
            view.updateBorderColor()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }

    /// Adds a row at the bottom, with a divider above it if it isn't the first.
    func addRow(_ row: UIView) {
        if !stack.arrangedSubviews.isEmpty {
            stack.addArrangedSubview(Divider())
        }
        stack.addArrangedSubview(row)
    }

    private func updateBorderColor() {
        layer.borderColor = AppColor.line.resolvedColor(with: traitCollection).cgColor
    }
}

/// Hairline divider, inset to line up with the row text.
private final class Divider: UIView {
    init() {
        super.init(frame: .zero)
        let line = UIView()
        line.backgroundColor = AppColor.line
        line.translatesAutoresizingMaskIntoConstraints = false
        addSubview(line)
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: topAnchor),
            line.bottomAnchor.constraint(equalTo: bottomAnchor),
            line.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppSpacing.l),
            line.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppSpacing.l),
            line.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }
}
