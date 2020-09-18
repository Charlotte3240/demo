//
//  Stack.swift
//  GenericType
//
//  Created by Charlotte on 2020/9/16.
//

import Foundation

struct Stack<T : Equatable> :Container{
    
    
    var items = [T]()
    
    mutating func push(item :T) {
        items.append(item)
    }
    
    mutating func pop() -> T{
        return items.removeLast()
    }
    
    mutating func append(_ item: T) {
        self.push(item: item)
    }
    
    var count: Int{
        return items.count
    }
    
    subscript(i: Int) -> T {
        return items[i]
    }
    
}

extension Stack{
    var topItem : T? {
        return items.first ?? items[items.count - 1]
    }
}

/// test
extension Stack{
    func foo() {
        var stack = Stack<Int>()

        for i in 0...4{
            stack.push(item: i)
        }
        print(stack.items)

        if let top = stack.topItem{
            print(top)
        }
    }
}


extension Stack where T : Equatable{
    /// stack 的 top 是数组的last
    func isTop(_ item : T) -> Bool{
        guard let topItem = items.last else {
            return false
        }
        
        return topItem == item
    }
}
