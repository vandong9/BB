//
//  RegisterCaptureCardVC.swift
//  BB
//

import UIKit

class RegisterCaptureCardVC: BaseVC {
    class Router {
        var onCaptureImage: ((UIImage) -> Void)?
    }
    
    struct InputData {
        var captureType: CaptureType
    }
    
    enum CaptureType {
        case front
        case back
    }
    // MARK: - Properties
    // Layout
    @IBOutlet weak var headerView: BBHeaderView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scanCardButton: BBButton!
    @IBOutlet weak var captureFrameView: UIView!
    
    lazy var cameraView: CameraView = CameraView()
    
    // Variable
    var router: Router!
    var inputData: InputData!
    
    // MARK: - LifeCycle
    static func instance(inputData: InputData, router: Router) -> RegisterCaptureCardVC {
        let vc = RegisterCaptureCardVC()
        vc.router = router
        vc.inputData = inputData
        return vc
    }
    
    override func viewDidLoad() {
        assert(router != nil && inputData != nil)
        super.viewDidLoad()

        setupUI()
        addControntAction()
        view.addSubview(cameraView)
        cameraView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.sendSubviewToBack(cameraView)
        
        cameraView.didCaptureImageCallback = { [weak self] image in
            self?.router.onCaptureImage?(image)
        }
    }

    // MARK: - Actions
    @objc func onCaptureTouchup() {
        cameraView.captureImage()
//        router.onCaptureImage?(UIImage())
    }

}

extension RegisterCaptureCardVC {
    func setupUI() {
        headerView.leftIcon = UIImage(named: "cm_nav_back_ic")
        headerView.leftButtonDidSelect = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        titleLabel.setFontColor(AppFont.baseTitle1, color: AppColor.baseGrey900)
        switch inputData.captureType {
        case .front:
            titleLabel.text =  "BUSINESS CARD\nFRONT".localized()
        case .back:
            titleLabel.text =  "BUSINESS CARD\nBACK".localized()
        }
        
        captureFrameView.makeBorder(radius: 0, width: 2, color: AppColor.baseGrey200)
        scanCardButton.setTitle("BUSINESS CARD".localized(), for: .normal)
    }
    
    func addControntAction() {
        scanCardButton.addTarget(self, action: #selector(onCaptureTouchup), for: .touchUpInside)
    }
}
