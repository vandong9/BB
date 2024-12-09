//
//  AppLanguage.swift
//  BB
//

import Foundation

class AppLanguage {
    static let shared = AppLanguage()
    
    private(set) var language: [String: String] = [:]
    private var isLoadingVN = false
    private var isLoadingEN = false

    func getWordingForKey(_ key: String) -> String? {
            var wd: String? = language[key]
//            if wd == nil {
//                loadBundleLanguageIfEmpty()
//                wd = bundleLanguage[key]
//            }
            
            return wd
    }
    
    func updateCurrentLanguage(lang: BBLanguage) {
        if lang == .vietnam, isLoadingVN { return }
        if lang == .english, isLoadingEN { return }
        
        switch lang {
        case .vietnam: isLoadingVN = true
        case .english: isLoadingEN = true
        }

        let fileLanguageName = lang.fileLanguageName
        if let jsonData = FileUtils.loadData(by: fileLanguageName) ?? FileUtils.loadDataOfBundleFile(fileLanguageName) {
            if let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: String] {
                language = dict
            }
            switch lang {
            case .vietnam: isLoadingVN = false
            case .english: isLoadingEN = false
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name.notifyCurrentLanguageChange, object: nil)
    }


}

enum BBLanguage: String {
    case english = "English", vietnam = "Tiếng Việt"
    var locale: Locale {
        switch self {
        case .english: return Locale(identifier: "en_US")
        case .vietnam: return Locale(identifier: "vi_VN")
        }
    }

    var key : String {
        switch self {
        case .english: return "en"
        case .vietnam: return "vi-VN"
        }
    }

    var paramKey: String {
        switch self {
        case .english: return "en-US"
        case .vietnam: return "vi-VN"
        }
    }
    
    // This property to specify the files by name upon current language.
    var suffix: String {
        switch self {
        case .english: return "_en"
        case .vietnam: return "_vi"
        }
    }
    
    var configName: String {
        switch self {
        case .vietnam: return AppConstant.ConfigFileName.kLangVi
        case .english: return AppConstant.ConfigFileName.kLangEn
        }
    }
    
    var fileLanguageName: String {
        return self.key + ".json"
    }
    
    var localStorageFilePath: String {
        let filePath = Utils.getDocumentsDirectory().absoluteString + self.fileLanguageName
        return filePath
    }
    
    static var languageList: [BBLanguage] = [.vietnam, .english]
    static var contentList = [BBLanguage.english.rawValue, BBLanguage.vietnam.rawValue]
}
