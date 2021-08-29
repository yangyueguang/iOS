
//
//  FoundationSwift.swift
//  Freedom
//
//  Created by Super on 2018/5/18.
//  Copyright © 2018年 Super. All rights reserved.
//
import Foundation
//import XExtension
//import XCarryOn
public let TabBarH:CGFloat = 49
let safeAreaTopHeight:CGFloat = (APPH >= 812.0 && UIDevice.current.model == "iPhone" ? 88 : 64)
let safeAreaBottomHeight:CGFloat = (APPH >= 812.0 && UIDevice.current.model == "iPhone"  ? 30 : 0)
let statusBarHeight = UIApplication.shared.statusBarFrame.height
public let TestWebURL = "https://www.baidu.com"
let APP_CHANNEL = "Github"
let PlaceHolder = " "
let baseDomain = "www.baidu.com"
let basePort = "80"
let basePath = "app"
let basePicPath = "www.baidu.com/"
let BaseURL = "http://www.isolar88.com/app/upload/xuechao"
//*****************           支      付     宝           ******************
let PartnerID = ""
let SellerID = "zfb@"
let MD5_KEY = ""
let AlipayPubKey = ""
let alipayBackUrl = ""
//*****************           微             信           ******************
// UMeng

public let UMENG_APPKEY = "563755cbe0f55a5cb300139c"
//let UMENG_APPKEY = "56b8ba33e0f55a15480020b0"
let JSPATCH_APPKEY = "7eadab71a29a784e"
// 七牛云存储
let QINIU_APPKEY = "28ed72E3r7nfEjApnsHWQhItdqyZqTLCtcfQZp9I"
let QINIU_SECRET = "aRYPqQYF9rK9EVJfcu849VY0PAky2Sfj97Sp349S"
// Mob SMS
let MOB_SMS_APPKEY = "1133dc881b63b"
let MOB_SMS_SECRET = "b4882225b9baee69761071c8cfa848f3"
let GoogleAppKey = "AIzaSyCegO8LjPujwaTtxijzowN3kCUQTop8tRA"
// 融云
let RONGCLOUD_IM_APPKEY = "n19jmcy59f1q9"
let defaultImageURL = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550771613747&di=0ff113da8eb2c2053bc5cd9083e1eeff&imgtype=0&src=http%3A%2F%2Fimg.besoo.com%2Ffile%2F201706%2F06%2F1920004445908.jpg"
//@"k51hidwqked9b" //自由主义
//@"n19jmcy59f1q9" //online key
//@"c9kqb3rdkbb8j" //pre key
//@"e0x9wycfx7flq" //offline key
//*****************           微             博           ******************
//*****************               shareSDK               ******************
//*****************           百      度    SDK           ******************
//*****************           科   大   讯   飞           ******************
//*****************           易            信           ******************
//*****************           蓝            牙           ******************
