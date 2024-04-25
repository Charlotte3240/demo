//
//  IndicatorView.swift
//  PIC
//
//  Created by m1 on 2024/4/8.
//

import UIKit

enum IndicatorStatus{
    case hidden
    case loading
    case collecting
    case end
}

class IndicatorView: UIView{
    var status : IndicatorStatus = .hidden
    var loadingText : String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.showIndictor(status: .loading)
        
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
            // 变更前移除所有显示的view
            self?.removeAll()

            switch status{
            case.hidden:
                self?.isHidden = true
            case .loading:
                self?.showLoading()
            case .collecting:
                self?.showCollecting()
            case .end:
                self?.showComplete()
            }
        }
    }
    
    
    func showLoading(){
        self.isHidden = false
        // 中间文字
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 35))
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = self.loadingText
        label.textAlignment = .center
        label.textColor = .black
        self.addSubview(label)
        label.center = self.center
        
        let subTitle = UILabel.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 25))
        subTitle.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        subTitle.text = "正在访问"
        subTitle.textAlignment = .center
        self.addSubview(subTitle)
        subTitle.center = CGPoint(x: self.center.x, y: self.center.y + (35 / 2.0) + (25/2.0))

        let curBundle = Bundle.init(for: IndicatorView.self)

        // 上面图片
        let loadingImagePath = curBundle.path(forResource: "loading", ofType: "png")
        let loadingImgView = UIImageView(image: UIImage(contentsOfFile: loadingImagePath!))
        loadingImgView.contentMode = .scaleAspectFit
        loadingImgView.frame = CGRect(x: 0, y: 0, width: 200, height: 165)
        self.addSubview(loadingImgView)
        loadingImgView.center = CGPoint(x: self.center.x, y: self.center.y - (165/2.0) - (35 / 2.0) - 10)
        
        // 下面动图
        let gifImg = try? UIImage(gifName: "loading.gif",bundle: curBundle)
        let loadingGifView = UIImageView()
        loadingGifView.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        self.addSubview(loadingGifView)
        loadingGifView.center = CGPoint(x: self.center.x, y: self.center.y + (35 / 2.0) + 25 + 10)
        if let gifImg = gifImg {
            loadingGifView.setGifImage(gifImg)
        }
    }
    
    func showCollecting(){
        self.isHidden = false
        // 中间文字
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 35))
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "数据整理中"
        label.textColor = .black
        label.textAlignment = .center
        self.addSubview(label)
        label.center = self.center
        
        let curBundle = Bundle.init(for: IndicatorView.self)

        // 上面动图
        let gifImg = try? UIImage(gifName: "collecting.gif",bundle: curBundle)
        let loadingGifView = UIImageView()
        loadingGifView.frame = CGRect(x: 0, y: 0, width: 165, height: 165)
        self.addSubview(loadingGifView)
        loadingGifView.center = CGPoint(x: self.center.x, y: self.center.y - (165/2.0) - (35 / 2.0) - 10)
        if let gifImg = gifImg {
            loadingGifView.setGifImage(gifImg)
        }

    }
    
    func showComplete(){
        self.isHidden = false
        // 上面图片
        let curBundle = Bundle.init(for: IndicatorView.self)
        let loadingImagePath = curBundle.path(forResource: "success", ofType: "jpg")
        let loadingImgView = UIImageView(image: UIImage(contentsOfFile: loadingImagePath!))
        loadingImgView.contentMode = .scaleAspectFit
        loadingImgView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.addSubview(loadingImgView)
        loadingImgView.center = self.center
    }

    
    func removeAll(){
        self.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}
