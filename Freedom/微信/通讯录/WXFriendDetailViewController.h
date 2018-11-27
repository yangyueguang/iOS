//  TLFriendDetailViewController.h
//  Freedom
// Created by Super
#import "WXInfoViewController.h"
#define     HEIGHT_USER_CELL           90.0f
#define     HEIGHT_ALBUM_CELL          80.0f
#import "WXModes.h"
@protocol WXFriendDetailUserCellDelegate <NSObject>
- (void)friendDetailUserCellDidClickAvatar:(WXInfo *)info;
@end
@interface WechatFriendDetailUserCell : WXTableViewCell
@property (nonatomic, assign) id<WXFriendDetailUserCellDelegate>delegate;
@property (nonatomic, strong) WXInfo *info;
@end
@class WXUser;
@interface WXFriendDetailViewController : WXInfoViewController <WXFriendDetailUserCellDelegate>
- (void)registerCellClass;
@property (nonatomic, strong) WXUser *user;
@end
