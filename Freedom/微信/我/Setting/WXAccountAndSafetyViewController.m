//  TLAccountAndSafetyViewController.m
//  Freedom
// Created by Super
#import "WXAccountAndSafetyViewController.h"
#import "WXWebViewController.h"
#import "WXUserHelper.h"
#import "WXModes.h"
@interface WXAccountAndSafetyHelper : NSObject
- (NSMutableArray *)mineAccountAndSafetyDataByUserInfo:(WXUser *)userInfo;
@end
@interface WXAccountAndSafetyHelper ()
@property (nonatomic, strong) NSMutableArray *data;
@end
@implementation WXAccountAndSafetyHelper
- (id)init{
    if (self = [super init]) {
        self.data = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSMutableArray *)mineAccountAndSafetyDataByUserInfo:(WXUser *)userInfo{
    WXSettingItem *username = [WXSettingItem createItemWithTitle:(@"微信号")];
    if (userInfo.username.length > 0) {
        username.subTitle = userInfo.username;
        username.showDisclosureIndicator = NO;
        username.disableHighlight = YES;
    }else{
        username.subTitle = @"未设置";
    }
    WXSettingGroup *group1 = TLCreateSettingGroup(nil, nil, @[username]);
    
    WXSettingItem *qqNumber = [WXSettingItem createItemWithTitle:(@"QQ号")];
    qqNumber.subTitle = (userInfo.detailInfo.qqNumber.length > 0 ? userInfo.detailInfo.qqNumber : @"未绑定");
    WXSettingItem *phoneNumber = [WXSettingItem createItemWithTitle:(@"手机号")];
    phoneNumber.subTitle = (phoneNumber.subTitle.length > 0 ?userInfo.detailInfo.phoneNumber : @"未绑定");
    WXSettingItem *email = [WXSettingItem createItemWithTitle:(@"邮箱地址")];
    email.subTitle = userInfo.detailInfo.email.length > 0 ? userInfo.detailInfo.email : @"未绑定";
    WXSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[qqNumber, phoneNumber, email]));
    
    WXSettingItem *voiceLock = [WXSettingItem createItemWithTitle:(@"声音锁")];
    WXSettingItem *password = [WXSettingItem createItemWithTitle:(@"微信密码")];
    WXSettingItem *idProtect = [WXSettingItem createItemWithTitle:(@"账号保护")];
    if (/* DISABLES CODE */ (1)) {
        idProtect.subTitle = @"已保护";
        idProtect.rightImagePath = @"u_protectHL";
    }else {
        idProtect.subTitle = @"未保护";
        idProtect.rightImagePath = @"u_protect";
    }
    WXSettingItem *safetyCenter = [WXSettingItem createItemWithTitle:(@"微信安全中心")];
    WXSettingGroup *group3 = TLCreateSettingGroup(nil, @"如果遇到账号信息泄露、忘记密码、诈骗等账号问题，可前往微信安全中心。", (@[voiceLock, password, idProtect, safetyCenter]));
    
    [_data removeAllObjects];
    [_data addObjectsFromArray:@[group1, group2, group3]];
    return _data;
}
@end
@interface WXAccountAndSafetyViewController ()
@property (nonatomic, strong) WXAccountAndSafetyHelper *helper;
@end
@implementation WXAccountAndSafetyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"账号与安全"];
    self.helper = [[WXAccountAndSafetyHelper alloc] init];
    self.data = [self.helper mineAccountAndSafetyDataByUserInfo:[WXUserHelper sharedHelper].user];
}
#pragma mark - Delegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"微信安全中心"]) {
        WXWebViewController *webVC = [[WXWebViewController alloc] init];
        [webVC setUrl:@"http://weixin110.qq.com/"];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
