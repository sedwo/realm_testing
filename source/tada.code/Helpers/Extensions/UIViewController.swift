import UIKit



extension UIViewController {

    func topMostController() -> UIViewController? {

        guard UIApplicationKeyWindow != nil else {
            return nil
        }

        guard UIApplicationKeyWindow!.rootViewController != nil else {
            return nil
        }

        var topController: UIViewController = UIApplicationKeyWindow!.rootViewController!

        while topController.presentedViewController != nil {
            topController = topController.presentedViewController!
        }
        return topController
    }


    func topViewController(rootViewController: UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }

        guard let presented = rootViewController.presentedViewController else {
            return rootViewController
        }

        switch presented {
        case let navigationController as UINavigationController:
            return topViewController(rootViewController: navigationController.viewControllers.last)

        case let tabBarController as UITabBarController:
            return topViewController(rootViewController: tabBarController.selectedViewController)

        default:
            return topViewController(rootViewController: presented)
        }
    }


    // https://stackoverflow.com/a/47360437/7599
    var isModal: Bool {
        return presentingViewController != nil ||
            navigationController?.presentingViewController?.presentedViewController === navigationController ||
            tabBarController?.presentingViewController is UITabBarController
    }


    // Walk through memory and return the loaded ViewController of a class 'Kind', if found.
    public static func findVC<T: UIViewController>(vcKind: T.Type? = nil) -> T? {
        if let vc = UIApplicationKeyWindow?.rootViewController as? T {
            return vc
        } else if let vc = UIApplicationKeyWindow?.rootViewController?.presentedViewController as? T {
            return vc
        } else if let childViewControllers = UIApplicationKeyWindow?.rootViewController?.children {
            // Loop through the array of childViewControllers.
            let foundVC = childViewControllers.lazy.compactMap { $0 as? T }.first
            if foundVC != nil {
                return foundVC
            }
            //
            // Continue looping through childViewControllers for any nested collections.
            //
            for childVC in childViewControllers where childVC is UINavigationController {
                // Walk through the nested array of more childViewControllers.
                let vcArray = (childVC as! UINavigationController).children
                let foundVC = vcArray.lazy.compactMap { $0 as? T }.first
                if foundVC != nil {
                    return foundVC
                }
            }

            for childVC in childViewControllers where childVC is UITabBarController {
                // Walk through the nested array of more childViewControllers.
                let vcArray = (childVC as! UITabBarController).children
                let foundVC = vcArray.lazy.compactMap { $0 as? T }.first
                if foundVC != nil {
                    return foundVC
                }
            }
        }

        return nil
    }


    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }


    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }


}
