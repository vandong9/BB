//
//  VIBInputText.swift
//  MyVIB_2.0
//
//  Created by digital on 07/05/2021.
//

import UIKit

private let kPadding: CGFloat = 16
private let kTitleHeight: CGFloat = 16
private let kClearButtonWidth: CGFloat = 30
private let kClearButtonRightPadding: CGFloat = 9
private let kIconLeftPadding: CGFloat = 13
private var kIconRightPadding: CGFloat = 13
private var kIconWidth: CGFloat = 30

typealias VIBInputTextDidChange = (UITextField) -> (Void)
protocol VIBInputTextDelegate: AnyObject {
    func shouldChangeCharactersIn(textField: UITextField, range: NSRange, text: String) -> Bool
}

/*
 Using Example:
 Use from interface file or add view programmatically
 Ex: - @IBOutlet weak var inputText: VIBInputText!
     - let inputText = VIBInputText(frame: CGRect)
 Note: Please set specific height constraint
 */

class VIBInputText: UITextField {
    private var unitLabel: UILabel!
    private var titleLabel: UILabel!
    fileprivate var clearButton: UIButton!
    fileprivate var padding = UIEdgeInsets.zero
    
    var rightIconAction: (() -> Void)?
    var returnKeyCompletion: () -> Void = {}
    private var rightIconTapGesture: UITapGestureRecognizer!

    var unit: String = "" {
        didSet {
            unitLabel.text = unit
            updateUnitLablePosition()
        }
    }

    /*
     Custom delegate
     */
    weak var customDelegate: VIBInputTextDelegate?

    /*
     Callback of view when text change
     */
    var textDidChange: VIBInputTextDidChange?
    
    /*
     Callback of view when text should begin editing
     */
    var textShouldBeginEditing: VIBInputTextDidChange?
    
    /*
     Enable or disable clear text button
     Default: enable
     */
    var clearModeEnable: Bool = true {
        didSet {
            let unitWith = unitLabel.frame.width
            if clearModeEnable {
                padding.right = kClearButtonWidth + kClearButtonRightPadding + unitWith + (self.rightView == nil ? 0 : kIconWidth)
            } else {
                padding.right = kPadding + unitWith
            }
            layoutIfNeeded()
        }
    }
    
    var isHiddenClearButton: Bool = true {
        didSet {
            clearButton.isHidden = isHiddenClearButton
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
            if rightIcon.isNotEmpty {
                addRightIcon(rightIcon)
            } else {
                self.rightView = nil
                self.rightViewMode = .never
                if clearModeEnable {
                    padding.right = kClearButtonWidth + kClearButtonRightPadding + (self.rightView == nil ? 0 : kIconWidth)
                } else {
                    padding.right = kPadding
                }
                
                clearButton.snp.updateConstraints { make in
                    make.trailing.equalToSuperview().offset(-kClearButtonRightPadding)
                }
                layoutIfNeeded()
            }
        }
    }

    /*
     Add title placeholder
     Default: 'Label'
     */
    @IBInspectable public var title: String {
        get {
            return titleLabel.text ?? ""
        }
        set {
            titleLabel.text = newValue
        }
    }

    /*
     Add textfield content
     */
    @IBInspectable public var content: String {
        get {
            return self.text ?? ""
        }
        set {
            self.text = newValue
            self.clearButton.isHidden = !(!newValue.isEmpty && clearModeEnable)
            if !newValue.isEmpty {
                titleLabelUpdateLayout(true)
            }
        }
    }
    
    /** Update width right icon*/
    @IBInspectable public var widthRightIcon: CGFloat = 30.0 {
        didSet {
            kIconWidth = widthRightIcon
            layoutIfNeeded()
        }
    }
    
    /** Update width right icon*/
    @IBInspectable public var padingRightIcon: CGFloat = 13.0 {
        didSet {
            kIconRightPadding = padingRightIcon
            layoutIfNeeded()
        }
    }

    /**
            Action for
     */
    @IBInspectable var isPasteEnabled: Bool = true
    @IBInspectable var isSelectEnabled: Bool = true
    @IBInspectable var isSelectAllEnabled: Bool = true
    @IBInspectable var isCopyEnabled: Bool = false
    @IBInspectable var isCutEnabled: Bool = true
    @IBInspectable var isDeleteEnabled: Bool = true
    
    /*
     Enable or disable border highlight
     Default: true
     */
    var borderHighlight: Bool = true

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    fileprivate func setupView() {
        padding = UIEdgeInsets(top: 0, left: kPadding, bottom: 0, right: kClearButtonWidth + kClearButtonRightPadding)
        backgroundColor = UIColor.white
        layer.borderWidth = 1.0
        layer.borderColor = AppColor.baseGrey200.cgColor
        layer.cornerRadius = 6.0
        font = AppFont.baseSmallBodyLink
        delegate = self
        autocorrectionType = .no
        tintColor = AppColor.baseGrey900

        // shadow
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2

        addTarget(self, action: #selector(textViewDidChange(_:)), for: .editingChanged)

        // add title
        titleLabel = UILabel()
        titleLabel.textColor = AppColor.baseGrey500
        titleLabel.font = AppFont.baseSubheadlineMedium
        titleLabel.text = "Label"
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(kTitleHeight)
            make.top.equalToSuperview().offset(frame.size.height/2 - kTitleHeight/2)
        }
        
        // add clear icon
        clearButton = UIButton()
        clearButton.setImage(UIImage(named: "cm_clear_text_ic"), for: .normal)
        clearButton.isHidden = true
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        addSubview(clearButton)

        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(kClearButtonWidth)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-kClearButtonRightPadding)
        }
        
        rightIconTapGesture = UITapGestureRecognizer(target: self, action: #selector(rightIconTabGestureHandler))
        
        unitLabel = UILabel()
        unitLabel.text = unit
        unitLabel.font = AppFont.baseInputMedium
        unitLabel.textColor = AppColor.baseGrey900
        addSubview(unitLabel)
        unitLabel.snp.makeConstraints {
            $0.top.equalTo(8)
            $0.left.equalTo(padding.left + 4)
            $0.height.equalTo(18)
        }
        unitLabel.isHidden = true
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += kIconLeftPadding
        return rect
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= kIconRightPadding
        return rect
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(UIResponderStandardEditActions.paste(_:)) where !isPasteEnabled,
            #selector(UIResponderStandardEditActions.select(_:)) where !isSelectEnabled,
            #selector(UIResponderStandardEditActions.selectAll(_:)) where !isSelectAllEnabled,
            #selector(UIResponderStandardEditActions.copy(_:)) where !isCopyEnabled,
            #selector(UIResponderStandardEditActions.cut(_:)) where !isCutEnabled,
            #selector(UIResponderStandardEditActions.delete(_:)) where !isDeleteEnabled:
            return false
        default:
            //return true : this is not correct
            return super.canPerformAction(action, withSender: sender)
        }
    }
    
    fileprivate func titleLabelUpdateLayout(_ inputActive: Bool) {
        let needUpdate = (inputActive || !self.text!.isEmpty)
        if needUpdate {
            let closerPadding: CGFloat = 1
            let txfHeight = frame.size.height
            let newTxfheight = txfHeight*3/5
            padding.top = txfHeight - newTxfheight - closerPadding

            titleLabel.font = AppFont.medium(size: 12)
            titleLabel.textColor = AppColor.baseGrey400
            titleLabel.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(frame.size.height/4 - kTitleHeight/4 + closerPadding)
            }
        } else {
            padding.top = 0
            titleLabel.font = AppFont.baseSubheadlineMedium
            titleLabel.textColor = AppColor.baseGrey500
            titleLabel.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(frame.size.height/2 - kTitleHeight/2)
            }
        }
        
        unitLabel.isHidden = !needUpdate
        unitLabel.snp.updateConstraints {
            $0.top.equalTo(padding.top + ((self.frame.height - padding.top - unitLabel.frame.height) / 2))
        }

        layoutIfNeeded()
    }

    private func highlightBorder(_ inputActive: Bool) {
        layer.borderColor = (inputActive && borderHighlight) ? AppColor.baseGrey500.cgColor : AppColor.baseGrey200.cgColor
    }

    @objc fileprivate func clearText() {
        clearButton.isHidden = true
        self.text = ""
        self.insertText("") // This line of code to trigger delegate actions
        updateUnitLablePosition()
    }
    
    func updateUnitLablePosition() {
        let fontAttributes = [NSAttributedString.Key.font: self.font]
        let size = (self.text ?? "").size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        unitLabel.snp.updateConstraints {
            $0.left.equalTo(max(size.width + padding.left + 2, 4))
        }
    }

    
    private func addLeftIcon(_ image: String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kIconWidth, height: kIconWidth))
        imageView.image = UIImage(named: image)
        self.leftView = imageView
        self.leftViewMode = .always

        padding.left = kPadding + kIconWidth + kIconLeftPadding
        titleLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(padding.left)
        }
        layoutIfNeeded()
    }

    private func addRightIcon(_ image: String) {
        rightView?.removeGestureRecognizer(rightIconTapGesture)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kIconWidth, height: kIconWidth))
        imageView.image = UIImage(named: image)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(rightIconTapGesture)
        self.rightView = imageView
        self.rightViewMode = .always
        
        if clearModeEnable {
            padding.right = kClearButtonWidth + kIconWidth + kIconRightPadding
        } else {
            padding.right = kIconWidth + kIconRightPadding
        }
        clearButton.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(-(kIconWidth + kIconRightPadding))
        }
        layoutIfNeeded()
    }
    
    @objc private func rightIconTabGestureHandler() {
        rightIconAction?()
    }
}

// MARK: UITextFieldDelegate
extension VIBInputText: UITextFieldDelegate {

    @objc func textViewDidChange(_ textField: UITextField) {
        clearButton.isHidden = textField.text!.isEmpty || !clearModeEnable
        textDidChange?(textField)
        if unit.isNotEmpty {
            updateUnitLablePosition()
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        titleLabelUpdateLayout(true)
        highlightBorder(true)
        clearButton.isHidden = textField.text!.isEmpty || !clearModeEnable
        textShouldBeginEditing?(textField)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        titleLabelUpdateLayout(false)
        highlightBorder(false)
        clearButton.isHidden = true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return customDelegate?.shouldChangeCharactersIn(textField: textField, range: range, text: string) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.returnKeyCompletion()
        return true
    }
}


//class VIBInputMoneyText: VIBInputText {
//    private let enableCharacters = "1234567890"
//    private let enableDecimalCharacters = "1234567890."
//
//    var maxNumberLenght: Int = 18 // Note: nếu dùng số có decimal, thì phần real sẽ sẽ phải nhỏ nhơn max là 1 để cho dấu .
//    var enabelDecimal = false {
//        didSet {
//            self.keyboardType = enabelDecimal ? .numbersAndPunctuation : .numberPad
//        }
//    }
//
//    var value: Double? {
//        get {
//            return text?.removeSpecialChars(specialString: ",").toDouble()
//        }
//        set {
//            let value = (newValue?.toString() ?? "").formatMoney()
//            text = value
//            updateUnitLablePosition()
//        }
//    }
//    
//    override func setupView() {
//        super.setupView()
//        unit = ""
//        enabelDecimal = false
//    }
//    
//    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if string.isNotEmpty {
//            let enableChars = enabelDecimal ? enableDecimalCharacters : enableCharacters
//            if !enableChars.contains(string) { return false }
//        }
//        
//        let currentText = textField.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else { return false }
//        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//        
//        let components = updatedText.components(separatedBy: ".")
//        if components.count < 1 || components.count > 2 { return false }
//        
//        let rawText = (components.first ?? "").removeSpecialChars(specialString: ",")
//
//        if components.count == 1 {
//            if rawText.count > maxNumberLenght {
//                return false
//            }
//
//            textField.text = rawText.formatMoney()
//            textViewDidChange(self)
//            updateUnitLablePosition()
//            return false
//        }
//        
//        if components.count == 2 {
//            if rawText.count == maxNumberLenght {
//                return false
//            }
//
//            let decimalComponent = components[1]
//            if decimalComponent.count > 2 { return false }
//            let moneyString = rawText.formatMoney() + "." + decimalComponent
//            textField.text = moneyString
//            textViewDidChange(self)
//            updateUnitLablePosition()
//            return false
//        }
//    
//        return true
//    }
//}

/*
   Time using in this control is default device time zone
   to support utils function about date which using Calendar
*/

//class VIBInputDateText: VIBInputText {
//    lazy var dateFormate: DateFormatter = {
//        let dateformate = DateFormatter()
//        dateformate.dateFormat = "dd/MM/yyyy"
//        dateformate.calendar = Calendar(identifier: .gregorian)
//        return dateformate
//    }()
//    var endDate: Date?
//    var startDate: Date?
//    var defaultDate: Date? {
//        didSet {
//            if let defaultDate = defaultDate {
//                content = dateFormate.string(from: defaultDate)
//            }
//        }
//    }
//    var inputedDate: Date? {
//        return text != nil ? dateFormate.date(from: text!) : nil
//    }
//    override var content: String {
//        get {
//            return self.text ?? ""
//        }
//        set {
//            self.text = newValue
//            if !newValue.isEmpty {
//                titleLabelUpdateLayout(true)
//            }
//            clearButton.isHidden = (self.text ?? "").count == 0
//        }
//    }
//
//    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString text: String) -> Bool {
//        defer {
//            clearButton.isHidden = (textField.text ?? "").count == 0
//        }
//        guard text.isNumber() else { return false }
//        
//        var currentText = textField.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else { return false }
//        var updatedText = currentText.replacingCharacters(in: stringRange, with: text)
//        if currentText.count > updatedText.count {
//            self.text = ""
//            self.insertText(updatedText.trimmingCharacters(in: CharacterSet(charactersIn: "/"))) // This line of code to trigger delegate actions
//            return false
//        }
//        if updatedText.count > 10 { return false }
//        
//        currentText = currentText.replacingOccurrences(of: "/", with: "")
//        updatedText = updatedText.replacingOccurrences(of: "/", with: "")
//        
//        switch currentText.count {
//        case 0:
//            if text.toInt() > 3 {
//                return false
//            }
//        case 1:
//            if updatedText.toInt() > 31 {
//                return false
//            }
//        case 2:
//            if text.toInt() > 1 {
//                return false
//            }
//        case 3:
//            if updatedText.substring(fromIndex: 2).toInt() > 12 {
//                return false
//            }
//            if updatedText.substring(fromIndex: 2).toInt() == 2, updatedText.substring(toIndex: 2).toInt() > 29 {
//                return false
//            }
//        case 4:
//            if text.toInt() > 2 {
//                return false
//            }
//        default: break
//        }
//        
//        let formatedDateString = formatDate(text: updatedText)
//        if formatedDateString.count == 10, let date = dateFormate.date(from: formatedDateString)?.dateFor(.startOfDay) {
//            if var startDate = startDate {
//                startDate = startDate.dateFor(.startOfDay)
//                if date.compare(startDate) == .orderedAscending {
//                    return false
//                }
//            }
//            if var endDate = endDate {
//                endDate = endDate.dateFor(.startOfDay)
//                if date.compare(endDate) == .orderedDescending {
//                    return false
//                }
//            }
//        }
//
//        self.text = ""
//        self.insertText(formatedDateString) // This line of code to trigger delegate actions
//        return false
//    }
//    
//    func formatDate(text: String) -> String {
//        if text.count < 3 {
//            return text
//        }
//        if text.count < 5 {
//            return String(format: "%@/%@", text.substring(toIndex: 2), text.substring(fromIndex: 2))
//        }
//        return String(format: "%@/%@/%@", text.substring(toIndex: 2), text.substring(fromIndex: 2).substring(toIndex: 2), text.substring(fromIndex: 4))
//    }
//}


//class VIBInputMonthYearText: VIBInputText {
//    lazy var dateFormate: DateFormatter = {
//        let dateformate = DateFormatter()
//        dateformate.dateFormat = "MM/yyyy"
//        dateformate.calendar = Calendar(identifier: .gregorian)
//        return dateformate
//    }()
//    var endDate: Date?
//    var startDate: Date?
//    var dateFormat: String = "MM/yyyy" {
//        didSet {
//            dateFormate.dateFormat = dateFormat
//        }
//    }
//    
//    var inputedDate: Date? {
//        get {
//            return text != nil ? dateFormate.date(from: text!) : nil
//        }
//        set {
//            guard let val = newValue else {
//                self.text = ""
//                return
//            }
//            self.content = dateFormate.string(from: val)
//        }
//    }
//    
//    override var content: String {
//        get {
//            return self.text ?? ""
//        }
//        set {
//            self.text = newValue
//            if !newValue.isEmpty {
//                titleLabelUpdateLayout(true)
//            }
//            clearButton.isHidden = (self.text ?? "").count == 0
//        }
//    }
//
//    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString text: String) -> Bool {
//        defer {
//            clearButton.isHidden = (textField.text ?? "").count == 0
//        }
//        guard text.isNumber() else { return false }
//        
//        var currentText = textField.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else { return false }
//        var updatedText = currentText.replacingCharacters(in: stringRange, with: text)
//        if currentText.count > updatedText.count {
//            self.text = ""
//            self.insertText(updatedText.trimmingCharacters(in: CharacterSet(charactersIn: "/"))) // This line of code to trigger delegate actions
//            return false
//        }
//        if updatedText.count > 7 { return false }
//        
//        currentText = currentText.replacingOccurrences(of: "/", with: "")
//        updatedText = updatedText.replacingOccurrences(of: "/", with: "")
//        
//        switch currentText.count {
//        case 0:
//            if text.toInt() > 1 {
//                return false
//            }
//        case 1:
//            if updatedText.toInt() > 12 {
//                return false
//            }
//        case 2:
//            let startYearChar = text.toInt()
//            if startYearChar < 1 || startYearChar > 2 {
//                return false
//            }
//        default: break
//        }
//        
//        let formatedDateString = formatDate(text: updatedText)
//        if formatedDateString.count == 7, let date = dateFormate.date(from: formatedDateString) {
//            if let startDate = startDate {
//                if date.compare(startDate) == .orderedAscending {
//                    return false
//                }
//            }
//            if let endDate = endDate {
//                if date.compare(endDate) == .orderedDescending {
//                    return false
//                }
//            }
//        }
//        self.text = ""
//        self.insertText(formatedDateString) // This line of code to trigger delegate actions
//        return false
//    }
//    
//    func formatDate(text: String) -> String {
//        if text.count < 2 {
//            return text
//        }
//        return String(format: "%@/%@", text.substring(toIndex: 2), text.substring(fromIndex: 2))
//    }
//}

extension VIBInputText {
    func applyDisableStyle() {
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = 0.0
        self.layer.borderWidth = 0.0
        self.isUserInteractionEnabled = false
    }
}

// MARK: - Handle 
extension VIBInputText {
    // Using this function should set delegate to nil first
    func handleEditByAddingTarget() {
        self.delegate = nil
        self.addTarget(self, action: #selector(textFieldBeginEdit), for: .editingDidBegin)
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(textFieldEndEdit), for: .editingDidEnd)
    }
    
    @objc func textFieldBeginEdit() {
        self.titleLabelUpdateLayout(true)
        self.highlightBorder(true)
        self.clearButton.isHidden = self.text!.isEmpty || !clearModeEnable
    }
    
    @objc func textFieldDidChange() {
        textDidChange?(self)
    }
    
    @objc func textFieldEndEdit() {
        titleLabelUpdateLayout(false)
        highlightBorder(false)
        clearButton.isHidden = true
    }
}
