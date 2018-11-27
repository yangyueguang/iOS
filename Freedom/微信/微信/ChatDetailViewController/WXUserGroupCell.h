//  TLUserGroupCell.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
@class WXUser;
@protocol WechatUserGroupCellDelegate <NSObject>
- (void)userGroupCellDidSelectUser:(WXUser *)user;
- (void)userGroupCellAddUserButtonDown;
@end
@interface WXUserGroupCell : UITableViewCell
@property (nonatomic, assign) id<WechatUserGroupCellDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *users;
@end
