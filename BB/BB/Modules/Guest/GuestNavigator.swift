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
        let vc = LoginVC.instance()
        nav.pushViewController(vc, animated: true)
    }
}
