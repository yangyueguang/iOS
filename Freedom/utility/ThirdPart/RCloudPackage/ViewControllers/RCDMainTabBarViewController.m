//
//  RCDMainTabBarViewController.m
//  RCloudMessage
#import "RCDMainTabBarViewController.h"
#import "RCDChatListViewController.h"
#import "RCDContactViewController.h"
#import "RCDSquareTableViewController.h"
#import "RCDMeTableViewController.h"
#import "AFHttpTool.h"
#import "RCDHttpTool.h"
#import "RCDRCIMDataSource.h"
#import "RCDataBaseManager.h"
#import "RCDNavigationViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <RongCallKit/RongCallKit.h>
#import <RongIMKit/RongIMKit.h>
#import "Freedom-Swift.h"
#import <RongContactCard/RongContactCard.h>
@interface RCDMainTabBarViewController ()<RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate>
@end
@implementation RCDMainTabBarViewController
+ (RCDMainTabBarViewController *)shareInstance {
  static RCDMainTabBarViewController *instance = nil;
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    instance = [[[self class] alloc] init];
  });
  return instance;
}
- (void)viewDidLoad {
  [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self configTabBar:[[RCDChatListViewController alloc] init] Title:@"会话" image:@"icon_chat" selectedImage:@"icon_chat_hover"];
    [self configTabBar:[[RCDContactViewController alloc] init] Title:@"通讯录" image:@"contact_icon" selectedImage:@"contact_icon_hover"];
    [self configTabBar:[[RCDSquareTableViewController alloc] init] Title:@"发现" image:@"square" selectedImage:@"square_hover"];
    [self configTabBar:[[RCDMeTableViewController alloc] init] Title:@"我" image:@"icon_me" selectedImage:@"icon_me_hover"];
}
-(void)configTabBar:(UIViewController*)vc Title:(NSString*)title image:(NSString *)image selectedImage:(NSString*)imageHL{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:imageHL]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    RCDNavigationViewController *nav = [[RCDNavigationViewController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:RCKitDispatchMessageNotification object:nil];
}
#pragma mark 初始化本该放在APPDelegate的
///FIXME:初始化融云
- (void)firstInitRongCloud{
    RCIM *rc = [RCIM sharedRCIM];
    BOOL debugMode = NO;
    UIWindow *keywindow = [UIApplication sharedApplication].delegate.window;
    //    debugMode = YES;
    // debugMode是为了动态切换导航server地址和文件server地址，公有云用户可以忽略
    if (debugMode) {
        //初始化融云SDK
        NSString *appKey = [RCDSettingUserDefaults getRCAppKey];
        if(appKey){
            //debug模式初始化sdk
            [rc initWithAppKey:appKey];
            NSString *navServer = [RCDSettingUserDefaults getRCNaviServer];
            NSString *fileUrlver = [RCDSettingUserDefaults getRCFileServer];
            //设置导航server和文件server地址
            [[RCIMClient sharedRCIMClient ]setServerInfo:navServer fileServer:fileUrlver];
            [self gotoLogin];
        }else{
            [self gotoLogin];
        }
    }else {
        //非debug模式初始化sdk
        NSString *rongCloudAPPKey = RONGCLOUD_IM_APPKEY;
        [RCDSettingUserDefaults setRCAppKey:rongCloudAPPKey];
        [rc initWithAppKey:rongCloudAPPKey];
    }
    /* RedPacket_FTR  *///需要在info.plist加上您的红包的scheme，注意一定不能与其它应用重复//设置扩展Module的Url Scheme。
    [rc setScheme:@"rongCloudRedPacket" forExtensionModule:@"JrmfPacketManager"];
    // 注册自定义测试消息
    [rc registerMessageType:[RCDTestMessage class]];
    //设置会话列表头像和会话页面头像
    [rc setConnectionStatusDelegate:self];
    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Info;
    rc.globalConversationPortraitSize = CGSizeMake(46, 46);
    //    [RCIM sharedRCIM].portraitImageViewCornerRadius = 10;
    //开启用户信息和群组信息的持久化
    rc.enablePersistentUserInfoCache = YES;
    //设置用户信息源和群组信息源
    RCDRCIMDataSource *imDataSource = [RCDRCIMDataSource shareInstance];
    rc.userInfoDataSource = imDataSource;
    rc.groupInfoDataSource = imDataSource;
    //设置名片消息功能中联系人信息源和群组信息源
    [RCContactCardKit shareInstance].contactsDataSource = imDataSource;
    [RCContactCardKit shareInstance].groupDataSource = imDataSource;
    //设置群组内用户信息源。如果不使用群名片功能，可以不设置
    //rc.groupUserInfoDataSource = RCDDataSource;
    //rc.enableMessageAttachUserInfo = YES;
    //设置接收消息代理
    rc.receiveMessageDelegate = self;
    //    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(46, 46);
    //开启输入状态监听
    rc.enableTypingStatus = YES;
    //开启发送已读回执
    rc.enabledReadReceiptConversationTypeList = @[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP)];
    //开启多端未读状态同步
    rc.enableSyncReadStatus = YES;
    //设置显示未注册的消息
    //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    rc.showUnkownMessage = YES;
    rc.showUnkownMessageNotificaiton = YES;
    //群成员数据源
    rc.groupMemberDataSource = imDataSource;
    //开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
    rc.enableMessageMentioned = YES;
    //开启消息撤回功能
    rc.enableMessageRecall = YES;
    //  设置头像为圆形
    // rc.globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    // rc.globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    //   设置优先使用WebView打开URL
    // rc.embeddedWebViewPreferred = YES;
    //  设置通话视频分辨率
    //  [[RCCallClient sharedRCCallClient] setVideoProfile:RC_VIDEO_PROFILE_480P];
    //设置Log级别，开发阶段打印详细log
    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Info;
    //登录
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"userToken"];
    NSString *userId = [defaults objectForKey:@"userId"];
    NSString *userName = [defaults objectForKey:@"userName"];
    NSString *password = [defaults objectForKey:@"userPwd"];
    NSString *userNickName = [defaults objectForKey:@"userNickName"];
    NSString *userPortraitUri = [defaults objectForKey:@"userPortraitUri"];
    if (token.length && userId.length && password.length) {
        [self insertSharedMessageIfNeed];
        RCUserInfo *_currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId name:userNickName portrait:userPortraitUri];
        rc.currentUserInfo = _currentUserInfo;
        [rc connectWithToken:token success:^(NSString *userId) {
            [AFHttpTool loginWithPhone:userName password:password region:@"86" success:^(id response) {
                if ([response[@"code"] intValue] == 200) {
                    [RCDHTTPTOOL getUserInfoByUserID:userId completion:^(RCUserInfo *user) {
                        [defaults setObject:user.portraitUri forKey:@"userPortraitUri"];
                        [defaults setObject:user.name forKey:@"userNickName"];
                        [defaults synchronize];
                        [RCIMClient sharedRCIMClient].currentUserInfo = user;
                    }];
                    //登录demoserver成功之后才能调demo 的接口
                    [imDataSource syncGroups];
                    [imDataSource syncFriendList:userId complete:^(NSMutableArray *result){ }];
                }
            }failure:^(NSError *err){}];
        }error:^(RCConnectErrorCode status) {
            [imDataSource syncGroups];
            NSLog(@"connect error %ld", (long)status);
        }tokenIncorrect:^{
            [AFHttpTool loginWithPhone:userName password:password region:@"86" success:^(id response) {
                if ([response[@"code"] intValue] == 200) {
                    NSString *newToken = response[@"result"][@"token"];
                    NSString *newUserId = response[@"result"][@"id"];
                    [[RCIM sharedRCIM] connectWithToken:newToken success:^(NSString *userId) {
                        [self loginSuccess:userName userId:newUserId token:newToken password:password];
                    } error:^(RCConnectErrorCode status) {
                        [self gotoLoginViewAndDisplayReasonInfo:@"登录失效，请重新登录。"];
                    } tokenIncorrect:^{
                        [self gotoLoginViewAndDisplayReasonInfo:@"无法连接到服务器"];
                        NSLog(@"Token无效");
                    }];
                } else {
                    [self gotoLoginViewAndDisplayReasonInfo:@"手机号或密码错误"];
                }
            }failure:^(NSError *err) {}];
        }];
    } else {
        [self gotoLogin];
    }
    NSArray *groups = [self getAllGroupInfo];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:groups];
    NSArray *loadedContents = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"loadedContents size is %lu", (unsigned long)loadedContents.count);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageNotification:)name:RCKitDispatchMessageNotification object:nil];
}
///FIXME: RCWKAppInfoProvider
- (NSString *)getAppName {
    return @"融云";
}
- (NSString *)getAppGroups {
    return @"group.cn.rongcloud.im.WKShare";
}
- (NSArray *)getAllUserInfo {
    return [[RCDRCIMDataSource shareInstance] getAllUserInfo:^{
        [[RCWKNotifier sharedWKNotifier] notifyWatchKitUserInfoChanged];
    }];
}
- (NSArray *)getAllGroupInfo {
    return [[RCDRCIMDataSource shareInstance] getAllGroupInfo:^{
        [[RCWKNotifier sharedWKNotifier] notifyWatchKitGroupChanged];
    }];
}
- (NSArray *)getAllFriends {
    return [[RCDRCIMDataSource shareInstance] getAllFriends:^{
        [[RCWKNotifier sharedWKNotifier] notifyWatchKitFriendChanged];
    }];
}
- (void)openParentApp {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"rongcloud://connect"] options:@{} completionHandler:^(BOOL success) {
    }];
}
- (BOOL)getNewMessageNotificationSound {
    return ![RCIM sharedRCIM].disableMessageAlertSound;
}
- (void)setNewMessageNotificationSound:(BOOL)on {
    [RCIM sharedRCIM].disableMessageAlertSound = !on;
}
- (void)logout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"userName"];
    [defaults removeObjectForKey:@"userPwd"];
    [defaults removeObjectForKey:@"userToken"];
    [defaults removeObjectForKey:@"userCookie"];
    if ([UIApplication sharedApplication].delegate.window.rootViewController != nil) {
        [self gotoLogin];
    }
    [[RCIMClient sharedRCIMClient] disconnect:NO];
}
- (BOOL)getLoginStatus {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:@"userToken"];
    if (token.length) {
        return YES;
    } else {
        return NO;
    }
}
///FIXME: RCIMConnectionStatusDelegate//网络状态变化
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        [SVProgressHUD showErrorWithStatus:@"您的帐号在别的设备上登录，"@"您被迫下线！"];
        [self gotoLogin];
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        [AFHttpTool getTokenSuccess:^(id response) {
            NSString *token = response[@"result"][@"token"];
            [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            } error:^(RCConnectErrorCode status) {
            } tokenIncorrect:^{}];
        }failure:^(NSError *err) { }];
    }
}
///FIXME: RCIMReceiveMessageDelegate
-(BOOL)onRCIMCustomLocalNotification:(RCMessage*)message withSenderName:(NSString *)senderName{
    //群组通知不弹本地通知
    if ([message.content isKindOfClass:[RCGroupNotificationMessage class]]) {
        return YES;
    }
    return NO;
}
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    if ([message.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *msg = (RCInformationNotificationMessage *)message.content;
        // NSString *str = [NSString stringWithFormat:@"%@",msg.message];
        if ([msg.message rangeOfString:@"你已添加了"].location != NSNotFound) {
            [[RCDRCIMDataSource shareInstance] syncFriendList:[RCIM sharedRCIM].currentUserInfo.userId complete:^(NSMutableArray *friends){}];
        }
    } else if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        RCContactNotificationMessage *msg = (RCContactNotificationMessage *)message.content;
        if ([msg.operation isEqualToString:ContactNotificationMessage_ContactOperationAcceptResponse]) {
            [[RCDRCIMDataSource shareInstance] syncFriendList:[RCIM sharedRCIM].currentUserInfo.userId complete:^(NSMutableArray *friends){}];
        }
    } else if ([message.content isMemberOfClass:[RCGroupNotificationMessage class]]) {
        RCGroupNotificationMessage *msg = (RCGroupNotificationMessage *)message.content;
        if ([msg.operation isEqualToString:@"Dismiss"] && [msg.operatorUserId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:message.targetId];
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:message.targetId];
        } else if ([msg.operation isEqualToString:@"Quit"] || [msg.operation isEqualToString:@"Add"]    ||[msg.operation isEqualToString:@"Kicked"] || [msg.operation isEqualToString:@"Rename"]) {
            if (![msg.operation isEqualToString:@"Rename"]) {
                [RCDHTTPTOOL getGroupMembersWithGroupId:message.targetId Block:^(NSMutableArray *result) {
                    [[RCDataBaseManager shareInstance]
                     insertGroupMemberToDB:result
                     groupId:message.targetId
                     complete:^(BOOL results) {
                     }];
                }];
            }
            [RCDHTTPTOOL getGroupByID:message.targetId successCompletion:^(RCDGroupInfo *group) {
                [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:group.groupId];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"UpdeteGroupInfo"
                 object:message.targetId];
            }];
        }
    }
}
///FIXME:其他私有方法
- (void)gotoLogin{
[UIApplication sharedApplication].delegate.window.rootViewController = [[RCDNavigationViewController alloc] initWithRootViewController:[[FreedomLoginViewController alloc] init]];
}
- (void)loginSuccess:(NSString *)userName userId:(NSString *)userId token:(NSString *)token password:(NSString *)password {
    //保存默认用户
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:@"userName"];
    [defaults setObject:password forKey:@"userPwd"];
    [defaults setObject:token forKey:@"userToken"];
    [defaults setObject:userId forKey:@"userId"];
    [defaults synchronize];
    //保存“发现”的信息
    [RCDHTTPTOOL getSquareInfoCompletion:^(NSMutableArray *result) {
        [defaults setObject:result forKey:@"SquareInfoList"];
        [defaults synchronize];
    }];
    [AFHttpTool getUserInfo:userId success:^(id response) {
        if ([response[@"code"] intValue] == 200) {
            NSDictionary *result = response[@"result"];
            NSString *nickname = result[@"nickname"];
            NSString *portraitUri = result[@"portraitUri"];
            RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId name:nickname portrait:portraitUri];
            if (!user.portraitUri || user.portraitUri.length <= 0) {
                user.portraitUri = [FreedomTools defaultUserPortrait:user];
            }
            [[RCDataBaseManager shareInstance] insertUserToDB:user];
            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
            [RCIM sharedRCIM].currentUserInfo = user;
            [defaults setObject:user.portraitUri forKey:@"userPortraitUri"];
            [defaults setObject:user.name forKey:@"userNickName"];
            [defaults synchronize];
        }
    }failure:^(NSError *err){}];
    //同步群组
    [[RCDRCIMDataSource shareInstance] syncGroups];
    [[RCDRCIMDataSource shareInstance] syncFriendList:userId complete:^(NSMutableArray *friends){}];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].delegate.window.rootViewController = [RCDMainTabBarViewController shareInstance];
    });
}
-(void)gotoLoginViewAndDisplayReasonInfo:(NSString *)reason{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:reason];
        [self gotoLogin];
    });
}
//为消息分享保存会话信息
- (void)saveConversationInfoForMessageShare {
    NSArray *conversationList = [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE), @(ConversationType_GROUP)]];
    NSMutableArray *conversationInfoList = [[NSMutableArray alloc] init];
    if (conversationList.count > 0) {
        for (RCConversation *conversation in conversationList) {
            NSMutableDictionary *conversationInfo = [NSMutableDictionary dictionary];
            [conversationInfo setValue:conversation.targetId forKey:@"targetId"];
            [conversationInfo setValue:@(conversation.conversationType) forKey:@"conversationType"];
            if (conversation.conversationType == ConversationType_PRIVATE) {
                RCUserInfo * user = [[RCIM sharedRCIM] getUserInfoCache:conversation.targetId];
                [conversationInfo setValue:user.name forKey:@"name"];
                [conversationInfo setValue:user.portraitUri forKey:@"portraitUri"];
            }else if (conversation.conversationType == ConversationType_GROUP){
                RCGroup *group = [[RCIM sharedRCIM] getGroupInfoCache:conversation.targetId];
                [conversationInfo setValue:group.groupName forKey:@"name"];
                [conversationInfo setValue:group.portraitUri forKey:@"portraitUri"];
            }
            [conversationInfoList addObject:conversationInfo];
        }
    }
    NSURL *sharedURL = [[NSFileManager defaultManager]containerURLForSecurityApplicationGroupIdentifier:@"group.cn.rongcloud.im.share"];
    NSURL *fileURL = [sharedURL URLByAppendingPathComponent:@"rongcloudShare.plist"];
    [conversationInfoList writeToURL:fileURL atomically:YES];
    NSUserDefaults *shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
    [shareUserDefaults setValue:[RCIM sharedRCIM].currentUserInfo.userId forKey:@"currentUserId"];
    [shareUserDefaults setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserCookies"] forKey:@"Cookie"];
    [shareUserDefaults synchronize];
}
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    NSNumber *left = [notification.userInfo objectForKey:@"left"];
    if ([RCIMClient sharedRCIMClient].sdkRunningMode == RCSDKRunningMode_Background && 0 == left.integerValue) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_APPSERVICE),@(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP)]];
        [UIApplication sharedApplication].applicationIconBadgeNumber =
        unreadMsgCount;
    }
}
//插入分享消息
- (void)insertSharedMessageIfNeed {
    NSUserDefaults *shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
    NSArray *sharedMessages = [shareUserDefaults valueForKey:@"sharedMessages"];
    if (sharedMessages.count > 0) {
        for (NSDictionary *sharedInfo in sharedMessages) {
            RCRichContentMessage *richMsg = [[RCRichContentMessage alloc]init];
            richMsg.title = [sharedInfo objectForKey:@"title"];
            richMsg.digest = [sharedInfo objectForKey:@"content"];
            richMsg.url = [sharedInfo objectForKey:@"url"];
            richMsg.imageURL = [sharedInfo objectForKey:@"imageURL"];
            richMsg.extra = [sharedInfo objectForKey:@"extra"];
            RCMessage *message = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:[[sharedInfo objectForKey:@"conversationType"] intValue] targetId:[sharedInfo objectForKey:@"targetId"] sentStatus:SentStatus_SENT content:richMsg];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RCDSharedMessageInsertSuccess" object:message];
        }
        [shareUserDefaults removeObjectForKey:@"sharedMessages"];
        [shareUserDefaults synchronize];
    }
}
@end
