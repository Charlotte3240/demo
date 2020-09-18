//
//  main.swift
//  GenericType
//
//  Created by Charlotte on 2020/9/16.
//

import Foundation

//let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
//
//
//if let foundIndex = ConstraintGeneric().findIndex(ofString: "dog", in: strings){
//    print(foundIndex)
//
//}
//
//
//var stackOfInts = Stack<Int>()
//
//stackOfInts.append(3)
//stackOfInts.append(5)
//stackOfInts.append(8)
//print(stackOfInts)
//print(stackOfInts.suffix(2))
//
//
//var stackOfStr = Stack<String>()
//
//stackOfStr.append("a")
//stackOfStr.append("b")
//stackOfStr.append("c")
//print(stackOfStr)
//stackOfStr = stackOfStr.suffix(2)
//
//
//var stackOfStr2 = Stack<String>()
//
//stackOfStr2.append("c")
//stackOfStr2.append("b")
//stackOfStr2.append("c")
//print(stackOfStr2)
//stackOfStr2 = stackOfStr2.suffix(2)
//
//
//print(stackOfStr.allItemMacth(stackOfStr, stackOfStr2))
//
//print(stackOfStr2.isTop("c"))
//print(stackOfStr2.isTop("b"))

//var container = IntStack()
//container.items = [9,9,9,9]
//
//if container.startWith(42){
//    print("start with 42")
//}else{
//    print("no start with")
//}

var container = Stack<Double>()
container.items = [1260.0, 1200.0, 98.6, 37.0]

print(container.average())


