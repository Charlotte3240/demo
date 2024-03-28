//
//  Ex.swift
//  PIC
//
//  Created by 360-jr on 2024/3/28.
//

import Foundation
import UIKit

extension UIViewController {
    /// 找到当前显示的viewcontroller
    /// - Parameter base: rootVC
    /// - Returns: 当前VC
    class func current(base: UIViewController? = UIApplication.shared.currentWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return current(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return current(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return current(base: presented)
        }
        if let split = base as? UISplitViewController{
            return current(base: split.presentingViewController)
        }
        return base
    }
    

}

extension UIApplication {
    
    /// 当前window
    var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let window = connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first{
                return window
            }else if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        } else {
            if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        }
    }
}
