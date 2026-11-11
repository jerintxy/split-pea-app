import Foundation

/// Holds what the user has filled in so far, and decides what the screen shows.
final class NewGroupPresenter: NewGroupPresenterProtocol {

    weak var view: NewGroupViewProtocol?

    private let interactor: NewGroupInteractorProtocol
    private let router: NewGroupRouterProtocol

    // What the user has filled in so far
    private var name = ""
    private var iconName = "person.2"
    private var iconChosenByUser = false
    private var isForeign = false
    private var tripCurrencyCode = "JPY"
    private var friends: [String] = []

    let iconOptions: [IconOption] = [
        IconOption(symbol: "airplane", title: "Trip"),
        IconOption(symbol: "person.2", title: "Friends"),
        IconOption(symbol: "graduationcap", title: "School"),
        IconOption(symbol: "house", title: "Home"),
        IconOption(symbol: "fork.knife", title: "Food"),
        IconOption(symbol: "cart", title: "Shopping"),
        IconOption(symbol: "heart", title: "Family")
    ]

    var currencyOptions: [CurrencyOption] { interactor.currencyOptions }

    init(interactor: NewGroupInteractorProtocol, router: NewGroupRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        render()
    }

    func nameChanged(_ text: String) {
        name = text
        render()
    }

    func iconSelected(_ symbol: String) {
        iconName = symbol
        iconChosenByUser = true
        render()
    }

    func foreignCurrencyToggled(_ isOn: Bool) {
        isForeign = isOn
        // Until the user picks an icon themselves, follow the switch: plane for trips.
        if !iconChosenByUser {
            iconName = isOn ? "airplane" : "person.2"
        }
        render()
    }

    func tripCurrencySelected(code: String) {
        tripCurrencyCode = code
        render()
    }

    func addFriendTapped(name friendName: String) {
        if let problem = interactor.problemAddingFriend(friendName, existing: friends) {
            view?.showError(problem)
            return
        }
        friends.append(friendName.trimmingCharacters(in: .whitespacesAndNewlines))
        view?.showError(nil)
        view?.clearFriendField()
        render()
    }

    func removeFriend(at index: Int) {
        guard friends.indices.contains(index) else { return }
        friends.remove(at: index)
        render()
    }

    func createTapped() {
        guard interactor.isValidGroupName(name) else {
            view?.showError("Give the group a name")
            return
        }
        interactor.createGroup(
            name: name,
            iconName: iconName,
            foreignCurrencyCode: isForeign ? tripCurrencyCode : nil,
            friends: friends
        )
        router.close(created: true)
    }

    func cancelTapped() {
        router.close(created: false)
    }

    private func render() {
        let tripTitle = currencyOptions.first { $0.code == tripCurrencyCode }?.title ?? tripCurrencyCode
        view?.show(NewGroupViewModel(
            iconName: iconName,
            canCreate: interactor.isValidGroupName(name),
            isForeign: isForeign,
            tripCurrencyTitle: tripTitle,
            homeCurrencyTitle: "Singapore dollar (S$)",
            yourName: interactor.userName,
            friends: friends
        ))
    }
}
