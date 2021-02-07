import UIKit
import CocoaLumberjack
import SnapKit
import RealmSwift



class RootVC: UIViewController, IndicatorProtocol {

    private var navigator: AppNavigator!
    private var imageView: UIImageView!

//    var myRealm: Realm?


    // MARK: -
    init(withNavigator: AppNavigator) {
        super.init(nibName: nil, bundle: nil)
        DDLogInfo("")

        navigator = withNavigator
    }


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        DDLogInfo("")
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        DDLogInfo("")
    }


    override func loadView() {
        // (1.) Do not call super!
        // (2.) *MUST* return a view if this method is implemented.
        // https://stackoverflow.com/questions/4875521/loadview-called-multiple-times-when-view-property-not-set
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.lightGray
//        DDLogVerbose("view.bounds = \(view.bounds)")

        imageView = UIImageView(image: UIImage(named: "AppLogo"))
        imageView.contentMode = .scaleAspectFit

        view.setSubviewForAutoLayout(imageView)
    }


    override func updateViewConstraints() {
        super.updateViewConstraints()
    }


    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        DDLogInfo("")
        view.setNeedsUpdateConstraints()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        DDLogInfo("")

        let testButton = UIBarButtonItem(title: "Sign in", style: .plain, target: self, action: #selector(signIn))
        navigationItem.rightBarButtonItem = testButton

        if let user = realmApp.currentUser {
            _ = user.logOut()
        }
    }


    override func viewWillLayoutSubviews() {
        imageView.snp.remakeConstraints { (make) -> Void in
            make.width.height.equalToSuperview().multipliedBy(0.5)
            make.center.equalToSuperview()
        }

    }


    // MARK: - lock rotation control, except for iPad
    override var shouldAutorotate: Bool {
        return hardwareDevice.isPad
    }


    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return hardwareDevice.isPhone ? UIInterfaceOrientationMask.portrait : UIInterfaceOrientationMask.all
    }


    deinit {
        DDLogWarn("\(self)")
    }

}


// MARK: - testing...

extension RootVC {

    @objc func signIn(_ sender: Any) {
        DDLogInfo("")

        if appSession.isSignedIn {
            DDLogVerbose("isSignedIn: user = \(realmApp.currentUser!.id)")
            navigator.testVC1()
        } else {

            // check: if we have a data connection for this auth
            if !isDataConnection {
                showErrorAlert(NetworkError.NetworkConnectionLost.message)
                return
            }

            /// Testing.
            let userCredentials = UserCredentials(email: "user1@tada.com", password: "password123")
            appSession.userProfile = UserProfile(userCredentials: userCredentials)

            let appCredentials = Credentials.emailPassword(email: userCredentials.email, password: userCredentials.password)

            // sign-in
            realmApp.login(credentials: appCredentials) { [weak self] (result) in
                // *IMPORTANT*
                // Realm completion handlers are not necessarily called on the UI thread.
                // This call to DispatchQueue.main.sync ensures that any changes to the UI,
                // namely disabling any loading indicator and navigating to the next page,
                // are handled on the UI thread.
                    switch result {
                    case .failure(let error):
                        DDLogError("Login failed: \(error)")
                        self?.showErrorAlert(AuthError.InvalidCredentials.message)

                    case .success(let user):    // RLMUser
                        DDLogVerbose("Login succeeded for: \(user.id)")
/*
                        // Background thread.
                        let config = app.currentUser!.configuration(partitionValue: "user=\(user.id)")
                        let realmConfiguration = Realm.setup(config: config) // update with other params.
                        let userRealm = Realm.open(withConfig: realmConfiguration)
                        self?.myRealm = userRealm
*/

                        DispatchQueue.main.async {
                            // main thread.
                            self?.onSignIn(user)
//                            appSession.userRealm?.syncSession?.resume()
//                            realmApp.syncManager.
//                            appSession.userRealm?.syncSession.


                            self?.navigator.testVC1()
                        }
                }
            }
        }


    }


    private func onSignIn(_ user: RealmSwift.User) {
        // Confirm user's private app folder is created.
        _ = userAppDirectory

        // Setup, open, and persist a realm db during this session.
//        let config = app.currentUser!.configuration(partitionValue: "user=\(appSession.userProfile.email)")
//        let config = realmApp.currentUser!.configuration(partitionValue: Partition.user)

//        let realmConfiguration = Realm.setup(config: config) // update with other params.
//        let userRealm = Realm.open(withConfig: realmConfiguration)
//        let userRealm = Realm.open(withConfig: config)

        // *NOTE*: Persist realm(s) during an open session to allow them to sync.
        appSession.userRealm = RLMDefaults.openRealm()

//        if let realm = appSession.userRealm,
//           let syncConfiguration = realm.configuration.syncConfiguration,
//           let partitionValue = syncConfiguration.partitionValue?.stringValue {
//            realmPartitionValue = partitionValue


        // *NOTE*: Persist realm(s) during an open session to allow them to sync.
//        appSession.userRealm = userRealm
//        self.myRealm = userRealm


//        Realm.openAsync(withConfig: config) { realm in
//            self.userRealm = realm
//        }
//        self.userRealm = userRealm


/*
        appSettings.userLoginCount += 1
        if appSettings.isFirstLogin() {
            /// First time, fresh install, new user, etc.  Set any defaults.
        }

        /// Track app version in case we need to perform any custom migration upon an update.
        let previousAppVersion = appSettings.appVersion ?? ""
        let currentAppVersion = Bundle.main.versionNumber

        let versionCompare = previousAppVersion.compare(currentAppVersion, options: .numeric)
        if versionCompare == .orderedSame {
            DDLogVerbose("same == version")
            // nothing to do.

        } else if versionCompare == .orderedAscending {
            /// previousAppVersion < currentAppVersion
            DDLogVerbose("(previousAppVersion [\(previousAppVersion)] < newAppVersion [\(currentAppVersion)])  [UPGRADE!]  🌈")
            DDLogVerbose("(.. or it's a fresh install...)")

            // critical upgrades..

        } else if versionCompare == .orderedDescending {
            // previousAppVersion > currentAppVersion
            DDLogVerbose("🤔 - from the future?")
        }

        // done.
        appSettings.appVersion = Bundle.main.versionNumber
*/
    }


}



/*
extension Realm {

    func createOrUpdateAll(with objects: [Object], update: Bool = true) {
/*
        // Validate `partitionKey == partitionValue` for this realm.
        let objectPartitionKey = objects.first?.value(forKeyPath: "_partition") as! String
        var realmPartitionValue: String

        if let syncConfiguration = self.configuration.syncConfiguration,
           let partitionValue = syncConfiguration.partitionValue?.stringValue {
            realmPartitionValue = partitionValue
        } else {
            DDLogError("Realm configuration error: not a syncing realm. 💥")
            fatalError("Realm configuration error: not a syncing realm. 💥")
       }

        if objectPartitionKey != realmPartitionValue {
            DDLogError("partitionKey ≠ partitionValue 💥")
            fatalError("partitionKey ≠ partitionValue 💥")
        }
*/
        autoreleasepool {
            do {
                try self.safeWrite {
                    self.add(objects, update: update ? .all : .error)
                }
            } catch let error {
                DDLogError("Database error: \(error)")
                fatalError("Database error: \(error)")
            }
        }


    }


    static func setup(config: Realm.Configuration) -> Realm.Configuration {
        var realmConfig = config

//        realmConfig.fileURL = userRealmFile

        realmConfig.shouldCompactOnLaunch = { (totalBytes: Int, usedBytes: Int) -> Bool in
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
            bcf.countStyle = .file
            let totalBytesString = bcf.string(fromByteCount: Int64(totalBytes))
            let usedBytesString = bcf.string(fromByteCount: Int64(usedBytes))

            DDLogInfo("size_of_realm_file: \(totalBytesString), used_bytes: \(usedBytesString)")
            let utilization = Double(usedBytes) / Double(totalBytes) * 100.0
            DDLogInfo(String(format: "utilization: %.0f%%", utilization))

            // totalBytes refers to the size of the file on disk in bytes (data + free space)
            // usedBytes refers to the number of bytes used by data in the file

            // Compact if the file is over 100mb in size and less than 60% 'used'
            let filesizeMB = 100 * 1024 * 1024
            let compactRealm: Bool = (totalBytes > filesizeMB) && (Double(usedBytes) / Double(totalBytes)) < 0.6

            if compactRealm {
                DDLogError("Compacting Realm database.")
            }

            return compactRealm
        }

        return realmConfig
    }


    static func open(withConfig: Realm.Configuration? = nil) -> Realm? {
        do {
            var config: Realm.Configuration

            if let c = withConfig {
                config = c
            } else {  // default
                let userConfig = realmApp.currentUser!.configuration(partitionValue: "user=\(appSession.userProfile.email)")
                config = Self.setup(config: userConfig)
            }

            return try Realm(configuration: config)

        } catch let error {
            DDLogError("Database error: \(error)")
            fatalError("Database error: \(error)")
        }
    }


    static func openAsync(withConfig: Realm.Configuration? = nil, completion:@escaping (_ realm: Realm?) -> Void) {
        var config: Realm.Configuration

        if let c = withConfig {
            config = c
        } else {  // default
            let userConfig = realmApp.currentUser!.configuration(partitionValue: "user=\(appSession.userProfile.email)")
            config = Self.setup(config: userConfig)
        }

        // Open the realm asynchronously so that it downloads the remote copy before opening the local copy.
        Realm.asyncOpen(configuration: config) { result in
            switch result {
            case .failure(let error):
                DDLogError("Database error: \(error)")
                fatalError("Database error: \(error)")
            case .success(let userRealm):
                completion(userRealm)
            }
        }
    }


}
*/
