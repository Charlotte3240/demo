//
//  ViewController.swift
//  KTVText
//
//  Created by 360-jr on 2024/1/4.
//


import UIKit

class GradientTextAnimationViewController: UIViewController {
    
    private var animatedLabel: SubtitleLabel?
    private var labelProgress = 0.0
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        animatedLabel = SubtitleLabel(frame: CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width, height: 100), noreadyColor: UIColor(red: 0.35, green: 0.36, blue: 0.45, alpha: 1), readyColor: UIColor(red: 0, green: 0.72, blue: 0.34, alpha: 1))
        
        animatedLabel!.originalText = "如果您同意，办理公证并且债务加入人为您承担部分债务，公证后您若违约则无需诉讼直接接受加入人住所低于或财产所在地等法院执行。"
        self.view.addSubview(animatedLabel!)
        self.animatedLabel!.center = self.view.center
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 启动定时器
        startColorChangingTimer()
    }

    func startColorChangingTimer() {
        // 创建并启动定时器
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(changeCharacterColor), userInfo: nil, repeats: true)
    }

    @objc func changeCharacterColor() {
        let sumTime = 2 * 1000.0 // 单位ms
        self.labelProgress += 100
        let progress = self.labelProgress / sumTime
        self.animatedLabel?.updateProgress(progress: progress)
        
        if progress >= 1{
            // 取消定时器， 完成播报
            self.timer?.invalidate()
            self.timer = nil
            debugPrint("开场白播报完成")
        }
    }

}

