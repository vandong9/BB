//
//  Utils.swift
//  BB
//

import Foundation
class Utils {
    
}

// MARK: - FOLDER
extension Utils {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
