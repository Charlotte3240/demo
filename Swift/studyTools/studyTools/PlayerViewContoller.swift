//
//  PlayerViewContoller.swift
//  studyTools
//
//  Created by 360-jr on 2023/6/14.
//

import UIKit
// 每个字母等待时间
let perLetterSecond = 0.70
// 每个汉字等待时间
let perChinaCharacterSecond = 4.0

class PlayerViewController : UIViewController{
    @IBOutlet weak var displayLabel: UILabel!
    
    var player : ENPlayer?
    var datas : [StudyData]?
    var lan : Language = .en_us
    var playContents  = [String]()
    var displayContents  = [String]()
    var playIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.player = ENPlayer(lan: self.lan)
        self.player?.delegate = self
                
        self.datas = [
            ENData(zhContent: "香蕉", enContent: "banana", partOfSpeech: "n", pinyin: "xiang jiao", semester: "2.1"),
            ENData(zhContent: "橘子", enContent: "orange", partOfSpeech: "n", pinyin: "ju zi", semester: "2.1"),
            ENData(zhContent: "苹果", enContent: "this is an apple", partOfSpeech: "n", pinyin: "ping guo", semester: "2.1")
        ]
        // 打乱顺序
        self.datas?.shuffle()

        // 准备数据
        self.startPlay()
    }
    
    
    func startPlay(){
        if self.lan == .en_us{
            self.playContents = self.datas?.compactMap({ data in
                if let data = data as? ENData{
                    return data.enContent
                }
                return ""
            }) ?? [String]()
        }else{
            self.playContents = self.datas?.compactMap({ data in
                if let data = data as? ENData{
                    return data.zhContent
                }
                return ""
            }) ?? [String]()

        }
        self.displayContents = self.datas?.compactMap({ data in
            if let data = data as? ENData{
                return data.pinyin
            }
            return ""
        }) ?? [String]()

        self.playNext(index: 0)
    }
    
    func playNext(index : Int){
        self.playIndex = index
        let pinyin = self.displayContents[index]
        self.displayLabel.text = pinyin
        self.player?.play(content: self.playContents[index])
    }
    
    deinit{
        print("player deinit")
    }
}


extension PlayerViewController : PlayerDelegate{
    func finish (content : String){
        // 记录默写了哪些单词
        print("\(content) play finished")
        
        // 延迟两s后播放下一个单词
        if self.playIndex+1 >= self.playContents.count {
            print("全部播放完毕")
            return
        }
        
        let curText = self.playContents[self.playIndex]
        var waitTime : Double
        if self.lan == .en_us {
            waitTime = Double(curText.count) * perChinaCharacterSecond
        }else{
            waitTime = Double(curText.count) * perLetterSecond
        }
        waitTime += 2

        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {[weak self] in
            self?.playNext(index: (self?.playIndex ?? 0)+1)
        }
    }

}
