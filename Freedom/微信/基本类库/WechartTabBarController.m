
//  WechartTabBarController.m
//  Created by Super on 16/8/19.
//  Copyright © 2016年 Super. All rights reserved.
#import "WechartTabBarController.h"
#import "WechartNavigationController.h"
#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"
#import "SVProgressHUD.h"
#import "TLRootViewController.h"
#import "TLMessageManager.h"
#import "TLExpressionHelper.h"
#import "JPEngine.h"
#import "CocoaLumberjack.h"
#import "TLUserHelper.h"
#import <MobClick.h>
#import <BlocksKit/BlocksKit+UIKit.h>
static WechartTabBarController *rootVC = nil;
@interface WechartTabBarController ()
@property (nonatomic, strong) NSArray *childVCArray;
@end
@implementation WechartTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self p_initThirdPartSDK];      // 初始化第三方SDK
    [self p_initAppData];           // 初始化应用信息
    [self p_initUserData];          // 初始化用户信息
    [self p_urgentMethod];          // 紧急方法
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"SDHomeTableViewController",
                                   kTitleKey  : @"微信",
                                   kImgKey    : @"tabbar_mainframe",
                                   kSelImgKey : @"tabbar_mainframeHL"},
                                 
                                 @{kClassKey  : @"SDContactsTableViewController",
                                   kTitleKey  : @"通讯录",
                                   kImgKey    : @"tabbar_contacts",
                                   kSelImgKey : @"tabbar_contactsHL"},
                                 
                                 @{kClassKey  : @"SDDiscoverTableViewController",
                                   kTitleKey  : @"发现",
                                   kImgKey    : @"tabbar_discover",
                                   kSelImgKey : @"tabbar_discoverHL"},
                                 
                                 @{kClassKey  : @"SDMeTableViewController",
                                   kTitleKey  : @"我",
                                   kImgKey    : @"tabbar_me",
                                   kSelImgKey : @"tabbar_meHL"} ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        vc.title = dict[kTitleKey];
        WechartNavigationController *nav = [[WechartNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBCOLOR(0, 190, 12)} forState:UIControlStateSelected];
        [self addChildViewController:nav];
    }];
}
- (void)p_initThirdPartSDK{
    // 友盟统计
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:APP_CHANNEL];
    // 网络环境监测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // JSPatch
//    [JSPatch testScriptInBundle];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}
- (void)p_initUserData{
    DLog(@"沙盒路径:\n%@", [NSFileManager documentsPath]);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"IsFirstRunApp"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"IsFirstRunApp"];
        [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"首次启动App，是否随机下载两组个性表情包，稍候也可在“我的”-“表情”中选择下载。" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self p_downloadDefaultExpression];
            }
        }];
    }
    [TLUserHelper sharedHelper];
    [TLFriendHelper sharedFriendHelper];
}
- (void)p_downloadDefaultExpression{
    [SVProgressHUD show];
    __block NSInteger count = 0;
    __block NSInteger successCount = 0;
    TLExpressionHelper *proxy = [TLExpressionHelper sharedHelper];
    TLEmojiGroup *group = [[TLEmojiGroup alloc] init];
    group.groupID = @"241";
    group.groupName = @"婉转的骂人";
    group.groupIconURL = @"http://123.57.155.230:8080/ibiaoqing/admin/expre/downloadsuo.do?pId=10790";
    group.groupInfo = @"婉转的骂人";
    group.groupDetailInfo = @"婉转的骂人表情，慎用";
    [proxy requestExpressionGroupDetailByGroupID:group.groupID pageIndex:1 success:^(id data) {
        group.data = data;
        [[TLExpressionHelper sharedHelper] downloadExpressionsWithGroupInfo:group progress:^(CGFloat progress) {
            
        } success:^(TLEmojiGroup *group) {
            BOOL ok = [[TLExpressionHelper sharedHelper] addExpressionGroup:group];
            if (!ok) {
                DLog(@"表情存储失败！");
            }else{
                successCount ++;
            }
            count ++;
            if (count == 2) {
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"成功下载%ld组表情！", (long)successCount]];
            }
        } failure:^(TLEmojiGroup *group, NSString *error) {
            
        }];
    } failure:^(NSString *error) {
        count ++;
        if (count == 2) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"成功下载%ld组表情！", (long)successCount]];
        }
    }];
    
    
    TLEmojiGroup *group1 = [[TLEmojiGroup alloc] init];
    group1.groupID = @"223";
    group1.groupName = @"王锡玄";
    group1.groupIconURL = @"http://123.57.155.230:8080/ibiaoqing/admin/expre/downloadsuo.do?pId=10482";
    group1.groupInfo = @"王锡玄 萌娃 冷笑宝宝";
    group1.groupDetailInfo = @"韩国萌娃，冷笑宝宝王锡玄表情包";
    [proxy requestExpressionGroupDetailByGroupID:group1.groupID pageIndex:1 success:^(id data) {
        group1.data = data;
        [[TLExpressionHelper sharedHelper] downloadExpressionsWithGroupInfo:group1 progress:^(CGFloat progress) {
            
        } success:^(TLEmojiGroup *group) {
            BOOL ok = [[TLExpressionHelper sharedHelper] addExpressionGroup:group];
            if (!ok) {
                DLog(@"表情存储失败！");
            }else{
                successCount ++;
            }
            count ++;
            if (count == 2) {
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"成功下载%ld组表情！", (long)successCount]];
            }
        } failure:^(TLEmojiGroup *group, NSString *error) {
            
        }];
    } failure:^(NSString *error) {
        count ++;
        if (count == 2) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"成功下载%ld组表情！", (long)successCount]];
        }
    }];
}
- (void)p_initAppData{
    TLMessageManager *proxy = [TLMessageManager sharedInstance];
    [proxy requestClientInitInfoSuccess:^(id data) {
        
    } failure:^(NSString *error) {
        
    }];
}
- (void)p_urgentMethod{
    // 由JSPatch重写
}
@end
