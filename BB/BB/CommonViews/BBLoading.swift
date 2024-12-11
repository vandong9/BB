//  MBLoading.swift
//  BB
//

import Foundation
import NVActivityIndicatorView
import UIKit

class BBLoading : NSObject {
    static func showLoading() {
        BBLoading.showLoading("")
    }
    static let kShimer_View_Tag = 199
    
    static func showLoading(_ message: String) {
        DispatchQueue.onMain {
            let activityData = ActivityData(size: CGSize(width: 60.0, height: 50.0), message: message, messageFont: AppFont.baseSmallBodyRegular, messageSpacing: 10, type: .lineSpinFadeLoader, color: nil, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil)
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        }
        
        // --- Change other type if needed -----
        // circleStrokeSpin
        // ballSpinFadeLoader
    }
    
    static func hideLoading() {
        DispatchQueue.onMain {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
    static func showLoading(inView: UIView?) {
        if let inView = inView {
            if let _ = inView.viewWithTag(99) {
                // Already show
                return
            }
            DispatchQueue.main.async {
                let hud = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                hud.type = .lineSpinFadeLoader // .ballSpinFadeLoader//.circleStrokeSpin
                hud.color = UIColor.darkGray
                hud.tag = 99
                hud.center = CGPoint(x: inView.frame.size.width/2.0, y: inView.frame.size.height/2.0)
                inView.addSubview(hud)
                inView.bringSubviewToFront(hud)
                hud.startAnimating()
            }
        }
    }
    
    static func showLoading(inView: UIView?, tag: Int = 99, color: UIColor = AppColor.baseGrey900, type: NVActivityIndicatorType = .lineSpinFadeLoader) {
        if let inView = inView {
            if let _ = inView.viewWithTag(tag) {
                return
            }
            DispatchQueue.main.async {
                let hud = NVActivityIndicatorView(frame: inView.bounds)
                hud.type = type
                hud.color = color
                hud.tag = tag
                hud.center = CGPoint(x: inView.frame.size.width/2.0, y: inView.frame.size.height/2.0)
                inView.addSubview(hud)
                inView.bringSubviewToFront(hud)
                hud.startAnimating()
            }
        }
    }
    
    static func hideLoading(inView : UIView?, tag: Int = 99) {
        if let inView = inView {
            DispatchQueue.main.async {
                if let loadingView = inView.viewWithTag(tag) as? NVActivityIndicatorView {
                    loadingView.stopAnimating()
                }
            }
        }
    }
    
    // MARK: - NETWORK ACTIVITY
    static func showNetworkActivity(show: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
    }
}
