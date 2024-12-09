//
//  GuestNavigator.swift
//  BB
//

import UIKit

class GuestNavigator {
    let nav = UINavigationController()
}

extension GuestNavigator {
    func start() {
        let router = LoginVC.Router()
        router.register = { [weak nav] in
            guard let nav = nav else { return }
            
            RegisterNavigator(nav: nav).start()
        }
        let vc = LoginVC.instance(router: router)
        nav.pushViewController(vc, animated: true)
    }
}
