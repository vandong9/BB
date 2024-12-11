//
//  AppConstant.swift
//  BB
//
//  Created by ha van dong on 12/8/24.
//

import Foundation

struct AppConstant {
    static let kAlertInfo = "alert_info"
    static let kAlertAutoDismissingInterval = 2000
    static let kDatakey = "data"
    static let kLocalizedFromJson = true
    struct ConfigFileName {
        static let kLangVi = ""
        static let kLangEn = ""
    }
}

extension Notification.Name {
    static let didUpdateTheme = Notification.Name("didUpdateTheme")
    static let notifyCurrentLanguageChange = Notification.Name("notifyCurrentLanguageChange")
}
