//
//  RegisterInputPinVC.swift
//  BB
//

import UIKit

class RegisterInputPinVC: BaseVC {
    class Router {
        var onConfirmSuccess: (() -> Void)?
    }
    // MARK: - Properties
    // Layout
    @IBOutlet weak var headerView: BBHeaderView!
    @IBOutlet weak var verifyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pinView: BBPinView!
    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var countDownLabel: UILabel!
    
    // Variable
    var router: Router!
    
    // MARK: - LifeCycle
    static func instance(router: Router) -> RegisterInputPinVC {
        let vc = RegisterInputPinVC()
        vc.router = router
        return vc
    }
    override func viewDidLoad() {
        assert(router != nil)
        super.viewDidLoad()

        setupUI()
        addAction()
        
        pinView.active()
    }

}

extension RegisterInputPinVC {
    func setupUI() {
        headerView.leftIcon = UIImage(named: "cm_nav_back_ic")
        headerView.leftButtonDidSelect = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        verifyLabel.setFontColor(AppFont.baseTitle2, color: AppColor.baseGrey900)
        verifyLabel.text = "Xác thực".localized()
        descriptionLabel.setFontColor(AppFont.baseSubheadlineRegular, color: AppColor.baseGrey600)
        descriptionLabel.text = "We’ve sent an mail with an activation code to your email".localized()
        countDownLabel.setFontColor(AppFont.baseSubheadlineRegular, color: AppColor.baseGrey600)
        countDownLabel.text = "00:20"

        sendCodeButton.titleLabel?.setFontColor(AppFont.baseSubheadlineBold, color: AppColor.baseGrey900)
        sendCodeButton.setTitle("Send code again".localized(), for: .normal)
        
        pinView.pinLenght = 5
        pinView.itemWidth = 63
    }
    
    func addAction() {
        pinView.completeInput = { [weak self] pin in
            self?.router.onConfirmSuccess?()
        }
    }
}
