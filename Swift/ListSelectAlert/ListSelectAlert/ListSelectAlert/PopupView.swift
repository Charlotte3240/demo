//
//  PopupView.swift
//  ListSelectAlert
//
//  Created by 360-jr on 2024/8/8.
//

import UIKit

struct ListCellModel : Codable {
    var `id` : String?
    var title : String?
}

typealias SelectBlock = (Int, String) -> Void
typealias CancelBlock = () -> Void


class PopupView: UIView{
    fileprivate let boxView = UIView() // 盒子
    fileprivate var contentView: TableContentView?
    
    fileprivate var titleString = ""
    fileprivate var dataList = [ListCellModel]()
    fileprivate var confirmBlock: SelectBlock?
    fileprivate var cancelBlock: CancelBlock?
    
    
    fileprivate var isAnimation : Bool = false
    fileprivate var effectView: UIVisualEffectView?

    
    
    init(titleString: String, dataList: [ListCellModel] = [ListCellModel](), confirmBlock: SelectBlock? = nil, cancelBlock: CancelBlock? = nil) {
        super.init(frame: .zero)
        
        self.titleString = titleString
        self.dataList = dataList
        self.confirmBlock = confirmBlock
        self.cancelBlock = cancelBlock
        
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancel))
        cancelTap.delegate = self
        self.addGestureRecognizer(cancelTap)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        
        //MARK: - boxView
        let maxCellCount = 5 // 最多展示几行
        let cellHeight = 50 // 行高
        let titleHeight = 70 // 标题高度
        var displayLines = 5 // 最终显示几行
        if self.dataList.count <= maxCellCount{
            displayLines = self.dataList.count
        }
        self.boxView.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width * 0.75), height: displayLines * cellHeight + titleHeight)
        self.boxView.backgroundColor = .white
        self.boxView.center = self.center
        self.boxView.layer.cornerRadius = 3.0
        self.addSubview(self.boxView)
        
        //MARK: - ContentView
        let titleLabel = UILabel()
        titleLabel.text = self.titleString
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 23)
        self.boxView.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 20, y: 0, width: Int(boxView.bounds.size.width), height: titleHeight)
        
        let contentView = TableContentView()
        contentView.frame = CGRect(x: 10, y: titleHeight, width: Int(boxView.bounds.size.width) - 10, height: Int(boxView.bounds.height) - titleHeight)
        self.boxView.addSubview(contentView)
        contentView.data = self.dataList
        self.contentView = contentView
        self.contentView?.selectBlock = {[weak self] (index) in
            if self?.confirmBlock != nil{
                self?.confirmBlock!(index, self?.dataList[index].title ?? "")
            }
        }

        
        //MARK: - insert current vc view
        self.alpha = 0
        UIViewController.current()?.view.addSubview(self)
        
    }
    
    func changeDataList(title: String,  data: [ListCellModel]){
        self.dataList = data
    }
    
    func show(){
        if self.isAnimation {
            return
        }
        
        self.setupView()

        
        self.boxView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        self.effectView?.removeFromSuperview()
        self.effectView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .dark))
        self.effectView?.alpha = 0.85
        self.effectView?.frame = bounds
        self.insertSubview(self.effectView!, at: 0)
        
        self.isAnimation = true
        let usingSpringWithDamping:CGFloat = 0.8
        let initialSpringVelocity:CGFloat = 0.5


        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: usingSpringWithDamping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: .curveEaseInOut,
                       animations: {[weak self] in
            self?.alpha = 1
            self?.boxView.transform = CGAffineTransform.init(scaleX: 1, y: 1)

        }) { [weak self] (_)in
            self?.isAnimation = false
        }

    }
    
    
    func hidden(){
        if self.isAnimation {
            return
        }
        self.isAnimation = true
        let usingSpringWithDamping:CGFloat = 0.8
        let initialSpringVelocity:CGFloat = 0.5

        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: usingSpringWithDamping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: .curveEaseInOut,
                       animations: {[weak self] in
            self?.alpha = 0

        }) { [weak self] (_)in
            self?.isAnimation = false
            self?.boxView.removeFromSuperview()
            self?.removeFromSuperview()
        }
        
    }
    
    @objc func cancel(){
        self.hidden()
        if self.cancelBlock != nil{
            self.cancelBlock!()
        }
    }
}


extension PopupView : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else {
            return false
        }
        //touchView的frame转化到popupView上的frame
        let frame = touchView.convert(touchView.frame, to: self.boxView)
        if frame.origin.x >= 0&&frame.origin.y >= 0 {
            //说明点击的是popupView上的视图
            return false
        }
        return true
    }

}
