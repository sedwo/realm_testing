import UIKit
import CocoaLumberjack



extension UIScreen {

    var orientation: UIInterfaceOrientation {
        var currentOrientation = UIInterfaceOrientation.portrait

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           windowScene.activationState == .foregroundActive,
           (windowScene.windows.first != nil) else { return currentOrientation }

        if windowScene.interfaceOrientation != .unknown {
            currentOrientation = windowScene.interfaceOrientation
        }

        return currentOrientation
    }

}
