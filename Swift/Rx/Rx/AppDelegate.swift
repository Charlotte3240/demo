//
//  AppDelegate.swift
//  Rx
//
//  Created by Charlotte on 2020/12/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow.init()
        window.backgroundColor = UIColor.white
        self.window = window
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = ObserverVC()
        
        return true
    }



}

