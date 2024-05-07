import Foundation
import UIKit

enum CustomColor {
    static let tabSelected = hexStringToUIColor(hex: "#1B708C")
    static let tabUnselected = hexStringToUIColor(hex: "#000000")
    
    static let gradient1 = hexStringToUIColor(hex: "#1B708C")
    static let gradient2 = hexStringToUIColor(hex: "#4A9EBA")
    static let btnBGColor = hexStringToUIColor(hex: "#1B708C")
    static let missedCallRed = hexStringToUIColor(hex: "#E94F37")
    static let textLightGray = hexStringToUIColor(hex: "#BEBEBE")
    static let colorPrimary = hexStringToUIColor(hex: "#3FA6E1")
    static let appBlack = hexStringToUIColor(hex: "#071F2C")
    
}

class Colors {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor(red: 0.106, green: 0.439, blue: 0.549, alpha: 1).cgColor
        let colorBottom = UIColor(red: 0.29, green: 0.62, blue: 0.729, alpha: 1).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0, 1]
        gl.startPoint = CGPoint(x: 0.25, y: 0.5)
        gl.endPoint = CGPoint(x: 0.75, y: 0.5)
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
