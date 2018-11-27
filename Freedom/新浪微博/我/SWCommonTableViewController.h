//  SWCommonViewController.h
//  Freedom
//  Created by apple on 15-3-18.
//  Copyright (c) 2015年 xc. All rights reserved.
//  抽取公共方法:只是模型数据改变
//
#import <UIKit/UIKit.h>
#import "SWCommonItem.h"
@interface SWCommonLabelItem : SWCommonItem
/** 右边label显示的内容 */
@property (nonatomic, copy) NSString *text;
@end
@interface SWCommonArrowItem : SWCommonItem
@end
@interface SWCommonGroup : NSObject
/** 组头 */
@property (nonatomic, copy) NSString *header;
/** 组尾 */
@property (nonatomic, copy) NSString *footer;
/** 这组的所有行模型(数组中存放的都是HMCommonItem模型) */
@property (nonatomic, strong) NSArray *items;
+ (instancetype)group;
@end
@interface SWCommonTableViewController : UITableViewController
- (NSMutableArray *)groups;
@end
