//
//  UIViewController+Extension.swift
//  BB
//

import UIKit
extension UIViewController: BBExtensionCompatible {}

extension UIViewController {
    var className: String {
        return NSStringFromClass(type(of: self))
    }

    func addChildVC(childVC: UIViewController, inView: UIView) {
        self.addChild(childVC)
        childVC.view.bounds = inView.bounds
        inView.addSubview(childVC.view)
        inView.bringSubviewToFront(childVC.view)
        // Finally, notify the child that it was moved to a parent
        childVC.didMove(toParent: self)
        childVC.view.pinEdges(to: inView)
        
    }
    
    func addChildVC(childVC: UIViewController, inView: UIView, atRect: CGRect) {
        self.addChild(childVC)
        childVC.view.frame = atRect
        inView.addSubview(childVC.view)
        inView.bringSubviewToFront(childVC.view)
        // Finally, notify the child that it was moved to a parent
        childVC.didMove(toParent: self)
    }
    
    func removeChildVC(childVC: UIViewController) {
        childVC.view.removeFromSuperview()
        childVC.willMove(toParent: nil)
        // Then, remove the child from its parent
        childVC.removeFromParent()
    }

    func removeAllChildren() {
        if self.children.count > 0 {
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers {
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
    }

}
