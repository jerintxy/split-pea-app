import Foundation

/// Rules and saving for New group. No UIKit in here.
final class NewGroupInteractor: NewGroupInteractorProtocol {

    private let repository: GroupRepositoryProtocol
    private let profileStore: UserProfileStoring

    init(repository: GroupRepositoryProtocol, profileStore: UserProfileStoring) {
        self.repository = repository
        self.profileStore = profileStore
    }

    var userName: String {
        profileStore.name ?? "You"
    }

    let currencyOptions: [CurrencyOption] = [
        CurrencyOption(code: "JPY", title: "Japanese yen (¥)"),
        CurrencyOption(code: "KRW", title: "Korean won (₩)"),
        CurrencyOption(code: "THB", title: "Thai baht (฿)"),
        CurrencyOption(code: "MYR", title: "Malaysian ringgit (RM)"),
        CurrencyOption(code: "IDR", title: "Indonesian rupiah (Rp)"),
        CurrencyOption(code: "USD", title: "US dollar ($)"),
        CurrencyOption(code: "EUR", title: "Euro (€)"),
        CurrencyOption(code: "GBP", title: "British pound (£)"),
        CurrencyOption(code: "AUD", title: "Australian dollar (A$)")
    ]

    func isValidGroupName(_ name: String) -> Bool {
        let cleaned = clean(name)
        return !cleaned.isEmpty && cleaned.count <= 40
    }

    func problemAddingFriend(_ name: String, existing: [String]) -> String? {
        let cleaned = clean(name)
        if cleaned.isEmpty { return "Type a name first" }
        if cleaned.count > 30 { return "Names can be up to 30 characters" }
        let taken = ([userName] + existing).contains {
            $0.caseInsensitiveCompare(cleaned) == .orderedSame
        }
        if taken { return "\(cleaned) is already in the group" }
        return nil
    }

    func createGroup(name: String, iconName: String, foreignCurrencyCode: String?, friends: [String]) {
        let group = ExpenseGroup(
            name: clean(name),
            memberNames: [userName] + friends.map(clean),
            foreignCurrencyCode: foreignCurrencyCode,
            iconName: iconName
        )
        repository.add(group)
    }

    private func clean(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
