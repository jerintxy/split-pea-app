import Foundation

// MARK: - What the screen shows (built by the presenter, drawn by the view)

struct HomeViewModel {
    let greeting: String          // "Hi, John"
    let balance: String           // "+S$40.80"
    let balanceTone: AmountTone
    let owed: String              // "S$63.80"
    let owe: String               // "S$23.00"
    let groups: [GroupRowModel]
}

struct GroupRowModel {
    let id: UUID
    let title: String             // "Japan trip"
    let subtitle: String          // "4 people · Trip in ¥"
    let iconName: String          // SF Symbol name
    let amountText: String        // "+S$54.80" or "Settled up"
    let tone: AmountTone
}

enum AmountTone {
    case positive, negative, settled
}

// MARK: - The four contracts of the Home module

protocol HomeViewProtocol: AnyObject {
    func show(_ model: HomeViewModel)
}

protocol HomePresenterProtocol: AnyObject {
    func viewWillAppear()
    func addGroupTapped()
    func groupSelected(id: UUID)
}

protocol HomeInteractorProtocol: AnyObject {
    func userName() -> String
    func loadSummaries() -> [GroupSummary]
}

protocol HomeRouterProtocol: AnyObject {
    /// Opens New group. `onCreated` runs after a group is saved, so Home can refresh.
    func showNewGroup(onCreated: @escaping () -> Void)
    func showGroup(id: UUID, name: String)
}
