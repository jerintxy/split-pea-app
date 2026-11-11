import UIKit

/// Creates the New group module. It comes wrapped in a navigation controller,
/// so it has its own bar with Cancel and Create.
enum NewGroupBuilder {

    static func build(
        onCreated: @escaping () -> Void,
        store: UserProfileStoring = UserDefaultsProfileStore(),
        repository: GroupRepositoryProtocol = UserDefaultsGroupRepository()
    ) -> UIViewController {
        let view = NewGroupViewController()
        let interactor = NewGroupInteractor(repository: repository, profileStore: store)
        let router = NewGroupRouter(onCreated: onCreated)
        let presenter = NewGroupPresenter(interactor: interactor, router: router)

        presenter.view = view
        view.presenter = presenter
        router.viewController = view
        return UINavigationController(rootViewController: view)
    }
}
