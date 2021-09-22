//
//  AppDelegate.swift
//  链式调用Dynamic Member Lookup
//
//  Created by Charlotte on 2021/9/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow.init()
        
        self.window?.rootViewController = ViewController()
        
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

