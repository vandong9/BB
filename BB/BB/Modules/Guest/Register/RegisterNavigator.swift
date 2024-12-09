//
//  RegisterNavigator.swift
//  BB
//

import UIKit

class RegisterNavigator {
    var nav: UINavigationController
    
    init(nav: UINavigationController) {
        self.nav = nav
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
            
        }
        let vc = RegisterInputInfoVC.instance(router: router)
        pushVC(vc)
    }
    
    func showInputPin() {
        
    }
}


