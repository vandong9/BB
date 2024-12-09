//
//  VIBHeaderView.swift
//  MyVIB_2.0
//
//  Created by chinhND on 19/05/2021.
//

import Foundation
import SnapKit
import UIKit

/*
 Using Example:
 
 @IBOutlet weak var headerView: VIBHeaderView!
 
 // set title
 headerView.title = ""
 
 // set icon left
 headerView.leftIcon = UIImage(named: "")!
 
 // set icon right
 headerView.rightIcon = UIImage(named: "")!
 
 // set icon title
 headerView.centerIcon = UIImage(named: "")!
 
 // set value bage
 headerView.bageValue = ""
 
 // set background image bage
 headerView.bageBackgroundImage = UIImage(named: "")!
 
 // set color bage value
 headerView.bageValueColor = .black
 
 // event click title
 headerView.titleDidSelect = {
     // processs
 }
 
 // event click left icon
 headerView.leftButtonDidSelect = {
     // processs
 }
 
 // event click right icon
 headerView.rightButtonDidSelect = {
     // processs
 }
 */

private let kHeightLeftButton: CGFloat = 50
private let kWidthLeftButton: CGFloat = 60
private let kHeightRightButton: CGFloat = 30
private let kWidthCenterIcon: CGFloat = 24
private let kWidthBadgeButton: CGFloat = 22

enum HeaderViewType: Int {
    case normal = 0
    case close
    case leftSmallTitle
    case leftMediumTitle
    case leftBigTitle
}

typealias TitleHeaderViewDidSelect = () -> (Void)
typealias LeftButtonHeaderViewDidSelect = () -> (Void)
typealias RightButtonHeaderViewDidSelect = () -> (Void)

class VIBHeaderView: UIView {
    // MARK: - Properties
    
    private var titleLabel: UILabel!
    private var letfButton: UIButton!
    private var badgeButton: UIButton!
    private var centerImageView: UIImageView!
    private var rightButton: UIButton!
    private var titleStackView: UIStackView!
    
    var titleDidSelect: TitleHeaderViewDidSelect?
    var leftButtonDidSelect: LeftButtonHeaderViewDidSelect?
    var rightButtonDidSelect: RightButtonHeaderViewDidSelect?
    
    var type: HeaderViewType = .normal {
        didSet {
            updateViewWithType()
        }
    }
    
    // MARK: - IBInspectable
    
    @IBInspectable public var title: String {
        get {
            return titleLabel.text ?? ""
        }
        set {
            titleLabel.text = newValue
            titleLabel.sizeToFit()
        }
    }
    
    @IBInspectable public var leftIcon: UIImage? = nil {
        didSet {
            if leftIcon != nil {
                letfButton.setImage(leftIcon, for: .normal)
                letfButton.isHidden = false
            } else {
                letfButton.isHidden = true
            }
        }
    }
    
    @IBInspectable public var centerIcon: UIImage? = UIImage(named: "cm_down_ic") {
        didSet {
            centerImageView.image = centerIcon
            centerImageView.isHidden = centerIcon == nil
            
            centerImageView.snp.updateConstraints({ make in
                make.width.height.equalTo(kWidthCenterIcon)
            })
        }
    }

    @IBInspectable public var rightIcon: UIImage? = UIImage(named: "cm_secure_ic") {
        didSet {
            if rightIcon != nil {
                rightButton.setImage(rightIcon, for: .normal)
                rightButton.isHidden = false
            } else {
                rightButton.isHidden = true
            }
        }
    }

    @IBInspectable public var titleRightButton: String = "" {
        didSet {
            rightButton.setTitle(titleRightButton, for: .normal)
            rightButton.isHidden = titleRightButton.isEmpty
            rightButton.snp.updateConstraints({make in
                make.trailing.equalToSuperview().offset(-17)
                make.width.equalTo(titleRightButton.isEmpty ? 0 : 54)
            })
        }
    }
    
    @IBInspectable public var badgeValue: String = "" {
        didSet {
            badgeButton.setTitle(badgeValue, for: .normal)
            badgeButton.isHidden = badgeValue.isEmpty ? true : false
        }
    }
    
    @IBInspectable public var bageValueColor: UIColor = UIColor.black {
        didSet {
            badgeButton!.setTitleColor(bageValueColor, for: .normal)
        }
    }
        
    var rightIconUrl: String = "" {
        didSet {
            if rightIconUrl != "", let url = URL(string: rightIconUrl) {
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.rightButton.setImage(image, for: .normal)
                                self?.rightButton.isHidden = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    var circleRightButton: Bool = false {
        didSet {
            if circleRightButton {
                rightButton.layer.cornerRadius = kHeightRightButton / 2
            }
        }
    }
    
    // MARK: - Method
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: AppUIConstant.SCREEN_WIDTH_PORTRAIT, height: UIView.layoutFittingExpandedSize.height) //UILayoutFittingExpandedSize
    }
    
    private func setupView() {
        // add left Image
        letfButton = UIButton()
        letfButton.isExclusiveTouch = true
        letfButton.addTarget(self, action: #selector(onClickLeftButton_Action), for: .touchUpInside)
        addSubview(letfButton)
        
        letfButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(kHeightLeftButton)
            make.width.equalTo(kWidthLeftButton)
        }
        // add title
        titleLabel = UILabel()
        titleLabel.font = AppFont.baseHeadline
        titleLabel.textColor = AppColor.baseGrey900
        titleLabel.text = ""
        titleLabel.sizeToFit()

        centerImageView = UIImageView()
        centerImageView.contentMode = .scaleAspectFit
        centerImageView.widthAnchor.constraint(equalToConstant: kWidthCenterIcon).isActive = true
        centerImageView.heightAnchor.constraint(equalToConstant: kWidthCenterIcon).isActive = true
        centerImageView.isHidden = true

        titleStackView = UIStackView(arrangedSubviews: [titleLabel, centerImageView])
        titleStackView.distribution = .fill
        titleStackView.axis = .horizontal
        titleStackView.spacing = 4.0
        addSubview(titleStackView)

        titleStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(kWidthLeftButton + 8)
        }
        titleStackView.isUserInteractionEnabled = true
        let tapTitleStackView = UITapGestureRecognizer(target: self, action: #selector(tapTitleStactView))
        titleStackView.addGestureRecognizer(tapTitleStackView)
        
        // add right button
        rightButton = UIButton()
        rightButton.titleLabel?.font = AppFont.baseHeadline
        rightButton.setTitleColor(AppColor.baseGrey900, for: .normal)
        rightButton.addTarget(self, action: #selector(onClickRightButton_Action), for: .touchUpInside)
        rightButton.isHidden = true
        addSubview(rightButton)

        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(kHeightRightButton)
        }
        // add bage button
        badgeButton = UIButton(type: .custom)
        badgeButton!.setTitleColor(AppColor.baseGrey900, for: .normal)
        badgeButton!.titleLabel?.font = AppFont.bold(size: 11)
        badgeButton!.isUserInteractionEnabled = false
        badgeButton.isHidden = true
        addSubview(badgeButton!)
        
        badgeButton!.snp.makeConstraints { make in
            make.width.height.equalTo(kWidthBadgeButton)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(rightButton.snp.leading)
        }
    }
    
    // switch UI case
        
    private func showHeaderClose() {
        titleStackView.isUserInteractionEnabled = false
        titleStackView.snp.makeConstraints({make in
            make.leading.equalTo(letfButton.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        })
    }
    
    private func showLeftSmallTitle() {
        titleStackView.isUserInteractionEnabled = false
        letfButton.isHidden = true
        titleLabel.font = AppFont.baseTitle2
        titleStackView.snp.makeConstraints({make in
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalTo(rightButton.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
        })
    }
    
    private func showLeftMediumTitle() {
        titleStackView.isUserInteractionEnabled = false
        letfButton.isHidden = true
        titleLabel.font = AppFont.baseLargeTitle
        titleStackView.snp.makeConstraints({make in
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalTo(rightButton.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
        })
    }
    
    private func showLeftBigTitle() {
        titleStackView.isUserInteractionEnabled = false
        letfButton.isHidden = true
        titleLabel.font = AppFont.baseTitle1
        titleStackView.snp.makeConstraints({make in
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalTo(rightButton.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
        })
    }
    
    private func updateViewWithType() {
        switch type {
        case .close:
            showHeaderClose()
        case .leftSmallTitle:
            showLeftSmallTitle()
        case .leftMediumTitle:
            showLeftMediumTitle()
        case .leftBigTitle:
            showLeftBigTitle()
        default:
            break
        }
    }
    
    // MARK: - Action
    
    @objc private func onClickLeftButton_Action() {
        leftButtonDidSelect?()
    }
    
    @objc private func onClickRightButton_Action() {
        rightButtonDidSelect?()
    }
    
    @objc private func tapTitleStactView() {
        titleDidSelect?()
    }
    
    // Public Function
    
//    func setDefaultLeftAction(action: @escaping LeftButtonHeaderViewDidSelect) {
//        leftIcon = UIImage(named: AppConstant.kBackIconName)
//        leftButtonDidSelect = action
//    }
//    
//    func setDefaultRightAction(action: @escaping RightButtonHeaderViewDidSelect) {
//        rightIcon = UIImage(named: AppConstant.kCloseHeaderIconName)
//        rightButtonDidSelect = action
//    }

}
