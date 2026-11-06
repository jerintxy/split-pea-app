import UIKit

/// Temporary stand-in for the Home screen, so Welcome has somewhere to go.
/// Delete this when the real Home module is built.
final class HomePlaceholderViewController: UIViewController {

    private let name: String

    init(name: String) {
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background

        let label = UILabel()
        label.text = "Hi, \(name)"
        label.font = AppFont.largeTitle
        label.textColor = AppColor.text
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppSpacing.screenInset),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppSpacing.l)
        ])
    }
}
