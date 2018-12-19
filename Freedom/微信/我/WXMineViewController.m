//  WXMineViewController.m
//  Freedom
// Created by Super
/*
 *  注意：该类TableView重载并增加section（0， 0）*/
#import "WXMineViewController.h"
#import "WXUserHelper.h"
#import "WXMineInfoViewController.h"
#import "WXExpressionViewController.h"
#import "WXMineSettingViewController.h"
#import "WXModes.h"
#import <UIKit/UIKit.h>
@interface WXMineHeaderCell : UITableViewCell
@property (nonatomic, strong) WXUser *user;
@end
@interface WXMineHeaderCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nikenameLabel;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIImageView *QRImageView;
@end
@implementation WXMineHeaderCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.nikenameLabel];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.QRImageView];
        
        [self addMasonry];
    }
    return self;
}
- (void) addMasonry{
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(- 12);
        make.width.mas_equalTo(self.avatarImageView.mas_height);
    }];
    
    [self.nikenameLabel setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    [self.nikenameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(10);
        make.bottom.mas_equalTo(self.avatarImageView.mas_centerY).mas_offset(-3.5);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nikenameLabel);
        make.top.mas_equalTo(self.avatarImageView.mas_centerY).mas_offset(5.0);
    }];
    
    [self.QRImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView).mas_offset(-0.5);
        make.right.mas_equalTo(self.contentView);
        make.height.and.width.mas_equalTo(18);
    }];
}
- (void) setUser:(WXUser *)user{
    _user = user;
    if (user.avatarPath) {
        [self.avatarImageView setImage:[UIImage imageNamed:user.avatarPath]];
    }
    else{
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarURL] placeholderImage:[UIImage imageNamed:@"userLogo"]];
    }
    [self.nikenameLabel setText:user.nikeName];
    [self.usernameLabel setText:user.username ? [@"微信号：" stringByAppendingString:user.username] : @""];
}
#pragma mark - Getter
- (UIImageView *) avatarImageView{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView.layer setMasksToBounds:YES];
        [_avatarImageView.layer setCornerRadius:5.0f];
    }
    return _avatarImageView;
}
- (UILabel *) nikenameLabel{
    if (_nikenameLabel == nil) {
        _nikenameLabel = [[UILabel alloc] init];
        [_nikenameLabel setFont:[UIFont systemFontOfSize:17.0f]];
    }
    return _nikenameLabel;
}
- (UILabel *) usernameLabel{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        [_usernameLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    return _usernameLabel;
}
- (UIImageView *) QRImageView{
    if (_QRImageView == nil) {
        _QRImageView = [[UIImageView alloc] init];
        [_QRImageView setImage:[UIImage imageNamed:PQRCode]];
    }
    return _QRImageView;
}
@end
@interface WXMineHelper : NSObject
@property (nonatomic, strong) NSMutableArray *mineMenuData;
@end
@implementation WXMineHelper
- (id) init{
    if (self = [super init]) {
        self.mineMenuData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}
-(WXMenuItem*)TLCreateMenuItem:(NSString*)IconPath :(NSString*)Title{
    return [WXMenuItem createMenuWithIconPath:IconPath title:Title];
}
- (void) p_initTestData{
    WXMenuItem *item0 =[self TLCreateMenuItem:nil: nil];
    WXMenuItem *item1 = [self TLCreateMenuItem:@"u_album_b": @"相册"];
    WXMenuItem *item2 = [self TLCreateMenuItem:@"u_favorites": @"收藏"];
    WXMenuItem *item3 = [self TLCreateMenuItem:@"MoreMyBankCard": @"钱包"];
    WXMenuItem *item4 = [self TLCreateMenuItem:@"MyCardPackageIcon": @"优惠券"];
    WXMenuItem *item5 = [self TLCreateMenuItem:@"MoreExpressionShops": @"表情"];
    WXMenuItem *item6 = [self TLCreateMenuItem:@"setingHL": @"设置"];
    [self.mineMenuData addObjectsFromArray:@[@[item0], @[item1, item2, item3, item4], @[item5], @[item6]]];
}
@end
@interface WXMineInfoHelper ()
@property (nonatomic, strong) NSMutableArray *mineInfoData;
@end
@implementation WXMineInfoHelper
- (id) init{
    if (self = [super init]) {
        _mineInfoData = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSMutableArray *)mineInfoDataByUserInfo:(WXUser *)userInfo{
    WXSettingItem *avatar = [WXSettingItem createItemWithTitle:(@"头像")];
    avatar.rightImageURL = userInfo.avatarURL;
    WXSettingItem *nikename = [WXSettingItem createItemWithTitle:(@"名字")];
    nikename.subTitle = userInfo.nikeName.length > 0 ? userInfo.nikeName : @"未设置";
    WXSettingItem *username = [WXSettingItem createItemWithTitle:(@"微信号")];
    if (userInfo.username.length > 0) {
        username.subTitle = userInfo.username;
        username.showDisclosureIndicator = NO;
        username.disableHighlight = YES;
    }else{
        username.subTitle = @"未设置";
    }
    
    WXSettingItem *qrCode = [WXSettingItem createItemWithTitle:(@"我的二维码")];
    qrCode.rightImagePath = PQRCode;
    WXSettingItem *location = [WXSettingItem createItemWithTitle:(@"我的地址")];
    WXSettingGroup *group1 = TLCreateSettingGroup(nil, nil, (@[avatar, nikename, username, qrCode, location]));
    
    WXSettingItem *sex = [WXSettingItem createItemWithTitle:(@"性别")];
    sex.subTitle = userInfo.detailInfo.sex;
    WXSettingItem *city = [WXSettingItem createItemWithTitle:(@"地区")];
    city.subTitle = userInfo.detailInfo.location;
    WXSettingItem *motto = [WXSettingItem createItemWithTitle:(@"个性签名")];
    motto.subTitle = userInfo.detailInfo.motto.length > 0 ? userInfo.detailInfo.motto : @"未填写";
    WXSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[sex, city, motto]));
    
    [_mineInfoData removeAllObjects];
    [_mineInfoData addObjectsFromArray:@[group1, group2]];
    return _mineInfoData;
}
@end
@interface WXMineViewController ()
@property (nonatomic, strong) WXMineHelper *mineHelper;
@end
@implementation WXMineViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我"];
    self.mineHelper = [[WXMineHelper alloc] init];
    self.data = self.mineHelper.mineMenuData;
    
    [self.tableView registerClass:[WXMineHeaderCell class] forCellReuseIdentifier:@"TLMineHeaderCell"];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WXMineHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLMineHeaderCell"];
        [cell setUser:[WXUserHelper sharedHelper].user];
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
}
//MARK: UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90;
    }
    return [super tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WXMineInfoViewController *mineInfoVC = [[WXMineInfoViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:mineInfoVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        return;
    }
    WXMenuItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"表情"]) {
        WXExpressionViewController *expressionVC = [[WXExpressionViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:expressionVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }else if ([item.title isEqualToString:@"设置"]) {
        WXMineSettingViewController *settingVC = [[WXMineSettingViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:settingVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}
@end
