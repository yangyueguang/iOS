//  TLSettingViewController.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
@class TLSettingItem;
@protocol TLSettingSwitchCellDelegate <NSObject>
@optional
- (void)settingSwitchCellForItem:(TLSettingItem *)settingItem didChangeStatus:(BOOL)on;
@end
@interface TLSettingViewController : UITableViewController <TLSettingSwitchCellDelegate>
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSString *analyzeTitle;
@end
