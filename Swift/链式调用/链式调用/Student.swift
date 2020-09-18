//
//  Student.swift
//  链式调用
//
//  Created by Charlotte on 2020/9/8.
//

import Cocoa
import AppKit



public class StudentMake{
    var name : String = ""
    var tall : Double = 0.0
    var age : Int = 0
    @discardableResult
    public func per_name(_ name : String) -> StudentMake{
        self.name = name
        return self
    }
    @discardableResult
    public func per_tall(_ tall : Double) -> StudentMake{
        self.tall = tall
        return self
    }
    @discardableResult
    public func per_age(_ age : Int) -> StudentMake{
        self.age = age
        return self
    }

}


class Student: StudentMake {

    public static func makeStudent(closer : (StudentMake) -> Void) -> Student{
        let maker = StudentMake()
        closer(maker)
        return maker as! Student
    }

}


let s = Student.makeStudent { (stu) in
    stu.per_name("dads")
        .per_tall(123)
        .per_age(18)
        
}
