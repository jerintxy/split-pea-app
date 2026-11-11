import UIKit

/// The New group sheet: icon, name, currency and people.
final class NewGroupViewController: UIViewController, NewGroupViewProtocol {

    var presenter: NewGroupPresenterProtocol!   // set by NewGroupBuilder

    private let iconImage = UIImageView()
    private let changeIconButton = UIButton(type: .system)
    private let nameField = UITextField()
    private let foreignSwitch = UISwitch()
    private let currencySlot = UIStackView()    // holds the currency card, rebuilt when it changes
    private let peopleSlot = UIStackView()      // holds the people card, rebuilt when it changes
    private let friendField = UITextField()
    private let errorLabel = UILabel()
    private lazy var createButton = UIBarButtonItem(
        title: "Create", image: nil,
        primaryAction: UIAction { [weak self] _ in
            self?.view.endEditing(true)
            self?.presenter.createTapped()
        },
        menu: nil)

    private var lastModel: NewGroupViewModel?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        configureNavigationBar()
        buildLayout()
        presenter.viewDidLoad()
    }

    // MARK: - NewGroupViewProtocol

    func show(_ model: NewGroupViewModel) {
        iconImage.image = UIImage(
            systemName: model.iconName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        changeIconButton.menu = makeIconMenu(selected: model.iconName)
        createButton.isEnabled = model.canCreate

        if foreignSwitch.isOn != model.isForeign {
            foreignSwitch.setOn(model.isForeign, animated: true)
        }
        // Only rebuild the cards when what they show has changed.
        if lastModel?.isForeign != model.isForeign || lastModel?.tripCurrencyTitle != model.tripCurrencyTitle {
            rebuildCurrencyCard(model)
        }
        if lastModel == nil || lastModel?.friends != model.friends {
            rebuildPeopleCard(model)
        }
        lastModel = model
    }

    func showError(_ message: String?) {
        errorLabel.text = message
        errorLabel.isHidden = (message == nil)
    }

    func clearFriendField() {
        friendField.text = ""
    }

    // MARK: - Navigation bar

    private func configureNavigationBar() {
        title = "New group"

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColor.background
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: AppColor.text, .font: AppFont.bodyMedium]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = AppColor.primaryText

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel", image: nil,
            primaryAction: UIAction { [weak self] _ in self?.presenter.cancelTapped() },
            menu: nil)
        createButton.style = .done
        navigationItem.rightBarButtonItem = createButton
    }

    // MARK: - Layout

    private func buildLayout() {
        // Icon + "Change icon"
        let iconCircle = UIView()
        iconCircle.backgroundColor = AppColor.tint
        iconCircle.layer.cornerRadius = 44
        iconCircle.translatesAutoresizingMaskIntoConstraints = false
        iconImage.tintColor = AppColor.primaryText
        iconImage.contentMode = .center
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconCircle.addSubview(iconImage)
        NSLayoutConstraint.activate([
            iconCircle.widthAnchor.constraint(equalToConstant: 88),
            iconCircle.heightAnchor.constraint(equalToConstant: 88),
            iconImage.centerXAnchor.constraint(equalTo: iconCircle.centerXAnchor),
            iconImage.centerYAnchor.constraint(equalTo: iconCircle.centerYAnchor)
        ])

        changeIconButton.setTitle("Change icon", for: .normal)
        changeIconButton.titleLabel?.font = AppFont.body
        changeIconButton.tintColor = AppColor.primaryText
        changeIconButton.showsMenuAsPrimaryAction = true

        let iconBlock = UIStackView(arrangedSubviews: [iconCircle, changeIconButton])
        iconBlock.axis = .vertical
        iconBlock.alignment = .center
        iconBlock.spacing = AppSpacing.s

        // Group name
        nameField.placeholder = "Group name"
        nameField.font = AppFont.body
        nameField.textColor = AppColor.text
        nameField.autocapitalizationType = .sentences
        nameField.returnKeyType = .done
        nameField.delegate = self
        nameField.addAction(UIAction { [weak self] _ in
            self?.presenter.nameChanged(self?.nameField.text ?? "")
        }, for: .editingChanged)
        let nameBox = makeFieldBox(symbol: "pencil", field: nameField, trailing: nil)

        // Switch for trips abroad
        foreignSwitch.onTintColor = AppColor.primary
        foreignSwitch.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.presenter.foreignCurrencyToggled(self.foreignSwitch.isOn)
        }, for: .valueChanged)

        currencySlot.axis = .vertical
        peopleSlot.axis = .vertical

        // Add a friend
        friendField.placeholder = "Add a friend's name"
        friendField.font = AppFont.body
        friendField.textColor = AppColor.text
        friendField.autocapitalizationType = .words
        friendField.autocorrectionType = .no
        friendField.returnKeyType = .default
        friendField.delegate = self
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add", for: .normal)
        addButton.titleLabel?.font = AppFont.bodyMedium
        addButton.tintColor = AppColor.primaryText
        addButton.addAction(UIAction { [weak self] _ in self?.addFriend() }, for: .touchUpInside)
        let friendBox = makeFieldBox(symbol: "person.badge.plus", field: friendField, trailing: addButton)

        errorLabel.font = AppFont.caption
        errorLabel.textColor = AppColor.accent
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        // Put it all in a scrolling column
        let content = UIStackView(arrangedSubviews: [
            iconBlock,
            nameBox,
            SectionLabel("Currency"),
            currencySlot,
            SectionLabel("People"),
            peopleSlot,
            friendBox,
            errorLabel
        ])
        content.axis = .vertical
        content.spacing = AppSpacing.s
        content.setCustomSpacing(AppSpacing.xl, after: iconBlock)
        content.setCustomSpacing(AppSpacing.xl, after: nameBox)
        content.setCustomSpacing(AppSpacing.xl, after: currencySlot)
        content.setCustomSpacing(AppSpacing.m, after: peopleSlot)
        content.translatesAutoresizingMaskIntoConstraints = false

        let scroll = UIScrollView()
        scroll.keyboardDismissMode = .interactive
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(content)
        view.addSubview(scroll)

        let inset = AppSpacing.screenInset
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // Stops at the keyboard, so the friend field never hides behind it.
            scroll.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            content.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: AppSpacing.l),
            content.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -AppSpacing.xl),
            content.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: inset),
            content.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -inset)
        ])
    }

    // MARK: - Cards

    private func rebuildCurrencyCard(_ model: NewGroupViewModel) {
        currencySlot.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let card = CardView()
        card.addRow(RowView(title: "Spending in another currency?",
                            subtitle: "For trips abroad",
                            trailing: foreignSwitch))
        if model.isForeign {
            card.addRow(RowView(title: "Trip currency",
                                trailing: makeCurrencyPicker(selectedTitle: model.tripCurrencyTitle)))
            card.addRow(RowView(title: "Your currency",
                                trailing: makeMutedLabel(model.homeCurrencyTitle)))
        } else {
            card.addRow(RowView(title: "Currency",
                                trailing: makeMutedLabel(model.homeCurrencyTitle)))
        }
        currencySlot.addArrangedSubview(card)
    }

    private func rebuildPeopleCard(_ model: NewGroupViewModel) {
        peopleSlot.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let card = CardView()
        card.addRow(RowView(title: "\(model.yourName) (you)",
                            leading: AvatarView(name: model.yourName, isYou: true)))

        for (index, friend) in model.friends.enumerated() {
            let remove = UIButton(type: .system)
            remove.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            remove.tintColor = AppColor.muted
            remove.accessibilityLabel = "Remove \(friend)"
            remove.addAction(UIAction { [weak self] _ in
                self?.presenter.removeFriend(at: index)
            }, for: .touchUpInside)
            card.addRow(RowView(title: friend, leading: AvatarView(name: friend), trailing: remove))
        }
        peopleSlot.addArrangedSubview(card)
    }

    // MARK: - Small helpers

    private func addFriend() {
        presenter.addFriendTapped(name: friendField.text ?? "")
    }

    /// White rounded box with an icon on the left, a text field, and an optional trailing view.
    private func makeFieldBox(symbol: String, field: UITextField, trailing: UIView?) -> UIView {
        let box = UIView()
        box.backgroundColor = AppColor.card
        box.layer.cornerRadius = AppSpacing.cardRadius

        let icon = UIImageView(image: UIImage(systemName: symbol))
        icon.tintColor = AppColor.muted
        icon.setContentHuggingPriority(.required, for: .horizontal)

        var items: [UIView] = [icon, field]
        if let trailing {
            trailing.setContentHuggingPriority(.required, for: .horizontal)
            items.append(trailing)
        }
        let row = UIStackView(arrangedSubviews: items)
        row.alignment = .center
        row.spacing = AppSpacing.m
        row.translatesAutoresizingMaskIntoConstraints = false
        box.addSubview(row)

        NSLayoutConstraint.activate([
            box.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),
            row.topAnchor.constraint(equalTo: box.topAnchor, constant: AppSpacing.s),
            row.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: -AppSpacing.s),
            row.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: AppSpacing.l),
            row.trailingAnchor.constraint(equalTo: box.trailingAnchor, constant: -AppSpacing.l)
        ])
        return box
    }

    private func makeMutedLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = AppFont.body
        label.textColor = AppColor.muted
        return label
    }

    /// "Japanese yen (¥) ⌄" that opens a menu of currencies.
    private func makeCurrencyPicker(selectedTitle: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.title = selectedTitle
        config.image = UIImage(
            systemName: "chevron.up.chevron.down",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 11, weight: .medium))
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.contentInsets = .zero
        config.baseForegroundColor = AppColor.muted
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var out = incoming
            out.font = AppFont.body
            return out
        }

        let button = UIButton(configuration: config)
        button.showsMenuAsPrimaryAction = true
        button.menu = UIMenu(children: presenter.currencyOptions.map { option in
            UIAction(title: option.title, state: option.title == selectedTitle ? .on : .off) { [weak self] _ in
                self?.presenter.tripCurrencySelected(code: option.code)
            }
        })
        return button
    }

    private func makeIconMenu(selected: String) -> UIMenu {
        UIMenu(children: presenter.iconOptions.map { option in
            UIAction(title: option.title,
                     image: UIImage(systemName: option.symbol),
                     state: option.symbol == selected ? .on : .off) { [weak self] _ in
                self?.presenter.iconSelected(option.symbol)
            }
        })
    }
}

// MARK: - Return key

extension NewGroupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === friendField {
            addFriend()          // stay in the field so you can add the next friend
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
