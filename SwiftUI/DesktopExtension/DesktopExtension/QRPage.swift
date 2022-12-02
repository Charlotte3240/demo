//
//  QRPage.swift
//  DesktopExtension
//
//  Created by 360-jr on 2022/12/1.
//

import UIKit
import SwiftUI
struct QRView : UIViewControllerRepresentable{
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    func updateUIViewController(_ uiViewController: QRViewController, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) ->  QRViewController {
        let controller = QRViewController()
        controller.goBack = {
            popAction()
        }
        return controller
    }
    typealias UIViewControllerType = QRViewController
    
    func popAction(){
        self.mode.wrappedValue.dismiss()
    }

}


class QRViewController : UIViewController{
    
    var active : Bool = true
    
    typealias Goback = () -> Void
    var goBack :Goback?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let swip  = UISwipeGestureRecognizer(target: self, action: #selector(swipBack))
        swip.direction = .right
        self.view.addGestureRecognizer(swip)
        
        let txt = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        txt.textColor = .blue
        txt.text = "hello world"
        txt.center = self.view.center
        self.view.addSubview(txt)
        
        
        
//        //MARK: - 简单哀悼模式 注意只能在iOS12以上使用
//        let aidaoView = UIView()
//        aidaoView.frame = UIScreen.main.bounds
//        aidaoView.isUserInteractionEnabled = false
//        aidaoView.backgroundColor = UIColor.lightGray
//        aidaoView.layer.compositingFilter = "saturationBlendMode"
//        // 在最上层加上这个view 蒙版
//        self.view.addSubview(aidaoView)
        
                
        
    }
    
    @objc func swipBack (){
//        self.goBack?()
        let scanVc = QRScanViewController()
        scanVc.modalPresentationStyle = .fullScreen
        self.present(scanVc, animated: true)

    }
    
}
