//  TLTagsViewController.h
//  Freedom
// Created by Super
#import "TLTableViewController.h"
@interface TLTagsViewController : TLTableViewController
@property (nonatomic, strong) NSMutableArray *data;
- (void)registerCellClass;
@end
