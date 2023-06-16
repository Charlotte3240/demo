//
//  CalculatorButtonItem.swift
//  Calc
//
//  Created by 360-jr on 2023/6/13.
//

import Foundation

enum CalculatorButtonItem{
    enum Op : String{
        case plus = "+"
        case minus = "-"
        case multipy = "x"
        case divide = "÷"
        case equal = "="
    }
    
    enum Command : String{
        case clear = "AC"
        case flip = "+/-"
        case percent = "%"
    }
    case digit(Int)
    case dot
    case op(Op)
    case command(Command)
}

import SwiftUI
extension CalculatorButtonItem{
    
    var title : String{
        switch self{
        case .digit(let value): return String(value)
        case .dot: return "."
        case .command(let cmd): return cmd.rawValue
        case .op(let op): return op.rawValue
        }
    }
    
    var size : CGSize{
        if self.title == "0"{
            return CGSize(width: (88 * 2 + 8) * scale, height: 88 * scale)
        }else{
            return CGSize(width: 88 * scale, height: 88 * scale)
        }
    }
    
    var backgroundColorName : String{
        switch self{
        case .digit, .dot : return "digitBackground"
        case .op : return "operatorBackground"
        case .command : return "commandBackground"
        }
    }
    
    var foregroundColorname : String{
        switch self{
        case .command: return "commandForeground"
        default: return "defaultForeground"
        }
    }
    
    var scale : CGFloat {
        return UIScreen.main.bounds.size.width / 414
    }
}

extension CalculatorButtonItem : Hashable{}
