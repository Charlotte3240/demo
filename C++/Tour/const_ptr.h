//
// Created by Charlotte on 2023/3/20.
//

#ifndef TOUR_CONST_PTR_H
#define TOUR_CONST_PTR_H

struct HCRes{
    const int *r1;
    const int *r2;
};


void const_ptr_foo();
void swap_hc(int * const p1,  int* const p2);
HCRes swap_hc2(const int *  p1, const  int*  p2);

#endif //TOUR_CONST_PTR_H
