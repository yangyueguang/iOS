//  TLInfoViewController.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#import "TLTableViewCell.h"
#import "WechartModes.h"
@protocol TLInfoButtonCellDelegate <NSObject>
- (void)infoButtonCellClicked:(TLInfo *)info;
@end
@interface TLInfoButtonCell : TLTableViewCell
@property (nonatomic, assign) id<TLInfoButtonCellDelegate>delegate;
@property (nonatomic, strong) TLInfo *info;
@end
@interface TLInfoCell : TLTableViewCell
@property (nonatomic, strong) TLInfo *info;
@end
@interface TLInfoHeaderFooterView : UITableViewHeaderFooterView
@end
@interface TLInfoViewController : UITableViewController <TLInfoButtonCellDelegate>
@property (nonatomic, strong) NSMutableArray *data;
@end
