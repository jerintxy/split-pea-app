import UIKit

/// A throwaway screen that shows every design-system piece, so you can check them in the simulator
/// in light and dark. Set it as the root in SceneDelegate while you build, then delete it later.
final class DesignGalleryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        title = "Design"

        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = AppSpacing.l
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stack)

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: AppSpacing.l),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -AppSpacing.xl),
            stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: AppSpacing.screenInset),
            stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -AppSpacing.screenInset)
        ])

        // Tabs
        stack.addArrangedSubview(TabsControl(titles: ["Expenses", "Balances", "Members"], selected: 1))

        // Where everyone stands
        stack.addArrangedSubview(SectionLabel("Where everyone stands"))
        let standings = CardView()
        standings.addRow(RowView(
            title: "You", subtitle: "are owed",
            leading: AvatarView(name: "John", isYou: true),
            trailing: AmountStackView(main: "+S$54.80", tone: .positive)))
        standings.addRow(RowView(
            title: "Julie", subtitle: "owes",
            leading: AvatarView(name: "Julie"),
            trailing: AmountStackView(main: "−S$27.20", tone: .negative)))
        standings.addRow(RowView(
            title: "Ethan", subtitle: "owes",
            leading: AvatarView(name: "Ethan"),
            trailing: AmountStackView(main: "−S$27.60", tone: .negative)))
        stack.addArrangedSubview(standings)

        // Suggested payments (only the ones involving you)
        stack.addArrangedSubview(SectionLabel("Suggested payments"))
        let payments = CardView()
        payments.addRow(RowView(
            title: "Julie → You",
            leading: AvatarView(name: "Julie"),
            trailing: paymentTrailing(main: "S$27.20", converted: "¥3,400")))
        payments.addRow(RowView(
            title: "Ethan → You",
            leading: AvatarView(name: "Ethan"),
            trailing: paymentTrailing(main: "S$27.60", converted: "¥3,450")))
        stack.addArrangedSubview(payments)

        stack.addArrangedSubview(PrimaryButton(title: "Record payment", symbol: "banknote", style: .outlined))

        // Buttons
        stack.addArrangedSubview(SectionLabel("Buttons"))
        stack.addArrangedSubview(PrimaryButton(title: "Get started"))
    }

    /// Amount stack plus the round cash button, side by side.
    private func paymentTrailing(main: String, converted: String) -> UIView {
        let amount = AmountStackView(main: main, converted: converted)
        let row = UIStackView(arrangedSubviews: [amount, CashButton()])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = AppSpacing.m
        return row
    }
}
