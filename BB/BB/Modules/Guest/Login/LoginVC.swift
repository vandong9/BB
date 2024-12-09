//
//  LoginVC.swift
//  BB
//
//  Created by ha van dong on 12/8/24.
//

import UIKit

class LoginVC: BaseVC {
    
    class Router {
        var login: (() -> Void)?
        var register: (() -> Void)?
    }
    // MARK: - Properties
    // Layout
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var accountInputText: BBInputText!
    @IBOutlet weak var passwordInputText: BBInputText!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: BBButton!
    @IBOutlet weak var facebookLoginButton: UIView!
    @IBOutlet weak var googleLoginButton: UIView!
    @IBOutlet weak var appleLoginButton: UIView!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!

    
    // Variable
    var router: Router!
    
    // MARK: - LifeCycle

    static func instance(router: Router) -> LoginVC {
        let vc = LoginVC()
        vc.router = router
        return vc
    }
    
    override func viewDidLoad() {
        assert(router != nil)
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    @objc func onLoginButtonTouch() {
        
    }
    
    @objc func onRegisterButtonTouch() {
        router.register?()
    }
}

// MARK: - Private Functions
private extension LoginVC {
    func setupUI() {
        appNameLabel.setFontColor(AppFont.baseTitle1, color: AppColor.baseGrey900)
        appNameLabel.text = "ĐĂNG NHẬP".localized()
        
        accountLabel.setFontColor(AppFont.baseSubheadlineRegular, color: AppColor.baseGrey900)
        accountLabel.text = "Tài khoản".localized()

        passwordLabel.setFontColor(AppFont.baseSubheadlineRegular, color: AppColor.baseGrey900)
        passwordLabel.text = "Mật khẩu".localized()
        
        loginButton.setTitle("Log in".localized(), for: .normal)
        loginButton.addTarget(self, action: #selector(onLoginButtonTouch), for: .touchUpInside)
        
        forgotPasswordButton.titleLabel?.font = AppFont.baseCaptionRegular
        forgotPasswordButton.setTitle("Quên mật khẩu?".localized(), for: .normal)
        
        facebookLoginButton.makeBorder(radius: 10, width: 1, color: UIColor.colorFromString("D8DADC"))
        googleLoginButton.makeBorder(radius: 10, width: 1, color: UIColor.colorFromString("D8DADC"))
        appleLoginButton.makeBorder(radius: 10, width: 1, color: UIColor.colorFromString("D8DADC"))
        
        registerLabel.setFontColor(AppFont.baseSubheadlineRegular, color: AppColor.baseGrey900)
        registerButton.titleLabel?.font = AppFont.baseSubheadlineMedium
        registerButton.setTitle("Đăng ký ngay".localized(), for: .normal)
        registerButton.addTarget(self, action: #selector(onRegisterButtonTouch), for: .touchUpInside)
    }
}
