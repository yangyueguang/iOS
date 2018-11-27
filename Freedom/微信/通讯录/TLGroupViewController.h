//  TLGroupViewController.h
//  Freedom
// Created by Super
#import "TLTableViewController.h"
#import "TLUserHelper.h"
#import "TLTableViewCell.h"
@interface TLGroupSearchViewController : TLTableViewController <UISearchResultsUpdating, UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *groupData;
@end
@interface TLGroupCell : TLTableViewCell
@property (nonatomic, strong) TLGroup *group;
@end
@interface TLGroupViewController : TLTableViewController
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) TLGroupSearchViewController *searchVC;
- (void)registerCellClass;
@end
