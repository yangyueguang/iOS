//
//  AppDelegate.swift
//  Tes
//
//  Created by Super on 6/14/18.
//  Copyright © 2018 Super. All rights reserved.
//
import UIKit
import AVFoundation
import SDWebImage
import Realm
import UserNotifications
import IQKeyboardManagerSwift
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
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UNUserNotificationCenterDelegate{
    var window: UIWindow?
    var taskID :UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)

    var runloopRef: CFRunLoop?
    var audioTimer: Timer?
    var queue: DispatchQueue?
    let launchView: UIImageView = UIImageView()
    var apps = [XAPP]()
    var myApps = [XAPP]()
    static let radialView:XRadiaMenu = XRadiaMenu(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    lazy var items:[[String:String]] = {
        let path = Bundle.main.path(forResource: "FreedomItems", ofType: "plist")!
        let tempItems = NSMutableArray(contentsOfFile: path) as! [[String : String]]
        return tempItems
    }()
    func configRadialView() {
        for i in 0..<items.count {
            let a = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            a.image = UIImage(named: items[i]["icon"]!)
            let mode = PopoutModel(a,items[i]["control"]!)
            AppDelegate.radialView.addPopoutModel(mode)
        }
        AppDelegate.radialView.didSelectBlock = {(menu : XRadiaMenu, didExpand:Bool, didRetract:Bool,mode:PopoutModel?) -> Void in
            if didExpand{
            }else if didRetract{
            }else{
                print("代理通知发现点击了控制器\(mode!.name)")
                if let action = mode?.action{
                    action()
                }else{
                    menu.retract()
                    UIApplication.shared.isStatusBarHidden = false
                    let controlName:String = (mode?.name)!
                    let StoryBoard = UIStoryboard(name: controlName, bundle: nil)
                    let con = StoryBoard.instantiateViewController(withIdentifier:"\(controlName)TabBarController")
                    let animation = CATransition()
                    animation.duration = 0.5
                    animation.type = CATransitionType(rawValue: "cube")
                    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                    self.window?.layer.add(animation, forKey: nil)
                    self.window?.rootViewController = con
                    self.window?.makeKeyAndVisible()
                    menu.removeFromSuperview()
                }
            }
        }
    }
    @objc func showRadialMenu() {
        if AppDelegate.radialView.superview == nil {
            AppDelegate.radialView.center = (window?.center)!
            window?.addSubview(AppDelegate.radialView)
            window?.bringSubviewToFront(AppDelegate.radialView)
        } else {
            AppDelegate.radialView.removeFromSuperview()
        }
    }
    func firstConfigRealm(){
        let appInfo = Bundle.main.infoDictionary
        let versionStr = (appInfo!["CFBundleVersion"] as! String).replacingOccurrences(of: ".", with: "")
        let version = UInt64(versionStr)
        let config : RLMRealmConfiguration = RLMRealmConfiguration.default()
        config.schemaVersion = version!;
        config.migrationBlock = {(migration:RLMMigration,oldSchemaVersion:UInt64) in
            if oldSchemaVersion < 1{
                print("OK")
            }
        }
        RLMRealmConfiguration.setDefault(config)
        RLMRealm.default()
        configRadialView()
    }
    func firstConfigAllAPPIds(){
        IQKeyboardManager.shared.enable = true
        let userDefault = UserDefaults.standard
        let isNotFirst = false//userDefault.bool(forKey: "first")
        if !isNotFirst {
            var allAPPids = [String]();
                userDefault.set(true, forKey: "first")
                userDefault.synchronize()
//                let path = Bundle.main.path(forResource: "app", ofType: "plist")
//                let allAPPDict :[String:String] = NSDictionary(contentsOfFile: path!) as! [String : String]
//                for (key,value) in allAPPDict{
//                    autoreleasepool {
//                        let application = UIApplication.shared
//                        let url = URL(string:value)
//                        if let urla = url{
//                            DispatchQueue.main.async {
//                                if application.canOpenURL(urla){
//                                    allAPPids.append(key)
//                                }
//                            }
//                        }
//                    }
//                }
            print(allAPPids)
            allAPPids = ["472208016", "481294264", "512166629", "547166701", "444934666", "310633997", "461703208", "398453262", "333206289", "577130046", "284882215", "525463029", "454638411", "364787363", "518966501", "1110145109", "414478124", "364709193", "414706506", "932723216", "466122094", "376101648", "861891048", "414245413"]
            self.addInstalledAPPS(allAPPids)
            //            let real = try! RLMRealm()
            //            real.addObjects([RLMObject()])
        }
    }
    func addInstalledAPPS(_ allAPPids:[String]){
        let appMan = AppManager.sharedInstance()
        appMan?.gotiTunesInfo(withTrackIds: allAPPids, completion: { apps in
            DispatchQueue.main.async {
                self.apps = apps!
                var popoutModels = [PopoutModel]()
                for xapp in self.apps{
                    let a = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                    a.image = xapp.icon
                    let mode = PopoutModel(a,xapp.trackName)
                    mode.action = {
                        appMan?.openApp(withBundleIdentifier: xapp.bundleId)
                    }
                    popoutModels.append(mode)
                    print(xapp.trackName)
                }
                AppDelegate.radialView.addPopoutModels(popoutModels)
                self.addMyapps()
            }
        })
    }
    func addMyapps(){
        let myAppsPath = Bundle.main.path(forResource: "MyAPP", ofType: "plist")
        let myApps = NSArray(contentsOfFile: myAppsPath!)
        let apps = XAPP.parses(myApps as! [Any]) as! [XAPP]
        self.myApps = apps;
        let appMan = AppManager.sharedInstance()
        var popoutModels = [PopoutModel]()
        for xapp in self.myApps{
            let a = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            a.image = UIImage(named:xapp.scheme)
            let mode = PopoutModel(a,xapp.trackName)
            mode.action = {
                if xapp.isHiddenApp{//已下架
                    UIApplication.shared.open(URL(string: xapp.trackId)!, options:[:], completionHandler: { (suscess) in
                    })
                }else{
                    appMan?.gotiTunesInfo(withTrackIds: [xapp.trackId], completion: { (app) in
                        if let realApp = app{
                            appMan?.openApp(withBundleIdentifier: realApp.first?.bundleId)
                        }
                    })
                }
            }
            popoutModels.append(mode)
        }
        AppDelegate.radialView.addPopoutModels(popoutModels)
    }
    func firstInitUMeng(){
        MobClick.setCrashReportEnabled(false)
        // 如果不需要捕捉异常，注释掉此行
        MobClick.setLogEnabled(true)
        // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        MobClick.setAppVersion(version!)
        let umconfig = UMAnalyticsConfig.sharedInstance()
        umconfig?.appKey = UMENG_APPKEY
        umconfig?.ePolicy = REALTIME
        MobClick.start(withConfigure: umconfig!)
        /**推送说明：
         我们在知识库里还有推送调试页面加了很多说明，当遇到推送问题时可以去知识库里搜索还有查看推送测试页面的说明。
         首先必须设置deviceToken，可以搜索本文件关键字“推送处理”。模拟器是无法获取devicetoken，也就没有推送功能。
         当使用"开发／测试环境"的appkey测试推送时，必须用Development的证书打包，并且在后台上传"开发／测试环境"的推送证书，证书必须是development的。
         当使用"生产／线上环境"的appkey测试推送时，必须用Distribution的证书打包，并且在后台上传"生产／线上环境"的推送证书，证书必须是distribution的。*/
    }
    func firstInitLaunching(){
        launchView.frame = (self.window?.bounds)!
        launchView.image = UIImage(named:"LaunchImage-700-568h")
        launchView.alpha = 1;
        self.window?.addSubview(launchView)
        self.window?.bringSubviewToFront(launchView)
        UIView.animate(withDuration: 1, delay: 1, options: UIView.AnimationOptions.transitionCurlDown, animations: {
            self.launchView.frame = CGRect(x: -80, y: -140, width: (self.window?.bounds.size.width)! + 160, height: (self.window?.bounds.size.height)! + 320)
            self.launchView.alpha = 0
        }) { (finished) in
            self.launchView.removeFromSuperview()
        }
    }
    func firstInit(){
        firstInitLaunching()
        firstConfigRealm()
        DispatchQueue.global().async {
            self.firstConfigAllAPPIds()
        }
        
        firstInitUMeng()
//        RCDMainTabBarViewController.shareInstance().firstInitRongCloud()
        let backButtonImage = UIImage(named: "u_cell_left")?.withRenderingMode(.alwaysTemplate)
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        if Float(UIDevice.current.systemVersion) ?? 0.0 >= 8.0 {
            UINavigationBar.appearance().isTranslucent = false
        }
//        window?.rootViewController = RCDMainTabBarViewController()
    }
    //FIXME:应用程序启动
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.firstInit()
        //启动页停留1秒钟。
        Thread.sleep(forTimeInterval: 1.0)
        //为了在启动页面不显示statusBar，所以在工程设置里面把statusBar隐藏了，在启动页面过后，显示statusBar。
        application.isStatusBarHidden = false
        /*** 推送处理1*/
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){ (granted, error) in
            if granted {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        //统计推送打开率1
        RCIMClient.shared().recordLaunchOptionsEvent(launchOptions)
        //获取融云推送服务扩展字段1
        let pushServiceData = RCIMClient.shared().getPushExtra(fromLaunchOptions: launchOptions)
        if let pushDict = pushServiceData {
            print("该启动事件包含来自融云的推送服务")
            for (key,value) in pushDict {
                print("\(key)\(value)")
            }
        } else {
            print("该启动事件不包含来自融云的推送服务")
        }
        return true
    }
    //FIXME:远程推送
    ///远程通知注册成功
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tempStr1 = deviceToken.description.replacingOccurrences(of: "<", with: "")
        let tempStr2 = tempStr1.replacingOccurrences(of: ">", with: "")
        let token = tempStr2.replacingOccurrences(of: " ", with: "")
        RCIMClient.shared().setDeviceToken(token)
        var token1 = ""
        for i in 0..<deviceToken.count {
            token1 = token1 + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(token1)
    }
    ///收到远程通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //统计推送打开率2
        RCIMClient.shared().recordRemoteNotificationEvent(userInfo)
        //获取融云推送服务扩展字段2
        let pushServiceData = RCIMClient.shared().getPushExtra(fromRemoteNotification: userInfo)
        if let pushDict = pushServiceData {
            print("该远程推送包含来自融云的推送服务")
            for (key,value) in pushDict {
                print("key = \(key), value = \(value)")
            }
        } else {
            print("该远程推送不包含来自融云的推送服务")
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //统计推送打开率3
//        RCIMClient.shared().recordLocalNotificationEvent(response.notification)
        //震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        AudioServicesPlaySystemSound(1007)
    }
    //FIXME:应用程序生命周期
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
    //即将释放第一响应
    func applicationWillResignActive(_ application: UIApplication) {
        // 设置音频会话类型
//        let session :AVAudioSession = AVAudioSession.sharedInstance()
//        session.setActive(true)
//        session.setCategory(AVAudioSessionCategoryPlayback)
        let status = RCIMClient.shared().getConnectionStatus()
        if status != RCConnectionStatus.ConnectionStatus_SignUp{
            let unreadMsgCount = RCIMClient.shared().getUnreadCount([
                RCConversationType.ConversationType_PRIVATE,
                RCConversationType.ConversationType_DISCUSSION,
                RCConversationType.ConversationType_APPSERVICE,
                RCConversationType.ConversationType_PUBLICSERVICE,
                RCConversationType.ConversationType_GROUP])
            application.applicationIconBadgeNumber = Int(unreadMsgCount)
        }
    }
    ///进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        RCDMainTabBarViewController.shareInstance().saveConversationInfoForMessageShare()
    }
    ///即将进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        if RCIMClient.shared().getConnectionStatus() == RCConnectionStatus.ConnectionStatus_Connected{
            RCDMainTabBarViewController.shareInstance().insertSharedMessageIfNeed()
        }
    }
    ///进入前台
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    ///闪退
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    ///关于iWatch
    func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
        let delegateVC = RCDMainTabBarViewController.shareInstance()
        let handler = RCWKRequestHandler(helperWithUserInfo: userInfo, provider:delegateVC) { (dict) in
        }
        if !(handler!.handleWatchKitRequest()) {
            print("can not handled! app should handle it here not handled the request: \(String(describing: userInfo))");
        }
    }
    // RedPacket_FTR //如果您使用了红包等融云的第三方扩展，请实现下面两个openURL方法
    ///打开其他程序
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if RCIM.shared().openExtensionModuleUrl(url){
            return true
        }
        return true
    }
    ///从其他程序跳入进来的
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if RCIM.shared().openExtensionModuleUrl(url){
            return true
        }
        return true
    }
    //禁止横屏
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    ///收到内存警告
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
//        SDWebImageManager.shared()?.imageCache.clearMemory()
    }
    ///结束
    deinit {
    }
    ///自动更新
    func updateVersionInBackground() {
        var url1 = "http://cloud.189.cn/download/client/iOS/cloud189.plist"
        url1 = "http://dn-mypure.qbox.me/iOS_test.plist"
        let url2 = "itms-services:///?action=download-manifest&url="
        let url = url2 + (url1)
        if let anUrl = URL(string: url) {
            UIApplication.shared.open(anUrl, options: [:], completionHandler: { success in
                exit(0)
            })
        }
    }
    func startRunInbackGround() {
        taskID = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            DispatchQueue.main.async(execute: {
                UIApplication.shared.endBackgroundTask(self.taskID)
                self.taskID = UIBackgroundTaskIdentifier.invalid
            })
        })
        queue?.async(execute: {
            self.audioTimer = Timer(fireAt: Date(), interval: 1000.0, target: self, selector: #selector(self.loopDoInBackground), userInfo: nil, repeats: true)
            self.runloopRef = CFRunLoopGetCurrent()

            RunLoop.current.add(self.audioTimer!, forMode: RunLoop.Mode.default)
            CFRunLoopRun()
        })
    }

    @objc func loopDoInBackground() {
        print("aaa")
    }

    func stopRunInbackGround() {
        CFRunLoopStop(runloopRef)
        audioTimer?.invalidate()
        audioTimer = nil
        UIApplication.shared.endBackgroundTask(taskID)
        taskID = UIBackgroundTaskIdentifier.invalid
    }

}
extension NSURLRequest {
    class func allowsAnyHTTPSCertificate(forHost host: String?) -> Bool {
        return true
    }
}

/*
 -(void)initAPP {
 NSError* error;
 [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
 [[AVAudioSession sharedInstance] setActive:YES error:nil];
 [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
 [[APIManager instance]checkAndClearOutTimePackage];
 NSDictionary *appinfo = [[NSBundle mainBundle] infoDictionary];
 NSString *appVersion = appinfo[@"CFBundleVersion"];
 uint64_t version = [appVersion longLongValue];
 RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
 config.schemaVersion = version;
 config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
 if (oldSchemaVersion < 1) {
 // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
 }
 };
 [RLMRealmConfiguration setDefaultConfiguration:config];
 [RLMRealm defaultRealm];
 }

 +(UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId{
 //设置并激活音频会话类别
 AVAudioSession *session=[AVAudioSession sharedInstance];
 [session setCategory:AVAudioSessionCategoryPlayback error:nil];
 [session setActive:YES error:nil];
 //允许应用程序接收远程控制
 [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
 //设置后台任务ID
 UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
 newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
 if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid){
 [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
 }
 return newTaskId;
 }


 - (void)applicationWillResignActive:(UIApplication *)application {
 //    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
 DLog(@"\n\n倔强的打出一行字告诉你我要挂起了。。\n\n");
 //开启后台处理多媒体事件
 [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
 AVAudioSession *session=[AVAudioSession sharedInstance];
 [session setActive:YES error:nil];
 //后台播放
 [session setCategory:AVAudioSessionCategoryPlayback error:nil];
 //这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放网络歌曲，若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：
 UIBackgroundTaskIdentifier *_bgTaskId=[AppDelegate backgroundPlayerID:UIBackgroundTaskInvalid];
 //其中的_bgTaskId是后台任务UIBackgroundTaskIdentifier _bgTaskId;
 //让app支持接受远程控制事件
 //    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
 }

 - (void)applicationDidEnterBackground:(UIApplication *)application {

 //允许后台播放音乐
 [application beginBackgroundTaskWithExpirationHandler:nil];

 application.applicationIconBadgeNumber = 0;
 }

 - (void)applicationWillEnterForeground:(UIApplication *)application {
 application.applicationIconBadgeNumber = 0;
 }

 - (void)applicationDidBecomeActive:(UIApplication *)application {

 //    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
 }

 - (void)applicationWillTerminate:(UIApplication *)application {
 NSLog(@"applicationWillTerminate");
 [[UIApplication sharedApplication] unregisterForRemoteNotifications];
 }
*/
//    常见变换类型（type）
//    kCATransitionFade//淡出
//    kCATransitionMoveIn//覆盖原图
//    kCATransitionPush  //推出
//    kCATransitionReveal//底部显出来
//SubType:
//    kCATransitionFromRight
//    kCATransitionFromLeft// 默认值
//    kCATransitionFromTop
//    kCATransitionFromBottom
//(type):
//    pageCurl   向上翻一页
//    pageUnCurl 向下翻一页
//    rippleEffect 滴水效果
//    suckEffect 收缩效果
//    cube 立方体效果
//    oglFlip 上下翻转效果
