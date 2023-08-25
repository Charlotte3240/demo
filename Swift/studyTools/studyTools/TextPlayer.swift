//
//  PlayZHContent.swift
//  studyTools
//
//  Created by Charlotte on 2023/6/14.
//

import Foundation
import AVFoundation

protocol PlayerDelegate : AnyObject{
    func finish (content : String)
}


enum Language : String{
    case zh_ch = "zh-CN"
    case en_us = "en-US"
}

class TextPlayer : NSObject{
    weak var delegate  : PlayerDelegate?
    var curContent : String?
    var synthesizer: AVSpeechSynthesizer?
    var language : Language?
    
    init(lan: Language) {
        super.init()
        self.language = lan
        self.synthesizer = AVSpeechSynthesizer()
        self.synthesizer?.delegate = self


    }
    
    /// 播放合成音频，取消上一个播放内容
    /// - Parameter content: 语音合成内容
    func playNext(content: String) {
        self.stop()
        self.addPlayList(content: content)
    }
    
    /// 播放合成音频，排队播放
    /// - Parameter content: 语音合成内容
    func addPlayList(content : String){
        self.curContent = content
        autoreleasepool {
            let utterance = AVSpeechUtterance(string: content)
            if self.language == .en_us{
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            }else{
                utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
            }
            
            self.synthesizer?.speak(utterance)
        }
    }
    
    
    /// 停止播放合成音频
    func stop (){
        self.synthesizer?.stopSpeaking(at: .immediate)
    }
    

    
}

extension TextPlayer :  AVSpeechSynthesizerDelegate{
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.delegate?.finish(content: self.curContent ?? "")
    }

}
