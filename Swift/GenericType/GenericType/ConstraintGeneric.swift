//
//  ConstraintGeneric.swift
//  GenericType
//
//  Created by Charlotte on 2020/9/16.
//

///泛型约束
import Foundation
/*
func someFunction<T:SomeClass,U:SomeProtocol>(someClass : T, someProtocol: U) {
    //body
}
*/

struct ConstraintGeneric {
    func findIndex<T : Equatable>(ofString valueToFind :T, in array :[T]) -> Int?{
        for (index,item) in array.enumerated() {
            if item == valueToFind{
                return index
            }
        }
        return nil
    }
}
