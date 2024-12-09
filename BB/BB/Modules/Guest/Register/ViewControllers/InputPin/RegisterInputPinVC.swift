//
//  RegisterInputPinVC.swift
//  BB
//

import UIKit

class RegisterInputPinVC: BaseVC {
    // MARK: - Properties
    // Layout
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var verifyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pinView: BBPinView!
    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var countDownLabel: UILabel!
    
    // MARK: - LifeCycle
    static func instance() -> RegisterInputPinVC {
        let vc = RegisterInputPinVC()
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
