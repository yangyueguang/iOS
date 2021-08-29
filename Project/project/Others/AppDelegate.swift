//
//  AppDelegate.swift
//  project
//
//  Created by Super on 2017/9/8.
//  Copyright © 2017年 Super. All rights reserved.
//

import UIKit
import AVFoundation
//import Bugly
//import Realm
//import GoogleMaps
//import GooglePlaces
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {//WXApiDelegate
    var window: UIWindow?
    let AMapKey = ""
    let GoogleMapKey = ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let config = RLMRealmConfiguration.default()
//        config.schemaVersion = 1
//        config.migrationBlock = {(_ migration: RLMMigration, _ oldSchemaVersion: UInt64) -> Void in
//            if oldSchemaVersion < 1 {}
//        }
//        RLMRealmConfiguration.setDefault(config)
//        RLMRealm.default()
        return true
    }
            
    class func backgroundPlayerID(_ backTaskId: UIBackgroundTaskIdentifier) -> UIBackgroundTaskIdentifier {
        //设置并激活音频会话类别
        let session = AVAudioSession.sharedInstance()
        try? session.setActive(true)
        //允许应用程序接收远程控制
        UIApplication.shared.beginReceivingRemoteControlEvents()
        //设置后台任务ID
        var newTaskId: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
        newTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: { 
            if newTaskId != UIBackgroundTaskIdentifier.invalid && backTaskId != UIBackgroundTaskIdentifier.invalid {
                UIApplication.shared.endBackgroundTask(backTaskId)
            }
        })
        return newTaskId
    }

    func applicationWillResignActive(_ application: UIApplication) {
        //[BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
        print("\n\n倔强的打出一行字告诉你我要挂起了。。\n\n")
        //开启后台处理多媒体事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let session = AVAudioSession.sharedInstance()
        try? session.setActive(true)
        let _: UIBackgroundTaskIdentifier? = AppDelegate.backgroundPlayerID(UIBackgroundTaskIdentifier.invalid)
        //其中的_bgTaskId是后台任务UIBackgroundTaskIdentifier _bgTaskId;
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //允许后台播放音乐
        application.beginBackgroundTask { 
            application.applicationIconBadgeNumber = 0
        }
    }
    
    //作为从背景到活动状态的转换的一部分调用，在这里您可以撤消在进入后台时所做的许多更改。
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    //[BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
    }
    //当应用程序即将终止时调用。如果需要保存数据。见applicationDidEnterBackground
    func applicationWillTerminate(_ application: UIApplication) {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    // MARK: - 如果使用SSO（可以简单理解成客户端授权），以下方法是必要的
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return true
    }
        
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }
   // NOTE: 9.0以后使用新API接口
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if (url.host == "safepay") {
//        // 支付跳转支付宝钱包进行支付，处理支付结果
//            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic:[AnyHashable : Any]?) in
//                print("result = \(String(describing: resultDic))")
//            })
//        }
//        // 授权跳转支付宝钱包进行支付，处理支付结果
//        AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (resultDic:[AnyHashable : Any]?) in
//            print("result = \(String(describing: resultDic))")
//        })
//        //微信的
//        WXApi.handleOpen(url, delegate: WXApiManager.shared())
//        ShareSDK.handleOpen(url, wxDelegate: self)
        return true
    }
}

