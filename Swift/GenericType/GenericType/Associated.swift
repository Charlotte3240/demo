//
//  Associated.swift
//  GenericType
//
//  Created by Charlotte on 2020/9/16.
//

import Foundation

protocol Container {
    // 给关联类型添加约束
    associatedtype Item : Equatable
    mutating func append(_ item: Item)
    var count : Int {get}
    subscript(i:Int) -> Item {get}
    
    
//    associatedtype Iterator : IteratorProtocol where Iterator.Element == Item
//    func makeIterator() -> Iterator
}



struct IntStack : Container {

    
    
    var items = [Int]()
        
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    
    /// protocol implement
    
    // 只要实现了Protocol中带有关联类型的一个方法 就不需要指定associatedtype类型
    //    typealias Item = Int
    var count: Int{
        return items.count
    }
    
    subscript(i: Int) -> Int {
        return items[i]
    }
    mutating func append(_ item: Int) {
        self.items.append(item)
    }
}


protocol SuffixableContainer : Container {
    associatedtype Suffix : SuffixableContainer where Item == Suffix.Item
    func suffix(_ size :Int) -> Suffix
}




extension Stack : SuffixableContainer{
    
    func suffix(_ size : Int) -> Stack{
        var result = Stack()
        
        for i in (count - size)..<count {
            result.append(self[i])
        }
        return result
        
    }
}


extension IntStack : SuffixableContainer{
    func suffix(_ size: Int) -> Stack<Int> {
        var result = Stack<Int>()
        for i in (count - size)..<count {
            result.append(self[i])
        }
        return result
    }
    
//    typealias Suffix = Stack<Int>
    
    
}


extension Stack {
    func allItemMacth<C1:Container,C2:Container>(_ item1 : C1,_ item2 : C2) ->  Bool where C1.Item == C2.Item {
        if item1.count != item2.count{ return false }
        
        for i in 0..<item1.count {
            if item1[i] != item2[i]{
                return false
            }
        }
        
        return true
    }
}


extension Container where Item :Equatable{
    func startWith(_ item :Item) -> Bool {
        return count >= 1 && item == self[0]
    }
}

extension Container where Item == Double{
    func average() -> Double{
        var sum = 0.0
        for i in 0..<self.count {
            sum += self[i]
        }
        return sum/Double(count)
    }
}



