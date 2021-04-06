//
//  ViewController.swift
//  GetWifiInfo
//
//  Created by 刘春奇 on 2021/3/25.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import CoreLocation

class ViewController: UIViewController {
    
    private var locationManager : CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let wifiInfo = HCGetWifiInfo.init()
//        let dic =  wifiInfo.fetchSSIDInfo()
//
        let dic = HCGetWifiInfo.fetchSSIDInfo()
        print("\(dic["SSIDDATA"] ?? "")")
        
        
        
        
    }
    
    func getConnectedWifiInfo() -> [AnyHashable: Any]? {

        if #available(iOS 13.0, *) {
            //系统版本高于13.0 未开启地理位置权限 需要提示一下
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
                self.locationManager = CLLocationManager()
                self.locationManager?.requestWhenInUseAuthorization()
                self.locationManager?.delegate = self
                
            }
        }

        
        if let ifs = CFBridgingRetain( CNCopySupportedInterfaces()) as? [String],
            let ifName = ifs.first as CFString?,
            let info = CFBridgingRetain( CNCopyCurrentNetworkInfo((ifName))) as? [AnyHashable: Any] {

            return info
        }
        return nil

    }
    
    

}

extension ViewController : CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .authorizedAlways,.authorizedWhenInUse:
                print("定位可以用")
            case .denied,.restricted:
                print("被拒绝 or 受限制")
            default: break
                // notDetermind 还没有进行选择
            }
        } else {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways,.authorizedWhenInUse:
                print("定位可以用")
            case .denied,.restricted:
                print("被拒绝 or 受限制")
            default: break
                // notDetermind 还没有进行选择
            }
        }
    }
}
