//
//  BaseButton.swift
//  BB
//

import UIKit

@IBDesignable
class BaseButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isExclusiveTouch = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isExclusiveTouch = true
    }
    
    // MAIN
    private func setup() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor.cgColor
        setNeedsDisplay()
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
            setNeedsDisplay()
        }
    }

    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
            setNeedsDisplay()
        }
    }

    @IBInspectable public var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            setNeedsDisplay()
        }
    }
    
    // MARK: - Set background color for state
    @IBInspectable public var disabledBackgroundColor: UIColor = .clear {
        didSet {
            setBackgroundColor(color: disabledBackgroundColor, forState: .disabled)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var normalBackgroundColor: UIColor = .clear {
        didSet {
            setBackgroundColor(color: normalBackgroundColor, forState: .normal)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var selectedBackgroundColor: UIColor = .clear {
        didSet {
            setBackgroundColor(color: selectedBackgroundColor, forState: .selected)
            setNeedsDisplay()
        }
    }
    
    var action:(() -> Void)? {
        didSet {
            removeTarget(self, action: #selector(self_Action), for: .touchUpInside)
            if action != nil {
                addTarget(self, action: #selector(self_Action), for: .touchUpInside)
            }
        }
    }
    
    /// Sets the background color to use for the specified button state.
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        
        let minimumSize: CGSize = CGSize(width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(minimumSize)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: minimumSize))
        }
        
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.clipsToBounds = true
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    // MARK: - Set Font for state
    // Sets one of the font properties, depending on which state was passed
    private var normalFont: UIFont?
    private var selectedFont: UIFont?
    private var disabledFont: UIFont?
    private var hightlightFont: UIFont?
    
    func setFont(font: UIFont, forState: UIControl.State) {
        switch forState {
        case .normal:
            normalFont = font
            
        case .selected:
            selectedFont = font
            
        case .disabled:
            disabledFont = font
            
        case .highlighted:
            hightlightFont = font
            
        default:
            break
        }
    }
    
    func setFontAllState(_ font: UIFont) {
        normalFont = font
        selectedFont = font
        disabledFont = font
        hightlightFont = font
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.showsTouchWhenHighlighted = false
        switch self.state {
        case .normal:
            if normalFont != nil {
                self.titleLabel?.font = normalFont
            }
            
        case .selected:
            if selectedFont != nil {
                self.titleLabel?.font = selectedFont
            }
            
        case .disabled:
            if disabledFont != nil {
                self.titleLabel?.font = disabledFont
            }
            
        case .highlighted:
            if hightlightFont != nil {
                self.titleLabel?.font = hightlightFont
            }
            
        default:
            break
        }
    }
    
    @objc func self_Action() {
        action?()
    }
}

// MARK: - RIGHT IMAGE ON BUTTON
class ButtonWithRightImage: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: (bounds.width - 35), bottom: 0, right: 0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}

extension BaseButton {
    
    /// Typealias for UIControl closure.
    public typealias UIControlTargetClosure = (UIControl) -> ()
    
    private class UIControlClosureWrapper: NSObject {
        let closure: UIControlTargetClosure
        init(_ closure: @escaping UIControlTargetClosure) {
            self.closure = closure
        }
    }
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIControlTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? UIControlClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, UIControlClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
    
    public func addAction(for event: UIControl.Event, closure: @escaping UIControlTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(BaseButton.closureAction), for: event)
    }
    
}
