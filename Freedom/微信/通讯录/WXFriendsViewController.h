//  WXFriendsViewController.h
//  Freedom
// Created by Super
#import "WXTableViewController.h"
#import "WXFriendSearchViewController.h"
#define     HEIGHT_FRIEND_CELL      54.0f
#define     HEIGHT_HEADER           22.0f
#import "WXUserHelper.h"
#import "WXTableViewCell.h"
@interface WXFriendCell : WXTableViewCell
/*用户信息*/
@property (nonatomic, strong) WXUser *user;
@end
@interface WXFriendHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) NSString *title;
@end
@interface WXFriendsViewController : WXTableViewController
@property (nonatomic, weak) NSMutableArray *data;
@property (nonatomic, weak) NSMutableArray *sectionHeaders;
@property (nonatomic, strong) WXFriendSearchViewController *searchVC;
- (void)registerCellClass;
@end
