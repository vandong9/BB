//
//  AppFont.swift
//  BB
//

import UIKit

struct AppFont {

    struct CssStyle {

        enum Style: String {
            case normal
            case italic
        }

        enum Weight: String {
            case normal
            case bold
        }

        var name = ""//AppConstant.kEmptyStr
        var weight = Weight.normal
        var style = Style.normal
    }

    enum Name: String {
        case regular              = "Inter-Regular"
        case italic               = "Inter-Regular_Italic"
        case thin                 = "Inter-Regular_Thin"
        case thinItalic           = "Inter-Regular_Thin-Italic"

        case extraLight           = "Inter-Regular_ExtraLight"
        case extraLightItalic     = "Inter-Regular_ExtraLight-Italic"
        case light                = "Inter-Regular_Light"
        case lightItalic          = "Inter-Regular_Light-Italic"

        case medium               = "Inter-Medium"
        case mediumItalic         = "Inter-Regular_Medium-Italic"

        case semiBold             = "Inter-SemiBold"
        case semiBoldItalic       = "Inter-Regular_SemiBold-Italic"

        case bold                 = "Inter-Bold"
        case boldItalic           = "Inter-Regular_Bold-Italic"
        case extraBold            = "Inter-Regular_ExtraBold"
        case extraBoldItalic      = "Inter-Regular_ExtraBold-Italic"

        case black                = "Inter-Regular_Black"
        //case blackItalic          = "Inter-Regular_Black"

        static let familyName = "Inter"

        func getCSS() -> CssStyle {
            switch self {
            case .regular, .thin, .extraLight, .light, .medium:
                return CssStyle(name: self.rawValue, weight: .normal, style: .normal)
            case .italic:
                return CssStyle(name: self.rawValue, weight: .normal, style: .italic)
            case .thinItalic, .extraLightItalic, .lightItalic, .mediumItalic:
                return CssStyle(name: Name.familyName, weight: .normal, style: .italic)
            case .semiBold, .extraBold, .black:
                return CssStyle(name: self.rawValue, weight: .bold, style: .normal)
            case .semiBoldItalic, .boldItalic, .extraBoldItalic:
                return CssStyle(name: Name.familyName, weight: .bold, style: .italic)
            case .bold:
                return CssStyle(name: Name.familyName, weight: .bold, style: .normal)
            }
        }
    }

    //MARK: Main
    static func mainFont(fontName name: String, fontSize size: Int) -> UIFont{
        return UIFont(name: name, size: CGFloat(size)) ?? UIFont.systemFont(ofSize: 12)
    }
}

//MARK: - PARTICICULAR FONT
extension AppFont{
    //MARK: MAIN
    static func regular(size: Int) -> UIFont{
        return mainFont(fontName: Name.regular.rawValue, fontSize: size)
    }
    
    static func italic(size: Int) -> UIFont{
        return mainFont(fontName: Name.italic.rawValue, fontSize: size)
    }
    
    static func thin(size: Int) -> UIFont{
        return mainFont(fontName: Name.thin.rawValue, fontSize: size)
    }
    
    static func thinItalic(size: Int) -> UIFont{
        return mainFont(fontName: Name.thinItalic.rawValue, fontSize: size)
    }
    
    static func extraLight(size: Int) -> UIFont{
        return mainFont(fontName: Name.extraLight.rawValue, fontSize: size)
    }
    
    static func extraLightItalic(size: Int) -> UIFont{
        return mainFont(fontName: Name.extraLightItalic.rawValue, fontSize: size)
    }
    
    static func light(size: Int) -> UIFont{
        return mainFont(fontName: Name.light.rawValue, fontSize: size)
    }
    
    static func lightItalic(size: Int) -> UIFont{
          return mainFont(fontName: Name.lightItalic.rawValue, fontSize: size)
    }
    
    static func medium(size: Int) -> UIFont{
          return mainFont(fontName: Name.medium.rawValue, fontSize: size)
    }

    static func mediumItalic(size: Int) -> UIFont{
          return mainFont(fontName: Name.mediumItalic.rawValue, fontSize: size)
    }

    static func semiBold(size: Int) -> UIFont{
          return mainFont(fontName: Name.semiBold.rawValue, fontSize: size)
    }

    static func semiBoldItalic(size: Int) -> UIFont{
          return mainFont(fontName: Name.semiBoldItalic.rawValue, fontSize: size)
    }

    static func bold(size: Int) -> UIFont{
          return mainFont(fontName: Name.bold.rawValue, fontSize: size)
    }

    static func boldItalic(size: Int) -> UIFont{
          return mainFont(fontName: Name.boldItalic.rawValue, fontSize: size)
    }

    static func extraBold(size: Int) -> UIFont{
          return mainFont(fontName: Name.extraBold.rawValue, fontSize: size)
    }

    static func extraBoldItalic(size: Int) -> UIFont{
          return mainFont(fontName: Name.extraBoldItalic.rawValue, fontSize: size)
    }

    static func black(size: Int) -> UIFont{
          return mainFont(fontName: Name.black.rawValue, fontSize: size)
    }

//    static func blackItalic(size: Int) -> UIFont{
//          return mainFont(fontName: Name.black.rawValue, fontSize: size)
//    }
}

//MARK: Typography
extension AppFont {
    static var baseSuperLargeTitle: UIFont = AppFont.semiBold(size: 40)
    static var baseLargeTitle: UIFont = AppFont.bold(size: 34)
    static var baseTitle1: UIFont = AppFont.bold(size: 28)
    static var baseTitle2: UIFont = AppFont.bold(size: 22)
    static var baseTitle3: UIFont = AppFont.semiBold(size: 20)
    static var baseTitle4: UIFont = AppFont.semiBold(size: 18)
    static var baseHeadline: UIFont = AppFont.semiBold(size: 16)
    static var baseBodyBold: UIFont = AppFont.semiBold(size: 17)
    static var baseBodyRegular: UIFont = AppFont.regular(size: 17)
    static var baseBodyLink: UIFont = AppFont.medium(size: 17)
    static var baseSubheadlineBold = AppFont.semiBold(size: 15)
    static var baseSubheadlineMedium: UIFont = AppFont.medium(size: 15)
    static var baseSubheadlineRegular: UIFont = AppFont.regular(size: 15)
    static var baseSmallBodyBold: UIFont = AppFont.semiBold(size: 13)
    static var baseSmallBodyRegular: UIFont = AppFont.regular(size: 13)
    static var baseSmallBodyLink: UIFont = AppFont.medium(size: 13)
    static var baseInputMedium: UIFont = AppFont.medium(size: 13)
    static var baseCaptionBold: UIFont = AppFont.semiBold(size: 12)
    static var baseCaptionRegular: UIFont = AppFont.medium(size: 12)
    static var baseRegular12: UIFont = AppFont.regular(size: 12)
    static var baseCaptionSmallMedium: UIFont = AppFont.medium(size: 11)
    static var baseBold11: UIFont = AppFont.bold(size: 11)
    static var baseBold17: UIFont = AppFont.bold(size: 17)
    static var baseMedium11: UIFont = AppFont.medium(size: 11)
}

