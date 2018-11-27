//  TLNewFriendViewController.h
//  Freedom
// Created by Super
#import "WXTableViewController.h"
@protocol WXAddThirdPartFriendCellDelegate <NSObject>
- (void)addThirdPartFriendCellDidSelectedType:(NSString *)thirdPartFriendType;
@end
@interface WXNewFriendViewController : WXTableViewController<UISearchBarDelegate, WXAddThirdPartFriendCellDelegate>
- (void)registerCellClass;
@end
