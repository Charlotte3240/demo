//
//  CalculatorModel.swift
//  Calc
//
//  Created by 360-jr on 2023/12/27.
//

import Foundation
import Combine

class CalculatorModel : ObservableObject{
    
//    let objectWillChange = PassthroughSubject<Void, Never>()
    
//    var brain : CalculatorBrain = .left("0"){
//        willSet{
//            objectWillChange.send()
//        }
//    }
    
    @Published var brain : CalculatorBrain = .left("0")
    
    @Published var history : [CalculatorButtonItem] = []
    
    func apply(_ item : CalculatorButtonItem){
        brain = brain.apply(item: item)
        history.append(item)
        
        temporaryKept.removeAll()
        slidingIndex = Float(totalCount)
    }
    
    
    var historyDetail : String{
        history.map{$0.description}.joined()
    }
    
    var temporaryKept : [CalculatorButtonItem] = []
    
    var totalCount : Int {
        history.count + temporaryKept.count
    }
    
    var slidingIndex : Float = 0{
        didSet{
            keepHistory(upTo: Int(slidingIndex))
        }
    }
    
    func keepHistory(upTo index : Int){
        precondition(index <= totalCount , "Out of index.")
        
        let total = history + temporaryKept
        
        history = Array(total[..<index])
        temporaryKept = Array(total[index...])
        
        brain = history.reduce(CalculatorBrain.left("0")) { result, item in
            result.apply(item: item)
        }
    }
}
