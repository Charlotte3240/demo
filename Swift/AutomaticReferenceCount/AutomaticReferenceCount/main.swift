//
//  main.swift
//  AutomaticReferenceCount
//
//  Created by Charlotte on 2020/9/21.
//

import Foundation

//var reference1 : Person?
//var reference2 : Person?
//var reference3 : Person?
//
//reference1 = Person(name: "John Appleseed")
//
//reference2 = reference1
//reference3 = reference1
//
//
//reference1 = nil
//reference2 = nil
//
//reference3 = nil

//---
/// 两个值都可以为nil时  适合使用弱引用
//var john : Person?
//var unit4A : Apartment?
//
//john = Person(name: "john apartment")
//unit4A = Apartment(unit: "4A")
//
//john?.apartment = unit4A
//unit4A?.tenant = john
//
//john = nil
//
/////当 ARC 设置弱引用为 nil 时，属性观察不会被触发。
//
//unit4A = nil

//---
/// 无主引用通常都期望拥有值，不过ARC  无法在实例被销毁后将无主引用置为nil ，因为非可选类型的变量不允许赋值为nil

/// 两个实例 其中一个一定要有值时 适合使用无主引用 unown
//var john : Customer?
//john = Customer(name: "john")
//
//john!.card = CreditCard(num: 1234_567_7879, customer: john!)
//
//john = nil
//
//print(john?.card)

/// 非可选类型的变量不允许赋值为nil
///'nil' cannot be assigned to type 'String'
//var test : String
//test = "123"
//test = nil



//var p : Person?
//
//p = Person(name: "avicii")
//let head = Head(detail: "circle", owner: p!)
//p!.head = head
//p!.apartment = Apartment(unit: "715-120")
//p = nil
//
//print(p?.head)

//let country = Country(name: "China", captialName: "beijing")
//
//print("country \(country.name)  captialCity \(country.captialCity.name)")



var html : HtmlElement? = HtmlElement(name: "div", text: "div text")

print(html!.asHTML())

html = nil
