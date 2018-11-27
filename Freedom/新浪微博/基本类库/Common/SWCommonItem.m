//  HMCommonItem.m
//  Created by Super on 14-7-21.
#import "SWCommonItem.h"
@implementation SWCommonItem
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon{
    SWCommonItem *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}
+ (instancetype)itemWithTitle:(NSString *)title{
    return [self itemWithTitle:title icon:nil];
}
@end
