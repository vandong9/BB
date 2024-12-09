//
//  BBPinCellView.swift
//  BB
//


import UIKit
class BBPinCellView: UIView {
    // MARK: - Properties
    var pinlabel: BaseLabel!
    private(set) var value: String?
    var secure: Bool = true
    var isFocus: Bool = false
    
    // MARK: - LifeCycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        backgroundColor = .white
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = AppColor.baseGrey200.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 6
        layer.cornerRadius = 6
        layer.shadowOpacity = 1

        pinlabel = BaseLabel()
        pinlabel.font = AppFont.baseTitle1
        pinlabel.textColor = AppColor.baseGrey800
        pinlabel.textAlignment = .center
        pinlabel.backgroundColor = .clear
        addSubview(pinlabel)
        pinlabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pinlabel.borderWidth = 1
        pinlabel.borderColor = AppColor.baseGrey200
        pinlabel.cornerRadius = 6
        pinlabel.clipsToBounds = true
    }
    
    // MARK: - Public Functions
    func setValue(_ newValue: String?) {
        value = newValue
        if isFocus {
            pinlabel.text = ""
        } else {
            if secure {
                pinlabel.text = "•"
            } else {
                pinlabel.text = value != nil ? "\(value!)" : "0"
            }
        }
        if value != nil {
            pinlabel.textColor = AppColor.baseGrey800
            pinlabel.borderColor = AppColor.baseGrey200
        } else {
            pinlabel.textColor = AppColor.baseGrey200
            pinlabel.borderColor = AppColor.baseGrey200
        }
    }
    
    func setFocus(_ isFocus: Bool) {
        self.isFocus = isFocus
        pinlabel.borderColor = isFocus ? AppColor.baseGrey800 : AppColor.baseGrey200
    }
}

class BBPinView: UIView {
    // MARK: - Properties
    var hiddenTextField: UITextField!
    var pinCellViews: [BBPinCellView] = []
    var cellStackView: UIStackView!

    var pinLenght: Int = 4 {
        didSet {
            addCell()
        }
    }
    var spaceBetweenItems: CGFloat = 8
    var itemWidth: CGFloat = 44 {
        didSet {
            addCell()
        }
    }
    var enable: Bool = true
    var completeInput: ((String) -> Void)?
    var valueChange: ((String) -> Void)?
    
    var value: String? {
        return hiddenTextField.text
    }
    
    // MARK: - LifeCycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        backgroundColor = .clear
        // Add hidden textfield to handle input
        hiddenTextField = UITextField()
        addSubview(hiddenTextField)
        hiddenTextField.keyboardType = .numberPad
        hiddenTextField.autocorrectionType = .no
        hiddenTextField.textContentType = .username
        hiddenTextField.alpha = 0
        hiddenTextField.addTarget(self, action: #selector(hiddenTextFieldValueChange), for: .editingChanged)
        hiddenTextField.delegate = self
        
        // Add stackview
        cellStackView = UIStackView()
        cellStackView.distribution = .fillEqually
        cellStackView.spacing = spaceBetweenItems
        cellStackView.axis = .horizontal
        cellStackView.clipsToBounds = false
        addSubview(cellStackView)
        cellStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
              
        addCell()
        
        // Set Touch to active
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnView))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Public Functions
    /// Set secure or not to show/hide pin value
    func setSecure(_ isSecure: Bool) {
        pinCellViews.forEach {
            $0.secure = isSecure
        }
        hiddenTextFieldValueChange(textField: hiddenTextField)
    }
    
    /// Reset status
    func clear() {
        DispatchQueue.onMain {
            self.hiddenTextField.text = ""
            self.hiddenTextFieldValueChange(textField: self.hiddenTextField)
        }
    }
    
    /// Make textfield become first response to show keyboard
    func active() {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.active()
            }
            return
        }
        
        hiddenTextField.becomeFirstResponder()
        let index = hiddenTextField.text?.count ?? 0

        if pinCellViews.count > index {
            pinCellViews[index].setFocus(true)
        }
    }
    
    func hideKeyboard() {
        DispatchQueue.onMain { [weak self] in
            self?.hiddenTextField.resignFirstResponder()
        }
    }
    
    // MARK: - Private Functions
    private func addCell() {
        // Remove current cells
        cellStackView.removeAllArrangedView()
        pinCellViews.removeAll()
        
        // Add new cells to stack
        // Init new cell
        for _ in 0...pinLenght - 1 {
            let pinCell = BBPinCellView()
            pinCellViews.append(pinCell)
            cellStackView.addArrangedSubview(pinCell)
            pinCell.snp.makeConstraints {
                $0.width.equalTo(itemWidth)
            }
            pinCell.setValue(nil)
        }
    }
    
    @objc private func hiddenTextFieldValueChange(textField: UITextField) {
        let text = textField.text ?? ""
        let minValue = min(text.count, pinLenght)
        let maxValue = max(text.count, pinLenght)
        for i in 0...maxValue - 1 {
            let pinCell =  pinCellViews[i]
            pinCell.isFocus = false
            pinCell.setValue( i < minValue ? text[i] : nil)
        }
        
        if text.count < pinCellViews.count {
            pinCellViews[text.count].setFocus(true)
        }
        valueChange?(text)
        if text.count == pinLenght {
            completeInput?(text)
        }
    }
    
    @objc private func handleTapOnView() {
        active()
    }
}

// MARK: - UITextFieldDelegate
extension BBPinView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard self.enable else {
            return false
        }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count > pinLenght {
            return false
        }
        return true
    }
}

