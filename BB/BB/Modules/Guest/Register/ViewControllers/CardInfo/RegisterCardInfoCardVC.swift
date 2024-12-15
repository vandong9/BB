//
//  RegisterCardInfoCardVC.swift
//  BB
//

import UIKit
import SnapKit

class RegisterCardInfoCardVC: BaseVC {
    protocol Repository {
        func submit(infos: [String: String], completion: @escaping (ErrorModel?) -> Void)
    }
    class Router {
        var onSuccess: (() -> Void)?
    }
    // MARK: - Properties
    // Layout
    @IBOutlet weak var headerView: BBHeaderView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scanCardButton: BBButton!
    @IBOutlet weak var infoStackView: UIStackView!
    
    // Variable
    
    var router: Router!
    var repository: Repository!
    
    // MARK: - LifeCycle
    static func instance(router: Router, repository: Repository = RegisterRepositoryImpl.instance) -> RegisterCardInfoCardVC {
        let vc = RegisterCardInfoCardVC()
        vc.router = router
        vc.repository = repository
        return vc
    }
    
    override func viewDidLoad() {
        assert(router != nil && repository != nil)
        super.viewDidLoad()

        setupUI()
        showInfos()
        addControntAction()
    }
    
    // MARK: - Actions
    @objc func onSubmitButtonTouch() {
        BBLoading.showLoading()
        repository.submit(infos: [:]) { [weak self] error in
            BBLoading.hideLoading()
            if let error = error {
                AppDelegate.shared.rootViewController.handleApiResponseError(errorModel: error)
                return
            }
            self?.router.onSuccess?()
        }
    }
}

// MARK: - Private
extension RegisterCardInfoCardVC {
    func setupUI() {
        headerView.leftIcon = UIImage(named: "cm_nav_back_ic")
        headerView.leftButtonDidSelect = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        titleLabel.setFontColor(AppFont.baseTitle1, color: AppColor.baseGrey900)
        titleLabel.text =  "BUSINESS CARD\nINFORMATION".localized()
        scanCardButton.setTitle("BUSINESS CARD".localized(), for: .normal)
    }
    
    func addControntAction() {
        scanCardButton.addTarget(self, action: #selector(onSubmitButtonTouch), for: .touchUpInside)
    }
    
    func showInfos() {
        let lineViews: [LineInfoView] = ["Your name:", "Contact:", "Email:", "Company:", "Street:", "City:", "State:", "Country:", "Website:"].map {
            let lineView = LineInfoView()
            lineView.setData(title: $0, content: "")
            return lineView
        }
        infoStackView.removeAllArrangedView()
        infoStackView.spacing = 16
        lineViews.forEach { lineView in
            infoStackView.addArrangedSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.height.equalTo(36)
            }
        }
    }
    
    
}

