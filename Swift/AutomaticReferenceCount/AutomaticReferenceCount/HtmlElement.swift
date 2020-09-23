//
//  HtmlElement.swift
//  AutomaticReferenceCount
//
//  Created by Charlotte on 2020/9/22.
//

import Foundation

class HtmlElement {
    let name : String
    let text : String?
    
    lazy var asHTML: () -> String = { [unowned self] in
        if let text = self.text{
            return "<\(self.name)>\(text)</\(self.name)>"
        }else{
            return "<\(self.name) />"
        }
    }
    
    init(name : String,text : String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("html element deinit")
    }
}
