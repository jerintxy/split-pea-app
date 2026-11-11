import UIKit

/// The Home screen: greeting, balance card and the list of groups, or an empty state.
final class HomeViewController: UIViewController, HomeViewProtocol {

    var presenter: HomePresenterProtocol!   // set by HomeBuilder

    private let greetingLabel = UILabel()
    private let balanceCard = BalanceCardView()
    private let groupsStack = UIStackView()     // holds the card list, rebuilt on every update
    private let scroll = UIScrollView()
    private let emptyState = UIStackView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        buildLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        presenter.viewWillAppear()
    }

    // MARK: - HomeViewProtocol

    func show(_ model: HomeViewModel) {
        greetingLabel.text = model.greeting

        let isEmpty = model.groups.isEmpty
        emptyState.isHidden = !isEmpty
        scroll.isHidden = isEmpty
        guard !isEmpty else { return }

        balanceCard.update(balance: model.balance, owed: model.owed, owe: model.owe)

        // Rebuild the list of groups.
        groupsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        groupsStack.addArrangedSubview(SectionLabel("Your groups"))

        let card = CardView()
        for group in model.groups {
            let row = RowView(
                title: group.title,
                subtitle: group.subtitle,
                leading: makeIcon(named: group.iconName),
                trailing: makeAmountLabel(text: group.amountText, tone: group.tone)
            )
            row.onTap = { [weak self] in self?.presenter.groupSelected(id: group.id) }
            card.addRow(row)
        }
        groupsStack.addArrangedSubview(card)
    }

    // MARK: - Layout

    private func buildLayout() {
        // Top bar: "Hi, John" and the + button
        greetingLabel.font = AppFont.largeTitle
        greetingLabel.textColor = AppColor.text
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.minimumScaleFactor = 0.7

        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(
            systemName: "plus.circle",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)), for: .normal)
        addButton.tintColor = AppColor.primaryText
        addButton.accessibilityLabel = "New group"
        addButton.addAction(UIAction { [weak self] _ in self?.presenter.addGroupTapped() }, for: .touchUpInside)

        let topBar = UIStackView(arrangedSubviews: [greetingLabel, addButton])
        topBar.alignment = .center
        topBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBar)

        // Scrolling content: balance card + groups
        groupsStack.axis = .vertical
        groupsStack.spacing = AppSpacing.s

        let content = UIStackView(arrangedSubviews: [balanceCard, groupsStack])
        content.axis = .vertical
        content.spacing = AppSpacing.xl
        content.translatesAutoresizingMaskIntoConstraints = false

        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        scroll.addSubview(content)
        view.addSubview(scroll)

        buildEmptyState()

        let inset = AppSpacing.screenInset
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppSpacing.l),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),

            scroll.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: AppSpacing.l),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            content.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            content.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -AppSpacing.xl),
            content.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: inset),
            content.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -inset)
        ])
    }

    private func buildEmptyState() {
        let pea: UIImageView
        if let image = UIImage(named: "Pea") {
            pea = UIImageView(image: image)
        } else {
            pea = UIImageView(image: UIImage(systemName: "leaf.fill"))
            pea.tintColor = AppColor.primary
        }
        pea.contentMode = .scaleAspectFit
        pea.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pea.widthAnchor.constraint(equalToConstant: 120),
            pea.heightAnchor.constraint(equalToConstant: 120)
        ])

        let title = UILabel()
        title.text = "No groups yet"
        title.font = AppFont.title
        title.textColor = AppColor.text

        let subtitle = UILabel()
        subtitle.text = "Create a group and add\nyour friends."
        subtitle.font = AppFont.body
        subtitle.textColor = AppColor.muted
        subtitle.textAlignment = .center
        subtitle.numberOfLines = 0

        let button = PrimaryButton(title: "Create a group")
        button.addAction(UIAction { [weak self] _ in self?.presenter.addGroupTapped() }, for: .touchUpInside)

        emptyState.axis = .vertical
        emptyState.alignment = .center
        emptyState.spacing = AppSpacing.m
        emptyState.addArrangedSubview(pea)
        emptyState.addArrangedSubview(title)
        emptyState.addArrangedSubview(subtitle)
        emptyState.setCustomSpacing(AppSpacing.xl, after: subtitle)
        emptyState.addArrangedSubview(button)
        emptyState.translatesAutoresizingMaskIntoConstraints = false
        emptyState.isHidden = true
        view.addSubview(emptyState)

        NSLayoutConstraint.activate([
            emptyState.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyState.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppSpacing.screenInset),
            emptyState.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppSpacing.screenInset),
            button.leadingAnchor.constraint(equalTo: emptyState.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: emptyState.trailingAnchor)
        ])
    }

    // MARK: - Small helpers

    private func makeIcon(named symbol: String) -> UIView {
        let circle = UIView()
        circle.backgroundColor = AppColor.tint
        circle.layer.cornerRadius = 22
        circle.translatesAutoresizingMaskIntoConstraints = false

        let image = UIImageView(image: UIImage(
            systemName: symbol,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)))
        image.tintColor = AppColor.primaryText
        image.translatesAutoresizingMaskIntoConstraints = false
        circle.addSubview(image)

        NSLayoutConstraint.activate([
            circle.widthAnchor.constraint(equalToConstant: 44),
            circle.heightAnchor.constraint(equalToConstant: 44),
            image.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: circle.centerYAnchor)
        ])
        return circle
    }

    private func makeAmountLabel(text: String, tone: AmountTone) -> UILabel {
        let label = UILabel()
        label.text = text
        switch tone {
        case .positive:
            label.font = AppFont.bodyMedium
            label.textColor = AppColor.primaryText
        case .negative:
            label.font = AppFont.bodyMedium
            label.textColor = AppColor.accent
        case .settled:
            label.font = AppFont.body
            label.textColor = AppColor.muted
        }
        return label
    }
}
