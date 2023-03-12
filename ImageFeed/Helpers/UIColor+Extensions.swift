import UIKit

extension UIColor {
    public enum YPColors: String {
        case ypBackground = "YP Background"
        case ypBlack = "YP Black"
        case ypBlue = "YP Blue"
        case ypGray = "YP Gray"
        case ypRed = "YP Red"
        case ypWhiteAlpha50 = "YP White (Alpha 50)"
        case ypWhite = "YP White"
    }
    public convenience init?(_ ypColor: YPColors) {
        self.init(named: ypColor.rawValue)
    }
}
