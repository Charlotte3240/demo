#include <iostream>
#include "unistd.h"
#include "cxxabi.h"
using namespace std;
#define DAY 7
#define ARR_LEN(array ,length){length = sizeof(array)/sizeof(array[0]);}

void reverseArray(int arr[],int size);
void bubbleSort(int arr [], int size);
int add(int num1,int num2);

#include "const_ptr.h"
#include "arr_ptr.h"

struct Worker{
    int id;
    string name;
};

struct Leader{
    int id;
    string  name;
    Worker w;
};

int main() {

    //输出完整类型名称
    //#include "cxxabi.h"
//    cout << abi::__cxa_demangle(typeid(10/3).name(),0,0,0) << endl;

    //随机数
    // 添加随机种子
//    ::srand((unsigned int) ::time(nullptr));
//    int randNum = rand()%100 +1;
//
//    switch (randNum) {
//        case 1:
//            cout << "1" << endl;
//        default:
//            cout << "other: " <<  randNum << endl;
//    }

    // c++ lamba
//    string  str = "charlotte";
//    std::for_each(str.begin(), str.end(), [&](const auto &item) {
//        cout << item << endl;
//    });

    // 数组
//    int arr[5] = {1,2,3,4,5};
//    cout << sizeof(arr) << endl;
//    cout << "length :" <<sizeof(arr) / sizeof(arr[0]) << endl;
//    int length;
//    ARR_LEN(arr,length);
//    cout << "length:" << length << endl;
//    string str = "charlotte";
//    cout << sizeof(str)  << strlen(str.c_str())<< endl;

    //reverse
//    int length = sizeof(arr)/ sizeof(arr[0]);
//    reverseArray(arr,length);
//    for (int i = 0; i < sizeof(arr)/ sizeof (arr[0]); ++i) {
//        cout << arr[i] << endl;
//    }
    // bubble sort
//    int arr2[10] = {3,2,7,6,23,9,10,89,18,39};
//    int size = sizeof(arr2) / sizeof(arr2[0]);
//    bubbleSort(arr2,size);
//    for (int i = 0; i < size;++i) {
//        cout << arr2[i] << endl;
//    }

    // function
//    int sum = add(1,2);
//    cout << sum << endl;
//    return 0;
//    const_ptr_foo();
//    arr_ptr();
//    int a = 10;
//    int b = 20;
//    HCRes res = swap_hc2(&a,&b);
//    cout << "swaped: r1:" << *res.r1 << " r2:"<< *res.r2 << endl;
//    cout << *res.r1<<endl;
//    cout << *res.r2<<endl;

    Leader leader;
    leader.id = 100;
    leader.name = "leader";

    Worker w;
    w.id = 1000;
    w.name = "worker";

    leader.w = w;

    std::cout << leader.name << " " << leader.w.name << endl;


}




int add(int num1,int num2){
    return  num1 + num2;
}

void foo(const string &chars){
    cout << chars << endl;
}

void reverseArray(int arr[],int size){
    int old = 0;
    int end = size - 1;
    int start = 0;
    while (start < end){
        old = arr[start];
        arr[start] = arr[end];
        arr[end] = old;
        end --;
        start ++;
    }
}

void bubbleSort(int arr [], int size){
    bool isSorted = true;
    for (int i = 0; i < size-1; ++i) {
        if (arr[i] > arr[i+1]){
            int tmp = arr[i];
            arr[i] = arr[i+1];
            arr[i+1] = tmp;
            isSorted = false;
        }
    }
    if (!isSorted){
        bubbleSort(arr,size);
    }
}