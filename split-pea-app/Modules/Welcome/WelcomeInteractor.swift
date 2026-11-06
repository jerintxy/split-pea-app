import Foundation

/// Business rules for the Welcome screen. No UIKit in here.
final class WelcomeInteractor: WelcomeInteractorProtocol {

    private let store: UserProfileStoring
    private let maxLength = 30

    init(store: UserProfileStoring) {
        self.store = store
    }

    func isValid(name: String) -> Bool {
        let cleaned = clean(name)
        return !cleaned.isEmpty && cleaned.count <= maxLength
    }

    func saveName(_ name: String) -> String {
        let cleaned = clean(name)
        store.name = cleaned
        return cleaned
    }

    private func clean(_ name: String) -> String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
