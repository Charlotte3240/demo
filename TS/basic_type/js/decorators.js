"use strict";
// 装饰器
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
// 1. 类装饰器      Class Decorator
// 2. 方法装饰器    Method Decorator
// 3. 属性装饰器    Property Decorator
// 4. 参数装饰器    Parameter Decorator
const MoveDecorator = (constructor) => {
    // 先执行装饰器，再执行其他方法
    console.log('类装饰器');
};
let Tank = class Tank {
    constructor() {
        console.log('class constructor');
    }
};
Tank = __decorate([
    MoveDecorator,
    __metadata("design:paramtypes", [])
], Tank);
let t = new Tank();
