import Foundation
import UIKit



extension CGFloat {

    public func longitudeToX(_ zoomLevel: CGFloat) -> CGFloat {
        return CGFloat((self + 180) / 360.0 * pow(2.0, zoomLevel) * 256.0)

    }

    public func latitudeToY(_ zoomLevel: CGFloat) -> CGFloat {
        return CGFloat((1 - log( tan( self * CGFloat.pi / 180.0 ) + 1 / cos( self * CGFloat.pi / 180.0 )) / CGFloat.pi ) / 2 * pow(2.0, zoomLevel) * 256.0)
    }

    public func xToLongitude(_ zoomLevel: CGFloat) -> CGFloat {
        return CGFloat((self * 360.0) / (pow(2.0, zoomLevel) * 256.0) - 180)
    }

    public func yToLatitude(_ zoomLevel: CGFloat) -> CGFloat {
        return CGFloat(atan(sinh(.pi - (self / (pow(2.0, zoomLevel) * 256.0)) * 2 * .pi)) * (180.0 / .pi))
    }


}
