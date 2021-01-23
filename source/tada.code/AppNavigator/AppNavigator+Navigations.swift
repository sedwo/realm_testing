import Foundation
import UIKit
import CocoaLumberjack



extension AppNavigator {

    // Here we define a set of supported destinations.
    enum Destination {
        case LogoScreen
        case TestVC1Screen
//        case AppSettingsScreen
    }


    func makeViewController(for destination: Destination, with parameters: Any ...) -> UIViewController {
        switch destination {
        case .LogoScreen:
            let vc = RootVC(withNavigator: self)
            return vc

        case .TestVC1Screen:
            let vc = TestVC1(navigator: self)
            return vc

/*
        case .SignInScreen:
//            let vm = SignInViewModel(withNavigator: self)
//            let vc = SignInVC(withViewModel: vm)
//            return vc

            // Stand-alone modal with its own Navigator.
            let vm = SignInViewModel(withNavigator: AppNavigator())
            let vc = SignInVC(withViewModel: vm)
            let modalNVC = UINVC(rootViewController: vc)
            // override new VC Navigator for modal, with modal specific NVC.
            vm.navigator.replaceNavigationController(with: modalNVC)
            return modalNVC

*/

        }


    } // makeViewController ...
}



// VC delegate functions
extension AppNavigator {

    func testVC1() {
        DDLogVerbose("")

        navigate(to: .TestVC1Screen, animated: false)
    }



/*
    func signInSuccess() {
        exitVC(with: .dismissAll)   // "kill -9" the stand-alone appNavigator
//        exitVC(with: .dismiss)

        // Mark the logfile of a sign-in for easier separation of multiple users.
        DDLogDebug(" ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~ ~ ⚠️ ~ ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~ ~ ⚠️")
        DDLogDebug("sign in for: \(appSession.userProfile.email)")
        DDLogDebug(" ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~ ~ ⚠️ ~ ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~ ~ ⚠️")

        let rootAppNavigator = rootNavigator(for: .center)  // used here due to having a separate modal VC.
        if rootAppNavigator.viewControllerCount() <= 1 {
            rootAppNavigator.navigate(to: .ProjectsScreen, animated: false)
        }
    }

*/

}
