//
//  IndicatorView.swift
//  PIC
//
//  Created by m1 on 2024/4/8.
//

import UIKit

enum IndicatorStatus{
    case create
    case loading
    case end
}

class IndicatorView: UIView{
    var imageView: UIImageView?
    
    var status : IndicatorStatus = .create
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if self.imageView == nil{
            self.imageView = UIImageView()
            self.imageView?.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            self.addSubview(self.imageView!)
            
            self.imageView?.center = self.center
        }
        self.backgroundColor = .white
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func showIndictor(status: IndicatorStatus){
        DispatchQueue.main.async {[weak self] in
            if self?.status == status{
                return
            }else{
                self?.status = status
            }
            guard let indictor = self?.imageView else{
                return
            }
            

            switch status{
            case.create: break
            case .loading:
                let gifImg = try? UIImage(gifName: "loading.gif",bundle: Bundle.init(for: IndicatorView.self))
                guard let gifImg else { return }
                indictor.setGifImage(gifImg, loopCount: -1)
            case .end:
                indictor.stopAnimatingGif()
                self?.isHidden = true
            }
        }
    }

}
