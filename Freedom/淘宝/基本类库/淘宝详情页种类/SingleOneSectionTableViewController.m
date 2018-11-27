//  SingleOneSectionTableViewController.m
//  Freedom
//  Created by Micker on 16/4/13.
#import "SingleOneSectionTableViewController.h"
@implementation SingleOneSectionTableViewController
- (void) dealloc {
    DLog(@"SingleOneSectionTableViewController.h dealloc");
}
//仅返回1
- (NSUInteger ) numberOfSections {
    return 1;
}
@end
