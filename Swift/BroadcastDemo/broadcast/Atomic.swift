//
//  Atomic.swift
//  HCWebRtc
//
//  Created by chunqi.liu on 2022/10/19.
//
import Foundation

@propertyWrapper
struct Atomic<Value> {
    private let queue = DispatchQueue(label: "com.charlotte.atomic")
    private var value: Value

    init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    var wrappedValue: Value {
        get {
            return queue.sync { value }
        }
        set {
            queue.sync { value = newValue }
        }
    }
}
