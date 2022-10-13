
import UIKit

enum Resources{
    enum Colors {
        static var titleGrey = UIColor(hexString:"#545C77")
        static var buttonColorGreen = UIColor(hexString:"#1b4c20")
        static var collorForBorderTable = UIColor(hexString: "#092e3c")
        static var background = UIColor(hexString: "#F8F9F9")
    }
    enum Fonts {
        static func hevletivcaRegular(with size: CGFloat) -> UIFont {
            UIFont(name: "Helvetica", size: size) ?? UIFont()
        }
    }
}
