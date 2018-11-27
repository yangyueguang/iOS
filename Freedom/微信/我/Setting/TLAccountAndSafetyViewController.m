//  TLAccountAndSafetyViewController.m
//  Freedom
// Created by Super
#import "TLAccountAndSafetyViewController.h"
#import "TLWebViewController.h"
#import "TLUserHelper.h"
#import "WechartModes.h"
@interface TLAccountAndSafetyHelper : NSObject
- (NSMutableArray *)mineAccountAndSafetyDataByUserInfo:(TLUser *)userInfo;
@end
@interface TLAccountAndSafetyHelper ()
@property (nonatomic, strong) NSMutableArray *data;
@end
@implementation TLAccountAndSafetyHelper
- (id)init{
    if (self = [super init]) {
        self.data = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSMutableArray *)mineAccountAndSafetyDataByUserInfo:(TLUser *)userInfo{
    TLSettingItem *username = TLCreateSettingItem(@"微信号");
    if (userInfo.username.length > 0) {
        username.subTitle = userInfo.username;
        username.showDisclosureIndicator = NO;
        username.disableHighlight = YES;
    }else{
        username.subTitle = @"未设置";
    }
    TLSettingGroup *group1 = TLCreateSettingGroup(nil, nil, @[username]);
    
    TLSettingItem *qqNumber = TLCreateSettingItem(@"QQ号");
    qqNumber.subTitle = (userInfo.detailInfo.qqNumber.length > 0 ? userInfo.detailInfo.qqNumber : @"未绑定");
    TLSettingItem *phoneNumber = TLCreateSettingItem(@"手机号");
    phoneNumber.subTitle = (phoneNumber.subTitle.length > 0 ?userInfo.detailInfo.phoneNumber : @"未绑定");
    TLSettingItem *email = TLCreateSettingItem(@"邮箱地址");
    email.subTitle = userInfo.detailInfo.email.length > 0 ? userInfo.detailInfo.email : @"未绑定";
    TLSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[qqNumber, phoneNumber, email]));
    
    TLSettingItem *voiceLock = TLCreateSettingItem(@"声音锁");
    TLSettingItem *password = TLCreateSettingItem(@"微信密码");
    TLSettingItem *idProtect = TLCreateSettingItem(@"账号保护");
    if (1) {
        idProtect.subTitle = @"已保护";
        idProtect.rightImagePath = PprotectHL;
    }else {
        idProtect.subTitle = @"未保护";
        idProtect.rightImagePath = Pprotect;
    }
    TLSettingItem *safetyCenter = TLCreateSettingItem(@"微信安全中心");
    TLSettingGroup *group3 = TLCreateSettingGroup(nil, @"如果遇到账号信息泄露、忘记密码、诈骗等账号问题，可前往微信安全中心。", (@[voiceLock, password, idProtect, safetyCenter]));
    
    [_data removeAllObjects];
    [_data addObjectsFromArray:@[group1, group2, group3]];
    return _data;
}
@end
@interface TLAccountAndSafetyViewController ()
@property (nonatomic, strong) TLAccountAndSafetyHelper *helper;
@end
@implementation TLAccountAndSafetyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"账号与安全"];
    self.helper = [[TLAccountAndSafetyHelper alloc] init];
    self.data = [self.helper mineAccountAndSafetyDataByUserInfo:[TLUserHelper sharedHelper].user];
}
#pragma mark - Delegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TLSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"微信安全中心"]) {
        TLWebViewController *webVC = [[TLWebViewController alloc] init];
        [webVC setUrl:@"http://weixin110.qq.com/"];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
