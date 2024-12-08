//
//  BaseBBExtension.swift
//  BB
//

import UIKit
public struct BBExtension<Base> {
    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}

// MARK: - BBExtensionCompatible

public protocol BBExtensionCompatible {}
extension BBExtensionCompatible {
    public var bb: BBExtension<Self> {
        BBExtension(self)
    }
}
