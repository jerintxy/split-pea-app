import UIKit

/// Closes the New group sheet.
final class NewGroupRouter: NewGroupRouterProtocol {

    weak var viewController: UIViewController?
    private let onCreated: () -> Void

    init(onCreated: @escaping () -> Void) {
        self.onCreated = onCreated
    }

    func close(created: Bool) {
        // Refresh Home first, so the new group is already there as the sheet slides away.
        if created { onCreated() }
        viewController?.dismiss(animated: true)
    }
}
