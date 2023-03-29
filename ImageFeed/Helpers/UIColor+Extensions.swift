import UIKit

extension UIColor {
    enum YPColors: String {
        case ypBackground = "YP Background"
        case ypBlack = "YP Black"
        case ypBlue = "YP Blue"
        case ypGray = "YP Gray"
        case ypWhiteAlpha50 = "YP White (Alpha 50)"
        case ypWhite = "YP White"
        case ypRed = "YP Red"
    }
    convenience init?(_ ypColor: YPColors) {
        self.init(named: ypColor.rawValue)
    }
}

