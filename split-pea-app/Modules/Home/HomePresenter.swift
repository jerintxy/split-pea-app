import Foundation

/// Turns the data into what the Home screen shows, and decides what each tap does.
final class HomePresenter: HomePresenterProtocol {

    weak var view: HomeViewProtocol?

    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol
    private var rows: [GroupRowModel] = []

    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func viewWillAppear() {
        refresh()
    }

    func addGroupTapped() {
        router.showNewGroup { [weak self] in
            self?.refresh()
        }
    }

    func groupSelected(id: UUID) {
        guard let row = rows.first(where: { $0.id == id }) else { return }
        router.showGroup(id: id, name: row.title)
    }

    // MARK: - Building the screen

    private func refresh() {
        let summaries = interactor.loadSummaries()

        let owed = summaries.map(\.balanceCents).filter { $0 > 0 }.reduce(0, +)
        let owe = -summaries.map(\.balanceCents).filter { $0 < 0 }.reduce(0, +)
        let net = owed - owe

        rows = summaries.map(makeRow)

        view?.show(HomeViewModel(
            greeting: "Hi, \(interactor.userName())",
            balance: MoneyFormat.signedSGD(cents: net),
            balanceTone: tone(for: net),
            owed: MoneyFormat.sgd(cents: owed),
            owe: MoneyFormat.sgd(cents: owe),
            groups: rows
        ))
    }

    private func makeRow(_ summary: GroupSummary) -> GroupRowModel {
        let group = summary.group
        let count = group.memberNames.count
        var subtitle = count == 1 ? "1 person" : "\(count) people"
        if let symbol = group.foreignSymbol {
            subtitle += " · Trip in \(symbol)"
        }
        let defaultIcon = group.foreignCurrencyCode == nil ? "person.2" : "airplane"
        let balance = summary.balanceCents
        return GroupRowModel(
            id: group.id,
            title: group.name,
            subtitle: subtitle,
            iconName: group.iconName ?? defaultIcon,
            amountText: balance == 0 ? "Settled up" : MoneyFormat.signedSGD(cents: balance),
            tone: tone(for: balance)
        )
    }

    private func tone(for cents: Int) -> AmountTone {
        cents > 0 ? .positive : (cents < 0 ? .negative : .settled)
    }
}
