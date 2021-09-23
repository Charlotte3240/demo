//
//  HCJSONDecode.swift
//  HCJSONDecode
//
//  Created by 刘春奇 on 2021/4/23.
//

import Foundation

/**
 * json 基本数据类型
 * string  number bool
 * 特殊类型 :
 * null
 * 复合类型 :
 * array object
 */

public enum JSON {
    case string(String)
    case bool(Bool)
    //number
    case double(Double)
    case int(Int)
    
    case array([JSON])
    case object([String : JSON])
    case null

}

extension JSON{
    public init(_ value : String){
        self = .string(value)
    }
    
    public init(_ value : Bool) {
        self = .bool(value)
    }
    
    public init(_ value : Double){
        self = .double(value)
    }
    
    public init(_ value : Int){
        self = .int(value)
    }
    
    public init(_ value : [JSON]){
        self = .array(value)
    }
    
    public init(_ value : [String : JSON]){
        self = .object(value)
    }
    
}

// 打印输出转化
extension JSON : CustomStringConvertible{
    public var description: String {
        switch self {
        case let .string(v):
            return "String(\(v))"
        case let .bool(v):
            return "Bool(\(v))"
        case let .int(v):
            return "Int(\(v))"
        case let .double(v):
            return "Double(\(v))"
        case let .array(v):
            return "Array(\(v))"
        case let .object(v):
            return "Object(\(v))"
        case .null:
            return "null"
        }
    }
    
    
}


// 美化json
func prettyJson(level:Int = 0, json : JSON) -> String {
    switch json {
    case let .string(s):
        return refString(s)
    
    case let .bool(b):
        return b ? "true" : "false"
    case let .double(d):
        return "\(d)"
    case let .int(i):
        return "\(i)"
    case let .array(arr):
        if arr.isEmpty { return "[]" }
        return "[" + prettyList(level: level, pretty: prettyJson, list: arr) + "]"
    case let .object(obj):
        if obj.isEmpty { return "{}" }
        return
    case .null:
        return "null"
    }
}


func refString(_ value : String) -> String{
    return #"\#(value)"#
}

func prettyList(level : Int, pretty : (Int , JSON) -> String, list : [JSON]) -> String{
    // 和上一次的锁进再加4
    let level1 = level + 4
    // 换行拼接空格
    let indent = "\n" + String(repeating: " ", count: level1)
    
    return list.compactMap { (json) -> String in
        let str = pretty(level1,json)
        return indent + str

    }.joined(separator: ",") + "\n" + String(repeating: " ", count: level)
    
}

func prettyObject(level : Int, pretty : (Int , JSON), object : [String : JSON]) -> String{
    return ""
}
