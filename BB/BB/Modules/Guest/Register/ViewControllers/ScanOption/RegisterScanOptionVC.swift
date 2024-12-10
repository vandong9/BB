//
//  RegisterScanOptionVC.swift
//  BB
//

import UIKit

class RegisterScanOptionVC: BaseVC {
    class Router {
        var onSelectCaptureCard: (() -> Void)?
    }
    // MARK: - Properties
    // Layout
    @IBOutlet weak var headerView: BBHeaderView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scanCardButton: BBButton!
    @IBOutlet weak var scanQRButton: BBButton!
    
    // Variable
    var router: Router!
    
    // MARK: - LifeCycle

    static func instance(router: Router) -> RegisterScanOptionVC {
        let vc = RegisterScanOptionVC()
        vc.router = router
        return vc
    }
    
    override func viewDidLoad() {
        assert(router != nil)
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Actions
    @objc func onCaptureCardButtonTouch() {
        router.onSelectCaptureCard?()
    }


}

extension RegisterScanOptionVC {
    func setupUI() {
        headerView.leftIcon = UIImage(named: "cm_nav_back_ic")
        headerView.leftButtonDidSelect = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        titleLabel.setFontColor(AppFont.baseTitle1, color: AppColor.baseGrey900)
        titleLabel.text = "SCAN".localized()
        
        scanCardButton.setTitle("BUSINESS CARD".localized(), for: .normal)
        scanCardButton.addTarget(self, action: #selector(onCaptureCardButtonTouch), for: .touchUpInside)

        scanQRButton.setTitle("QR CODE".localized(), for: .normal)
    }
}
