//
//  AppDelegate.swift
//  GetMacAddress
//
//  Created by Charlotte on 2020/12/18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window = window
        self.window?.rootViewController = ViewController()
        self.window?.makeKeyAndVisible()
        
        
        
        return true
    }



}

