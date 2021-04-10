//
//  Student.swift
//  Rx
//
//  Created by Charlotte on 2020/12/25.
//

import Foundation

struct Student {
    var stuId : String?
    var name : String?
    var score : Double?
    var parent : Parent?
    var grade : Int?
    var `class` : Int?
    var sex : Sex = .male
    
    func singASong(songName:String = "一剪梅"){
        print(songName)
    }
}

enum Sex {
    case male
    case female
}

struct Parent {
    var name :String?
    var childId: String?
    
    func receiveAPrize(){
        print("领奖")
    }
}
