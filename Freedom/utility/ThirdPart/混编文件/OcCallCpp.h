//
//  OcCallCpp.h
//  OC-Cpp
//
//  Created by wangzhen on 15-1-14.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
#import <Foundation/Foundation.h>
#include "MyCppClass.h"
@interface OcCallCpp : NSObject{
    CMyCppClass *mycppClass;
}
- (void)doSomething;
@end
@interface MyOcClass : NSObject
- (void)doSomething;
@end
