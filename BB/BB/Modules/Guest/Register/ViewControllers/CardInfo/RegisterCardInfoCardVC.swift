//
//  RegisterCardInfoCardVC.swift
//  BB
//

import UIKit

class RegisterCardInfoCardVC: BaseVC {
    // MARK: - Properties
    // Layout
    @IBOutlet weak var headerView: BBHeaderView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scanCardButton: BBButton!

    // MARK: - LifeCycle
    static func instance() -> RegisterCardInfoCardVC {
        let vc = RegisterCardInfoCardVC()
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
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
        titleLabel.text =  "BUSINESS CARD\nFRONT".localized()
        scanCardButton.setTitle("BUSINESS CARD".localized(), for: .normal)
    }
    
    func addControntAction() {
        scanCardButton.addTarget(self, action: #selector(onSubmitButtonTouch), for: .touchUpInside)
    }
}

