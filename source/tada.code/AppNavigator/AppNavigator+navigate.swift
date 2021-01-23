import Foundation
import UIKit
import CocoaLumberjack



extension AppNavigator {

    func navigate(to destination: Destination,
                  presentationStyle: Presentation = .push,
                  animated: Bool = true,
                  with vc: UIViewController? = nil) {

        let viewController = vc ?? makeViewController(for: destination)

        switch presentationStyle {
        case .push:
            uinvc.pushViewController(viewController, animated: animated)

        case .modalWithNavigationBarFadeIn:
            viewController.modalTransitionStyle = .crossDissolve
            fallthrough

        case .modalWithNavigationBar:
            uinvc.present(viewController, animated: animated, completion: nil)

        case .modal:    // fullscreen
            viewController.modalPresentationStyle = .overFullScreen

            if let topChildVC = uinvc.viewControllers.last {
                topChildVC.present(viewController, animated: true, completion: nil)
            } else {
                let topVC = UIViewController().topMostController()
                topVC?.present(viewController, animated: true, completion: nil)
            }

        case .popover(let sourceView, let height, let isModal):
            // Embed VC inside a plain NVC, to support SearchBar UI.
            let navController = UINVC(rootViewController: viewController)

            navController.modalPresentationStyle = .popover
            navController.isModalInPresentation = isModal    // controls if it's dismissible by tapping outside its view

            if height != nil {
                navController.preferredContentSize.height = height!
            } else {
                navController.preferredContentSize.height = 250
            }

            let popover = navController.popoverPresentationController!
            popover.permittedArrowDirections = .left
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.canOverlapSourceViewRect = isModal
//            popover.backgroundColor = .red

            if let topChildVC = uinvc.viewControllers.last {
                // Support the `UIPopoverPresentationControllerDelegate`
                // This can be used to handle a user tapping outside of a popover, so that when it dismisses, we can clean up the UI.
                popover.delegate = topChildVC as? UIPopoverPresentationControllerDelegate
                topChildVC.present(navController, animated: true, completion: nil)
            } else {
                let topVC = UIViewController().topMostController()
                // Support the `UIPopoverPresentationControllerDelegate`
                // This can be used to handle a user tapping outside of a popover, so that when it dismisses, we can clean up the UI.
                popover.delegate = topVC as? UIPopoverPresentationControllerDelegate
                topVC?.present(navController, animated: true, completion: nil)
            }

        case .replace:
            uinvc.popToRootViewController(animated: false)
            uinvc.pushViewController(viewController, animated: animated)

        }

        printNVCstack(uinvc)
    }


}
