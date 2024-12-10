//
//  RegisterNavigator.swift
//  BB
//

import UIKit

class RegisterNavigator {
    var nav: UINavigationController
    
    init(nav: UINavigationController) {
        self.nav = nav
        nav.isNavigationBarHidden = true
    }
}

// MARK: - Start Flow function
extension RegisterNavigator {
    func start() {
        showInputInfo()
    }
}

// MARK: - Navigator Functions
extension RegisterNavigator {
    func pushVC(_ vc: UIViewController) {
        nav.pushViewController(vc, animated: true)
    }
    
    func showInputInfo() {
        let router = RegisterInputInfoVC.Router()
        router.register = { [weak nav] in
            self.showInputPin()
        }
        let vc = RegisterInputInfoVC.instance(router: router)
        pushVC(vc)
    }
    
    func showInputPin() {
        let router = RegisterInputPinVC.Router()
        router.onConfirmSuccess = { [weak self] in
            self?.showScanOption()
        }
        let vc = RegisterInputPinVC.instance(router: router)
        pushVC(vc)
    }
    
    func showScanOption() {
        let router = RegisterScanOptionVC.Router()
        router.onSelectCaptureCard = { [weak self] in
            self?.showCaptureFrontCard()
        }
        let vc = RegisterScanOptionVC.instance(router: router)
        pushVC(vc)
    }
    
    func showCaptureFrontCard() {
        let router = RegisterCaptureCardVC.Router()
        router.onCaptureImage = { [weak self] image in
            self?.showCaptureBackCard()
        }
        let inputData = RegisterCaptureCardVC.InputData(captureType: .front)
        let vc = RegisterCaptureCardVC.instance(inputData: inputData, router: router)
        pushVC(vc)
    }
    
    func showCaptureBackCard() {
        let router = RegisterCaptureCardVC.Router()
        router.onCaptureImage = { [weak self] image in
            self?.showCardInfo()
        }
        let inputData = RegisterCaptureCardVC.InputData(captureType: .front)
        let vc = RegisterCaptureCardVC.instance(inputData: inputData, router: router)
        pushVC(vc)
    }

    func showCardInfo() {
        let vc = RegisterCardInfoCardVC.instance()
        pushVC(vc)
    }
}


