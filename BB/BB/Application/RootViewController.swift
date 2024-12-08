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
