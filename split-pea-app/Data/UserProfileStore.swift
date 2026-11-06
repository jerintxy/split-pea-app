import Foundation

/// Where the user's display name is kept on this phone.
/// Screens never touch UserDefaults directly; they go through this protocol,
/// so it can be swapped for the real backend later.
protocol UserProfileStoring: AnyObject {
    var name: String? { get set }
}

final class UserDefaultsProfileStore: UserProfileStoring {
    private let key = "userName"

    var name: String? {
        get { UserDefaults.standard.string(forKey: key) }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}
