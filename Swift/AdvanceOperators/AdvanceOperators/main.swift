//
//  main.swift
//  AdvanceOperators
//
//  Created by Charlotte on 2020/9/23.
//

import Foundation

// MARK: - 溢出运算符
/*
 溢出加法 &+
 溢出减法 &-
 溢出乘法 &*
 */

var int8V : Int8 = 0

int8V = Int8.max &+ 1
print(int8V)
int8V = int8V &- 1
print(int8V)

// MARK: - 按位取反 运算符

let initialBits : UInt8 = 0b00001111
let invertedBits = ~initialBits
print(invertedBits)

// MARK: - 按位与  运算符

let firstSixBits :UInt8 = 0b11111100
let lasSixBits :UInt8 =   0b00111111
//                        0b00111100
let result = firstSixBits&lasSixBits
print(result)

// MARK: - 按位或  运算符

let someBits :UInt8 = 0b10110010
let moreBits :UInt8 = 0b01011110
//                    0b11111110
let res = someBits | moreBits
print(res)

// MARK: - 按位异或 运算符

let firstBits :UInt8 = 0b00100100
let otherBits :UInt8 = 0b00000101
//                     0b00100001
print(firstBits ^ otherBits)

// MARK: - 无符号位移运算  逻辑移位
let shiftBits: UInt8 = 4 // 即二进制的 00000100
print(shiftBits << 1)           // 00001000
print(shiftBits << 2)           // 00010000
print(shiftBits << 5)           // 10000000
print(shiftBits << 6)           // 00000000
print(shiftBits >> 2)           // 00000001


let pink: UInt32 = 0xCC6699
let redComponent = (pink & 0xFF0000) >> 16  // redComponent 是 0xCC，即 204
print(redComponent)
let greenComponent = (pink & 0x00FF00) >> 8 // greenComponent 是 0x66， 即 102
print(greenComponent)
let blueComponent = pink & 0x0000FF         // blueComponent 是 0x99，即 153
print(blueComponent)

// MARK: - 有符号位移运算  算术移位
/// 右移时 填充为为 符号位

// MARK: - 运算符函数

struct Vector2D {
    var x :Double = 0
    var y :Double = 0
    
}
extension Vector2D{
    static func + (left :Vector2D, right :Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
}
let vector = Vector2D(x: 3.0, y: 1.0)
let anotherVector = Vector2D(x: 2.0, y: 4.0)
let combinedVector = vector + anotherVector

print(combinedVector)

// MARK: - 前缀和后缀运算符

precedencegroup InFixGroup{
//    higherThan: AdditionPrecedence 优先级比加法运算高
//    lowerThan
    //结合方向左边
//    associativity:left
    // true 赋值运算符 false非赋值运算符
//    assignment : false
}
//Only infix operators may declare a precedence
infix operator ^^ : InFixGroup

postfix operator ~ :
extension Vector2D{
    // 前缀运算符 要加上 prefix
    static prefix func - (vector :Vector2D) -> Vector2D{
        return Vector2D(x: -vector.x, y: -vector.y)
    }
    // 后缀运算符 需要加上postfix 并且还要增加优先级组
    static postfix func ~ (vector :Vector2D) -> Vector2D{
        return Vector2D(x: vector.x+1, y: vector.y+1)
    }
    // 中置运算符
    // 这里求平均值 'infix' modifier is not required or allowed on func declarations
    static func ^^ (left :Vector2D, right :Vector2D) ->Vector2D{
        // 中置 直接声明为方法就可以 上面加入优先级组
        return Vector2D(x: (left.x + right.x)/2, y: (left.y + right.y)/2)
    }
    
}
print(-combinedVector)
print(vector^^anotherVector)


// MARK: - 复合赋值运算符
extension Vector2D{
    static func += (_ left :inout Vector2D , _ right :Vector2D){
        left = left + right
    }
}


var original = Vector2D(x: 1.0, y: 2.0)

var valueToAdd = Vector2D(x: 3.0, y: 4.0)

original += valueToAdd

print(original)

// MARK: - 等价运算符

extension Vector2D : Equatable{
    static func == (left : Vector2D, right : Vector2D) -> Bool{
        return (left.x == right.x && left.y == right.y)
    }
}

let twoThree = Vector2D(x: 2.0, y: 3.0)
let anotherTwoThree = Vector2D(x: 2.0, y: 3.0)
if twoThree == anotherTwoThree {
    print("These two vectors are equivalent.")
}else{
    print("not equal")
}
if twoThree != anotherTwoThree {
    print("not equal")
}else{
    print("These two vectors are equivalent.")
}

struct Vector3D : Equatable {
    
    var x  = 0.0,y = 0.0 ,z = 0.0
}

let vector3d1 = Vector3D(x: 0, y: 1, z: 2)
let vector3d2 = Vector3D(x: 0, y: 1, z: 12)
print(vector3d1 == vector3d2)

// MARK: - 自定义运算符

prefix operator +++
extension Vector2D {
    static prefix func +++ (vector : inout Vector2D) -> Vector2D{
        return vector + vector
    }
}

var toBeDoubled = Vector2D(x: 1.0, y: 4.0)
let afterDoubling = +++toBeDoubled
print(afterDoubling)


infix operator +- : AdditionPrecedence
extension Vector2D{
    static func +- (left : Vector2D , right : Vector2D) -> Vector2D{
        return Vector2D(x: left.x + right.x , y: left.x - right.x)
    }
}
let firstVector = Vector2D(x: 1.0, y: 2.0)
let secondVector = Vector2D(x: 3.0, y: 4.0)

print(firstVector +- secondVector)
