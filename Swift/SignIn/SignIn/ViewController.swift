//
//  ViewController.swift
//  SignIn
//
//  Created by Charlotte on 2020/9/15.
//

import UIKit

class ViewController: UIViewController {

    lazy var manager : CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
        
    }
    
    
    func convertLocation() {
        //船舶大厦121.511064,31.23859
//        let location = CLLocationCoordinate2D.init(latitude: 31.23859, longitude: 121.511064)
        //巨洋大厦121.534119,31.241564
        let location = CLLocationCoordinate2D.init(latitude: 31.241564, longitude: 121.534119)

        let convertLocatin = ConvertLocation.gcj02(toWgs84: location)
        
        print(convertLocatin)

    }


}

extension ViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print(locations)
    }

}

