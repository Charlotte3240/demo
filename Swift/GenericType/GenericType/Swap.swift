//
//  Swap.swift
//  GenericType
//
//  Created by Charlotte on 2020/9/16.
//

import Foundation

struct SwapTest {
    
    func swapTwoInts(_ a: inout Int, _ b: inout Int) {
        let temp = a
        a = b
        b = temp
    }
    
    func swapTwoValues<T>(_ a: inout T,_ b: inout T){
        let temp = a
        a = b
        b = temp
    }


    func foo(){
        var someInt = 3

        var otherInt = 5

        swap(&someInt, &otherInt)
        print(someInt,otherInt)

        
        var someString = "hello"
        var anotherString = "world"
        swapTwoValues(&someString, &anotherString)
        print(someString,anotherString)

    }
}

