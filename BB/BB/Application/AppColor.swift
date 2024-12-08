//
//  AppColor.swift
//  BB
//

import UIKit

struct AppColor {
    // MARK: - MAIN
    static func colorFromRGB(red:UInt, green: UInt, blue:UInt) -> UIColor {
        return UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1.0)
    }

    static func colorFromRGBA(red:UInt, green: UInt, blue:UInt, alpha: Float) -> UIColor {
        return UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha))
    }

    static func colorFromDecimaRGBA(red:CGFloat, green: CGFloat, blue:CGFloat, alpha: Float) -> UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
    // colorFromHex
    static func colorFromHex(_ hex: Int) -> UIColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    // Sample: var color1 = hexStringToUIColor("#d3d3d3")
    static func colorFromString (_ string: String) -> UIColor {
        var cString:String = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.clear
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
// MARK: - FOF VIB APP
extension AppColor {
    // From RGB
    static var defaultBackgroundCard: UIColor {
        return self.colorFromRGB(red: 255, green: 255, blue: 255)
    }
    // From string
    static var bgInputField: UIColor {
        return self.colorFromString("F1F3F8")
    }
    
    static var mainTintColor: UIColor {
        return self.colorFromString("F9FAFB")
    }
    
    static var separatedLineColor: UIColor {
        return self.colorFromRGB(red: 231, green: 231, blue: 231)
    }
    
    static var mainBgView: UIColor {
        return baseGrey50//AppColor.colorFromString("F9FAFB")
    }
    // -------- Add more in need -------
    static var orgranGradientButtonColor: [CGColor] = [colorFromString("FE9B25").cgColor, colorFromString("FF5922").cgColor]
    static var blueGradientButtonColor: [CGColor] = [colorFromString("007FFF").cgColor, UIColor.colorFromString("134DD3").cgColor]
    
    static var fireReverseGradientButtonColor: [CGColor] = [colorFromString("FF5922").cgColor, colorFromString("FE9B25").cgColor]
    static var iceReverseGradientButtonColor: [CGColor] = [UIColor.colorFromString("134DD3").cgColor, colorFromString("007FFF").cgColor]
    static var baseGrey400Colors: [CGColor] = [colorFromString("9DA3AE").cgColor, colorFromString("9DA3AE").cgColor]
    
    // Theme
    static var themeGradientColor: [CGColor] {
        switch UserSettings.shared.theme {
        case .orgran:
            return AppColor.orgranGradientButtonColor
        case .blue:
            return AppColor.blueGradientButtonColor
        }
    }
        
    static var themeLightColor: UIColor {
        switch UserSettings.shared.theme {
        case .orgran:
            return AppColor.baseFireLight
        case .blue:
            return AppColor.baseIceLight
        }
    }
    
    static var baseBlack: UIColor = Self.colorFromString("000000")
    static var baseWhite: UIColor = Self.colorFromString("FFFFFF")
    // --------------------------
    static var baseGrey50: UIColor = Self.colorFromString("F9FAFB")
    static var baseGrey100: UIColor = Self.colorFromString("F3F4F6")
    static var baseGrey200: UIColor = Self.colorFromString("E5E7EB")
    static var baseGrey300: UIColor = Self.colorFromString("D2D5DA")
    static var baseGrey400: UIColor = Self.colorFromString("9DA3AE")
    static var baseGrey500: UIColor = Self.colorFromString("6C727F")
    static var baseGrey600: UIColor = Self.colorFromString("4D5562")
    static var baseGrey800: UIColor = Self.colorFromString("212936")
    static var baseGrey700: UIColor = Self.colorFromString("4D5562")
    static var baseGrey900: UIColor = Self.colorFromString("121826")
    // 2 these file should merge in 1
    static var baseFireLight: UIColor = Self.colorFromString("FE9B25")
    static var baseFireDark: UIColor = Self.colorFromString("F47920")
    // 2 these file should merge in 1
    static var baseIceLight: UIColor = Self.colorFromString("007FFF")
    static var baseIceDark: UIColor = Self.colorFromString("134DD3")
    
    static var baseRed50: UIColor = Self.colorFromString("FFF0DF")
    static var baseRed400: UIColor = Self.colorFromString("F42020")
    static var baseRed500: UIColor = Self.colorFromString("FF5922")

    static var chatUserMessageBackground: UIColor = Self.colorFromString("0096FB")
    static var baseBlue200: UIColor = UIColor.colorFromString("CAE3FA")
    static var baseBlue400: UIColor = UIColor.colorFromString("318DD2")
    static var baseGreen50: UIColor = Self.colorFromString("CFF7E9")
    static var baseGreen100: UIColor = Self.colorFromString("D5F6EC")
    static var baseGreen500: UIColor = Self.colorFromString("27A87A")
    static var baseBlue600: UIColor = Self.colorFromString("0164BF")
    
    
    static var baseYellow400: UIColor = UIColor.colorFromString("FDB813")
    static var baseYellow300: UIColor = UIColor.colorFromString("FDD471")
    static var baseYellow200: UIColor = UIColor.colorFromString("FDE2A0")
    static var baseYellow100: UIColor = UIColor.colorFromString("FDF0CF")
    static var baseOrange400: UIColor = UIColor.colorFromString("F7941E")
    static var baseOrange300: UIColor = UIColor.colorFromString("F9B869")
    static var baseOrange200: UIColor = UIColor.colorFromString("FDD3A6")
    static var baseOrange100: UIColor = UIColor.colorFromString("FFE8D3")
    static var baseNewBlue500: UIColor = UIColor.colorFromString("0F5BDF")
    static var baseDarkOrange200: UIColor = UIColor.colorFromString("FACAA7")

    
    static var baseChartTopFireGradient: UIColor = UIColor.colorFromString("#F2A770")
    static var baseChartBottomFireGradient: UIColor = UIColor.colorFromString("#FFFBF8")
    static var baseChartTopIceGradient: UIColor = UIColor.colorFromString("#ADCAFB")
    static var baseChartBottomIceGradient: UIColor = UIColor.colorFromString("#F3F8FF")
}

