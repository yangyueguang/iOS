//  TLFriendSearchViewController.h
//  Freedom
//  Created by Super on 16/1/25.
#import "WXTableViewController.h"
#define     HEIGHT_FRIEND_CELL      54.0f
@interface WXFriendSearchViewController : WXTableViewController <UISearchResultsUpdating>
@property (nonatomic, strong) NSMutableArray *friendsData;
@end
