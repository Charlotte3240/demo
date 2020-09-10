//
//  DemoBtn.swift
//  Responder
//
//  Created by Charlotte on 2020/9/10.
//

import UIKit

class DemoBtn: UIButton {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var next = self.next
        print(self.classForCoder)
        
        var prefix = "--"
        
        while next != nil {
            print("\(prefix) \(next!.classForCoder)")
            prefix.append("--")
            next = next?.next
            
        }
        super.touchesBegan(touches, with: event)

        guard let superP = touches.first?.location(in: self.next as! UIView) else { return  }
        
        let superV = self.next as! UIView
        
        if superV.point(inside: superP, with: event){
            self.next?.touchesBegan(touches, with: event)
        }
        
        
        
    }

    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isUserInteractionEnabled == false || self.isHidden == true || self.alpha <= 0.01{
            return nil
        }
        if self.point(inside: point, with: event) == false{
            return nil
        }
        for subView in self.subviews.reversed() {
            let subPoint = self.convert(point, to: subView)
            let fitView = subView.hitTest(subPoint, with: event)
            if fitView != nil{
                return fitView
            }
        }

        return self
    }
    
    
    
}
