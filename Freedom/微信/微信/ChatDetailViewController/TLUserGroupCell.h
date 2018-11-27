//  TLUserGroupCell.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
@class TLUser;
@protocol TLUserGroupCellDelegate <NSObject>
- (void)userGroupCellDidSelectUser:(TLUser *)user;
- (void)userGroupCellAddUserButtonDown;
@end
@interface TLUserGroupCell : UITableViewCell
@property (nonatomic, assign) id<TLUserGroupCellDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *users;
@end
