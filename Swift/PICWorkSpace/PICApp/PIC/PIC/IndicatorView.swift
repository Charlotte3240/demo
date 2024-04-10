//
//  IndicatorView.swift
//  PIC
//
//  Created by 360-jr on 2024/4/8.
//

import UIKit

enum IndicatorStatus{
    case loading
    case end
}

class IndicatorView: UIView{
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if self.imageView == nil{
            self.imageView = UIImageView()
            self.imageView?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            self.addSubview(self.imageView!)
            
            self.imageView?.center = self.center
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func showIndictor(status: IndicatorStatus){
        guard let indictor = self.imageView else{
            return
        }
        let bundlePath = Bundle.init(for: IndicatorView.self).path(forResource: "VC", ofType: "bundle")
        let vcBundle = Bundle.init(path: bundlePath!)!

        let gifImg = try? UIImage(gifName: "fq2SpeakerGif.gif", bundle: vcBundle)
        guard let gifImg else { return }

        switch status{
        case .loading:
            indictor.setGifImage(gifImg, loopCount: -1)
        case .end:
            indictor.setGifImage(gifImg, loopCount: -1)
        }
    }

}
