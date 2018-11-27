
#import "AppDelegate.h"
#import "FirstViewController.h"
#import "SettingsViewController.h"
#import "LibraryCollectionViewController.h"
#import "User.h"
#import "PlayAudioViewController.h"
//#import "TheAmazingAudioEngine.h"
#import <AVFoundation/AVFoundation.h>
//#import "LaunchViewController.h"
//＝＝＝＝＝＝＝＝＝＝ShareSDK头文件＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//#import <ShareSDK/ShareSDK.h>
//＝＝＝＝＝＝＝＝＝＝以下是各个平台SDK的头文件，根据需要继承的平台添加＝＝＝
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//以下是腾讯SDK的依赖库：
//libsqlite3.dylib
//微信SDK头文件
//#import "WXApi.h"
//新浪微博SDK头文件
//#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
//人人SDK头文件
//#import <RennSDK/RennSDK.h>
//支付宝SDK
//#import "APOpenAPI.h"
//易信SDK头文件
//#import "YXApi.h"
@interface AppDelegate ()
@end
@implementation AppDelegate
//禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    _launchView  = [[UIImageView alloc] initWithFrame:self.window.bounds];
    _launchView.image = [UIImage imageNamed:@"LaunchImage-700-568h"];
    _launchView.alpha = 1;
    [self.window addSubview:_launchView];
    [self.window bringSubviewToFront:_launchView];
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionTransitionNone animations:^{
        _launchView.frame = CGRectMake(-80, -140, self.window.bounds.size.width+160, self.window.bounds.size.height+320); //最终位置
        _launchView.alpha = 0;
    } completion:^(BOOL finished) {
        [_launchView removeFromSuperview];
    }];
    FirstViewController *controller = (FirstViewController *)self.window.rootViewController;
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
//    self.window.rootViewController = nav;
    //检查初次使用标识
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs boolForKey:@"hasRunBefore"] != YES) {
        [prefs setBool:YES forKey:@"hasRunBefore"];
        [prefs synchronize];
        [self readData];
    }
    return YES;
}
- (void)readData {
    self.items = [NSMutableArray arrayWithArray:[User getControllerData]];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // 设置音频会话类型
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    taskID = [application beginBackgroundTaskWithExpirationHandler:nil];//模拟机可以后台 (在真机上不行)
    /**
     *  app的状态
     *  1.死亡状态：没有打开app
     *  2.前台运行状态
     *  3.后台暂停状态：停止一切动画、定时器、多媒体、联网操作，很难再作其他操作
     *  4.后台运行状态
     */
    // 向操作系统申请后台运行的资格，能维持多久，是不确定的
    __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台运行时间已经结束（过期），就会调用这个block
        // 赶紧结束任务
        [application endBackgroundTask:task];
    }];
    // 在Info.plst中设置后台模式：Required background modes == App plays audio or streams audio/video using AirPlay
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application endBackgroundTask:taskID];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
- (BOOL)canResignFirstResponder{
    return YES;
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    DLog(@"remoteControlReceivedWithEvent");
    PlayAudioViewController *pbVC = [PlayAudioViewController shared];
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:[pbVC play];break;
            case UIEventSubtypeRemoteControlPause:[pbVC play];break;
            case UIEventSubtypeRemoteControlStop:[pbVC stop];break;
            case UIEventSubtypeRemoteControlPreviousTrack:[pbVC rewind];break;
            case UIEventSubtypeRemoteControlNextTrack:[pbVC fastForward];break;
            default:break;
        }
    }
}
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
}
#pragma mark - Application's Documents directory
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
//- (PPRevealSideDirection)pprevealSideViewController:(PPRevealSideViewController *)controller directionsAllowedForPanningOnView:(UIView *)view {
//    return PPRevealSideDirectionLeft | PPRevealSideDirectionRight | PPRevealSideDirectionTop | PPRevealSideDirectionBottom;
//}
@end
