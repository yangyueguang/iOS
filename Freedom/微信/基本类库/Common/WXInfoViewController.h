//  TLInfoViewController.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#import "WXTableViewCell.h"
#import "WXModes.h"
#import "WXBaseViewController.h"
@protocol WXInfoButtonCellDelegate <NSObject>
- (void)infoButtonCellClicked:(WXInfo *)info;
@end
@interface WXInfoButtonCell : WXTableViewCell
@property (nonatomic, assign) id<WXInfoButtonCellDelegate>delegate;
@property (nonatomic, strong) WXInfo *info;
@end
@interface WXInfoCell : WXTableViewCell
@property (nonatomic, strong) WXInfo *info;
@end
@interface WXInfoHeaderFooterView : UITableViewHeaderFooterView
@end
@interface WXInfoViewController : UITableViewController <WXInfoButtonCellDelegate>
@property (nonatomic, strong) NSMutableArray *data;
@end
