import Foundation

// The four contracts of the Welcome module. Each layer only knows the others through these protocols.

/// What the Presenter may ask the screen to do.
protocol WelcomeViewProtocol: AnyObject {
    func setGetStartedEnabled(_ enabled: Bool)
    func showError(_ message: String?)
}

/// What the screen may tell the Presenter.
protocol WelcomePresenterProtocol: AnyObject {
    func viewDidLoad()
    func nameChanged(_ text: String)
    func getStartedTapped(name: String)
}

/// The rules and data: is the name valid, and save it.
protocol WelcomeInteractorProtocol: AnyObject {
    func isValid(name: String) -> Bool
    /// Saves the name and returns the cleaned-up version.
    func saveName(_ name: String) -> String
}

/// Moving to other screens.
protocol WelcomeRouterProtocol: AnyObject {
    func showHome(name: String)
}
