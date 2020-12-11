//
//  HCVCEx.swift
//  Routerdemo
//
//  Created by Charlotte on 2020/12/8.
//

import UIKit

extension UIViewController {
    // MARK: - 找到当前显示的viewcontroller
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
