//
//  BBAlertView.swift
//  BB
//

import UIKit

enum BBString {
    // Plain text
    case plain(String)
    // Attributed text - whole text is formatted
    case rich(NSAttributedString)
}

class BBAlertView: UIView {
    private(set) weak var popup: FFPopup?

    static let kMinContentHeight: CGFloat = 134
    static let kMarginTop: CGFloat = 24
    static let kMarginBottom: CGFloat = 24

    static let kTitleFont = AppFont.baseTitle2
    static let kMesgFont = AppFont.baseBodyRegular
    static let kTitleColor = UIColor.black
    static let kMesgColor = AppColor.baseGrey500

    /*
    struct Visualize {
        //var primaryTextColor: UIColor = UIColor.colorFromString("121826")
        var primaryTextColor: UIColor = .white
    }

    var visualize: Visualize = Visualize() {
        didSet {
            layoutSubviews()
        }
    }
    */
    var primaryAction: (() -> (Void))?
    var secondaryAction: (() -> (Void))?
    
    /**
        Action will be called when close alert
        if Button is not empty mean action by button
        if button is empty mean action by touch out to close
     */
    var closeAction: (() -> Void)?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func layoutSubviews() {
        super.layoutSubviews()

    }

    // MARK: - INITIAL CUSTOM VIEW
    /*
    private var nibView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        //commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //commonInit()
    }

    func commonInit() {
        backgroundColor = UIColor.white
        self.layer.cornerRadius = 12
        nibView = loadNib()
        // use bounds not frame or it'll be offset
        nibView.frame = bounds
        // Adding custom subview on top of our view
        addSubview(nibView)
        nibView.pinEdges(to: self)
//        self.layoutIfNeeded()
    }
    */
    // MARK: - ACTIONS
    @IBAction func onCloseAction(_ sender: Any) {
        closeAction?()
         FFPopup.dismissAll()
        // self.hideInWindow()
    }

    @IBAction func onSecondaryAction(_ sender: Any) {
        secondaryAction?()
        FFPopup.dismissAll()
        // self.hideInWindow()
    }

    @IBAction func onPrimaryAction(_ sender: Any) {
        primaryAction?()
         FFPopup.dismissAll()
        // self.hideInWindow()
    }


    private func calculateLabelHeight(target: UILabel, shouldAdjust: Bool) -> CGFloat {
        target.sizeToFit()
        let textRect = ((target.text ?? "") as NSString).boundingRect(with: CGSize(width: target.frame.size.width ,
                                                                                   height: CGFloat.greatestFiniteMagnitude),
                                                                      options: [.usesFontLeading, .usesLineFragmentOrigin],
                                                                      attributes: [NSAttributedString.Key.font: target.font as Any],
                                                                      context: nil)
        var result = textRect.size.height
        if shouldAdjust { // adjust for .html & .rich content
            result -= target.font.pointSize
        } else {
            result += 5
        }
        return result
    }
    
    // MARK: - MAIN
    func createAlert(_ infoImage: String? = nil, title: BBString, message: BBString, _ primaryTitle: String? = nil, _ secondaryTitle: String? = nil, isAddClose: Bool = true, styleSingleButton: ButtonViewStyle = .themeGradient) {
        // Dismiss All Keyboard first
        UIApplication.shared.sendAction(#selector(self.resignFirstResponder), to:nil, from:nil, for:nil)
        // Do setup
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        // HEIGHT
        let alertWidth = AppUIConstant.SCREEN_WIDTH_PORTRAIT * 0.82
        self.frame = CGRect(x: 0, y: 0, width: alertWidth, height: 1000)
        // Start Calculating...
        var totalHeight: CGFloat = 0
        let marginTop: CGFloat = 24
        var marginBottom: CGFloat = 40

        if isAddClose {
            // Add close button
            let closeBt = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            closeBt.setBackgroundImage(UIImage(named: "cm_alert_close_ic"), for: .normal)
            closeBt.addTarget(self, action: #selector(onCloseAction(_:)), for: .touchDown)
            closeBt.tag = 9999
            self.addSubview(closeBt)
            closeBt.snp.makeConstraints { (make) in
                make.width.height.equalTo(40)
                make.top.equalTo(8)
                make.trailing.equalTo(-8)
            }
        }

        var isAddedTitleImage = false
        // Add title image
        if let imgInfo = infoImage, let image = UIImage.imageByTheme(named: imgInfo) {
            isAddedTitleImage = true
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            self.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.top.equalTo(24)
                make.width.height.equalTo(60)
                make.centerX.equalToSuperview()
            }
            // Calculate total height
            totalHeight += 60
        }

        // Add title label
        let labelTitle = UILabel(frame: CGRect(x: 0, y: 0, width: alertWidth - 38, height: 0))
        labelTitle.textColor = BBAlertView.kTitleColor
        labelTitle.textAlignment = .center
        labelTitle.numberOfLines = 0
        labelTitle.font = BBAlertView.kTitleFont
        var shouldAdjustTitle = false
        switch title {
        case .plain(let text):
            labelTitle.text = text
        case .rich(let text):
            shouldAdjustTitle = true
            labelTitle.attributedText = text
        }
        let titleHeight = calculateLabelHeight(target: labelTitle, shouldAdjust: shouldAdjustTitle)
        self.addSubview(labelTitle)
        labelTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(isAddedTitleImage ? 100 : 24)
            make.leading.equalTo(19)
            make.trailing.equalTo(-19)
            make.height.equalTo(titleHeight)
        }
        // Calculate total height
        totalHeight += titleHeight
        if isAddedTitleImage {
            totalHeight += 16
        }
        // Add message label
        let labelMsg = UILabel(frame: CGRect(x: 0, y: 0, width: alertWidth - 38, height: 0))
        labelMsg.textColor = BBAlertView.kMesgColor
        labelMsg.textAlignment = .center
        labelMsg.numberOfLines = 0
        labelMsg.font = BBAlertView.kMesgFont
        var shouldAdjustMesg = false
        switch message {
        case .plain(let text):
            labelMsg.text = text
        case .rich(let text):
            shouldAdjustMesg = true
            labelMsg.attributedText = text
        }
        let messageHeight = calculateLabelHeight(target: labelMsg, shouldAdjust: shouldAdjustMesg)
        self.addSubview(labelMsg)
        labelMsg.snp.makeConstraints { (make) in
            make.top.equalTo(labelTitle.snp.bottom).offset(10)
            make.leading.leading.equalTo(19)
            make.trailing.equalTo(-19)
            make.height.equalTo(messageHeight)
        }
        if shouldAdjustMesg || labelMsg.text != "" {
            // Caculate totalHeigh
            totalHeight += messageHeight
            totalHeight += 10
        }
        
        // Add Control Button
        if primaryTitle == nil && secondaryTitle == nil {
            // Do not add any control
            marginBottom = 40
        } else {
            if let prTitle = primaryTitle, let seTitle = secondaryTitle {
                // Do add 2 button control
                let priButton = BBButton()
                priButton.setTitle(prTitle, for: .normal)
                priButton.setFont(font: AppFont.baseSubheadlineMedium, forState: .normal)
                // priButton.setTitleColor(.white, for: .normal)
                priButton.setTitleColor(AppColor.baseGrey900, for: .normal)
                priButton.addTarget(self, action: #selector(onPrimaryAction(_:)), for: .touchUpInside)
                priButton.layer.cornerRadius = 20
                priButton.layer.masksToBounds = true
                priButton.viewStyle = .themeGradient
                // priButton.setTitleColor(AppColor.baseGrey900, for: .normal)

                let seButton = UIButton()
                seButton.setTitle(seTitle, for: .normal)
                seButton.titleLabel?.font = AppFont.baseSubheadlineMedium
                seButton.setTitleColor(AppColor.baseGrey900, for: .normal)
                seButton.addTarget(self, action: #selector(onSecondaryAction(_:)), for: .touchUpInside)
                seButton.layer.cornerRadius = 20
                seButton.layer.borderWidth = 2
                seButton.layer.borderColor = AppColor.baseGrey200.cgColor
                seButton.layer.masksToBounds = true

                let stView = UIStackView()
                stView.axis = .horizontal
                stView.distribution = .fillEqually
                stView.spacing = 12
                stView.addArrangedSubview(seButton)
                stView.addArrangedSubview(priButton)
                self.addSubview(stView)
                stView.snp.makeConstraints { (make) in
                    make.height.equalTo(40)
                    make.top.equalTo(labelMsg.snp.bottom).offset(16)
                    make.leading.equalTo(19)
                    make.trailing.equalTo(-19)
                }
                // Calculate total height
                totalHeight += 40
                totalHeight += 16
                marginBottom = 24
            } else {
                let titleControl = (primaryTitle == nil) ? (secondaryTitle ?? "") : (primaryTitle ?? "")
                // Do add only one button
                let priButton = BBButton()
                priButton.setTitle(titleControl, for: .normal)
                priButton.setTitleColor(AppColor.baseGrey900, for: .normal)
                priButton.setFont(font: AppFont.baseSubheadlineMedium, forState: .normal)
                priButton.addTarget(self, action: #selector(onPrimaryAction(_:)), for: .touchUpInside)
                priButton.layer.cornerRadius = 20
                priButton.layer.masksToBounds = true
                priButton.viewStyle = styleSingleButton
                // priButton.setTitleColor(AppColor.baseGrey900, for: .normal)
                var widthOfButton = titleControl.width(withConstrainedHeight: 40, font: AppFont.baseSubheadlineMedium) + 52 // 56 is for margin
                if widthOfButton < 100 {
                    widthOfButton = 100
                }
                if widthOfButton >= alertWidth - 38 {
                    widthOfButton = alertWidth - 38
                }
                self.addSubview(priButton)
                priButton.snp.makeConstraints { (make) in
                    make.top.equalTo(labelMsg.snp.bottom).offset(16)
                    make.width.equalTo(widthOfButton)
                    make.height.equalTo(40)
                    make.centerX.equalToSuperview()
                }
                // Calculate total height
                totalHeight += 40
                totalHeight += 16
                marginBottom = 24
            }
        }
        // Summary info Rect
        totalHeight += marginBottom
        totalHeight += marginTop
        self.frame = CGRect(x: 0, y: 0, width: alertWidth, height: totalHeight)
        self.setNeedsDisplay()
    }

    func autoHide(after miliSeconds: Int = AppConstant.kAlertAutoDismissingInterval, completion: (() -> Void)?) {
        self.viewWithTag(9999)?.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(miliSeconds)) {[weak self] in
            self?.popup?.dismiss(animated: true)
            // self?.hideInWindow()
            completion?()
        }
    }
}

// MARK: - MAIN CALLING
extension BBAlertView{

    @discardableResult
    static func show(infoImage: String? = nil,
                     title: String,
                     message: String,
                     primaryTitle: String? = nil,
                     secondaryTitle: String? = nil,
                     primaryAction: (() -> Void)? = nil,
                     secondaryAction: (() -> Void)? = nil,
                     closeAction:(()->Void)? = nil,
                     isAddClose: Bool = true, styleSingleButton: ButtonViewStyle = .themeGradient) -> BBAlertView {
        return show(infoImage: infoImage,
                    title: .plain(title),
                    message: .plain(message),
                    primaryTitle: primaryTitle,
                    secondaryTitle: secondaryTitle,
                    primaryAction: primaryAction,
                    secondaryAction: secondaryAction,
                    closeAction: closeAction,
                    isAddClose: isAddClose, styleSingleButton: styleSingleButton)
    }

    @discardableResult
    static func show(infoImage: String? = nil,
                     title: BBString,
                     message: BBString,
                     primaryTitle: String? = nil,
                     secondaryTitle: String? = nil,
                     primaryAction: (() -> Void)? = nil,
                     secondaryAction: (() -> Void)? = nil,
                     closeAction:(()->Void)? = nil,
                     isAddClose: Bool = true, styleSingleButton: ButtonViewStyle = .themeGradient) -> BBAlertView {
        let alert = BBAlertView()
        alert.createAlert(infoImage, title: title, message: message, primaryTitle, secondaryTitle, isAddClose: isAddClose, styleSingleButton: styleSingleButton)
        alert.primaryAction = primaryAction
        alert.secondaryAction = secondaryAction
        alert.closeAction = closeAction

        let popup = FFPopup(contentView: alert,
                            showType: .bounceIn,
                            dismissType: .bounceOut,
                            maskType: .dimmed,
                            dismissOnBackgroundTouch: false,
                            dismissOnContentTouch: false)
        let layout = FFPopupLayout(horizontal: .center, vertical: .center)
        FFPopup.dismissAll()
        popup.show(layout: layout)
        alert.popup = popup
        return alert
    }

    func show(infoImage: String? = nil,
              title: String,
              message: String,
              primaryTitle: String? = nil,
              secondaryTitle: String? = nil,
              isAddClose: Bool = true, styleSingleButton: ButtonViewStyle = .themeGradient) {
        show(infoImage: infoImage,
             title: .plain(title),
             message: .plain(message),
             primaryTitle: primaryTitle,
             secondaryTitle: secondaryTitle,
             isAddClose: isAddClose, styleSingleButton: styleSingleButton)
    }

    func show(infoImage: String? = nil,
              title: BBString,
              message: BBString,
              primaryTitle: String? = nil,
              secondaryTitle: String? = nil,
              isAddClose: Bool = true, styleSingleButton: ButtonViewStyle = .themeGradient){
        self.createAlert(infoImage, title: title, message: message, primaryTitle, secondaryTitle, isAddClose: isAddClose, styleSingleButton: styleSingleButton)
        let popup = FFPopup(contentView: self,
                            showType: .bounceIn,
                            dismissType: .bounceOut,
                            maskType: .dimmed,
                            dismissOnBackgroundTouch: false,
                            dismissOnContentTouch: false)
        let layout = FFPopupLayout(horizontal: .center, vertical: .center)
        popup.show(layout: layout)
        self.popup = popup
    }
}
