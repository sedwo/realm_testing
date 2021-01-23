import Foundation
import UIKit
import CocoaLumberjack



extension AppNavigator {

    func exitVC(with dismissStyle: DismissStyle, animated: Bool = true, completion: (() -> Swift.Void)? = nil) {

        switch dismissStyle {
        case .popLast:
            if let lastVC = uinvc.viewControllers.last {
                DDLogInfo(".popLast: \(lastVC)")
            }
            uinvc.popViewController(animated: animated) {
                if completion != nil {
                    completion!()
                }
            }

        case .popToRoot:
            DDLogInfo(".popToRoot")
            uinvc.popToRootViewController(animated: animated) {
                if completion != nil {
                    completion!()
                }
            }

        case .dismiss:
//            DDLogVerbose(".dismiss: uinvc count =  \(uinvc.viewControllers.count)")
//            DDLogVerbose(".dismiss: uinvc.viewControllers.last = \(uinvc.viewControllers.last!)")
//            DDLogVerbose(".dismiss: uinvc.presentedViewController = \(uinvc.presentedViewController)")
//            DDLogVerbose(".dismiss: rootVC = \(rootVC)")
//            DDLogVerbose(".dismiss: uinvc = \(uinvc!)")

            if let topVC = UIViewController().topMostController() {
                if topVC.isModal {
                    DDLogInfo("topVC.dismiss modal: \(topVC)")
                    topVC.dismiss(animated: animated, completion: {
                        if completion != nil {
                            completion!()
                        }
                    })
                    break
                }
            }

            if let topChildVC = uinvc.viewControllers.last {
                DDLogInfo("topChildVC.dismiss: \(topChildVC)")
                topChildVC.dismiss(animated: animated, completion: {
                    if completion != nil {
                        completion!()
                    }
                })
                break
            }

            if uinvc.presentedViewController != nil {
                if let presentedViewController = uinvc.presentedViewController {
                    DDLogInfo("uinvc.dismiss (non-modal): \(presentedViewController)")
                }
                uinvc.dismiss(animated: animated, completion: {
                    if completion != nil {
                        completion!()
                    }
                })
            } else {
                if let topVC = UIViewController().topMostController() {
                    DDLogInfo("topVC.dismiss (non-modal): \(topVC)")
                    topVC.dismiss(animated: animated, completion: {
                        if completion != nil {
                            completion!()
                        }
                    })
                }
            }

        case .dismissAll:
            if let topVC = UIViewController().topMostController() {
                DDLogVerbose("topVC.dismissAll: \(topVC)")
                topVC.dismiss(animated: animated, completion: { [unowned self] in
                    DDLogInfo("+force release any VC(s) in a separate 'Navigator' stack")
                    self.uinvc = nil
                    if completion != nil {
                        completion!()
                    }
                })
            }

        }

        printNVCstack(uinvc)
    }


    func exitPopoverVC(completion: (() -> Swift.Void)? = nil) {
        if hardwareDevice.isPad {
            self.exitVC(with: .dismiss, completion: {
                if completion != nil {
                    completion!()
                }
            })
        } else { // iPhone
            self.exitVC(with: .popLast, completion: {
                if completion != nil {
                    completion!()
                }
            })
        }
    }


}
