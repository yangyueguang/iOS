//  TLGroupViewController.m
//  Freedom
// Created by Super
#import "WXGroupViewController.h"
#import "WXSearchController.h"
#import "WXUserHelper.h"
#import "WXChatViewController.h"
#import "WXRootViewController.h"
#import "NSFileManager+expanded.h"
#define     FRIENDS_SPACE_X         10.0f
#define     FRIENDS_SPACE_Y         9.5f
@interface WXGroupCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@end
@implementation WXGroupCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftSeparatorSpace = FRIENDS_SPACE_X;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.usernameLabel];
        
        [self p_addMasonry];
    }
    return self;
}
- (void) setGroup:(WXGroup *)group{
    _group = group;
    NSString *path = [NSFileManager pathUserAvatar:group.groupAvatarPath];
    UIImage *image = [UIImage imageNamed:path];
    if (image == nil) {
        image = [UIImage imageNamed:PuserLogo];
    }
    [self.avatarImageView setImage:image];
    [self.usernameLabel setText:group.groupName];
}
#pragma mark - Private Methods -
- (void) p_addMasonry{
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(FRIENDS_SPACE_X);
        make.top.mas_equalTo(FRIENDS_SPACE_Y);
        make.bottom.mas_equalTo(- FRIENDS_SPACE_Y + 0.5);
        make.width.mas_equalTo(self.avatarImageView.mas_height);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(FRIENDS_SPACE_X);
        make.centerY.mas_equalTo(self.avatarImageView);
        make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-20);
    }];
}
#pragma mark - Getter
- (UIImageView *) avatarImageView{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
    }
    return _avatarImageView;
}
- (UILabel *) usernameLabel{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        [_usernameLabel setFont:[UIFont systemFontOfSize:17.0f]];
    }
    return _usernameLabel;
}
@end
@interface WXGroupViewController () <UISearchBarDelegate>
@property (nonatomic, strong) WXSearchController *searchController;
@end
@implementation WXGroupViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"群聊"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    
    [self registerCellClass];
    
    self.data = [WXFriendHelper sharedFriendHelper].groupsData;
}
#pragma mark - Getter -
- (WXSearchController *)searchController{
    if (_searchController == nil) {
        _searchController = [[WXSearchController alloc] initWithSearchResultsController:self.searchVC];
        [_searchController setSearchResultsUpdater:self.searchVC];
        [_searchController.searchBar setPlaceholder:@"搜索"];
        [_searchController.searchBar setDelegate:self];
    }
    return _searchController;
}
- (WXGroupSearchViewController *)searchVC{
    if (_searchVC == nil) {
        _searchVC = [[WXGroupSearchViewController alloc] init];
    }
    return _searchVC;
}
#pragma mark - Public Methods -
- (void)registerCellClass{
    [self.tableView registerClass:[WXGroupCell class] forCellReuseIdentifier:@"TLGroupCell"];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXGroup *group = self.data[indexPath.row];
    WXGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLGroupCell"];
    [cell setGroup:group];
    [cell setBottomLineStyle:(indexPath.row == self.data.count - 1 ? TLCellLineStyleFill : TLCellLineStyleDefault)];
    return cell;
}
//MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXGroup *group = [self.data objectAtIndex:indexPath.row];
    WXChatViewController *chatVC = [WXChatViewController sharedChatVC];
    [chatVC setPartner:group];
    UIViewController *vc = [[WXRootViewController sharedRootViewController] childViewControllerAtIndex:0];
    [[WXRootViewController sharedRootViewController] setSelectedIndex:0];
    [vc setHidesBottomBarWhenPushed:YES];
    [vc.navigationController pushViewController:chatVC animated:YES completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [vc setHidesBottomBarWhenPushed:NO];
}
//MARK: UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.searchVC setGroupData:self.data];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
}
@end
@interface WXGroupSearchViewController ()
@property (nonatomic, strong) NSMutableArray *data;
@end
@implementation WXGroupSearchViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.data = [[NSMutableArray alloc] init];;
    [self.tableView registerClass:[WXGroupCell class] forCellReuseIdentifier:@"TLGroupCell"];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLGroupCell"];
    
    WXGroup *group = [self.data objectAtIndex:indexPath.row];
    [cell setGroup:group];
    return cell;
}
#pragma mark - Delegate -
//MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}
//MARK: UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = [searchController.searchBar.text lowercaseString];
    [self.data removeAllObjects];
    for (WXGroup *group in self.groupData) {
        if ([group.groupName containsString:searchText] || [group.pinyin containsString:searchText] || [group.pinyinInitial containsString:searchText]) {
            [self.data addObject:group];
        }
    }
    [self.tableView reloadData];
}
@end
