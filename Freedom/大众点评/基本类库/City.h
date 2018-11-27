//  City.h
//  XTuan
//  Created by Super on 15/8/15.
//  Copyright (c) 2015年 Super. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
@interface BaseModel : NSObject
//组名
@property(nonatomic, copy)NSString *name;
@end
@interface City : BaseModel
//分区
@property(nonatomic, strong)NSArray *districts;
@property(nonatomic, assign)BOOL hot;
@property(nonatomic, assign)CLLocationCoordinate2D position;
@end
