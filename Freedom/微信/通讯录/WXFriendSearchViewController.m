//  TLFriendSearchViewController.m
//  Freedom
//  Created by Super on 16/1/25.
#import "WXFriendSearchViewController.h"
#import "WXFriendsViewController.h"
@interface WXFriendSearchViewController ()
@property (nonatomic, strong) NSMutableArray *data;
@end
@implementation WXFriendSearchViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.data = [[NSMutableArray alloc] init];;
    [self.tableView registerClass:[WXFriendCell class] forCellReuseIdentifier:@"FriendCell"];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.frameY = HEIGHT_NAVBAR + NavY;
    self.tableView.frameHeight = APPH - self.tableView.frameY;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"联系人";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    
    WXUser *user = [self.data objectAtIndex:indexPath.row];
    [cell setUser:user];
    [cell setTopLineStyle:(indexPath.row == 0 ? TLCellLineStyleFill : TLCellLineStyleNone)];
    [cell setBottomLineStyle:(indexPath.row == self.data.count - 1 ? TLCellLineStyleFill : TLCellLineStyleDefault)];
    return cell;
}
#pragma mark - Delegate -
//MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_FRIEND_CELL;
}
//MARK: UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = [searchController.searchBar.text lowercaseString];
    [self.data removeAllObjects];
    for (WXUser *user in self.friendsData) {
        if ([user.remarkName containsString:searchText] || [user.username containsString:searchText] || [user.nikeName containsString:searchText] || [user.pinyin containsString:searchText] || [user.pinyinInitial containsString:searchText]) {
            [self.data addObject:user];
        }
    }
    [self.tableView reloadData];
}
@end
