//  TLMineViewController.m
//  Freedom
// Created by Super
/*
 *  注意：该类TableView重载并增加section（0， 0）*/
#import "TLMineViewController.h"
#import "TLUserHelper.h"
#import "TLMineInfoViewController.h"
#import "TLExpressionViewController.h"
#import "TLMineSettingViewController.h"
#import "WechartModes.h"
#define     MINE_SPACE_X        14.0f
#define     MINE_SPACE_Y        12.0f
#import <UIKit/UIKit.h>
@interface TLMineHeaderCell : UITableViewCell
@property (nonatomic, strong) TLUser *user;
@end
@interface TLMineHeaderCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nikenameLabel;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIImageView *QRImageView;
@end
@implementation TLMineHeaderCell
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
        make.left.mas_equalTo(MINE_SPACE_X);
        make.top.mas_equalTo(MINE_SPACE_Y);
        make.bottom.mas_equalTo(- MINE_SPACE_Y);
        make.width.mas_equalTo(self.avatarImageView.mas_height);
    }];
    
    [self.nikenameLabel setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    [self.nikenameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(MINE_SPACE_Y);
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
- (void) setUser:(TLUser *)user{
    _user = user;
    if (user.avatarPath) {
        [self.avatarImageView setImage:[UIImage imageNamed:user.avatarPath]];
    }
    else{
        [self.avatarImageView sd_setImageWithURL:TLURL(user.avatarURL) placeholderImage:[UIImage imageNamed:PuserLogo]];
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
        [_nikenameLabel setFont:[UIFont fontMineNikename]];
    }
    return _nikenameLabel;
}
- (UILabel *) usernameLabel{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        [_usernameLabel setFont:[UIFont fontMineUsername]];
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
@interface TLMineHelper : NSObject
@property (nonatomic, strong) NSMutableArray *mineMenuData;
@end
@implementation TLMineHelper
- (id) init{
    if (self = [super init]) {
        self.mineMenuData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}
- (void) p_initTestData{
    TLMenuItem *item0 = TLCreateMenuItem(nil, nil);
    TLMenuItem *item1 = TLCreateMenuItem(Palbum_b, @"相册");
    TLMenuItem *item2 = TLCreateMenuItem(PfavoriteHL, @"收藏");
    TLMenuItem *item3 = TLCreateMenuItem(@"MoreMyBankCard", @"钱包");
    TLMenuItem *item4 = TLCreateMenuItem(@"MyCardPackageIcon@2x", @"优惠券");
    TLMenuItem *item5 = TLCreateMenuItem(@"MoreExpressionShops@3x", @"表情");
    TLMenuItem *item6 = TLCreateMenuItem(PsetingHL, @"设置");
    [self.mineMenuData addObjectsFromArray:@[@[item0], @[item1, item2, item3, item4], @[item5], @[item6]]];
}
@end
@interface TLMineInfoHelper ()
@property (nonatomic, strong) NSMutableArray *mineInfoData;
@end
@implementation TLMineInfoHelper
- (id) init{
    if (self = [super init]) {
        _mineInfoData = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSMutableArray *)mineInfoDataByUserInfo:(TLUser *)userInfo{
    TLSettingItem *avatar = TLCreateSettingItem(@"头像");
    avatar.rightImageURL = userInfo.avatarURL;
    TLSettingItem *nikename = TLCreateSettingItem(@"名字");
    nikename.subTitle = userInfo.nikeName.length > 0 ? userInfo.nikeName : @"未设置";
    TLSettingItem *username = TLCreateSettingItem(@"微信号");
    if (userInfo.username.length > 0) {
        username.subTitle = userInfo.username;
        username.showDisclosureIndicator = NO;
        username.disableHighlight = YES;
    }else{
        username.subTitle = @"未设置";
    }
    
    TLSettingItem *qrCode = TLCreateSettingItem(@"我的二维码");
    qrCode.rightImagePath = PQRCode;
    TLSettingItem *location = TLCreateSettingItem(@"我的地址");
    TLSettingGroup *group1 = TLCreateSettingGroup(nil, nil, (@[avatar, nikename, username, qrCode, location]));
    
    TLSettingItem *sex = TLCreateSettingItem(@"性别");
    sex.subTitle = userInfo.detailInfo.sex;
    TLSettingItem *city = TLCreateSettingItem(@"地区");
    city.subTitle = userInfo.detailInfo.location;
    TLSettingItem *motto = TLCreateSettingItem(@"个性签名");
    motto.subTitle = userInfo.detailInfo.motto.length > 0 ? userInfo.detailInfo.motto : @"未填写";
    TLSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[sex, city, motto]));
    
    [_mineInfoData removeAllObjects];
    [_mineInfoData addObjectsFromArray:@[group1, group2]];
    return _mineInfoData;
}
@end
@interface TLMineViewController ()
@property (nonatomic, strong) TLMineHelper *mineHelper;
@end
@implementation TLMineViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我"];
    self.mineHelper = [[TLMineHelper alloc] init];
    self.data = self.mineHelper.mineMenuData;
    
    [self.tableView registerClass:[TLMineHeaderCell class] forCellReuseIdentifier:@"TLMineHeaderCell"];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TLMineHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLMineHeaderCell"];
        [cell setUser:[TLUserHelper sharedHelper].user];
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
        TLMineInfoViewController *mineInfoVC = [[TLMineInfoViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:mineInfoVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        return;
    }
    TLMenuItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"表情"]) {
        TLExpressionViewController *expressionVC = [[TLExpressionViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:expressionVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }else if ([item.title isEqualToString:@"设置"]) {
        TLMineSettingViewController *settingVC = [[TLMineSettingViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:settingVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}
@end
