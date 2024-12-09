//
//  String+Extension.swift
//  BB
//

import Foundation
//extension String: BBExtensionCompatible {}

// MARK: - INDEX + String at Index
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                              upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    
    // Remove Prefix
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func index(from: Int) -> Index? {
        guard from <= count else { return nil }
        
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(with r: Range<Int>) -> String {
        guard let startIndex = index(from: max(0, r.lowerBound)),
              let endIndex = index(from: min(self.count, r.upperBound)) else {
            return ""
        }
        return String(self[startIndex..<endIndex])
    }
}

// MARK: - Remove space and special char....
extension String {
    func removeAllSpace() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    func removeLeadingAndTrailingSpace() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func removeSpecialChars(specialString: String) -> String {
        let charSet = CharacterSet.init(charactersIn: specialString)
        let arrOfComponents = self.components(separatedBy: charSet)
        return arrOfComponents.joined(separator: "")
    }

    func marginLeadingAndTrailing() -> String {
        let marginSpace = "    "
        return marginSpace + self + marginSpace
    }
    
    // MARK: - trim Trailing and leading whitespace
    func stringByTrimmingLeadingAndTrailingWhitespace() -> String {
        let leadingAndTrailingWhitespacePattern = "(?:^\\s+)|(?:\\s+$)"
        return self.replacingOccurrences(of: leadingAndTrailingWhitespacePattern, with: "", options: .regularExpression)
    }

    // Contain Special char
    var containsSpecialCharacter: Bool {
       let regex = ".*[^A-Za-z0-9 ].*"
       let testString = NSPredicate(format:"SELF MATCHES %@", regex)
       return testString.evaluate(with: self)

    }
    
    var isValidReferalCode: Bool {
        let regex = "[a-zA-Z0-9-_.]{0,20}"
        let testString = NSPredicate(format:"SELF MATCHES %@", regex)
        return testString.evaluate(with: self)
    }
    
    var isHaveSpecialChatGPTChars: Bool {
       let regex = ".*[^A-Za-z0-9 -_<>!@#$%^&*():;+={}].*"
       let testString = NSPredicate(format:"SELF MATCHES %@", regex)
       return testString.evaluate(with: self)
    }

}


// MARK: - TO DICT/COVERT
extension String {
    ///
    //  let dict = myString.toJSON() as? [String:AnyObject] // can be any type here
    //  let dict = myString.toJSON() as? [Any] // can be any type here
    ///
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    func toDictionary() -> [String: AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func toInt() -> Int {
        if let value = Int(self) {
            return value
        }
        return 0
    }
    
    func toFloat() -> Float {
        if let value = Float(self) {
            return value
        }
        return 0
    }
    
    func toDouble() -> Double {
        if let value = Double(self) {
            return value
        }
        return 0.0
    }
    
    func toBool() -> Bool {
        switch self.lowercased() {
        case "success", "true", "yes", "1":
            return true
        default:
            return false
        }
    }
    
    public var isNotEmpty: Bool {
        return !isEmpty
    }
    
    var trim: String {
        if self.isNotEmpty {
            return self.trimmingCharacters(in: CharacterSet.whitespaces)
        } else {
            return ""
        }
    }
    
    var trimLine: String {
        if self.isNotEmpty {
            return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        } else {
            return ""
        }
    }

}

// MARK: - LOCALIZED STRING
 extension String {
    func toLocalized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
     func localized() -> String {
        if AppConstant.kLocalizedFromJson == false {
            guard let path = Bundle.main.path(forResource: UserSettings.shared.language.key, ofType: "lproj") else { return self }
            return Bundle(path: path)?.localizedString(forKey: self, value: nil, table: nil) ?? self
        }
                  
         return AppLanguage.shared.getWordingForKey(self) ?? self
    }
         
    func localizedFormat(_ arguments: CVarArg...) -> String {
        let wording = localized()
        let prepareString = wording.replacingOccurrences(of: "{$}%", with: "{$}") // avoid error when contains % character
        let replaceString = prepareString.replacingOccurrences(of: "{$}", with: "%@")
        return String(format: replaceString, arguments: arguments)
    }
     
     func localizedFormatWithArray(_ arguments: [CVarArg]) -> String {
         let wording = localized()
         let prepareString = wording.replacingOccurrences(of: "{$}%", with: "{$}") // avoid error when contains % character
         let replaceString = prepareString.replacingOccurrences(of: "{$}", with: "%@")
         return String(format: replaceString, arguments: arguments)
     }
 }

