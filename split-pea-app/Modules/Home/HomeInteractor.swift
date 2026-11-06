import Foundation

/// The data and rules behind the Home screen. No UIKit in here.
final class HomeInteractor: HomeInteractorProtocol {

    private let repository: GroupRepositoryProtocol
    private let profileStore: UserProfileStoring

    init(repository: GroupRepositoryProtocol, profileStore: UserProfileStoring) {
        self.repository = repository
        self.profileStore = profileStore
    }

    func userName() -> String {
        profileStore.name ?? "there"
    }

    func loadSummaries() -> [GroupSummary] {
        // There are no expenses yet, so every balance is 0 for now.
        // Once expenses exist, this is where each group's balance gets worked out.
        repository.allGroups().map { GroupSummary(group: $0, balanceCents: 0) }
    }

    func addSampleGroup() {
        let samples: [(String, [String], String?)] = [
            ("Japan trip", ["John", "Julie", "Ethan", "Alice"], "JPY"),
            ("Uni friends", ["John", "Julie", "Ethan", "Alice"], nil),
            ("Flatmates", ["John", "Julie", "Ethan"], nil),
            ("Hawker night", ["John", "Julie", "Ethan", "Alice"], nil)
        ]
        let next = samples[repository.allGroups().count % samples.count]
        repository.add(ExpenseGroup(name: next.0, memberNames: next.1, foreignCurrencyCode: next.2))
    }
}
