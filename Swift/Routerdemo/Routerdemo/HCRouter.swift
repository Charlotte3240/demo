//
//  HCRouter.swift
//  TongdaoApp
//
//  Created by Charlotte on 2020/9/28.
//  Copyright © 2020 HK. All rights reserved.
//

import UIKit

class HCRouter: NSObject {
    
    @objc static func router(url : String){
        
        var vc : UIViewController?

        switch url {
        case "home"://首页
            tabbarSelectIndex(index: 0)
        case "product"://产品页
            tabbarSelectIndex(index: 1)
        case "find"://发现页
            tabbarSelectIndex(index: 2)
        case "account"://账户页
            tabbarSelectIndex(index: 3)
        case "postAll"://所有海报
            vc = vcFromStr("PostAllViewController")
        case "lastNews":// 所有资讯
            vc = vcFromStr("LastNewsAllViewController")
        default:
            break
        }
        
        guard let targetVc = vc else {
            return
        }
        if let nav = UIViewController.current()?.navigationController {
            nav.pushViewController(targetVc, animated: true)
        }else{
            let nav = UINavigationController.init(rootViewController: targetVc)
            UIViewController.current()?.present(nav, animated: true, completion: nil)
        }
        
        
    }
    
    static func tabbarSelectIndex(index : Int){
        guard let tabbar = UIViewController.current()?.tabBarController ,index <= (tabbar.children.count - 1) else {
            return
        }
        tabbar.selectedIndex = index
    }
    
    static func vcFromStr(_ name: String) -> UIViewController? {

//        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
//            print("CFBundleName - \(appName)")
        if let viewControllerType = NSClassFromString("\(Bundle.bundleName()).\(name)") as? UIViewController.Type {
                return viewControllerType.init()
            }
//        }

        return nil
    }

    
    
    
}
