//
//  ViewController.swift
//  MetalDemo
//
//  Created by Charlotte on 2020/11/19.
//

import UIKit
import Metal
import MetalKit

class ViewController: UIViewController {
    
    var render: HCColorRender?

    var mtkView : MTKView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.创建一个MTKView
        self.mtkView = MTKView.init(frame: self.view.bounds)
        
        // 2.创建一个默认的device
        self.mtkView?.device = MTLCreateSystemDefaultDevice()
        
        guard self.mtkView?.device != nil else {
            print("metal not supported the device")
            return
        }
        
        self.render = HCColorRender(mtkView: self.mtkView!)
        mtkView!.delegate = self.render
        // 设置帧数
        mtkView!.preferredFramesPerSecond = 60

        self.view.addSubview(mtkView!)
        
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100))
        label.textAlignment = .center
        label.text = "hello world"
        label.textColor = .blue
        label.center = self.view.center
        self.view.addSubview(label)


        
         float4
        
    }


}



