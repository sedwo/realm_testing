import UIKit
import CocoaLumberjack
import SnapKit
import RealmSwift



class RootVC: UIViewController {

    private var navigator: AppNavigator!
    private var imageView: UIImageView!

    var userRealm: Realm?


    // MARK: -
    init(withNavigator: AppNavigator) {
        super.init(nibName: nil, bundle: nil)
        DDLogInfo("")

        navigator = withNavigator

        // log all realm sync info
        app.syncManager.logLevel = .all
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

        let userCredentials = UserCredentials(email: "user1@tada.com", password: "password123")

        var fakeToken = APIToken(withToken: newUUID)
        fakeToken.isFake = true
        let userProfile = UserProfile(userCredentials: userCredentials)

        // Override any previous session
        appDelegate._session = Session(token: fakeToken, userProfile: userProfile)
        appSettings.lastUsername = appSession.userProfile.email

        if appSettings.isFirstLogin() {
            // Set user defaults.
            _ = userAppDirectory
        }

        let testButton = UIBarButtonItem(title: "Test Me!", style: .plain, target: self, action: #selector(testing123))
        navigationItem.rightBarButtonItem = testButton
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

    @objc func testing123(_ sender: Any) {
        DDLogInfo("")

        // sign-in
        app.login(credentials: Credentials.emailPassword(email: appSession.userProfile.email,
                                                         password: appSession.userProfile.password)) { [weak self] (result) in

//            let sessions = app.currentUser?.allSessions


                // This call to DispatchQueue.main.sync ensures that any changes to the UI,
                // namely disabling the loading indicator and navigating to the next page,
                // are handled on the UI thread:
                DispatchQueue.main.async {

                    switch result {
                    case .failure(let error):
                        // Auth error: user already exists? Try logging in as that user.
                        DDLogError("Login failed: \(error)")
                        return

                    case .success(let user):    // RLMUser
                        DDLogVerbose("Login succeeded for: \(user)")

                        let car = RLMCar(partitionKey: "user=\(user.id)")
                        car.brand = "Honda"
                        car.colour = "blue"

                        // Open our user realm db.
                        // persist it globally so that it remains connected to the server for syncing.
                        self?.userRealm = RLMCar.getDatabase()
                        RLMCar.createOrUpdateAll(with: [car])

//                        RLMCar.getDatabase { realm in
//                            self?.userRealm = realm
//                            RLMCar.createOrUpdateAll(with: [car])
//                        }


                    }
                }
            }


    }

}
