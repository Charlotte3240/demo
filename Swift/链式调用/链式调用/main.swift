//
//  main.swift
//  链式调用
//
//  Created by Charlotte on 2020/9/8.
//

import Foundation

print("Hello, World!")

let stu = Student()
stu.per_name("name").per_tall(180)

print(stu.name,stu.tall)


let stu2 = Student.makeStudent { (stu) in
    stu.per_name("dads")
        .per_tall(123)
        .per_age(18)
        
}
