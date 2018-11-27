//  TLMenuViewController.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#import "WXModes.h"
@interface WXMenuCell : UITableViewCell
@property (nonatomic, strong) WXMenuItem *menuItem;
@end
@interface WXMenuViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSString *analyzeTitle;
@end
