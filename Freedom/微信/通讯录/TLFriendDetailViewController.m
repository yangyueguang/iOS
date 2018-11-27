//  TLFriendDetailViewController.m
//  Freedom
// Created by Super
#import "TLFriendDetailViewController.h"
#import "TLChatViewController.h"
#import "TLRootViewController.h"
#import "MWPhotoBrowser.h"
#import "UINavigationController+JZExtension.h"
#import "TLUserHelper.h"
#import "TLTableViewCell.h"
#import "WechartModes.h"
#import "UIButton+WebCache.h"
#define     MINE_SPACE_X        14.0f
#define     MINE_SPACE_Y        12.0f
#import "TLSettingViewController.h"
@interface TLFriendDetailAlbumCell : TLTableViewCell
@property (nonatomic, strong) TLInfo *info;
@end
@interface TLFriendDetailAlbumCell ()
@property (nonatomic, strong) NSMutableArray *imageViewsArray;
@end
@implementation TLFriendDetailAlbumCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageViewsArray = [[NSMutableArray alloc] init];
        [self.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}
- (void)setInfo:(TLInfo *)info{
    _info = info;
    [self.textLabel setText:info.title];
    NSArray *arr = info.userInfo;
    
    CGFloat spaceY = 12;
    NSUInteger count = (WIDTH_SCREEN - WIDTH_SCREEN * 0.28 - 28) / (80 - spaceY * 2 + 3);
    count = arr.count <= count ? arr.count : count;
    CGFloat spaceX = (WIDTH_SCREEN - WIDTH_SCREEN * 0.28 - 28 - count * (80 - spaceY * 2)) / count;
    spaceX = spaceX > 7 ? 7 : spaceX;
    for (int i = 0; i < count; i ++) {
        NSString *imageURL = arr[i];
        UIImageView *imageView;
        if (self.imageViewsArray.count <= i) {
            imageView = [[UIImageView alloc] init];
            [self.imageViewsArray addObject:imageView];
        }else{
            imageView = self.imageViewsArray[i];
        }
        [self.contentView addSubview:imageView];
        [imageView sd_setImageWithURL:TLURL(imageURL) placeholderImage:[UIImage imageNamed:PuserLogo]];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(spaceY);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-spaceY);
            make.width.mas_equalTo(imageView.mas_height);
            if (i == 0) {
                make.left.mas_equalTo(WIDTH_SCREEN * 0.28);
            }else{
                make.left.mas_equalTo([self.imageViewsArray[i - 1] mas_right]).mas_offset(spaceX);
            }
        }];
    }
}
@end
@interface TLFriendDetailUserCell ()
@property (nonatomic, strong) UIButton *avatarView;
@property (nonatomic, strong) UILabel *shownameLabel;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *nikenameLabel;
@end
@implementation TLFriendDetailUserCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.leftSeparatorSpace = 15.0f;
        
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.shownameLabel];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.nikenameLabel];
        
        [self addMasonry];
    }
    return self;
}
- (void) addMasonry{
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MINE_SPACE_X);
        make.top.mas_equalTo(MINE_SPACE_Y);
        make.bottom.mas_equalTo(- MINE_SPACE_Y);
        make.width.mas_equalTo(self.avatarView.mas_height);
    }];
    
    [self.shownameLabel setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    [self.shownameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarView.mas_right).mas_offset(MINE_SPACE_Y);
        make.top.mas_equalTo(self.avatarView.mas_top).mas_offset(3);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shownameLabel);
        make.top.mas_equalTo(self.shownameLabel.mas_bottom).mas_offset(5);
    }];
    
    [self.nikenameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shownameLabel);
        make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(3);
    }];
}
- (void) setInfo:(TLInfo *)info{
    _info = info;
    TLUser *user = info.userInfo;
    if (user.avatarPath) {
        [self.avatarView setImage:[UIImage imageNamed:user.avatarPath] forState:UIControlStateNormal];
    }
    else{
        [self.avatarView sd_setImageWithURL:TLURL(user.avatarURL) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PuserLogo]];
    }
    [self.shownameLabel setText:user.showName];
    if (user.username.length > 0) {
        [self.usernameLabel setText:[@"微信号：" stringByAppendingString:user.username]];
        if (user.nikeName.length > 0) {
            [self.nikenameLabel setText:[@"昵称：" stringByAppendingString:user.nikeName]];
        }
    }else if (user.nikeName.length > 0){
        [self.nikenameLabel setText:[@"昵称：" stringByAppendingString:user.nikeName]];
    }
}
#pragma mark - Event Response
- (void)avatarViewButtonDown:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(friendDetailUserCellDidClickAvatar:)]) {
        [self.delegate friendDetailUserCellDidClickAvatar:self.info];
    }
}
#pragma mark - Getter
- (UIButton *)avatarView{
    if (_avatarView == nil) {
        _avatarView = [[UIButton alloc] init];
        [_avatarView.layer setMasksToBounds:YES];
        [_avatarView.layer setCornerRadius:5.0f];
        [_avatarView addTarget:self action:@selector(avatarViewButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarView;
}
- (UILabel *)shownameLabel{
    if (_shownameLabel == nil) {
        _shownameLabel = [[UILabel alloc] init];
        [_shownameLabel setFont:[UIFont fontMineNikename]];
    }
    return _shownameLabel;
}
- (UILabel *)usernameLabel{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        [_usernameLabel setFont:[UIFont fontMineUsername]];
        [_usernameLabel setTextColor:[UIColor grayColor]];
    }
    return _usernameLabel;
}
- (UILabel *)nikenameLabel{
    if (_nikenameLabel == nil) {
        _nikenameLabel = [[UILabel alloc] init];
        [_nikenameLabel setTextColor:[UIColor grayColor]];
        [_nikenameLabel setFont:[UIFont fontMineUsername]];
    }
    return _nikenameLabel;
}
@end
@interface TLFriendDetailSettingViewController : TLSettingViewController
@property (nonatomic, strong) TLUser *user;
@end
@interface TLFriendDetailSettingViewController ()
@end
@implementation TLFriendDetailSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"资料设置"];
    
    self.data = [[TLFriendHelper sharedFriendHelper] friendDetailSettingArrayByUserInfo:self.user];
}
@end
@implementation TLFriendDetailViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"详细资料"];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    [self registerCellClass];
}
- (void)setUser:(TLUser *)user{
    _user = user;
    NSArray *array = [[TLFriendHelper sharedFriendHelper] friendDetailArrayByUserInfo:self.user];
    self.data = [NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];
}
#pragma mark - Event Response -
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
    TLFriendDetailSettingViewController *detailSetiingVC = [[TLFriendDetailSettingViewController alloc] init];
    [detailSetiingVC setUser:self.user];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailSetiingVC animated:YES];
}
#pragma mark - Private Methods -
- (void)registerCellClass{
    [self.tableView registerClass:[TLFriendDetailUserCell class] forCellReuseIdentifier:@"TLFriendDetailUserCell"];
    [self.tableView registerClass:[TLFriendDetailAlbumCell class] forCellReuseIdentifier:@"TLFriendDetailAlbumCell"];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TLInfo *info = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if (info.type == TLInfoTypeOther) {
        if (indexPath.section == 0) {
            TLFriendDetailUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLFriendDetailUserCell"];
            [cell setDelegate:self];
            [cell setInfo:info];
            [cell setTopLineStyle:TLCellLineStyleFill];
            [cell setBottomLineStyle:TLCellLineStyleFill];
            return cell;
        }else{
            TLFriendDetailAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLFriendDetailAlbumCell"];
            [cell setInfo:info];
            return cell;
        }
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
//MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TLInfo *info = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if (info.type == TLInfoTypeOther) {
        if (indexPath.section == 0) {
            return HEIGHT_USER_CELL;
        }
        return HEIGHT_ALBUM_CELL;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
//MARK: TLInfoButtonCellDelegate
- (void)infoButtonCellClicked:(TLInfo *)info{
    if ([info.title isEqualToString:@"发消息"]) {
        TLChatViewController *chatVC = [TLChatViewController sharedChatVC];
        if ([self.navigationController findViewController:@"TLChatViewController"]) {
            if ([[chatVC.partner chat_userID] isEqualToString:self.user.userID]) {
                [self.navigationController popToViewControllerWithClassName:@"TLChatViewController" animated:YES];
            }else {
                [chatVC setPartner:self.user];
                __block id navController = self.navigationController;
                [self.navigationController popToRootViewControllerAnimated:YES completion:^(BOOL finished) {
                    if (finished) {
                        [navController pushViewController:chatVC animated:YES];
                    }
                }];
            }
        }else {
            [chatVC setPartner:self.user];
            UIViewController *vc = [[TLRootViewController sharedRootViewController] childViewControllerAtIndex:0];
            [[TLRootViewController sharedRootViewController] setSelectedIndex:0];
            [vc setHidesBottomBarWhenPushed:YES];
            [vc.navigationController pushViewController:chatVC animated:YES completion:^(BOOL finished) {
                [self.navigationController popViewControllerAnimated:NO];
            }];
            [vc setHidesBottomBarWhenPushed:NO];
        }
    }else {
        [super infoButtonCellClicked:info];
    }
}
//MARK: TLFriendDetailUserCellDelegate
- (void)friendDetailUserCellDidClickAvatar:(TLInfo *)info{
    NSURL *url;
    if (self.user.avatarPath) {
        NSString *imagePath = [NSFileManager pathUserAvatar:self.user.avatarPath];
        url = [NSURL fileURLWithPath:imagePath];
    }else{
        url = TLURL(self.user.avatarURL);
    }
    
    MWPhoto *photo = [MWPhoto photoWithURL:url];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:@[photo]];
    TLNavigationController *broserNavC = [[TLNavigationController alloc] initWithRootViewController:browser];
    [self presentViewController:broserNavC animated:NO completion:nil];
}
@end
