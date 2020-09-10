//
//  DemoScrollview.swift
//  Responder
//
//  Created by Charlotte on 2020/9/10.
//

import UIKit

class DemoScrollview: UIView {
    
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view  = super.hitTest(point, with: event)

//        if self.point(inside: point, with: event){
//            return self
//        }

        for subview in self.subviews.reversed() {

            //转换到子视图上的坐标
            let convertP = self.convert(point, to: subview)

            if subview.point(inside: convertP, with: event){
                // 在子视图上
                return subview
            }
        }

        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)


    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        let point =  touch?.location(in: self)
        
        let subP = self.convert(point ?? CGPoint.zero, to: self.subviews.first)
        
        if ((self.subviews.first?.point(inside: subP, with: event))  == true){
            
            let blueView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
            blueView.backgroundColor = UIColor.blue
            blueView.center = point ?? CGPoint.zero
            
            let superV = self.next as! UIView
            
            superV.addSubview(blueView)
        }
        
        
        print("scroll touches began")
    }
    
    
    @objc func tapAction(){
        print("scrollview action")
    }
}
