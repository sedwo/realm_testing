import UIKit



// How to use hex colour values
// https://stackoverflow.com/a/52679313/7599
extension UIColor {

    convenience init(r: UInt8, g: UInt8, b: UInt8, alpha: CGFloat = 1.0) {
        let divider: CGFloat = 255.0
        self.init(red: CGFloat(r)/divider, green: CGFloat(g)/divider, blue: CGFloat(b)/divider, alpha: alpha)
    }

    private convenience init(rgbWithoutValidation value: Int32, alpha: CGFloat = 1.0) {
        self.init(
            r: UInt8((value & 0xFF0000) >> 16),
            g: UInt8((value & 0x00FF00) >> 8),
            b: UInt8(value & 0x0000FF),
            alpha: alpha
        )
    }

    convenience init(rgb: Int32, alpha: CGFloat = 1.0) {
        if rgb > 0xFFFFFF || rgb < 0 {
            fatalError("Out of range")
        }
        self.init(rgbWithoutValidation: rgb, alpha: alpha)
    }

    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }

}
