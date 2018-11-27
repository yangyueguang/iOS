//  TLSettingViewController.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
@class WXSettingItem;
@protocol WXSettingSwitchCellDelegate <NSObject>
@optional
- (void)settingSwitchCellForItem:(WXSettingItem *)settingItem didChangeStatus:(BOOL)on;
@end
@interface WXSettingViewController : UITableViewController <WXSettingSwitchCellDelegate>
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSString *analyzeTitle;
@end
