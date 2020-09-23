//
//  Customer.swift
//  AutomaticReferenceCount
//
//  Created by Charlotte on 2020/9/21.
//

import Foundation

class Customer {
    let name: String
    var card : CreditCard?
    init(name : String) {
        self.name = name
    }
    deinit {
        print("\(name) customer deinit")
    }
}

class CreditCard {
    let number : UInt64
    unowned let customer:Customer
    init(num : UInt64,customer : Customer) {
        self.number = num
        self.customer = customer
    }
    
    deinit {
        print("card num \(number) deinit")
    }
}
