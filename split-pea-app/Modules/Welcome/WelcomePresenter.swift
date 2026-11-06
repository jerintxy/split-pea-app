import Foundation

/// Decides what the Welcome screen shows and what happens on each tap. No UIKit in here either.
final class WelcomePresenter: WelcomePresenterProtocol {

    // weak, because the screen owns the presenter (avoids a retain cycle)
    weak var view: WelcomeViewProtocol?

    private let interactor: WelcomeInteractorProtocol
    private let router: WelcomeRouterProtocol

    init(interactor: WelcomeInteractorProtocol, router: WelcomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        view?.setGetStartedEnabled(false)
    }

    func nameChanged(_ text: String) {
        view?.showError(nil)
        view?.setGetStartedEnabled(interactor.isValid(name: text))
    }

    func getStartedTapped(name: String) {
        guard interactor.isValid(name: name) else {
            view?.showError("Enter a name up to 30 characters")
            return
        }
        let saved = interactor.saveName(name)
        router.showHome(name: saved)
    }
}
