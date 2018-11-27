//  TLFriendSearchViewController.h
//  Freedom
//  Created by Super on 16/1/25.
#import "TLTableViewController.h"
#define     HEIGHT_FRIEND_CELL      54.0f
@interface TLFriendSearchViewController : TLTableViewController <UISearchResultsUpdating>
@property (nonatomic, strong) NSMutableArray *friendsData;
@end
