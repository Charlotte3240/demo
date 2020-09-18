//
//  ViewController.swift
//  SignIn
//
//  Created by Charlotte on 2020/9/15.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2D.init(latitude: 31.239028, longitude: 121.511093)
        
        let convertLocatin = ConvertLocation.gcj02(toWgs84: location)
        
        print(convertLocatin)
        
    }


}

