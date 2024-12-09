//
//  DispatchQueue+Extensions.swift
//  BB
//


import Foundation
// MARK: - Handle Queue in background thread
extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
    static func onMain(action: @escaping (() -> Void)) {
        if Thread.current.isMainThread {
            action()
            return
        }
        
        DispatchQueue.main.async {
            action()
        }
    }
    
    // Delay on main
    static func delay(_ delay:Double, closure:@escaping () -> ()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}

