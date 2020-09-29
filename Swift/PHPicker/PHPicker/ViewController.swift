//
//  ViewController.swift
//  PHPicker
//
//  Created by Charlotte on 2020/9/27.
//

import UIKit
import PhotosUI


class ViewController: UIViewController {
    @IBOutlet weak var chooseBtn: UIButton!
    @IBOutlet weak var displayImageView: UIImageView!
    
    var images = [UIImage]()
    var timer = DispatchSource.makeTimerSource(queue: .main)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            
        
    }
    @IBAction func writePhoto(_ sender: Any) {
        let image = self.view.convertViewToImage()
        HCPicker.shared.save(image: image) { (success) in
            print("保存照片 \(success)")
        }
        
    }
    /// 选择更多的照片加入到限制浏览中 前提是权限是limited
    @IBAction func chooseMoreLimitedPhotos(_ sender: Any) {
        HCPicker.shared.showLimitedImages()
    }
    
    
    /// 读取照片
    @IBAction func chooseAction(_ sender: Any) {
        HCPicker.shared.numberOflimited = 3
        HCPicker.shared.getImages { (images) in
            self.images = images
            self.changimages()
        }
    }
    
    func changimages(){
        
        var index = 0
        
        timer.schedule(deadline: .now(), repeating: 2, leeway: .microseconds(10))
        timer.setEventHandler {
            if index > 2{
                self.timer.cancel()
                self.timer = DispatchSource.makeTimerSource(queue: .main)
                index = 0
                return
            }
            self.displayImageView.image = self.images[index]
            index += 1
            
        }
        timer.activate()
        
        
    }

}

extension UIView{
    
    @objc func convertViewToImage() -> UIImage{
        let size = self.bounds.size
        ///  size : view size
        /// opaque : 是否非透明，半透明需要false
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
        
    }
    
}
