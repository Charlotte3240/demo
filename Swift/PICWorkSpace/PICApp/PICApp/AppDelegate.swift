//
//  AppDelegate.swift
//  PICApp
//
//  Created by m1 on 2024/3/28.
//

import UIKit
import WebKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 首次安装app 弹出允许网络
        let webview = WKWebView()
        webview.load(URLRequest(url: URL(string: "https://www.baidu.com")!))

        
        return true
    }


}


extension UIViewController {
// Ends editing view when touches to view
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      self.view.endEditing(true)
    }
}

