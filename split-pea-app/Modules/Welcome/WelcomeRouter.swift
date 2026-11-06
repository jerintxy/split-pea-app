import UIKit

/// Moves from Welcome to the next screen.
final class WelcomeRouter: WelcomeRouterProtocol {

    private weak var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func showHome(name: String) {
        guard let window else { return }
        // Temporary placeholder. Swap for HomeBuilder.build(...) once the Home module exists.
        let home = UINavigationController(rootViewController: HomePlaceholderViewController(name: name))
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = home
        }
    }
}
