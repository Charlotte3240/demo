//
//  AppDelegate.swift
//  BroadcastDemo
//
//  Created by 360-jr on 2022/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let vc = UIStoryboard.init(name: "Main", bundle: nil)
        let root = vc.instantiateViewController(withIdentifier: "ViewController")
        self.window?.rootViewController = root
        self.window?.makeKeyAndVisible()
        
        return true
    }



}

