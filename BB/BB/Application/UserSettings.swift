//
//  UserSettings.swift
//  BB
//

import Foundation

private enum UserSettingKey: String {
    case language = "language"
    case didSelectTheme = "didSelectTheme"
    case theme = "theme"

}


class UserSettings {
    // Singleton
    static let shared = UserSettings()
    let appLanguage = AppLanguage.shared
    
    private init() {
    }
    private static let settingKey = "settingKey"
    
    // ------ PROPERTIES --------
    private(set) var language: BBLanguage = .english
    
    var didSelectTheme: Bool = false
    private(set) var theme: BBTheme = .blue {
        didSet {
            NotificationCenter.default.post(name: .didUpdateTheme, object: nil)
        }
    }
}
