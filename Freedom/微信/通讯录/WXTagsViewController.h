//  TLTagsViewController.h
//  Freedom
// Created by Super
#import "WXTableViewController.h"
@interface WXTagsViewController : WXTableViewController
@property (nonatomic, strong) NSMutableArray *data;
- (void)registerCellClass;
@end
