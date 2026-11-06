import UIKit

/// Creates the Home module and connects its parts.
enum HomeBuilder {

    static func build(
        store: UserProfileStoring = UserDefaultsProfileStore(),
        repository: GroupRepositoryProtocol = UserDefaultsGroupRepository()
    ) -> UIViewController {
        let view = HomeViewController()
        let interactor = HomeInteractor(repository: repository, profileStore: store)
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router)

        presenter.view = view
        view.presenter = presenter
        router.viewController = view
        return view
    }
}
