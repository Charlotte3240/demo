//
//  PlayZHContent.swift
//  studyTools
//
//  Created by 360-jr on 2023/6/14.
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

class ENPlayer : NSObject{
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
    
    func play(content: String) {
        self.curContent = content
        
        let utterance = AVSpeechUtterance(string: content)
        if self.language == .en_us{
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }else{
            utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        }
        
        self.synthesizer?.speak(utterance)

    }
    
//    func stop (){
//        self.synthesizer?.stopSpeaking(at: .immediate)
//    }
    

    
}

extension ENPlayer :  AVSpeechSynthesizerDelegate{
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.delegate?.finish(content: self.curContent ?? "")
    }

}



//struct ZHPlayer : NSObject, AVSpeechSynthesizerDelegate{
//
//}
