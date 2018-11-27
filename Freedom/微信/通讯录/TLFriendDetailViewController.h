//  TLFriendDetailViewController.h
//  Freedom
// Created by Super
#import "TLInfoViewController.h"
#define     HEIGHT_USER_CELL           90.0f
#define     HEIGHT_ALBUM_CELL          80.0f
#import "WechartModes.h"
@protocol TLFriendDetailUserCellDelegate <NSObject>
- (void)friendDetailUserCellDidClickAvatar:(TLInfo *)info;
@end
@interface TLFriendDetailUserCell : TLTableViewCell
@property (nonatomic, assign) id<TLFriendDetailUserCellDelegate>delegate;
@property (nonatomic, strong) TLInfo *info;
@end
@class TLUser;
@interface TLFriendDetailViewController : TLInfoViewController <TLFriendDetailUserCellDelegate>
- (void)registerCellClass;
@property (nonatomic, strong) TLUser *user;
@end
