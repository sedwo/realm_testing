import UIKit
import CocoaLumberjack
import IHProgressHUD
import DeviceKit
import Connectivity



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - AppDelegate Singleton GLOBALS

    // https://stackoverflow.com/questions/45832155/how-do-i-refactor-my-code-to-call-appdelegate-on-the-main-thread/45833540#45833540
    static var _applicationDelegate: AppDelegate!   // treat as #internal.  Use Global: `appDelegate` instead to read.  Underscore to write.

    let connectivity: Connectivity = Connectivity()

    var _isDataConnection: Bool = false     // treat as #internal.  Use Global: `isDataConnection` instead to read.  Underscore to write.

    let _device: Device = {                 // treat as #internal.  Use Global: `hardwareDevice` instead to read.  Underscore to write.
        return Device.current
    }()

    var _session: Session = Session()       // treat as #internal.  Use Global: `appSession` instead to read.  Underscore to write.

    var _loggerDirectory: URL = URL(fileURLWithPath: "")    // location of all log files.
    var _appSettings: AppSettings = AppSettings()

//    var _isShuttingDown: Bool = false


    // MARK: -

    override init() {
        IHProgressHUD.set(defaultMaskType: .clear)
        IHProgressHUD.setHUD(backgroundColor: #colorLiteral(red: 0.7610064149, green: 0.759601295, blue: 0.8178459406, alpha: 1))
        IHProgressHUD.set(foregroundColor: Theme.slateGray.mainColor)

        super.init()
        AppDelegate._applicationDelegate = self

        setupLoggingFramework()
        DDLogInfo("")

//        if appSettings.isTesting {
//            DDLogError("~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~")
//            DDLogError(" ATTENTION!  SYSTEM UNDER TEST -")
//            DDLogError(" ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~\n")
//        }

        // Programmatically enabling CFNetwork diagnostic logging:
        // https://stackoverflow.com/a/48971763/7599
//        setenv("CFNETWORK_DIAGNOSTICS", "2", 1)
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // do only pure app launch stuff, not interface stuff

        DDLogDebug(appNameVersionAndBuildDateString())
//        DDLogDebug("server url string: \(appSettings.serverURLstring)")

        let connectivityChanged: (Connectivity) -> Void = { [weak self] connectivity in
            self?.updateConnectionStatus(connectivity.status)
        }

        connectivity.whenConnected = connectivityChanged
        connectivity.whenDisconnected = connectivityChanged
        connectivity.framework = .network
        connectivity.startNotifier()

        #if DEBUG
//            DDLogDebug("#DEBUG build❕  Fabric.with([Crashlytics.self]) DISABLED.  ❕")
        #else
//            DDLogDebug("#RELEASE buid ☑️ Fabric.with([Crashlytics.self]) ENABLED.  ☑️")
//            Fabric.with([Crashlytics.self])
        #endif

//        Theme.slateGray.apply()

        DDLogInfo("")
        return true
    }

/*
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // Handle OAuth callback
        applicationHandle(url: url)

        return true
    }
*/

    func applicationWillTerminate(_ application: UIApplication) {
        DDLogDebug("")
    }


}


extension AppDelegate {

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}



/*
// MARK: handle callback url
extension AppDelegate {

    func applicationHandle(url: URL) {
        if url.host == "oauth-callback" {
            DDLogVerbose("🔑 Handle \"oauth-callback\"")
            DDLogVerbose("url = \(url)")
//            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
//                if let queryItems = components.queryItems {
//                    for queryItem in queryItems {
//                        DDLogVerbose("[URLComponent] \(queryItem.name): \(queryItem.value ?? "<>")")
//                    }
//                }
//            }

            OAuthSwift.handle(url: url)
        } else {
            DDLogVerbose("🔑  ¯\\_(ツ)_/¯  ⚠️")
            // Google provider is the only one with your.bundle.id url schema.
            OAuthSwift.handle(url: url)
        }
    }

}
*/
