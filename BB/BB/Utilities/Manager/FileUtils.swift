//
//  FileUtils.swift
//  BB
//

import Foundation

class FileUtils {
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    // Save
    static func saveData(by data: Data, for name: String, isGlobal: Bool = false, completion:((_ error: Error?) -> Void)? = nil) {
        let filePath = self.getDocumentsDirectory().absoluteString + name
        if let fileUrl = URL(string: filePath) {
            if isGlobal {
                DispatchQueue.global().async {
                   do {
                      try data.write(to: fileUrl)
                       DispatchQueue.main.async {
                           completion?(nil)
                       }
                   }
                   catch {
                       DispatchQueue.main.async {
                           completion?(error)
                       }
                   }
                 }
            } else {
                do {
                    try data.write(to: fileUrl)
                    completion?(nil)
                }
                catch {
                    completion?(error)
                }
            }
        } else {
            let error = NSError(domain: filePath, code: 701, userInfo: [ NSLocalizedDescriptionKey: "Save failed"])
            completion?(error)
        }
    }
    
    static func saveDataOnMain(by data: Data, for name: String, completion:((_ error: Error?) -> Void)? = nil) {
        let filePath = self.getDocumentsDirectory().absoluteString + name
        if let fileUrl = URL(string: filePath) {
            do {
               try data.write(to: fileUrl)
                completion?(nil)
            }
            catch {
                completion?(error)
            }
        } else {
            let error = NSError(domain: filePath, code: 701, userInfo: [ NSLocalizedDescriptionKey: "Save failed"])
            completion?(error)
        }
    }

    static func deleteDataOnMain(name: String, completion:((_ error: Error?) -> Void)? = nil) {
        let url = self.getDocumentsDirectory().appendingPathComponent(name)

        let filePath = url.path
        do {
            try FileManager.default.removeItem(atPath: filePath)
            completion?(nil)
        } catch {
            completion?(error)
        }
    }
    
    static func loadData(by name: String) -> Data? {
        let url = self.getDocumentsDirectory().appendingPathComponent(name)
        return try? Data.init(contentsOf: url)
    }
    
    static func loadDataOfBundleFile(_ name: String) -> Data? {
        if let url = Bundle.main.url(forResource: name, withExtension: nil) {
            return try? Data.init(contentsOf: url)
        }
        return nil
    }
    
    static func loadDataFileSound(by name: String) -> Data? {
        let fileManager = FileManager.default
        if let soundsDirectoryURL = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent("Sounds") {
            let destinationUrl = soundsDirectoryURL.appendingPathComponent("\(name).caf")
            return try? Data.init(contentsOf: destinationUrl)
        }
        return nil
    }
    
    static func saveFileSounds(withLink links: [String], completion: @escaping ((_ isError: Bool)->Void)){
        var errorCount = 0
        var successCount = 0
        DispatchQueue.global(qos: .utility).async {
            for i in 0..<links.count {
                let urlString = links[i].addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                if let url  = URL.init(string: urlString ?? "") {
                    //attempt to create the folder
                    let fileManager = FileManager.default
                    if let soundsDirectoryURL = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent("Sounds") {
                        try? fileManager.createDirectory(at: soundsDirectoryURL, withIntermediateDirectories: true)
                        let destinationUrl = soundsDirectoryURL.appendingPathComponent(url.lastPathComponent)
                        downloadFile(withUrl: url, andFilePath: destinationUrl, completion: {isHasError in
                            if isHasError {
                                errorCount = errorCount + 1
                            } else {
                                successCount = successCount + 1
                            }
                            let total = errorCount + successCount
                            if total == links.count {
                                DispatchQueue.onMain {
                                    completion(errorCount > 0)
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    static func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ isError: Bool)->Void)){
        if let data = try? Data(contentsOf: url) {
            do {
                try data.write(to: filePath)
                completion(false)
            }
            catch {
                completion(true)
            }
        }
    }
}
