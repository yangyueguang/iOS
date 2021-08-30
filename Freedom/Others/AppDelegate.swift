//
//  AppDelegate.swift
//  Tes
//
//  Created by Super on 6/14/18.
//  Copyright © 2018 Super. All rights reserved.
//
import UIKit
import Alamofire
import Kingfisher
import AVFoundation
import UserNotifications
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UNUserNotificationCenterDelegate{
    var window: UIWindow? = UIApplication.shared.keyWindow
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
    }
    func firstConfigWXRealm() {
        let path = "\(FileManager.documentsPath())/User/"
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    func firstConfigAllAPPIds(){
        let userDefault = UserDefaults.standard
        let isNotFirst = userDefault.bool(forKey: "first")
        var allAPPids = [String]()
        if !isNotFirst {
            let path = Bundle.main.path(forResource: "app", ofType: "plist")
            let allAPPDict :[String:String] = NSDictionary(contentsOfFile: path!) as! [String : String]
            for (key,value) in allAPPDict{
                autoreleasepool {
                    let application = UIApplication.shared
                    let url = URL(string:value)
                    if let urla = url{
                        DispatchQueue.main.async {
                            if application.canOpenURL(urla){
                                allAPPids.append(key)
                            }
                        }
                    }
                }
            }
            print(allAPPids)
            userDefault.set(true, forKey: "first")
            userDefault.set(allAPPids, forKey: "apps")
            userDefault.synchronize()
        } else {
            allAPPids = userDefault.array(forKey: "apps") as! [String]
        }
        self.addInstalledAPPS(allAPPids)
    }
    private func addInstalledAPPS(_ allAPPids:[String]){
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
    private func addMyapps(){
        let myAppsPath = Bundle.main.path(forResource: "MyAPP", ofType: "plist")
        let myApps = NSArray(contentsOfFile: myAppsPath!)
        for (_ , dict) in myApps!.enumerated(){
            let dict = dict as! NSDictionary
            let model = XAPP.parse(dict)
            model.isHiddenApp = dict["isHiddenApp"] as? Bool ?? true
            model.trackId = dict["trackId"] as? String
            model.trackName = dict["trackName"] as? String
            model.scheme = dict["scheme"] as? String
            self.myApps.append(model)
        }
        let appMan = AppManager.sharedInstance()
        var popoutModels = [PopoutModel]()
        for xapp in self.myApps{
            let a = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            a.image = xapp.scheme.image
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
        MobClick.setLogEnabled(true)
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        MobClick.setAppVersion(version!)
        let umconfig = UMAnalyticsConfig.sharedInstance()
        umconfig?.appKey = UMENG_APPKEY
        umconfig?.ePolicy = REALTIME
        umconfig?.channelId = APP_CHANNEL
        MobClick.start(withConfigure: umconfig!)
    }
    func firstInitLaunching(){
        DispatchQueue.main.async {
        self.launchView.frame = (self.window?.bounds)!
        self.launchView.image = Image.launch.image
        XNetKit.luanch({[weak self] (resource) in
            guard let `self` = self else { return }
            self.launchView.kf.setImage(with: URL(string: resource))
        })
        self.launchView.alpha = 1;
        self.window?.addSubview(self.launchView)
        self.window?.bringSubviewToFront(self.launchView)
        UIView.animate(withDuration: 3, delay: 0, options: UIView.AnimationOptions.transitionCurlDown, animations: {
            self.launchView.frame = CGRect(x: -80, y: -140, width: (self.window?.bounds.size.width)! + 160, height: (self.window?.bounds.size.height)! + 320)
            self.launchView.alpha = 0
        }) { (finished) in
            self.launchView.removeFromSuperview()
        }
        }
    }
    func firstInitNetKit() {
        let requestConfig = XNetKit.kit.config
        requestConfig.scheme = "https://"
        requestConfig.domain = "www.easy-mock.com"
        requestConfig.port = ""
        requestConfig.baseURL = "mock/5c1898ad37831a75ccf47a8f/api"
        requestConfig.method = HTTPMethod.post
        let responseConfig = APIResponse.APIResponseConfiguration.shared
        responseConfig.codeKey = "code"
        responseConfig.successCode = 200
        responseConfig.dataKey = "data"
        responseConfig.messageKey = "message"
    }
    func firstInit(){
        firstInitNetKit()
//        firstInitLaunching()
        firstConfigRealm()
        firstConfigWXRealm()
        firstInitUMeng()
        firstConfigAllAPPIds()
        configRadialView()
    }
    //FIXME:应用程序启动
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.firstInit()
        IQKeyboardManager.shared.enable = true
        let backButtonImage = Image.left.image.withRenderingMode(.alwaysTemplate)
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        if Float(UIDevice.current.systemVersion) ?? 0.0 >= 8.0 {
            UINavigationBar.appearance().isTranslucent = false
        }
        Thread.sleep(forTimeInterval: 1.0)
        application.isStatusBarHidden = false
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){ (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        return true
    }
    //FIXME:远程推送
    ///远程通知注册成功
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tempStr1 = deviceToken.description.replacingOccurrences(of: "<", with: "")
        let tempStr2 = tempStr1.replacingOccurrences(of: ">", with: "")
        let token = tempStr2.replacingOccurrences(of: " ", with: "")
        var token1 = ""
        for i in 0..<deviceToken.count {
            token1 = token1 + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(token1)
    }
    ///收到远程通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("该远程推送不包含来自融云的推送服务")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        RCIMClient.shared().recordLocalNotificationEvent(response.notification)
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
    }
    ///进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    ///即将进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    ///进入前台
    func applicationDidBecomeActive(_ application: UIApplication) {

    }
    ///闪退
    func applicationWillTerminate(_ application: UIApplication) {

    }
    ///关于iWatch
    func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
        print(String(describing: userInfo));
        
    }
    // RedPacket_FTR //如果您使用了红包等融云的第三方扩展，请实现下面两个openURL方法
    ///打开其他程序
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    ///从其他程序跳入进来的
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }
    //禁止横屏
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    ///收到内存警告
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {

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
