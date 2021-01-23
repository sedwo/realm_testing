import UIKit
import CocoaLumberjack
import DeviceKit


// MARK: Conveniences and randoms.

var UIApplicationKeyWindow: UIWindow? {
    if #available(iOS 13.0, *) {
        // https://stackoverflow.com/a/57169802
        return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    } else {
        return UIApplication.shared.keyWindow
    }

}

var appDelegate: AppDelegate {      // 'read-only' property
    // https://stackoverflow.com/questions/45832155/how-do-i-refactor-my-code-to-call-appdelegate-on-the-main-thread/45833540#45833540
    return ._applicationDelegate
}

var appSession: Session {           // 'read-only' property
    return appDelegate._session
}

var isDataConnection: Bool {        // 'read-only' property
    return appDelegate._isDataConnection
}


//var syncEngine: SyncEngine {        // 'read-only' property
//    return appDelegate._syncEngine
//}


var hardwareDevice: Device {        // 'read-only' property
    return appDelegate._device
}

var newUUID: String {               // 'read-only' property
    return UUID().uuidString.lowercased()
}

var userAppDirectory: URL {         // 'read-only' property
    return FileStorageService.userAppDirectory
}

var appSettings: AppSettings {      // 'read-only' property
    return appDelegate._appSettings
}


var loggerDirectory: URL {          // 'read-only' property
    return appDelegate._loggerDirectory
}

var iOSblue: UIColor {
    return UIColor(hex: "007aff")
}


// https://stackoverflow.com/a/46275578/7599
func imageForBase64String(_ strBase64: String) -> UIImage? {
    do {
        let imageData = try Data(contentsOf: URL(string: strBase64)!)

        if let image = UIImage(data: imageData) {
            return image
        }

        return nil

    } catch {
        return nil
    }
}

/*
func loadImageFromLocalFile(_ filename: String?) -> UIImage? {

    if let imageLocalFilename = filename {

            let fileURL = userAppDirectory.appendingPathComponent(imageLocalFilename)
            let fileExtension = fileURL.pathExtension.lowercased()

            if fileExtension == "svg" {
                // Convert SVG file to UIImage
                do {
                    let image = try SVGParser.parse(fullPath: fileURL.path).toNativeImage(size: Size(w: 32, h: 32))
                    return image

                } catch {
                    DDLogError("SVG parsing error = \(error)")
                }

            } else {
                if let image = UIImage(contentsOfFile: fileURL.path) {
                    return image
                }
            }

        }

    return nil

}
*/

// MARK: - misc.

func formatBytesToSize(bytes: Double) -> String {

    guard bytes > 0 else {
        return "0 bytes"
}

    // Adapted from http://stackoverflow.com/a/18650828
    let suffixes = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
    let k: Double = 1000
    let i = floor(log(bytes) / log(k))

    // Format number with thousands separator and everything below 1 GB with no decimal places.
    let numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = i < 3 ? 0 : 1
    numberFormatter.numberStyle = .decimal

    let numberString = numberFormatter.string(from: NSNumber(value: bytes / pow(k, i))) ?? "Unknown"
    let suffix = suffixes[Int(i)]

    return "\(numberString) \(suffix)"
}


// ... delete all keychain items accessible to our app
// https://stackoverflow.com/questions/14086085/how-to-delete-all-keychain-items-accessible-to-an-app
func resetKeychain() {
    DDLogError("~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~")
    DDLogError(" ATTENTION!  ALL KEYCHAIN DATA WIPED")
    DDLogError("~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~\n")

    let secItemClasses = [kSecClassGenericPassword,
                          kSecClassInternetPassword,
                          kSecClassCertificate,
                          kSecClassKey,
                          kSecClassIdentity]
    for secItemClass in secItemClasses {
        let dictionary = [kSecClass as String: secItemClass]
        SecItemDelete(dictionary as CFDictionary)
    }
}


func resetUserAppDirectory() {
    DDLogError("~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~")
    DDLogError(" ATTENTION!  ALL LOCAL USER DATA WIPED for user account: \(appSession.userProfile.email)")
    DDLogError("~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~  ~ ⚠️ ~\n")

    // wipes DB, etc.
    FileManager.default.removeDirectory(userAppDirectory)
}


// Little utility class to wait on data
class Semaphore<T> {
    let segueSemaphore = DispatchSemaphore(value: 0)
    var data: T?

    func waitData(timeout: DispatchTime? = nil) -> T? {
        if let timeout = timeout {
            _ = segueSemaphore.wait(timeout: timeout) // wait user
        } else {
            segueSemaphore.wait()
        }
        return data
    }

    func publish(data: T) {
        self.data = data
        segueSemaphore.signal()
    }

    func cancel() {
        segueSemaphore.signal()
    }
}

func printAllFonts() {
    UIFont.familyNames.forEach({ familyName in
        let fontNames = UIFont.fontNames(forFamilyName: familyName)
        print(familyName, fontNames)
    })
}
