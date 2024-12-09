//
//  RegisterInputInfoVC.swift
//  BB
//
//  Created by ha van dong on 12/8/24.
//

import UIKit

class RegisterInputInfoVC: BaseVC {
    
    class Router {
        var register: (() -> Void)?
    }
    // MARK: - Properties
    // Layout
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var repasswordLabel: UILabel!
    @IBOutlet weak var emailInputText: BBInputText!
    @IBOutlet weak var passwordInputText: BBInputText!
    @IBOutlet weak var repasswordInputText: BBInputText!
    @IBOutlet weak var registerButton: BBButton!

    
    // Variable
    var router: Router!
    
    // MARK: - LifeCycle

    static func instance(router: Router) -> RegisterInputInfoVC {
        let vc = RegisterInputInfoVC()
        vc.router = router
        return vc
    }
    
    override func viewDidLoad() {
        assert(router != nil)
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc func onRegisterButtonTouch() {
        router.register?()
    }
}

// MARK: - Private Functions
private extension RegisterInputInfoVC {
    func setupUI() {
        appNameLabel.setFontColor(AppFont.baseTitle1, color: AppColor.baseGrey900)
        appNameLabel.text = "ĐĂNG KÝ".localized()
        
        emailLabel.setFontColor(AppFont.baseSubheadlineRegular, color: AppColor.baseGrey900)
        emailLabel.text = "Email".localized()

        passwordLabel.setFontColor(AppFont.baseSubheadlineRegular, color: AppColor.baseGrey900)
        passwordLabel.text = "Mật khẩu".localized()
        passwordLabel.setFontColor(AppFont.baseSubheadlineRegular, color: AppColor.baseGrey900)
        passwordLabel.text = "Xác nhận mật khẩu".localized()

        registerButton.setTitle("Đăng ký".localized(), for: .normal)
        registerButton.addTarget(self, action: #selector(onRegisterButtonTouch), for: .touchUpInside)
    }
}
