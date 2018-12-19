//  WXFriendsViewController.m
//  Freedom
// Created by Super
#import "WXFriendsViewController.h"
#import "WXSearchController.h"
#import "WXAddFriendViewController.h"
#import "WXUserHelper.h"
#import "WXNewFriendViewController.h"
#import "WXGroupViewController.h"
#import "WXTagsViewController.h"
#import "WXPublicServerViewController.h"
#import "WXFriendDetailViewController.h"
@interface WXFriendCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end
@implementation WXFriendCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftSeparatorSpace = 10;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.subTitleLabel];
        
        [self p_addMasonry];
    }
    return self;
}
#pragma mark - Public Methods
- (void)setUser:(WXUser *)user{
    _user = user;
    if (user.avatarPath) {
        [self.avatarImageView setImage:[UIImage imageNamed:user.avatarPath]];
    }else{
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarURL] placeholderImage:[UIImage imageNamed:PuserLogo]];
    }
    
    [self.usernameLabel setText:user.showName];
    [self.subTitleLabel setText:user.detailInfo.remarkInfo];
    if (user.detailInfo.remarkInfo.length > 0 && self.subTitleLabel.isHidden) {
        [self.subTitleLabel setHidden:NO];
        [self.usernameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.avatarImageView).mas_offset(-9.5);
        }];
    }else if (user.detailInfo.remarkInfo.length == 0 && !self.subTitleLabel.isHidden){
        [self.usernameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.avatarImageView);
        }];
    }
}
#pragma mark - Prvate Methods -
- (void)p_addMasonry{
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(9);
        make.bottom.mas_equalTo(- 9 + 0.5);
        make.width.mas_equalTo(self.avatarImageView.mas_height);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.avatarImageView);
        make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-20);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.usernameLabel);
        make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(2);
        make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-20);
    }];
}
#pragma mark - Getter
- (UIImageView *)avatarImageView{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
    }
    return _avatarImageView;
}
- (UILabel *)usernameLabel{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        [_usernameLabel setFont:[UIFont systemFontOfSize:17.0f]];
    }
    return _usernameLabel;
}
- (UILabel *)subTitleLabel{
    if (_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc] init];
        [_subTitleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_subTitleLabel setTextColor:[UIColor grayColor]];
        [_subTitleLabel setHidden:YES];
    }
    return _subTitleLabel;
}
@end
@interface WXFriendHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation WXFriendHeaderView
- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIView *bgView = [UIView new];
        [bgView setBackgroundColor:[UIColor lightGrayColor]];
        [self setBackgroundView:bgView];
        [self addSubview:self.titleLabel];
    }
    return self;
}
- (void) layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel setFrame:CGRectMake(10, 0, self.frame.size.width - 15, self.frame.size.height)];
}
- (void) setTitle:(NSString *)title{
    _title = title;
    [_titleLabel setText:title];
}
- (UILabel *) titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.5f]];
        [_titleLabel setTextColor:[UIColor grayColor]];
    }
    return _titleLabel;
}
@end
@interface WXFriendsViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, strong) WXFriendHelper *friendHelper;
@property (nonatomic, strong) WXSearchController *searchController;
@end
@implementation WXFriendsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"通讯录"];
    
    [self p_initUI];        // 初始化界面UI
    [self registerCellClass];
    
    self.friendHelper = [WXFriendHelper sharedFriendHelper];      // 初始化好友数据业务类
    self.data = self.friendHelper.data;
    self.sectionHeaders = self.friendHelper.sectionHeaders;
    [self.footerLabel setText:[NSString stringWithFormat:@"%ld位联系人", (long)self.friendHelper.friendCount]];
    
    __weak typeof(self) weakSelf = self;
    [self.friendHelper setDataChangedBlock:^(NSMutableArray *data, NSMutableArray *headers, NSInteger friendCount) {
        weakSelf.data = data;
        weakSelf.sectionHeaders = headers;
        [weakSelf.footerLabel setText:[NSString stringWithFormat:@"%ld位联系人", (long)friendCount]];
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark - Event Response -
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
    WXAddFriendViewController *addFriendVC = [[WXAddFriendViewController alloc] init];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:addFriendVC animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}
#pragma mark - Private Methods -
- (void)p_initUI{
    [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.tableView setSeparatorColor:[UIColor grayColor]];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:UIColor(46.0, 49.0, 50.0, 1.0)];
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    
    [self.tableView setTableFooterView:self.footerLabel];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add_friend"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}
#pragma mark - Getter -
- (WXSearchController *)searchController{
    if (_searchController == nil) {
        _searchController = [[WXSearchController alloc] initWithSearchResultsController:self.searchVC];
        [_searchController setSearchResultsUpdater:self.searchVC];
        [_searchController.searchBar setPlaceholder:@"搜索"];
        [_searchController.searchBar setDelegate:self];
        [_searchController setShowVoiceButton:YES];
    }
    return _searchController;
}
- (WXFriendSearchViewController *)searchVC{
    if (_searchVC == nil) {
        _searchVC = [[WXFriendSearchViewController alloc] init];
    }
    return _searchVC;
}
- (UILabel *)footerLabel{
    if (_footerLabel == nil) {
        _footerLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APPW, 50.0f)];
        [_footerLabel setTextAlignment:NSTextAlignmentCenter];
        [_footerLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_footerLabel setTextColor:[UIColor grayColor]];
    }
    return _footerLabel;
}
#pragma mark - Public Methods -
- (void)registerCellClass{
    [self.tableView registerClass:[WXFriendHeaderView class] forHeaderFooterViewReuseIdentifier:@"TLFriendHeaderView"];
    [self.tableView registerClass:[WXFriendCell class] forCellReuseIdentifier:@"TLFriendCell"];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    WXUserGroup *group = [self.data objectAtIndex:section];
    return group.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    WXUserGroup *group = [self.data objectAtIndex:section];
    WXFriendHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TLFriendHeaderView"];
    [view setTitle:group.groupName];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLFriendCell"];
    WXUserGroup *group = [self.data objectAtIndex:indexPath.section];
    WXUser *user = [group objectAtIndex:indexPath.row];
    [cell setUser:user];
    
    if (indexPath.section == self.data.count - 1 && indexPath.row == group.count - 1){  // 最后一个cell，底部全线
        [cell setBottomLineStyle:TLCellLineStyleFill];
    }else{
        [cell setBottomLineStyle:indexPath.row == group.count - 1 ? TLCellLineStyleNone : TLCellLineStyleDefault];
    }
    
    return cell;
}
// 拼音首字母检索
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionHeaders;
}
// 检索时空出搜索框
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if(index == 0) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height) animated:NO];
        return -1;
    }
    return index;
}
//MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 22;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUser *user = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 0) {
        if ([user.userID isEqualToString:@"-1"]) {
            WXNewFriendViewController *newFriendVC = [[WXNewFriendViewController alloc] init];
            [self setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:newFriendVC animated:YES];
            [self setHidesBottomBarWhenPushed:NO];
        }else if ([user.userID isEqualToString:@"-2"]) {
            WXGroupViewController *groupVC = [[WXGroupViewController alloc] init];
            [self setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:groupVC animated:YES];
            [self setHidesBottomBarWhenPushed:NO];
        }else if ([user.userID isEqualToString:@"-3"]) {
            WXTagsViewController *tagsVC = [[WXTagsViewController alloc] init];
            [self setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:tagsVC animated:YES];
            [self setHidesBottomBarWhenPushed:NO];
        }else if ([user.userID isEqualToString:@"-4"]) {
            WXPublicServerViewController *publicServer = [[WXPublicServerViewController alloc] init];
            [self setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:publicServer animated:YES];
            [self setHidesBottomBarWhenPushed:NO];
        }
    }else{
        WXFriendDetailViewController *detailVC = [[WXFriendDetailViewController alloc] init];
        [detailVC setUser:user];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//MARK: UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.searchVC setFriendsData:[WXFriendHelper sharedFriendHelper].friendsData];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.tabBarController.tabBar setHidden:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.tabBarController.tabBar setHidden:NO];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    [SVProgressHUD showInfoWithStatus:@"语音搜索按钮"];
}
@end
