//
//  AppDelegate.swift
//  MetalDemo
//
//  Created by Charlotte on 2020/11/19.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.rootViewController = ViewController()
        
        
        self.window = window
        
        window.makeKeyAndVisible()
                
        return true
    }



}

