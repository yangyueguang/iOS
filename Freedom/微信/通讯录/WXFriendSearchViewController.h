//  TLFriendSearchViewController.h
//  Freedom
//  Created by Super on 16/1/25.
#import "WXTableViewController.h"
@interface WXFriendSearchViewController : WXTableViewController <UISearchResultsUpdating>
@property (nonatomic, strong) NSMutableArray *friendsData;
@end
