//
//  ViewController.swift
//  CreateQRImageSwift
//
//  Created by 刘春奇 on 2018/5/17.
//  Copyright © 2018年 Cloudnapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageview = UIImageView.init(image: createQRForString(qrString: "this is a qr code", qrImageName: nil))
        
        let bacView = UIView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        imageview.frame = CGRect(x: 0, y: 0, width:  sqrt(2)*100 - 5, height: sqrt(2)*100 - 5)
//        √2 * r = 圆内切最大正方形边长
        
        
        bacView.addSubview(imageview)
        imageview.center = bacView.center

        bacView.layer.cornerRadius = 100.0
        bacView.backgroundColor = UIColor.gray
        bacView.center = self.view.center
        
        self.view.addSubview(bacView)
        

    }
    
    func createQRForString(qrString: String?, qrImageName: String?) -> UIImage?{
        if let sureQRString = qrString {
            let stringData = sureQRString.data(using: .utf8,
                                               allowLossyConversion: false)
            // 创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter.outputImage
            
            // 创建一个颜色滤镜,黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")!
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            
            // 返回二维码image
            let codeImage = UIImage(ciImage: colorFilter.outputImage!
                .transformed(by: CGAffineTransform(scaleX: 5, y: 5)))
            
            // 通常,二维码都是定制的,中间都会放想要表达意思的图片
            if let iconImage = UIImage(named: qrImageName ?? "") {
                let rect = CGRect(x:0, y:0, width:codeImage.size.width,
                                  height:codeImage.size.height)
                UIGraphicsBeginImageContext(rect.size)
                
                codeImage.draw(in: rect)
                let avatarSize = CGSize(width:rect.size.width * 0.25,
                                        height:rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.draw(in: CGRect(x:x, y:y, width:avatarSize.width,
                                          height:avatarSize.height))
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        return nil
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

