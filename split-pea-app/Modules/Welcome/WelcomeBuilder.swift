import UIKit

/// Creates the five pieces and connects them. This is the only place that knows about all of them.
enum WelcomeBuilder {

    static func build(window: UIWindow, store: UserProfileStoring) -> UIViewController {
        let view = WelcomeViewController()
        let interactor = WelcomeInteractor(store: store)
        let router = WelcomeRouter(window: window)
        let presenter = WelcomePresenter(interactor: interactor, router: router)

        presenter.view = view      // presenter -> view (weak)
        view.presenter = presenter // view -> presenter (strong, keeps everything alive)
        return view
    }
}
