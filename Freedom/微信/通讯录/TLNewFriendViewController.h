//  TLNewFriendViewController.h
//  Freedom
// Created by Super
#import "TLTableViewController.h"
@protocol TLAddThirdPartFriendCellDelegate <NSObject>
- (void)addThirdPartFriendCellDidSelectedType:(NSString *)thirdPartFriendType;
@end
@interface TLNewFriendViewController : TLTableViewController<UISearchBarDelegate, TLAddThirdPartFriendCellDelegate>
- (void)registerCellClass;
@end
