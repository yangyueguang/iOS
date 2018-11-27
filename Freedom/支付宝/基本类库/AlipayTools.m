//  AlipayTools.m
//  Created by Super on 16/8/24.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "AlipayTools.h"
@implementation AlipayTools
#define kItemsArrayCacheKey @"AlipayHomeIconsCacheKey"
+ (NSArray *)itemsArray{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kItemsArrayCacheKey];
}
+ (void)saveItemsArray:(NSArray *)array{
    [[NSUserDefaults standardUserDefaults] setObject:[array copy] forKey:kItemsArrayCacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
