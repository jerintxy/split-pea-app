import UIKit

/// The Welcome screen (option C): green top with the Pea and headline, white sheet with name field and button.
/// It only draws things and reports taps to the presenter.
final class WelcomeViewController: UIViewController, WelcomeViewProtocol {

    var presenter: WelcomePresenterProtocol!   // set by WelcomeBuilder

    private let nameField = UITextField()
    private let getStartedButton = PrimaryButton(title: "Get started")
    private let errorLabel = UILabel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.primary
        buildLayout()
        presenter.viewDidLoad()
    }

    // MARK: - WelcomeViewProtocol

    func setGetStartedEnabled(_ enabled: Bool) {
        getStartedButton.isEnabled = enabled
    }

    func showError(_ message: String?) {
        errorLabel.text = message
        errorLabel.isHidden = (message == nil)
    }

    // MARK: - Layout

    private func buildLayout() {
        // Top: Pea + headline
        let pea = makePeaView()

        let headline = UILabel()
        headline.text = "Split bills,\neasy peasy"
        headline.numberOfLines = 2
        headline.textAlignment = .center
        headline.font = .systemFont(ofSize: 34, weight: .semibold)
        headline.textColor = AppColor.onPrimary
        headline.adjustsFontForContentSizeCategory = true

        let hero = UIStackView(arrangedSubviews: [pea, headline])
        hero.axis = .vertical
        hero.alignment = .center
        hero.spacing = AppSpacing.l
        hero.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hero)

        // Bottom: white sheet
        let sheet = UIView()
        sheet.backgroundColor = AppColor.card
        sheet.layer.cornerRadius = 28
        sheet.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        sheet.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sheet)

        configureNameField()

        errorLabel.font = AppFont.caption
        errorLabel.textColor = AppColor.accent
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        getStartedButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.view.endEditing(true)
            self.presenter.getStartedTapped(name: self.nameField.text ?? "")
        }, for: .touchUpInside)

        let content = UIStackView(arrangedSubviews: [nameField, errorLabel, getStartedButton])
        content.axis = .vertical
        content.spacing = AppSpacing.m
        content.translatesAutoresizingMaskIntoConstraints = false
        sheet.addSubview(content)

        // The space above the sheet, where the hero is centred.
        let heroArea = UILayoutGuide()
        view.addLayoutGuide(heroArea)

        NSLayoutConstraint.activate([
            sheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheet.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // The content sits on top of the keyboard when it appears, and on the safe area otherwise.
            content.leadingAnchor.constraint(equalTo: sheet.leadingAnchor, constant: AppSpacing.screenInset),
            content.trailingAnchor.constraint(equalTo: sheet.trailingAnchor, constant: -AppSpacing.screenInset),
            content.topAnchor.constraint(equalTo: sheet.topAnchor, constant: AppSpacing.xl),
            content.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -AppSpacing.l),

            heroArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            heroArea.bottomAnchor.constraint(equalTo: sheet.topAnchor),
            heroArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            heroArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            hero.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hero.centerYAnchor.constraint(equalTo: heroArea.centerYAnchor)
        ])

        // Tap anywhere to close the keyboard.
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func configureNameField() {
        nameField.placeholder = "Your name"
        nameField.font = AppFont.body
        nameField.textColor = AppColor.text
        nameField.backgroundColor = AppColor.background
        nameField.layer.cornerRadius = AppSpacing.buttonRadius
        nameField.autocapitalizationType = .words
        nameField.autocorrectionType = .no
        nameField.returnKeyType = .done
        nameField.clearButtonMode = .whileEditing
        nameField.delegate = self
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.heightAnchor.constraint(equalToConstant: AppSpacing.buttonHeight).isActive = true

        // Left padding inside the field
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: AppSpacing.l, height: 1))
        nameField.leftViewMode = .always

        nameField.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.presenter.nameChanged(self.nameField.text ?? "")
        }, for: .editingChanged)
    }

    /// Uses your "Pea" image if you add one to Assets.xcassets, otherwise a leaf symbol as a stand-in.
    private func makePeaView() -> UIImageView {
        let imageView: UIImageView
        if let image = UIImage(named: "Pea") {
            imageView = UIImageView(image: image)
        } else {
            imageView = UIImageView(image: UIImage(systemName: "leaf.fill"))
            imageView.tintColor = AppColor.onPrimary
        }
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 110),
            imageView.heightAnchor.constraint(equalToConstant: 110)
        ])
        return imageView
    }
}

// MARK: - UITextFieldDelegate

extension WelcomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
