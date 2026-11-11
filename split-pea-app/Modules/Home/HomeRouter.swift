import UIKit

/// Moves from Home to other screens.
final class HomeRouter: HomeRouterProtocol {

    // weak: the screen owns the router's navigation, not the other way round
    weak var viewController: UIViewController?

    func showNewGroup(onCreated: @escaping () -> Void) {
        let screen = NewGroupBuilder.build(onCreated: onCreated)
        viewController?.present(screen, animated: true)
    }

    func showGroup(id: UUID, name: String) {
        // Placeholder until the group screen (Expenses | Balances | Members) is built.
        let screen = GroupPlaceholderViewController(groupName: name)
        viewController?.navigationController?.pushViewController(screen, animated: true)
    }
}
