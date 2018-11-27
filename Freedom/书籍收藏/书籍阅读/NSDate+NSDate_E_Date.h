//
//  Freedom
//  Created by Super on 15/3/3.
#import <Foundation/Foundation.h>
@interface NSDate (NSDate_E_Date)
/*
 是否是今天*/
- (BOOL)isToday;
/*
 时间差*/
- (NSInteger) minutesAfterDate : (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
@end
