import UIKit

/// The big green card at the top of Home: total balance, plus "You're owed" and "You owe".
final class BalanceCardView: UIView {

    private let balanceLabel = UILabel()
    private let owedValue = UILabel()
    private let oweValue = UILabel()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColor.primary
        layer.cornerRadius = 24

        let title = UILabel()
        title.text = "Your balance"
        title.font = AppFont.body
        title.textColor = AppColor.onPrimary

        balanceLabel.font = .systemFont(ofSize: 44, weight: .medium)
        balanceLabel.textColor = AppColor.onPrimary
        balanceLabel.adjustsFontSizeToFitWidth = true
        balanceLabel.minimumScaleFactor = 0.6

        let pills = UIStackView(arrangedSubviews: [
            makePill(title: "You're owed", value: owedValue),
            makePill(title: "You owe", value: oweValue)
        ])
        pills.axis = .horizontal
        pills.distribution = .fillEqually
        pills.spacing = AppSpacing.m

        let stack = UIStackView(arrangedSubviews: [title, balanceLabel, pills])
        stack.axis = .vertical
        stack.spacing = AppSpacing.s
        stack.setCustomSpacing(AppSpacing.l, after: balanceLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: AppSpacing.l),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppSpacing.l),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppSpacing.l),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppSpacing.l)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }

    func update(balance: String, owed: String, owe: String) {
        balanceLabel.text = balance
        owedValue.text = owed
        oweValue.text = owe
    }

    private func makePill(title: String, value: UILabel) -> UIView {
        let pill = UIView()
        pill.backgroundColor = AppColor.onPrimary.withAlphaComponent(0.15)
        pill.layer.cornerRadius = AppSpacing.m

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = AppFont.body
        titleLabel.textColor = AppColor.onPrimary

        value.font = AppFont.bodyMedium
        value.textColor = AppColor.onPrimary

        let stack = UIStackView(arrangedSubviews: [titleLabel, value])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        pill.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: pill.topAnchor, constant: AppSpacing.m),
            stack.bottomAnchor.constraint(equalTo: pill.bottomAnchor, constant: -AppSpacing.m),
            stack.leadingAnchor.constraint(equalTo: pill.leadingAnchor, constant: AppSpacing.m),
            stack.trailingAnchor.constraint(equalTo: pill.trailingAnchor, constant: -AppSpacing.m)
        ])
        return pill
    }
}
