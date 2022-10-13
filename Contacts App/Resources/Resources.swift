
import UIKit

enum Resources{
    enum Colors {
        static var titleGrey = UIColor(hexString:"#545C77")
    }
    enum Fonts {
        static func hevletivcaRegular(with size: CGFloat) -> UIFont {
            UIFont(name: "Helvetica", size: size) ?? UIFont()
        }
    }
}
