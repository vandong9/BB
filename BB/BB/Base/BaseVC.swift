//
//  BaseVC.swift
//  BB
//

import UIKit

class BaseVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
        print("*********\(self.className) Didload")
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        #if DEBUG
        print("*********\(self.className) Appear")
        #endif
    }

}
