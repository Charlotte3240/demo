//
//  AppDelegate.swift
//  PICApp
//
//  Created by 360-jr on 2024/3/28.
//

import UIKit
import WebKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = ViewController()
        self.window?.makeKeyAndVisible()
        
        // 首次安装app 弹出允许网络
        let webview = WKWebView()
        webview.load(URLRequest(url: URL(string: "https://www.baidu.com")!))

        
        return true
    }


}

