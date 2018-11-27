//  TLRootViewController.m
//  Freedom
// Created by Super
#import "TLRootViewController.h"
#import "TLConversationViewController.h"
#import "TLFriendsViewController.h"
#import "TLDiscoverViewController.h"
#import "TLMineViewController.h"
#import "UINavigationController+JZExtension.h"
#import "TLMessageManager.h"
#import "TLExpressionHelper.h"
#import "JPEngine.h"
#import "TLUserHelper.h"
#import "CocoaLumberjack.h"
#import <MobClick.h>
#import <BlocksKit/BlocksKit+UIKit.h>
static TLRootViewController *rootVC = nil;
@interface TLRootViewController ()
@property (nonatomic, strong) NSArray *childVCArray;
@property (nonatomic, strong) TLConversationViewController *conversationVC;
@property (nonatomic, strong) TLFriendsViewController *friendsVC;
@property (nonatomic, strong) TLDiscoverViewController *discoverVC;
@property (nonatomic, strong) TLMineViewController *mineVC;
@end
@implementation TLRootViewController
+ (TLRootViewController *) sharedRootViewController{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        rootVC = [[TLRootViewController alloc] init];
    });
    return rootVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self p_initThirdPartSDK];      // 初始化第三方SDK
    [self p_initAppData];           // 初始化应用信息
    [self p_initUserData];          // 初始化用户信息
    [self p_urgentMethod];          // 紧急方法
    [self setViewControllers:self.childVCArray];       // 初始化子控制器
}
- (id)childViewControllerAtIndex:(NSUInteger)index{
    return [[self.childViewControllers objectAtIndex:index] rootViewController];
}
#pragma mark - Getters
- (NSArray *) childVCArray{
    if (_childVCArray == nil) {
        TLNavigationController *convNavC = [[TLNavigationController alloc] initWithRootViewController:self.conversationVC];
        TLNavigationController *friendNavC = [[TLNavigationController alloc] initWithRootViewController:self.friendsVC];
        TLNavigationController *discoverNavC = [[TLNavigationController alloc] initWithRootViewController:self.discoverVC];
        TLNavigationController *mineNavC = [[TLNavigationController alloc] initWithRootViewController:self.mineVC];
        _childVCArray = @[convNavC, friendNavC, discoverNavC, mineNavC];
    }
    return _childVCArray;
}
- (TLConversationViewController *) conversationVC{
    if (_conversationVC == nil) {
        _conversationVC = [[TLConversationViewController alloc] init];
        [_conversationVC.tabBarItem setTitle:@"消息"];
        [_conversationVC.tabBarItem setImage:[UIImage imageNamed:@"tabbar_mainframe"]];
        [_conversationVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_mainframeHL"]];
    }
    
    return _conversationVC;
}
- (TLFriendsViewController *) friendsVC{
    if (_friendsVC == nil) {
        _friendsVC = [[TLFriendsViewController alloc] init];
        [_friendsVC.tabBarItem setTitle:@"通讯录"];
        [_friendsVC.tabBarItem setImage:[UIImage imageNamed:@"tabbar_contacts"]];
        [_friendsVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_contactsHL"]];
    }
    return _friendsVC;
}
- (TLDiscoverViewController *) discoverVC{
    if (_discoverVC == nil) {
        _discoverVC = [[TLDiscoverViewController alloc] init];
        [_discoverVC.tabBarItem setTitle:@"发现"];
        [_discoverVC.tabBarItem setImage:[UIImage imageNamed:@"tabbar_discoverS"]];
        [_discoverVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_discoverHL"]];
    }
    return _discoverVC;
}
- (TLMineViewController *) mineVC{
    if (_mineVC == nil) {
        _mineVC = [[TLMineViewController alloc] init];
        [_mineVC.tabBarItem setTitle:@"我"];
        [_mineVC.tabBarItem setImage:[UIImage imageNamed:@"tabbar_me"]];
        [_mineVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_meHL"]];
    }
    return _mineVC;
}
/**********************************************************************************/
- (void)p_initThirdPartSDK{
    // 友盟统计
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:APP_CHANNEL];
    // 网络环境监测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // JSPatch
#ifdef DEBUG_JSPATCH
    [JSPatch testScriptInBundle];
#else
//    [JSPatch startWithAppKey:JSPATCH_APPKEY];
//    [JSPatch sync];
#endif
    // Mob SMS
    //    [SMSSDK registerApp:MOB_SMS_APPKEY withSecret:MOB_SMS_SECRET];
    // 提示框
    //    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    //    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    // 日志
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
