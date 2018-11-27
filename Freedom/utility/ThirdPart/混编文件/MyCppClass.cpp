//
//  MyCppClass.cpp
//  OC-Cpp
//
//  Created by wangzhen on 15-1-14.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
#include "MyCppClass.h"
#include "OC-CppInterface.h"
CMyCppClass::CMyCppClass(){
    printf("CMyCppClass::CMyCppClass() call OcInit\n");
    pOc = OcInit();
    return;
}
CMyCppClass::~CMyCppClass(){
    printf("CMyCppClass::~CMyCppClass() call OcRelease\n");
    if (pOc != NULL) {
        OcRelease(pOc);
        //delete pOc;
        pOc = NULL;
    }
    return;
}
void CMyCppClass::ExampleMethod(){
    printf("void CMyCppClass::ExampleMethod() call OcDosomthing\n");
    if (pOc) {
        OcDosomething(pOc);
    }
    return;
}
