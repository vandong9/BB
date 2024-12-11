//
//  RootViewController.swift
//  BB
//
//  Created by ha van dong on 12/8/24.
//

import UIKit

class RootViewController: UIViewController {
    private(set) var current: UIViewController

    init() {
        self.current = UIViewController()
        super.init(nibName: nil, bundle: nil)
        
        
        let navigator = GuestNavigator()
        current = navigator.nav
        self.addChildVC(childVC: current, inView: view, atRect: view.bounds)
        navigator.start()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension RootViewController {
    func handleApiResponseError(errorModel: Error, closeAction: (() -> Void)? = nil) {
        guard let error = errorModel as? ErrorModel else { return }
        guard error.isShowError else { return }
        
        var primeAction: (() -> Void)?
        var primeButtonText: String?
            
//        if error.isOTPBlocked {
//            primeButtonText = "login_call_customer_service".localized()
//            primeAction = {
//                Utils.makeCalling(phone: AppConstant.kSupportCallNumber)
//            }
//        }
//        if error.errorCode == VIBStatusCode.maintanence.rawValue {
//            dismiss(animated: false)
//            AppDelegate.shared.rootViewController.directToMaintainceView()
//            return
//        }
//        if error.errorCode == VIBStatusCode.sessionExpired.rawValue {
//            VIBLoading.hideLoading()
//        }

        BBAlertView.show(infoImage: AppConstant.kAlertInfo, title: error.wrapTitle, message: error.wrapMessage, primaryTitle: primeButtonText, primaryAction: primeAction, closeAction: {
            
            
            closeAction?()
//            NotificationCenter.default.post(name: NSNotification.Name.didCloseAPIResponseErrorVIBAlertView, object: nil)
        })
    }

}
