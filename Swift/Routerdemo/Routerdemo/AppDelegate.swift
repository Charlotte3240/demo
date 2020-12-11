//
//  AppDelegate.swift
//  Routerdemo
//
//  Created by Charlotte on 2020/12/7.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        self.window = window
        self.window?.rootViewController = UINavigationController.init(rootViewController: ViewController())
        self.window?.makeKeyAndVisible()
        
        
        
        return true
    }



}

