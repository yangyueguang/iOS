//  NSDate+NSDate_E_Date.m
//  Freedom
//  Created by Super on 15/3/3.
#import "NSDate+NSDate_E_Date.h"
@implementation NSDate (NSDate_E_Date)
- (BOOL) isToday{
    
    return [self isEqualToDateTime:[NSDate date]];
}
- (BOOL) isEqualToDateTime: (NSDate *) aDate{
    
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal) fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal) fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}
- (NSInteger) minutesAfterDate: (NSDate *) aDate{
    
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / 60);
}
- (NSInteger) minutesBeforeDate: (NSDate *) aDate{
    
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / 60);
}
@end
