//
//  UIImage+Extension.swift
//  BB
//

import UIKit

extension UIImage {
    
    static func imageByTheme(named: String) -> UIImage? {
        return UIImage(named: named.getIconThemeName()) ?? UIImage(named: named)
    }
    
    static func imageByLang(named: String) -> UIImage? {
        return UIImage(named: named.getIconLangName()) ?? UIImage(named: named)
    }
}
