//
//  UIView+Extension.swift
//  BB
//
//  Created by ha van dong on 12/8/24.
//

import UIKit
extension UIView: BBExtensionCompatible {}

extension  UIView {
    func pinEdges(to other: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
    
    func makeBorder(radius: CGFloat, width: CGFloat, color: UIColor) {
        layer.cornerRadius = radius
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}
