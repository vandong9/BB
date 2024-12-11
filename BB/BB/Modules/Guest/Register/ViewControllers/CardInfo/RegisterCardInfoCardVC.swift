//
//  RegisterCardInfoCardVC.swift
//  BB
//

import UIKit
import SnapKit

class RegisterCardInfoCardVC: BaseVC {
    // MARK: - Properties
    // Layout
    @IBOutlet weak var headerView: BBHeaderView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scanCardButton: BBButton!
    @IBOutlet weak var infoStackView: UIStackView!
    
    // MARK: - LifeCycle
    static func instance() -> RegisterCardInfoCardVC {
        let vc = RegisterCardInfoCardVC()
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        showInfos()
    }
    
    // MARK: - Actions
    @objc func onSubmitButtonTouch() {
        
    }


}

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

