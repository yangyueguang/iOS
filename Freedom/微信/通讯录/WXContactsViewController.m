//  TLContactsViewController.m
//  Freedom
// Created by Super
#import "WXContactsViewController.h"
#import "WXSearchController.h"
#import "WXUserHelper.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#define     FRIENDS_SPACE_X         10.0f
#define     FRIENDS_SPACE_Y         9.5f
#import "WXTableViewCell.h"
#import <UMMobClick/MobClick.h>
#import "NSFileManager+expanded.h"
#import "WXFriendsViewController.h"
/*通讯录 Cell*/
@interface WechatContactCell : WXTableViewCell
@property (nonatomic, strong) WechatContact *contact;
@end
@interface WechatContactCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *rightButton;
@end
@implementation WechatContactCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftSeparatorSpace = FRIENDS_SPACE_X;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.rightButton];
        
        [self p_addMasonry];
    }
    return self;
}
#pragma mark - Public Methods
- (void) setContact:(WechatContact *)contact{
    _contact = contact;
    if (contact.avatarPath) {
        NSString *path = [NSFileManager pathContactsAvatar:contact.avatarPath];
        [self.avatarImageView setImage:[UIImage imageNamed:path]];
    }else{
        [self.avatarImageView sd_setImageWithURL:TLURL(contact.avatarURL) placeholderImage:[UIImage imageNamed:PuserLogo]];
    }
    
    [self.usernameLabel setText:contact.name];
    [self.subTitleLabel setText:contact.tel];
    if (contact.status == TLContactStatusStranger) {
        [self.rightButton setBackgroundColor:colorGreenDefault];
        [self.rightButton setTitle:@"添加" forState:UIControlStateNormal];
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightButton.layer setBorderColor:[UIColor colorWithWhite:0.7 alpha:1.0].CGColor];
    }else{
        [self.rightButton setBackgroundColor:[UIColor clearColor]];
        [self.rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.rightButton.layer setBorderColor:[UIColor clearColor].CGColor];
        if (contact.status == TLContactStatusFriend) {
            [self.rightButton setTitle:@"已添加" forState:UIControlStateNormal];
        }else if (contact.status == TLContactStatusWait) {
            [self.rightButton setTitle:@"等待验证 " forState:UIControlStateNormal];
        }
    }
}
#pragma mark - Prvate Methods -
- (void) p_addMasonry{
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(FRIENDS_SPACE_X);
        make.top.mas_equalTo(FRIENDS_SPACE_Y);
        make.bottom.mas_equalTo(- FRIENDS_SPACE_Y + 0.5);
        make.width.mas_equalTo(self.avatarImageView.mas_height);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(FRIENDS_SPACE_X);
        make.top.mas_equalTo(self.avatarImageView).mas_offset(-1);
        make.right.mas_lessThanOrEqualTo(self.rightButton.mas_left).mas_offset(-10);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.usernameLabel);
        make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(2);
        make.right.mas_lessThanOrEqualTo(self.rightButton.mas_left).mas_offset(-10);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-5);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(48);
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
    }
    return _subTitleLabel;
}
- (UIButton *)rightButton{
    if (_rightButton == nil) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_rightButton.layer setMasksToBounds:YES];
        [_rightButton.layer setCornerRadius:4.0f];
        [_rightButton.layer setBorderWidth:BORDER_WIDTH_1PX];
    }
    return _rightButton;
}
@end
@interface WXContactsViewController () <UISearchBarDelegate>
@property (nonatomic, strong) WXSearchController *searchController;
@end
@implementation WXContactsViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"通讯录朋友"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:RGBACOLOR(46.0, 49.0, 50.0, 1.0)];
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    
    [self registerCellClass];
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [WXFriendHelper tryToGetAllContactsSuccess:^(NSArray *data, NSArray *formatData, NSArray *headers) {
        [SVProgressHUD dismiss];
        self.data = formatData;
        self.contactsData = data;
        self.headers = headers;
        [self.tableView reloadData];
        
        [MobClick event:@"e_get_contacts"];
    } failed:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"未成功获取到通讯录信息"];
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
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
- (WXContactsSearchViewController *)searchVC{
    if (_searchVC == nil) {
        _searchVC = [[WXContactsSearchViewController alloc] init];
    }
    return _searchVC;
}
- (void)registerCellClass{
    [self.tableView registerClass:[WXFriendHeaderView class] forHeaderFooterViewReuseIdentifier:@"TLFriendHeaderView"];
    [self.tableView registerClass:[WechatContactCell class] forCellReuseIdentifier:@"TLContactCell"];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WechatContact *contact = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    WechatContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLContactCell"];
    [cell setContact:contact];
    NSArray *temp = self.data[indexPath.section];
    if (indexPath.section == self.data.count - 1 && indexPath.row == [temp count] - 1) {
        [cell setBottomLineStyle:TLCellLineStyleFill];
    }else{
        [cell setBottomLineStyle:(indexPath.row == [temp count] - 1 ? TLCellLineStyleNone : TLCellLineStyleDefault)];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WXUserGroup *group = [self.data objectAtIndex:section];
    WXFriendHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TLFriendHeaderView"];
    [view setTitle:group.groupName];
    return view;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.headers;
}
//MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0f;
}
//MARK: UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.searchVC setContactsData:self.contactsData];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
}
@end
@interface WXContactsSearchViewController ()
@property (nonatomic, strong) NSMutableArray *data;
@end
@implementation WXContactsSearchViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.data = [[NSMutableArray alloc] init];;
    [self.tableView registerClass:[WechatContactCell class] forCellReuseIdentifier:@"TLContactCell"];
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
    WechatContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLContactCell"];
    
    WechatContact *contact = [self.data objectAtIndex:indexPath.row];
    [cell setContact:contact];
    [cell setTopLineStyle:(indexPath.row == 0 ? TLCellLineStyleFill : TLCellLineStyleNone)];
    [cell setBottomLineStyle:(indexPath.row == self.data.count - 1 ? TLCellLineStyleFill : TLCellLineStyleDefault)];
    return cell;
}
#pragma mark - Delegate -
//MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}
//MARK: UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = [searchController.searchBar.text lowercaseString];
    [self.data removeAllObjects];
    for (WechatContact *contact in self.contactsData) {
        if ([contact.name containsString:searchText] || [contact.pinyin containsString:searchText] || [contact.pinyinInitial containsString:searchText]) {
            [self.data addObject:contact];
        }
    }
    [self.tableView reloadData];
}
@end
