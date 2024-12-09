//
//  UIStackView+Extension.swift
//  BB
//

import UIKit

extension UIStackView {
    func addArragedViews(_ views: [UIView]) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
    
    func removeAllArrangedView() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
        
}
