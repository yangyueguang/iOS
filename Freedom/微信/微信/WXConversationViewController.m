//  WXConversationViewController.m
//  Freedom
// Created by Super
#import "WXConversationViewController.h"
#import "WXSearchController.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "WXTableViewCell.h"
#import "WXModes.h"
#import "WXUserHelper.h"
#import "NSFileManager+expanded.h"
#define     CONV_SPACE_X            10.0f
#define     CONV_SPACE_Y            9.5f
#define     REDPOINT_WIDTH          10.0f
#define     WIDTH_TABLEVIEW             140.0f
#define     HEIGHT_TABLEVIEW_CELL       45.0f
@interface WechatAddMenuCell : WXTableViewCell
@property (nonatomic, strong) WXAddMenuItem *item;
@end
@interface WechatAddMenuCell()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation WechatAddMenuCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.rightSeparatorSpace = 16;
        [self setBackgroundColor:UIColor(71, 70, 73, 1.0)];
        UIView *selectedView = [[UIView alloc] init];
        [selectedView setBackgroundColor:UIColor(65, 64, 67, 1.0)];
        [self setSelectedBackgroundView:selectedView];
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        
        [self p_addMasonry];
    }
    return self;
}
- (void)setItem:(WXAddMenuItem *)item{
    _item = item;
    [self.iconImageView setImage:[UIImage imageNamed:item.iconPath]];
    [self.titleLabel setText:item.title];
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(15.0f);
        make.centerY.mas_equalTo(self);
        make.height.and.width.mas_equalTo(32);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(10.0f);
        make.centerY.mas_equalTo(self.iconImageView);
    }];
}
#pragma mark - Getter
- (UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    }
    return _titleLabel;
}
@end
@interface WechatAddMenuView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) WXAddMenuHelper *helper;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@end
@implementation WechatAddMenuView
- (id)init{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.tableView];
        
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:panGR];
        
        [self.tableView registerClass:[WechatAddMenuCell class] forCellReuseIdentifier:@"TLAddMenuCell"];
        self.data = self.helper.menuData;
    }
    return self;
}
- (void)showInView:(UIView *)view{
    [view addSubview:self];
    [self setNeedsDisplay];
    [self setFrame:view.bounds];
    
    CGRect rect = CGRectMake(view.frame.size.width - WIDTH_TABLEVIEW - 5, HEIGHT_NAVBAR + NavY + 10, WIDTH_TABLEVIEW, self.data.count * HEIGHT_TABLEVIEW_CELL);
    [self.tableView setFrame:rect];
}
- (BOOL)isShow{
    return self.superview != nil;
}
- (void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:0.0f];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            [self setAlpha:1.0];
        }
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXAddMenuItem *item = [self.data objectAtIndex:indexPath.row];
    WechatAddMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLAddMenuCell"];
    [cell setItem:item];
    return cell;
}
//MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXAddMenuItem *item = [self.data objectAtIndex:indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(addMenuView:didSelectedItem:)]) {
        [_delegate addMenuView:self didSelectedItem:item];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self dismiss];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TABLEVIEW_CELL;
}
#pragma mark - Private Methods -
- (void)drawRect:(CGRect)rect{
    CGFloat startX = self.frame.size.width - 27;
    CGFloat startY = NavY + HEIGHT_NAVBAR + 3;
    CGFloat endY = NavY + HEIGHT_NAVBAR + 10;
    CGFloat width = 6;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, startX + width, endY);
    CGContextAddLineToPoint(context, startX - width, endY);
    CGContextClosePath(context);
    [UIColor(71, 70, 73, 1.0) setFill];
    [UIColor(71, 70, 73, 1.0) setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}
#pragma mark - Getter -
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setScrollEnabled:NO];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:UIColor(71, 70, 73, 1.0)];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView.layer setMasksToBounds:YES];
        [_tableView.layer setCornerRadius:3.0f];
    }
    return _tableView;
}
- (WXAddMenuHelper *)helper{
    if (_helper == nil) {
        _helper = [[WXAddMenuHelper alloc] init];
    }
    return _helper;
}
@end
@interface WechatConversationCell : WXTableViewCell
/// 会话Model
@property (nonatomic, strong) WXConversation *conversation;
#pragma mark - Public Methods
/*标记为未读*/
- (void) markAsUnread;
/*标记为已读*/
- (void) markAsRead;
@end
@interface WechatConversationCell()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *remindImageView;
@property (nonatomic, strong) UIView *redPointView;
@end
@implementation WechatConversationCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftSeparatorSpace = CONV_SPACE_X;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.remindImageView];
        [self.contentView addSubview:self.redPointView];
        
        [self p_addMasonry];
    }
    return self;
}
#pragma mark - Public Methods
- (void) setConversation:(WXConversation *)conversation{
    _conversation = conversation;
    
    if (conversation.avatarPath.length > 0) {
        NSString *path = [NSFileManager pathUserAvatar:conversation.avatarPath];
        [self.avatarImageView setImage:[UIImage imageNamed:path]];
    }else if (conversation.avatarURL.length > 0){
        [self.avatarImageView sd_setImageWithURL:TLURL(conversation.avatarURL) placeholderImage:[UIImage imageNamed:PuserLogo]];
    }else{
        [self.avatarImageView setImage:nil];
    }
    [self.usernameLabel setText:conversation.partnerName];
    [self.detailLabel setText:conversation.content];
    [self.timeLabel setText:conversation.date.timeToNow];
    switch (conversation.remindType) {
        case TLMessageRemindTypeNormal:
        [self.remindImageView setHidden:YES];
        break;
        case TLMessageRemindTypeClosed:
        [self.remindImageView setHidden:NO];
        [self.remindImageView setImage:[UIImage imageNamed:@"conv_remind_close"]];
        break;
        case TLMessageRemindTypeNotLook:
        [self.remindImageView setHidden:NO];
        [self.remindImageView setImage:[UIImage imageNamed:@"conv_remind_notlock"]];
        break;
        case TLMessageRemindTypeUnlike:
        [self.remindImageView setHidden:NO];
        [self.remindImageView setImage:[UIImage imageNamed:@"conv_remind_unlike"]];
        break;
        default:
        break;
    }
    
    self.conversation.isRead ? [self markAsRead] : [self markAsUnread];
}
/*标记为未读*/
- (void) markAsUnread{
    if (_conversation) {
        switch (_conversation.clueType) {
            case TLClueTypePointWithNumber:
            
            break;
            case TLClueTypePoint:
            [self.redPointView setHidden:NO];
            break;
            case TLClueTypeNone:
            
            break;
            default:
            break;
        }
    }
}
/*标记为已读*/
- (void) markAsRead{
    if (_conversation) {
        switch (_conversation.clueType) {
            case TLClueTypePointWithNumber:
            
            break;
            case TLClueTypePoint:
            [self.redPointView setHidden:YES];
            break;
            case TLClueTypeNone:
            
            break;
            default:
            break;
        }
    }
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(CONV_SPACE_X);
        make.top.mas_equalTo(CONV_SPACE_Y);
        make.bottom.mas_equalTo(- CONV_SPACE_Y);
        make.width.mas_equalTo(self.avatarImageView.mas_height);
    }];
    
    [self.usernameLabel setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(CONV_SPACE_X);
        make.top.mas_equalTo(self.avatarImageView).mas_offset(2.0);
        make.right.mas_lessThanOrEqualTo(self.timeLabel.mas_left).mas_offset(-5);
    }];
    
    [self.detailLabel setContentCompressionResistancePriority:110 forAxis:UILayoutConstraintAxisHorizontal];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.avatarImageView).mas_offset(-2.0);
        make.left.mas_equalTo(self.usernameLabel);
        make.right.mas_lessThanOrEqualTo(self.remindImageView.mas_left);
    }];
    
    [self.timeLabel setContentCompressionResistancePriority:300 forAxis:UILayoutConstraintAxisHorizontal];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.usernameLabel);
        make.right.mas_equalTo(self.contentView).mas_offset(-CONV_SPACE_X);
    }];
    
    [self.remindImageView setContentCompressionResistancePriority:310 forAxis:UILayoutConstraintAxisHorizontal];
    [self.remindImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.timeLabel);
        make.centerY.mas_equalTo(self.detailLabel);
    }];
    
    [self.redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.avatarImageView.mas_right).mas_offset(-2);
        make.centerY.mas_equalTo(self.avatarImageView.mas_top).mas_offset(2);
        make.width.and.height.mas_equalTo(REDPOINT_WIDTH);
    }];
}
#pragma mark - Getter
- (UIImageView *)avatarImageView{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView.layer setMasksToBounds:YES];
        [_avatarImageView.layer setCornerRadius:3.0f];
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
- (UILabel *)detailLabel{
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        [_detailLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_detailLabel setTextColor:[UIColor grayColor]];
    }
    return _detailLabel;
}
- (UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:12.5f]];
        [_timeLabel setTextColor:UIColor(160, 160, 160, 1.0)];
    }
    return _timeLabel;
}
- (UIImageView *)remindImageView{
    if (_remindImageView == nil) {
        _remindImageView = [[UIImageView alloc] init];
        [_remindImageView setAlpha:0.4];
    }
    return _remindImageView;
}
- (UIView *)redPointView{
    if (_redPointView == nil) {
        _redPointView = [[UIView alloc] init];
        [_redPointView setBackgroundColor:[UIColor redColor]];
        
        [_redPointView.layer setMasksToBounds:YES];
        [_redPointView.layer setCornerRadius:REDPOINT_WIDTH / 2.0];
        [_redPointView setHidden:YES];
    }
    return _redPointView;
}
@end
@interface WXConversationViewController ()
@property (nonatomic, strong) UIImageView *scrollTopView;
@property (nonatomic, strong) WXSearchController *searchController;
@property (nonatomic, strong) WechatAddMenuView *addMenuView;
@end
@implementation WXConversationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"微信"];
    
    [self p_initUI];        // 初始化界面UI
    [self registerCellClass];
    
    [[WXMessageManager sharedInstance] setConversationDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //TODO: 临时写法
    [self updateConversationData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.addMenuView.isShow) {
        [self.addMenuView dismiss];
    }
}
#pragma mark - Event Response
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
    if (self.addMenuView.isShow) {
        [self.addMenuView dismiss];
    }else{
        [self.addMenuView showInView:self.navigationController.view];
    }
}
// 网络情况改变
- (void)networkStatusChange:(NSNotification *)noti{
    AFNetworkReachabilityStatus status = [noti.userInfo[@"AFNetworkingReachabilityNotificationStatusItem"] longValue];
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusUnknown:
            [self.navigationItem setTitle:@"微信"];
            break;
        case AFNetworkReachabilityStatusNotReachable:
            [self.navigationItem setTitle:@"微信(未连接)"];
            break;
        default:
            break;
    }
}
#pragma mark - Private Methods -
- (void)p_initUI{
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    [self.tableView addSubview:self.scrollTopView];
    [self.scrollTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tableView);
        make.bottom.mas_equalTo(self.tableView.mas_top).mas_offset(-35);
    }];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}
#pragma mark - Getter -
- (WXSearchController *) searchController{
    if (_searchController == nil) {
        _searchController = [[WXSearchController alloc] initWithSearchResultsController:self.searchVC];
        [_searchController setSearchResultsUpdater:self.searchVC];
        [_searchController.searchBar setPlaceholder:@"搜索"];
        [_searchController.searchBar setDelegate:self];
        [_searchController setShowVoiceButton:YES];
    }
    return _searchController;
}
- (WXFriendSearchViewController *) searchVC{
    if (_searchVC == nil) {
        _searchVC = [[WXFriendSearchViewController alloc] init];
    }
    return _searchVC;
}
- (UIImageView *)scrollTopView{
    if (_scrollTopView == nil) {
        _scrollTopView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"conv_wechat_icon"]];
    }
    return _scrollTopView;
}
- (WechatAddMenuView *)addMenuView{
    if (_addMenuView == nil) {
        _addMenuView = [[WechatAddMenuView alloc] init];
        [_addMenuView setDelegate:self];
    }
    return _addMenuView;
}
#pragma mark - Public Methods -
- (void)registerCellClass{
    [self.tableView registerClass:[WechatConversationCell class] forCellReuseIdentifier:@"TLConversationCell"];
}
#pragma mark - Delegate -
//MARK: WXMessageManagerConvVCDelegate
- (void)updateConversationData{
    [[WXMessageManager sharedInstance] conversationRecord:^(NSArray *data) {
        for (WXConversation *conversation in data) {
            if (conversation.convType == TLConversationTypePersonal) {
                WXUser *user = [[WXFriendHelper sharedFriendHelper] getFriendInfoByUserID:conversation.partnerID];
                [conversation updateUserInfo:user];
            }else if (conversation.convType == TLConversationTypeGroup) {
                WXGroup *group = [[WXFriendHelper sharedFriendHelper] getGroupInfoByGroupID:conversation.partnerID];
                [conversation updateGroupInfo:group];
            }
        }
        self.data = [[NSMutableArray alloc] initWithArray:data];
        [self.tableView reloadData];
    }];
}
//MARK: UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXConversation *conversation = [self.data objectAtIndex:indexPath.row];
    WechatConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLConversationCell"];
    [cell setConversation:conversation];
    [cell setBottomLineStyle:indexPath.row == self.data.count - 1 ? TLCellLineStyleFill : TLCellLineStyleDefault];
    
    return cell;
}
//MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_CONVERSATION_CELL;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    WXChatViewController *chatVC = [WXChatViewController sharedChatVC];
    
    WXConversation *conversation = [self.data objectAtIndex:indexPath.row];
    if (conversation.convType == TLConversationTypePersonal) {
        WXUser *user = [[WXFriendHelper sharedFriendHelper] getFriendInfoByUserID:conversation.partnerID];
        if (user == nil) {
            [SVProgressHUD showErrorWithStatus:@"您不存在此好友"];
            return;
        }
        [chatVC setPartner:user];
    }else if (conversation.convType == TLConversationTypeGroup){
        WXGroup *group = [[WXFriendHelper sharedFriendHelper] getGroupInfoByGroupID:conversation.partnerID];
        if (group == nil) {
            [SVProgressHUD showErrorWithStatus:@"您不存在该讨论组"];
            return;
        }
        [chatVC setPartner:group];
    }
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:chatVC animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
    
    // 标为已读
    [(WechatConversationCell *)[self.tableView cellForRowAtIndexPath:indexPath] markAsRead];
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXConversation *conversation = [self.data objectAtIndex:indexPath.row];
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *delAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删除"
                                                                       handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                       {
                                           [weakSelf.data removeObjectAtIndex:indexPath.row];
                                           BOOL ok = [[WXMessageManager sharedInstance] deleteConversationByPartnerID:conversation.partnerID];
                                           if (!ok) {
                                               [SVProgressHUD showErrorWithStatus:@"从数据库中删除会话信息失败"];
                                           }
                                           [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                           if (self.data.count > 0 && indexPath.row == self.data.count) {
                                               NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
                                               WechatConversationCell *cell = [self.tableView cellForRowAtIndexPath:lastIndexPath];
                                               [cell setBottomLineStyle:TLCellLineStyleFill];
                                           }
                                       }];
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                          title:conversation.isRead ? @"标为未读" : @"标为已读"
                                                                        handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                        {
                                            WechatConversationCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                            conversation.isRead ? [cell markAsUnread] : [cell markAsRead];
                                            [tableView setEditing:NO animated:YES];
                                        }];
    moreAction.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    return @[delAction, moreAction];
}
//MARK: UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.searchVC setFriendsData:[WXFriendHelper sharedFriendHelper].friendsData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.tabBarController.tabBar setHidden:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.tabBarController.tabBar setHidden:NO];
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    [SVProgressHUD showInfoWithStatus:@"语音搜索按钮"];
}
//MARK: TLAddMenuViewDelegate
// 选中了addMenu的某个菜单项
- (void)addMenuView:(WechatAddMenuView *)addMenuView didSelectedItem:(WXAddMenuItem *)item{
    if (item.className.length > 0) {
        id vc = [[NSClassFromString(item.className) alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }else{
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ 功能暂未实现",item.title]];
    }
}
@end
