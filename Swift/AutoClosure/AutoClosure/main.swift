//
//  main.swift
//  AutoClosure
//
//  Created by Charlotte on 2021/9/22.
//

import Foundation



func ifElse(condition: () -> Bool, trueValue :() ->Void , falseValue : () -> Void){
    condition() ? trueValue() : falseValue()
}

ifElse {
    1 < 2
} trueValue: {
    print("xiaoyu")
} falseValue: {
    print("dayu")
}

func ifElse2(condition : @autoclosure () -> Bool, trueValue : @autoclosure () -> Void , falseValue : @autoclosure () -> Void){
    condition() ? trueValue() : falseValue()
}

ifElse2(condition: 1 < 2, trueValue: print("true condition"), falseValue: print("false condition"))
