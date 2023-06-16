//
//  DataModel.swift
//  studyTools
//
//  Created by 360-jr on 2023/6/14.
//

import Foundation

protocol StudyData{}

struct ZHData: StudyData,Codable{
    
}

struct ENData: StudyData, Codable{
    let zhContent : String // 汉字内容
    let enContent : String // 英文内容 ，主键
    let partOfSpeech : String // 词性
    let pinyin : String // 汉字的拼音
    let semester : String // 学期 如2.1 2年级上班学期
}




enum DataType : String{
    case yuwen = "hanzi"
    case yingyu = "yingyu"
}





