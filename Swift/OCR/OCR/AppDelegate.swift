//
//  AppDelegate.swift
//  OCR
//
//  Created by Charlotte on 2023/2/2.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        guard let url = URL(string: "https://www.baidu.com")else{
            return true
        }
        let req = URLRequest(url: url )
        URLSession.shared.dataTask(with: req) { data, res, err in
            
        }.resume()
        
        return true
    }


}

