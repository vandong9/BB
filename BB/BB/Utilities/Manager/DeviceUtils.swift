//
//  DeviceUtils.swift
//  BB
//

import Foundation

class DeviceUtils {
    // MARK: - VERSION, DEVICE INFO...
    static func appVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.00"
    }
    /** get device id*/

    static func deviceOSVersion() -> String {
        return UIDevice.current.systemVersion
    }
    /**Get device OS name*/
    static func deviceOSName() -> String {
        return "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    }
    ///
    // Get bundle, default is production bundle if return nil
    ///
    static func appBundle() -> String {
        return Bundle.main.bundleIdentifier ?? "com.vib.myvib2"
    }
    
}
