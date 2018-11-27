//  TLGroupViewController.h
//  Freedom
// Created by Super
#import "WXTableViewController.h"
#import "WXUserHelper.h"
#import "WXTableViewCell.h"
@interface WXGroupSearchViewController : WXTableViewController <UISearchResultsUpdating, UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *groupData;
@end
@interface WXGroupCell : WXTableViewCell
@property (nonatomic, strong) WXGroup *group;
@end
@interface WXGroupViewController : WXTableViewController
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) WXGroupSearchViewController *searchVC;
- (void)registerCellClass;
@end
