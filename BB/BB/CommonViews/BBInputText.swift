//
//  BBInputText.swift
//  MyVIB_2.0
//

import UIKit

enum BBInputTextStyle {
    case standard
}

class BBInputText: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        custom()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        custom()
    }
    
    func custom() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = AppColor.baseBlue400.cgColor
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

}
