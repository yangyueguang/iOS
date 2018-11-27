//  TLMineSettingViewController.m
//  Freedom
//  Created by Super on 16/2/8.
#import "WXMineSettingViewController.h"
#import "WXAccountAndSafetyViewController.h"
#import "WXNewMessageSettingViewController.h"
#import "WXPrivacySettingViewController.h"
#import "WXCommonSettingViewController.h"
#import "WXHelpAndFeedbackViewController.h"
#import "WXAboutViewController.h"
#import "WXModes.h"
typedef void (^ CompleteBlock)(NSMutableArray *data);
@interface WXSettingHelper : NSObject
@property (nonatomic, strong) NSMutableArray *mineSettingData;
@end
@implementation WXSettingHelper
- (id) init{
    if (self = [super init]) {
        self.mineSettingData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}
- (void) p_initTestData{
    WXSettingItem *item1 = TLCreateSettingItem(@"账号与安全");
    if (/* DISABLES CODE */ (1)) {
        item1.subTitle = @"已保护";
        item1.rightImagePath = @"u_protectHL";
    }else {
        item1.subTitle = @"未保护";
        item1.rightImagePath = @"u_protect";
    }
    WXSettingGroup *group1 = TLCreateSettingGroup(nil, nil, @[item1]);
    
    WXSettingItem *item2 = TLCreateSettingItem(@"新消息通知");
    WXSettingItem *item3 = TLCreateSettingItem(@"隐私");
    WXSettingItem *item4 = TLCreateSettingItem(@"通用");
    WXSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[item2, item3, item4]));
    
    WXSettingItem *item5 = TLCreateSettingItem(@"帮助与反馈");
    WXSettingItem *item6 = TLCreateSettingItem(@"关于微信");
    WXSettingGroup *group3 = TLCreateSettingGroup(nil, nil, (@[item5, item6]));
    
    WXSettingItem *item7 = TLCreateSettingItem(@"退出登录");
    item7.type = TLSettingItemTypeTitleButton;
    WXSettingGroup *group4 = TLCreateSettingGroup(nil, nil, @[item7]);
    
    [self.mineSettingData addObjectsFromArray:@[group1, group2, group3, group4]];
}
@end
@interface WXMineSettingViewController ()
@property (nonatomic, strong) WXSettingHelper *helper;
@end
@implementation WXMineSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"设置"];
    
    self.helper = [[WXSettingHelper alloc] init];
    self.data = self.helper.mineSettingData;
}
#pragma mark - 
//MARK: UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"账号与安全"]) {
        WXAccountAndSafetyViewController *accountAndSafetyVC = [[WXAccountAndSafetyViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:accountAndSafetyVC animated:YES];
    }else if ([item.title isEqualToString:@"新消息通知"]) {
        WXNewMessageSettingViewController *newMessageSettingVC = [[WXNewMessageSettingViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newMessageSettingVC animated:YES];
    }else if ([item.title isEqualToString:@"隐私"]) {
        WXPrivacySettingViewController *privacySettingVC = [[WXPrivacySettingViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:privacySettingVC animated:YES];
    }else if ([item.title isEqualToString:@"通用"]) {
        WXCommonSettingViewController *commonSettingVC = [[WXCommonSettingViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:commonSettingVC animated:YES];
    }else if ([item.title isEqualToString:@"帮助与反馈"]) {
        WXHelpAndFeedbackViewController *helpAndFeedbackVC = [[WXHelpAndFeedbackViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:helpAndFeedbackVC animated:YES];
    }else if ([item.title isEqualToString:@"关于微信"]) {
        WXAboutViewController *aboutVC = [[WXAboutViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }else if ([item.title isEqualToString:@"退出登录"]) {
        [self showAlerWithtitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号。" message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
            return [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
        } ac2:^UIAlertAction *{
            return [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            }];
        } ac3:nil completion:nil];
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}
@end
