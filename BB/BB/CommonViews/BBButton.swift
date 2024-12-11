//
//  VIBButton.swift
//  BB
//
//  Created by digital on 11/05/2021.
//

import UIKit
import SnapKit

struct Visualize {
    let kPadding: CGFloat
    let kSmallPadding: CGFloat
    let kIconWidth: CGFloat
    let kIconPadding: CGFloat
}

fileprivate let defaultVisulize = Visualize(kPadding: 17, kSmallPadding: 13, kIconWidth: 24, kIconPadding: 10)

enum ButtonStyle: Int {
    case standard = 0
    case small
    case processing
    case arrow
}

enum ButtonViewStyle: Int {
    case yellowGradient = 0
    case whiteWithBorder
    case grey
    case black
    case whiteWithShadow
    case clear
    case blueGradient
    case redGradient
    case themeGradient
    case clearWithBorder
}

/*
 Using Example:
 Use from interface file or add view programmatically
 Ex: - @IBOutlet weak var button: VIBButton!
     - let button = VIBButton(frame: CGRect)
 */

class BBButton: BaseButton {
    
    /*
     Set size for some attributes
     Default: kPadding: 17, kSmallPadding: 13, kIconWidth: 24, kIconPadding: 10
     */
    var visualize: Visualize = defaultVisulize {
        didSet {
            updateViewStyle()
        }
    }
    
    /*
     Set style for button
     Default: standard
     */
    var style: ButtonStyle = .standard {
        didSet {
            updateStyle()
        }
    }
    
    /*
     Set style for background gradient, border color
     Default: themeGradient
     */
    var viewStyle: ButtonViewStyle = .themeGradient {
        didSet {
            updateViewStyle()
        }
    }
    
    /*
     Add left icon - please assign image name string
     Default: hidden
     */
    @IBInspectable public var leftIcon: String = "" {
        didSet {
            addLeftIcon(leftIcon)
        }
    }

    /*
     Add right icon - please assign image name string
     Default: hidden
     */
    @IBInspectable public var rightIcon: String = "" {
        didSet {
            addRightIcon(rightIcon)
        }
    }
    
    private var gradientLayer: CAGradientLayer?
    private var leftIconImv: UIImageView?
    private var rightIconImv: UIImageView?
    private var middleIconImv: UIImageView?
    private var processingView: UIActivityIndicatorView?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // add background gradient
        // gradientLayer?.removeFromSuperlayer()
        gradientLayer?.frame = bounds
        gradientLayer?.cornerRadius = 10
        layer.cornerRadius = 10
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        
        if title?.isEmpty ?? false {
            return
        }
        
        // update width khi content thay đổi
        let stringWidth = widthOfString()
        var contentWidth = stringWidth
        
        switch style {
        case .processing:
            if let _ = processingView {
                contentWidth = 185
            }
        default:
            // update width khi có icon left hoặc right
            let padding = (style == .small) ? visualize.kSmallPadding : visualize.kPadding
            contentWidth += padding*2
            if leftIconImv != nil && rightIconImv != nil {
                contentWidth += visualize.kIconPadding*2
            }
            if let _ = leftIconImv {
                contentWidth += visualize.kIconWidth
                if rightIconImv == nil {
                    contentWidth += visualize.kIconPadding*2
                }
            }
            if let _ = rightIconImv {
                contentWidth += visualize.kIconWidth
                if leftIconImv == nil {
                    contentWidth += visualize.kIconPadding*2
                }
            }
        }
        
        updateWidthConstraint(contentWidth)
    }
    
    fileprivate func setupView() {
        // init gradient object default
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = self.bounds
        gradientLayer?.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        gradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer?.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer?.cornerRadius = frame.size.height/2
        if let gl = gradientLayer {
            layer.insertSublayer(gl, at: 0)
        }
        
        // set thuộc tính cho button
        titleLabel?.font = (style == .small) ? AppFont.baseSubheadlineMedium : AppFont.baseHeadline
        setTitleColor(AppColor.baseGrey900, for: .normal)
        layer.cornerRadius = frame.size.height/2
                
        // set width mặc định từ content
        let stringWidth = widthOfString()
        let padding = (style == .small) ? visualize.kSmallPadding : visualize.kPadding
        updateWidthConstraint(stringWidth + padding*2)
        
        updateViewStyle()
    }
    
    private func widthOfString() -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: self.titleLabel?.font ?? AppFont.baseHeadline]
        let size = (titleLabel?.text ?? "").size(withAttributes: fontAttributes)
        return size.width
    }
    
    func updateWith() {
        let stringWidth = widthOfString()
        let padding = (style == .small) ? visualize.kSmallPadding : visualize.kPadding
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: stringWidth + padding*2)
        ])
        self.layoutIfNeeded()
    }
    
    private func updateWidthConstraint(_ newWidth: CGFloat) {
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.width {
                constraint.constant = newWidth
                break
            }
        }
    }
    
    private func currentWidth() -> CGFloat {
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.width {
                return constraint.constant
            }
        }
        
        return 0
    }
    
    private func addLeftIcon(_ image: String) {
        leftIconImv = UIImageView()
        leftIconImv!.image = UIImage(named: image)
        leftIconImv!.contentMode = .scaleAspectFit
        addSubview(leftIconImv!)
        
        let padding = (style == .small) ? visualize.kSmallPadding : visualize.kPadding
        leftIconImv!.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(visualize.kIconWidth)
            make.leading.equalToSuperview().offset(padding)
        }
        
        // update width khi add thêm icon
        var contentWidth = currentWidth() + visualize.kIconWidth
        if rightIconImv == nil {
            contentWidth += visualize.kIconPadding*2
        }
        updateWidthConstraint(contentWidth)
        titleEdgeInsets.left = padding + visualize.kIconPadding
        
        updateContentColor()
    }
    
    private func addRightIcon(_ image: String) {
        rightIconImv = UIImageView()
        rightIconImv!.image = UIImage(named: image)
        rightIconImv!.contentMode = .scaleAspectFit
        addSubview(rightIconImv!)
        
        let padding = (style == .small) ? visualize.kSmallPadding : visualize.kPadding
        rightIconImv!.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(visualize.kIconWidth)
            make.trailing.equalToSuperview().offset(-padding)
        }
        
        // update width khi add thêm icon
        var contentWidth = currentWidth() + visualize.kIconWidth
        if leftIconImv == nil {
            contentWidth += visualize.kIconPadding*2
        }
        updateWidthConstraint(contentWidth)
        titleEdgeInsets.right = padding + visualize.kIconPadding
        
        updateContentColor()
    }
    
    private func setupArrowIcon() {
//        updateWidthConstraint(frame.size.height)
        setTitle("", for: .normal)
        
        // add arrow icon
        middleIconImv = UIImageView()
        middleIconImv!.image = UIImage(named: "cm_accessory_ic")
        middleIconImv!.contentMode = .scaleAspectFit
        addSubview(middleIconImv!)
        
        middleIconImv!.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        updateContentColor()
    }
    
    private func addProcessingIcon() {
        processingView = UIActivityIndicatorView()
        processingView!.startAnimating()
        addSubview(processingView!)
        
        processingView!.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(visualize.kIconWidth)
            make.leading.equalToSuperview().offset(visualize.kPadding)
        }
        
        updateWidthConstraint(185)
        titleEdgeInsets.left = visualize.kPadding
        updateContentColor()
    }
    
    private func updateViewStyle() {
        // gradientLayer?.removeFromSuperlayer()
        gradientLayer?.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        
        // update UI theo style
        switch viewStyle {
        case .yellowGradient:
            gradientLayer?.colors = [AppColor.baseFireLight.cgColor, AppColor.baseFireDark.cgColor]
//            if let gl = gradientLayer {
//                layer.insertSublayer(gl, at: 0)
//            }
        case .whiteWithBorder:
            layer.borderWidth = 2.0
            layer.borderColor = AppColor.baseGrey200.cgColor
            backgroundColor = UIColor.white
        case .grey:
            backgroundColor = AppColor.baseGrey100
        case .black:
            backgroundColor = AppColor.baseGrey900
        case .whiteWithShadow:
            backgroundColor = UIColor.white
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.12
            layer.shadowOffset = CGSize(width: 1, height: 1)
            layer.shadowRadius = 2
        case .blueGradient:
            gradientLayer?.colors = AppColor.blueGradientButtonColor
//            if let gl = gradientLayer {
//                layer.insertSublayer(gl, at: 0)
//            }
        case .redGradient:
            gradientLayer?.colors = AppColor.orgranGradientButtonColor
//            if let gl = gradientLayer {
//                layer.insertSublayer(gl, at: 0)
//            }
        case .themeGradient:
            backgroundColor = AppColor.themeColor

//            layer.borderWidth = 0.0
//            layer.borderColor = UIColor.clear.cgColor
//            gradientLayer?.colors = AppColor.themeGradientColor
//            if let gl = gradientLayer {
//                layer.insertSublayer(gl, at: 0)
//            }
        case .clear:
            backgroundColor = AppColor.baseGrey50
            layer.shadowOpacity = 0
        case .clearWithBorder:
            layer.borderWidth = 2.0
            layer.borderColor = AppColor.baseGrey200.cgColor
            backgroundColor = UIColor.clear
        }
        
        updateContentColor()
    }
    
    private func updateContentColor() {
        let white = (viewStyle == .black || viewStyle == .blueGradient || viewStyle == .redGradient || viewStyle == .themeGradient)
        setTitleColor(white ? UIColor.white : AppColor.baseGrey900, for: .normal)
        setTitleColor(white ? UIColor.white : AppColor.baseGrey900, for: .highlighted)

        // tự set màu image bằng code
        if let leftIconImv = leftIconImv {
            leftIconImv.image = leftIconImv.image?.withRenderingMode(.alwaysTemplate)
            leftIconImv.tintColor = white ? UIColor.white : AppColor.baseGrey900
        }
        
        if let rightIconImv = rightIconImv {
            rightIconImv.image = rightIconImv.image?.withRenderingMode(.alwaysTemplate)
            rightIconImv.tintColor = white ? UIColor.white : AppColor.baseGrey900
        }
        
        if let middleIconImv = middleIconImv {
            middleIconImv.image = middleIconImv.image?.withRenderingMode(.alwaysTemplate)
            middleIconImv.tintColor = white ? UIColor.white : AppColor.baseGrey900
        }
        
        if let processingView = processingView {
            processingView.style = white ? .white : .gray
        }
    }
    
    private func updateStyle() {
        switch style {
        case .small:
            // thêm độ dài với content
            titleLabel?.font = AppFont.baseSubheadlineMedium
            var contentWidth = widthOfString() + visualize.kSmallPadding*2
            
            if leftIconImv != nil && rightIconImv != nil {
                contentWidth += visualize.kIconPadding*2
            }
            
            // thêm độ dài với left icon
            if let leftIconImv = leftIconImv {
                contentWidth += visualize.kIconWidth
                if rightIconImv == nil {
                    contentWidth += visualize.kIconPadding*2
                }
                titleEdgeInsets.left = visualize.kSmallPadding + visualize.kIconPadding
                leftIconImv.snp.updateConstraints { make in
                    make.leading.equalToSuperview().offset(visualize.kSmallPadding)
                }
            }
            
            // thêm độ dài với right icon
            if let rightIconImv = rightIconImv {
                contentWidth += visualize.kIconWidth
                if leftIconImv == nil {
                    contentWidth += visualize.kIconPadding*2
                }
                titleEdgeInsets.right = visualize.kSmallPadding + visualize.kIconPadding
                rightIconImv.snp.updateConstraints { make in
                    make.trailing.equalToSuperview().offset(-visualize.kSmallPadding)
                }
            }
            
            updateWidthConstraint(contentWidth)
        case .processing:
            setTitle("Processing", for: .normal)
            addProcessingIcon()
        case .arrow:
            setupArrowIcon()
        default:
            break
        }
    }
}
