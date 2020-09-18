//
//  Shape.swift
//  TestProject
//
//  Created by Charlotte on 2020/9/17.
//

import Foundation
/// 不透明类型
protocol Shape {
    func draw() -> String
}

fileprivate struct Triangle : Shape {
    
    var size : Int
    
    func draw() -> String {
        var result = [String]()
        for length in 1...size{
            result.append(String.init(repeating: "*", count: length))
        }
        return result.joined(separator: "\n")
        
    }
}


fileprivate struct FlippedShape<T : Shape>: Shape {
    var shape : T
    
    func draw() -> String {
        // MARK: - 将下方invalid方法更改到这里
        if shape is Square {
            return shape.draw()
        }
        
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}


fileprivate struct JoinedShape<T:Shape , U: Shape> : Shape{
    
    var top : T
    
    var bottom : U
    
    func draw() -> String {
        return top.draw() + "\n" + bottom.draw()
    }
}


fileprivate struct Square : Shape{
    var size : Int
    func draw() -> String {
        
        let line = String.init(repeating: "*", count: size)
        let result = Array.init(repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}


extension Shape{
    
    func draw() -> String{""}
    
    func makeTrapezoid() -> some Shape{
        let top = Triangle.init(size: 2)
        let middle = Square.init(size: 2)
        let bottom = FlippedShape.init(shape: top)
        
        let trapezoid = JoinedShape.init(
            top: top,
            bottom: JoinedShape.init(top: middle, bottom: bottom))
        return trapezoid
    }
    
    
    func flip<T: Shape>(_ shape :T) -> some Shape{
        return FlippedShape(shape: shape)
    }
    
    func join<T: Shape, U: Shape>(_ top : T,_ bottom : U) -> some Shape{
        return JoinedShape(top: top, bottom: bottom)
    }
    
    
}


struct Demo : Shape{
    func foo(){
        let triangle = Triangle.init(size: 5)
//        print(triangle.draw())
        
//        let flipTriangle = FlippedShape.init(shape: triangle)
//        print(flipTriangle.draw())
        
        let flipTriangle = flip(triangle)
        
        let joinedShape = join(triangle, flipTriangle)
        
//        let joinedShape = JoinedShape.init(top: triangle, bottom: flipTriangle)
        print(joinedShape.draw())
        
        print(invalidFlip(joinedShape))
        
        
        let protoFlipTriangle = protoFlip(triangle)
        let sameThing = protoFlip(triangle)
        
        //Binary operator '==' cannot be applied to two 'Shape' operands
//        print(protoFlipTriangle == sameThing)
        /// 不透明类型保留了底层类型的唯一性
        
        print(type(of: sameThing) == type(of: protoFlipTriangle))
        
        
    }
    
    func opaqueTypeCall(){

        let trapezoid = self.makeTrapezoid()

        print(trapezoid.draw())

    }
    
//    // opaque type 不透明返回类型 错误示范
//  违反了不透明类型只能返回一种类型的定义
//   这里有可能返回square类型 或者  flippedshape 类型
//    只能返回一种
//    func invalidFlip<T: Shape>(_ shape: T) -> some Shape {
//        if shape is Triangle {
//            return shape // 错误：返回类型不一致
//        }
//        return FlippedShape(shape: shape) // 错误：返回类型不一致
//    }
    
    
    /// 这样改  无论shape 是什么类型的 ，最终都会返回输入的类型 是不是三角形  都返回自己本身
//    func invalidFlip<T: Shape>(_ shape: T) -> some Shape {
//        if shape is Triangle {
//            return shape
//        }
//        return shape
//    }
    
    /// 或者将判断放到FlippedShape中 直接返回filppedshape
    func invalidFlip<T: Shape>(_ shape: T) -> some Shape {
        return FlippedShape(shape: shape)
    }
    
    func `repeat`<T :Shape>(shape :T , count : Int) -> some Collection{
        return Array<T>(repeating: shape, count: count)
    }

    ///不使用 不透明类型 直接返回协议类型
    func protoFlip<T : Shape>(_ shape : T) -> Shape{
        if shape is Square{
            return shape
        }
        return FlippedShape(shape: shape)
    }
    
}


protocol Container {
    associatedtype Item
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
extension Array: Container {
    
    /*
    func makeProtocolContainer<T>(item : T) -> Container{
        //Protocol 'Container' can only be used as a generic constraint because it has Self or associated type requirements
        return [item]
    }
    
    
    //Cannot convert return expression of type '[T]' to return type 'C'
    func makeProtocolContainer<T,C:Container>(item :T) -> C{
        return [item]
    }
     */
    
    func makeOpaqueContainer<T>(item : T) -> some Container{
        return [item]
    }
    
    
    func foo(){
        let opaqueContainer = makeOpaqueContainer(item: 12)
        let sameContainer = makeOpaqueContainer(item: 13)

        print(opaqueContainer[0])
        print(type(of: opaqueContainer[0]) == type(of: sameContainer[0]))
        
        
    }
    
}


