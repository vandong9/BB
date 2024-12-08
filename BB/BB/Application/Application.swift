//
//  Application.swift
//  BB
//

import UIKit

class Application: NSObject {
    static let shared = Application()
    var window: UIWindow? {
        didSet {
            AppDelegate.shared.window = window
        }
    }
    var coverImageView: UIImageView?
    var rootViewController: RootViewController {
        return window!.rootViewController as! RootViewController
    }
    
    private override init() {
        super.init()
    }
    
    func initialRoot(in window: UIWindow?) {
        guard let window = window else { return }
        //window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = RootViewController()
        window.makeKeyAndVisible()
        self.window = window
    }
}
