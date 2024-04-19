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
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        // 首次安装app 弹出允许网络
        let webview = WKWebView()
        webview.load(URLRequest(url: URL(string: "https://www.baidu.com")!))

        
        return true
    }


}

