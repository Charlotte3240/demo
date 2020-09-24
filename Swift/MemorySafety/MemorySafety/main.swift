//
//  main.swift
//  MemorySafety
//
//  Created by Charlotte on 2020/9/22.
//

import Foundation
/*
 内存访问冲突的条件:
     * 至少有一个是写访问
     * 它们访问的是同一个存储地址
     * 它们的访问在时间线上部分重叠
 */



//var stepSize = 1
//
//func increment(_ num : inout Int){
//    num += stepSize
//}
//// Thread 1: Simultaneous accesses to 0x100008190, but modification requires exclusive access
//increment(&stepSize)


//
//// 解決冲突 显示 深拷贝（值类型都是深拷贝）
//var copyObj = stepSize
//increment(&copyObj)
//
//print(copyObj)


func balance(_ x : inout Int , _ y : inout Int){
    let sum = x + y
    x = sum/2
    y = sum - x
}
//
//var playOneSource = 42
//var playTwoSource = 30
//
//balance(&playOneSource, &playTwoSource)
//print(playOneSource,playTwoSource)
//Inout arguments are not allowed to alias each other
//balance(&playOneSource, &playOneSource)


struct Player {
    var name : String
    var health : Int
    var energy : Int
    static let maxHealth = 10
    
    mutating func restoreHealth(){
        self.health = Player.maxHealth
    }
}

extension Player{
    mutating func shareHealth (with teammate : inout Player){
        balance(&teammate.health, &self.health)
    }
}

var oscar = Player(name: "Oscar", health: 10, energy: 10)

var maria = Player(name: "Maria", health: 5, energy: 10)

oscar.shareHealth(with: &maria)
/// 写访问重叠 导致了 内存冲突
//balance(&oscar.health, &oscar.energy)

print(oscar.health)


func foo(){
    var oscar = Player(name: "Oscar", health: 10, energy: 5)
    balance(&oscar.health, &oscar.energy)
    print(oscar.health,oscar.energy)
}

foo()

