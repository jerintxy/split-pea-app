import Foundation

// MARK: - Options and what the screen shows

struct CurrencyOption {
    let code: String     // "JPY"
    let title: String    // "Japanese yen (¥)"
}

struct IconOption {
    let symbol: String   // SF Symbol name
    let title: String    // "Trip"
}

struct NewGroupViewModel {
    let iconName: String
    let canCreate: Bool
    let isForeign: Bool
    let tripCurrencyTitle: String
    let homeCurrencyTitle: String
    let yourName: String
    let friends: [String]
}

// MARK: - The four contracts of the New group module

protocol NewGroupViewProtocol: AnyObject {
    func show(_ model: NewGroupViewModel)
    func showError(_ message: String?)
    func clearFriendField()
}

protocol NewGroupPresenterProtocol: AnyObject {
    var iconOptions: [IconOption] { get }
    var currencyOptions: [CurrencyOption] { get }

    func viewDidLoad()
    func nameChanged(_ text: String)
    func iconSelected(_ symbol: String)
    func foreignCurrencyToggled(_ isOn: Bool)
    func tripCurrencySelected(code: String)
    func addFriendTapped(name: String)
    func removeFriend(at index: Int)
    func createTapped()
    func cancelTapped()
}

protocol NewGroupInteractorProtocol: AnyObject {
    var userName: String { get }
    var currencyOptions: [CurrencyOption] { get }
    func isValidGroupName(_ name: String) -> Bool
    /// Returns a message explaining why the friend can't be added, or nil if it's fine.
    func problemAddingFriend(_ name: String, existing: [String]) -> String?
    func createGroup(name: String, iconName: String, foreignCurrencyCode: String?, friends: [String])
}

protocol NewGroupRouterProtocol: AnyObject {
    func close(created: Bool)
}
