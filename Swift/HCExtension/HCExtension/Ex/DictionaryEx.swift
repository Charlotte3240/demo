//
//  DictionaryEx.swift
//  HCExtension
//
//  Created by 360-jr on 2024/11/11.
//

import Foundation

// 定义一个协议用于扩展字典相关操作
protocol DictionaryExtension {
    // 关联类型，用于确定具体的字典类型
    associatedtype Key: Hashable
    associatedtype Value

    // 获取字典自身的引用，方便在扩展方法中使用
    var dictionarySelf: Dictionary<Key, Value> { get }

    // 扩展方法所在的辅助结构体
    var hc: DictionaryExtensionHelper<Self> { get }
}

// 为遵循协议的类型提供默认实现
extension DictionaryExtension {
    var hc: DictionaryExtensionHelper<Self> {
        return DictionaryExtensionHelper(self)
    }
}

// 辅助结构体，包含具体的扩展方法
struct DictionaryExtensionHelper<Base: DictionaryExtension> {
    let base: Base

    init(_ base: Base) {
        self.base = base
    }

    // 示例扩展方法：打印字典所有键值对
    func printAllPairs() {
        let dict = base.dictionarySelf
        dict.forEach { key, value in
            print("\(key) -> \(value)")
        }
    }
}

// 让标准字典类型遵循我们定义的扩展协议
extension Dictionary: DictionaryExtension {
    typealias Key = Key
    typealias Value = Value
    var dictionarySelf: Dictionary<Key, Value> {
        return self
    }
}
