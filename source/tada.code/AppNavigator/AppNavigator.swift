import Foundation
import UIKit
import CocoaLumberjack



protocol NavigatorProtocol {
    associatedtype Destination
}


enum Presentation {
    case push
    case modalWithNavigationBar
    case modalWithNavigationBarFadeIn
    case modal
    case popover(sourceView: UIView, height: CGFloat?, isModal: Bool)
    case replace
}


public enum DismissStyle {
    case popLast
    case popToRoot
    case dismiss
    case dismissAll
}


class AppNavigator: NSObject, NavigatorProtocol, UINavigationControllerDelegate {

    // MARK: - Properties

    var uinvc: UINVC! {
        didSet {
            if let nvc = uinvc {
                if let _oldValue = oldValue {
                    DDLogInfo("\(self).uinvc changed from \(_oldValue) to \(nvc)")
                }
            }
        }
    }


//    var nvc: UINVC {       // 'read-only' property
//        return uinvc
//    }


    // MARK: - Initializer

    override init() {
        super.init()
        DDLogInfo("")

        replaceNavigationController(with: UINVC())
    }


    // MARK: -

    func replaceNavigationController(with newNVC: UINVC) {
        DDLogInfo("")
        uinvc = newNVC
        uinvc.delegate = self
    }


    func viewControllerCount() -> Int {
        return self.uinvc.viewControllers.count
    }


    func printNVCstack(_ nav: UINVC?) {
        if let _nvc = nav {
            DDLogInfo("🥞 \(_nvc) uinvc stack[\(_nvc.viewControllers.count)]:")
            for vc in _nvc.viewControllers {
                DDLogInfo("vc = \(vc)")
            }
        } else {
            DDLogInfo("uinvc = nil")
        }
//        print("\n")
    }


    deinit {
        DDLogWarn("\(self)")
    }


    // MARK: - UINavigationController Delegates
/*
    // http://khanlou.com/2017/05/back-buttons-and-coordinators/
    // "By making the `navigator` into the delegate of the navigation controller,
    // you can maintain the structure of the `navigator`: namely that it is the parent of the navigation controller.
    // When you get the delegate messages that a view controller was transitioned out,
    // you can manually clean up anything that might need to be dealt with."  (... if you want)
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController, animated: Bool) {
//        DDLogVerbose("🌼  \(viewController)")
        // ensure the view controller is dismissed from view.
        guard
            let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(fromViewController) else {
                return
        }
        DDLogVerbose("💥  transitioned from \(fromViewController) in \(self)")
        printNVCstack(nvc: navigationController)
    }
*/
}
