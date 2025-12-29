//
//  HCExtension.swift
//  HCExtension
//
//  Created by 360-jr on 2024/11/11.
//
import Foundation

public protocol HCExtension{
    associatedtype someType
    var hc: someType {get}
}



public extension HCExtension{
    var hc: HCHelper<Self>{
        get { return HCHelper(self) }

    }
}

public struct HCHelper<Base>{
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

