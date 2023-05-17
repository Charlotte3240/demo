//
// Created by 360-jr on 2023/3/20.
//

#include <iostream>
#include "const_ptr.h"
using namespace std;

void const_ptr_foo(){
    int a = 10;
    int b = 20;
    // 常量指针, 可以更改指向地址，不能更改指向的内容
    const int* p = &a;
//    *p = 20; // 更改指向的值会报错 error: read-only variable is not assignable
    p = &b; // 更改指向是可以的
    cout << *p << endl;

    // 指针常量, 不可以更改指向地址，可以更改指向的内容
    int * const cp  = &a;
    *cp = 30; // 可以更改指向的内容
//    cp = &b; // 不可以更改指向的地址,  variable 'cp' declared const here
    cout << *cp << endl;

    // const 既修饰指针，又修饰常量
    const int* const ccp = &a;
//    ccp = &b; // 不可以更改指向
//    ccp = 30; // 不可以更改指向内容
    cout << *ccp << endl;


}

void swap_hc(int * const p1,  int* const p2){
    int tmp = *p1;
    *p1 = *p2;
    *p2 = tmp;
}
HCRes swap_hc2(const int *  p1, const  int*  p2){
    auto res =  HCRes{};
    res.r1 = p2;
    res.r2 = p1;


    return res;
}
