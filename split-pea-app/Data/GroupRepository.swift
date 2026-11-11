import Foundation

/// Where groups are stored. Screens only know this protocol, so the storage can be swapped later.
protocol GroupRepositoryProtocol: AnyObject {
    func allGroups() -> [ExpenseGroup]
    func add(_ group: ExpenseGroup)
}

/// Simple on-phone storage: the groups are saved as JSON in UserDefaults.
final class UserDefaultsGroupRepository: GroupRepositoryProtocol {

    private let key = "groups"

    func allGroups() -> [ExpenseGroup] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let groups = try? JSONDecoder().decode([ExpenseGroup].self, from: data)
        else { return [] }
        return groups
    }

    func add(_ group: ExpenseGroup) {
        var groups = allGroups()
        groups.insert(group, at: 0)   // newest first
        if let data = try? JSONEncoder().encode(groups) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
