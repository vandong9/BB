//
//  AppTheme.swift
//  BB
//

import Foundation

enum BBTheme: String {
    case blue = "blue"
    case orgran = "orgran"
    // This property to specify the asset upon current theme.
    var imageSuffix: String {
        switch self {
        case .blue: return "_blue"
        case .orgran: return "_orgran"
        }
    }
    static var allThemes = [BBTheme.blue, BBTheme.orgran]
}

