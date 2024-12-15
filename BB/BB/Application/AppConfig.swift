//
//  AppConfig.swift
//  BB
//

import Foundation
import SwiftyJSON

fileprivate class AppConfigModel: SwiftyJSONMappable {
    
    var rootUrl: String = ""
    var gotitUrl: String = ""
    var uboxUrl: String = ""
    var ekycUrl: String = ""

    // Map data
    required init(json: SwiftyJSON.JSON) {
        if json["RootURL"].exists() {
            rootUrl = json["RootURL"].stringValue
            gotitUrl = json["GotItURL"].stringValue
            uboxUrl = json["UboxURL"].stringValue
            ekycUrl = json["EkycURL"].stringValue
        }
    }
    
    init() {
        
    }
}

class AppConfigs {
    // Singleton
    static let shared = AppConfigs()
    private init() { }
    private var model = AppConfigModel()
    
    var rootUrl: String = ""
    
    func loadConfigs() {
        let bundleApp = DeviceUtils.appBundle()
        if let path = Bundle.main.path(forResource: bundleApp, ofType: "plist") {
          if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
            // use swift dictionary as normal
            self.model = AppConfigModel(json: JSON(dict))
          }
        }
        
//        if let configureDict = UserDefaults.standard.dictionary(forKey: "appConfigure") {
//            appConfigure = AppConfigure(json: JSON(configureDict))
//        }
    }
}
