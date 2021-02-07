import CocoaLumberjack
import RealmSwift



final class Session {
    var userProfile: UserProfile

    // Global realms
    var userRealm: Realm?


    var isSignedIn: Bool {
//        app.currentUser != nil && app.currentUser?.state == .loggedIn && userRealm != nil
        realmApp.currentUser != nil && realmApp.currentUser?.state == .loggedIn
    }

    // MARK: - Initializers(...)
    init(userProfile: UserProfile = UserProfile()) {
        DDLogInfo("")

        self.userProfile = userProfile
    }


//    func copy(with zone: NSZone? = nil) -> Any {
//    }


}
