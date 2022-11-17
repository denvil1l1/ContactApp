import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let colorA, colorR, colorG, colorB: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (colorA, colorR, colorG, colorB) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (colorA, colorR, colorG, colorB) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (colorA, colorR, colorG, colorB) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (colorA, colorR, colorG, colorB) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(colorR) / 255,
                  green: CGFloat(colorG) / 255,
                  blue: CGFloat(colorB) / 255,
                  alpha: CGFloat(colorA) / 255)
    }
}
