import UIKit

/// Temporary screen shown when you tap a group. Replaced by the real group screen later.
final class GroupPlaceholderViewController: UIViewController {

    private let groupName: String

    init(groupName: String) {
        self.groupName = groupName
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = groupName
        view.backgroundColor = AppColor.background

        let label = UILabel()
        label.text = "Expenses, Balances and Members\ncome next."
        label.font = AppFont.body
        label.textColor = AppColor.muted
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // Home hides the navigation bar, so show it again here.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
