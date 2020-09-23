//
//  Person.swift
//  AutomaticReferenceCount
//
//  Created by Charlotte on 2020/9/21.
//

import Foundation

class Person {
    let name : String
    init(name : String) {
        self.name = name
        print("\(name) is being initialized")
    }
    
    var apartment: Apartment?
    var head : Head?
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Apartment {
    let unit : String
    init(unit : String) {self.unit = unit}
    
    weak var tenant : Person?
    deinit {print("Apartment \(unit) is being deinitialized")}
    
}

class Head {
    // 圆头 方头
    let detail: String
    unowned let owner : Person
    init(detail : String , owner : Person) {
        self.detail = detail
        self.owner = owner
    }
    
    deinit {
        print("head class deinit")
    }
    
}
