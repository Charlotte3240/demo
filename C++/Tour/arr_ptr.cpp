//
// Created by 360-jr on 2023/3/20.
//

#include "arr_ptr.h"
#include "iostream"
using namespace std;
void arr_ptr(){
    int array[10] = {234,123,55,23,566,32432,65465,1232,3432,12321};

    int *p = array; // 这里不需要取地址，数组变量就是首地址
    for (int i = 0; i < sizeof(array)/ sizeof(array[0]); ++i) {
        cout << "value: " << *p << endl;
        p ++;
    }
}

