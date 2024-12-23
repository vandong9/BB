//
//  RegisterInputInfoVC.swift
//  BB
//
//  Created by ha van dong on 12/8/24.
//

import UIKit

class RegisterInputInfoVC: BaseVC {
    protocol Repository {
        func checkInfo(infos: [String: String], completion: @escaping (ErrorModel?) -> Void)
    }
    class Router {
        var register: ((_ email: String, _ password: String) -> Void)?
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
    var repository: Repository!
    
    // MARK: - LifeCycle

    static func instance(router: Router, repository: Repository = RegisterRepositoryImpl.instance) -> RegisterInputInfoVC {
        let vc = RegisterInputInfoVC()
        vc.router = router
        vc.repository = repository
        return vc
    }
    
    override func viewDidLoad() {
        assert(router != nil && repository != nil)
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc func onRegisterButtonTouch() {
        guard isValidateInfo() else { return }
        
        BBLoading.showLoading()
        repository.checkInfo(infos: ["name": "name", "email": emailInputText.text ?? "", "password": passwordInputText.text ?? ""]) { [weak self] error in
            BBLoading.hideLoading()
            if let error = error  {
                AppDelegate.shared.rootViewController.handleApiResponseError(errorModel: error)
                return
            }
            
            guard let self = self else { return }
            
            self.router.register?(emailInputText.text ?? "", passwordInputText.text ?? "")
        }
        
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

        emailInputText.delegate = self
        passwordInputText.delegate = self
        repasswordInputText.delegate = self
        
        registerButton.setTitle("Đăng ký".localized(), for: .normal)
        registerButton.addTarget(self, action: #selector(onRegisterButtonTouch), for: .touchUpInside)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
    }
    
    private func isValidateInfo() -> Bool {
        guard let email = emailInputText.text,
              let pass = passwordInputText.text,
              let repass = repasswordInputText.text
        else {
            BBAlertView.show(title: "Missing info".localized(), message: "Please input all info")
            return false
        }
        
        if email.isEmpty || pass.isEmpty || repass.isEmpty {
            BBAlertView.show(title: "Missing info".localized(), message: "Please input all info")
            return false
        }
        
        if pass !=  repass {
            BBAlertView.show(title: "Not match".localized(), message: "Password and Re-Password are not match")
            return false
        }
        
        return true
    }

    @objc private func handleTapOnView() {
        view.endEditing(true)
    }
}

extension RegisterInputInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
