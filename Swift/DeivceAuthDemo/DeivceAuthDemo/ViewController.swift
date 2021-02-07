//
//  ViewController.swift
//  DeivceAuthDemo
//
//  Created by 刘春奇 on 2021/2/7.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        
        self.checkCameraAndMicAuth { (result) in
            print("权限 v a =  \(result)")
        }
        
    }

    /// 检查摄像头和麦克风权限
    /// - Returns: 权限数组
    @objc func checkCameraAndMicAuth(_ authed : @escaping ( [Bool] )->Void){
        
        var result = [Bool]()
        
        let vStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let aStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        
        var needRequestAuth = false
        
        switch vStatus {
        case .authorized:
            result.append(true)
        case .denied://被拒绝，需要跳转setting
            result.append(false)
        case .notDetermined:// 还没有决定，可以申请一次权限
            needRequestAuth = true
            result.append(false)
        case .restricted:// 客服端无权访问媒体类型的硬件，可能会出现在家长控制中
            result.append(false)
        default:break
            
        }
        switch aStatus {
        case .authorized:
            result.append(true)
        case .denied://被拒绝，需要跳转setting
            result.append(false)
        case .notDetermined:// 还没有决定，可以申请一次权限
            needRequestAuth = true
            result.append(false)
        case .restricted:// 客服端无权访问媒体类型的硬件，可能会出现在家长控制中
            result.append(false)
        default:break
            
        }
        
        print("当前权限状态 \(vStatus) , \(aStatus)")
        
        if needRequestAuth{
            authCameraAndMic(authed)
        }else{
            authed(result)
        }
    }

    
    
    /// 申请摄像头和麦克风权限
    @objc func authCameraAndMic(_ authed : @escaping ( [Bool] )->Void){
        
        var result : [Bool] = [Bool].init(repeating: false, count: 2)
        
        let group = DispatchGroup()
        
        DispatchQueue.global().async(group: group, execute: {
            group.enter()
            AVCaptureDevice.requestAccess(for: .video) { (res) in
                result[0] = res
                group.leave()
            }
        })
        DispatchQueue.global().async(group: group, execute: {
            group.enter()
            AVCaptureDevice.requestAccess(for: .audio) { (res) in
                result[1] = res
                group.leave()
            }
        })
        
        group.notify(queue: .main) {
            authed(result)
        }
        
    }


}

