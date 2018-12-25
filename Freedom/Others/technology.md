#
# 前言
本框架是由Super为期一周时间设计的用于iOS_APP开发的框架，分类清晰，设计巧妙，封装性好。如果在使用中遇到什么问题可以及时修改优化本框架。
熟练使用本框架的人基本掌握了以下开发能力:
* 1、掌握C/Objective-C /CocoaTouch编程，对Swift略有涉猎。
* 2、熟悉各种UI控件，熟悉多视图开发，能够实现复杂的界面交互以及应用间通讯。
* 3、熟练使用MacOS、Xcode、iOS_SDK、framework及xib和storyboard与autoLayout等开发工具。
* 4、熟练使用UIView、CoreAnimation、ImageView等动画和各种手势及特效优化APP产品。
* 5、熟悉MVC、委托代理、单例、工厂方法和观察者模式等常用设计模式。
* 6、熟练使用NSURLSession、 AFNetworking进行网络数据请求。
* 7、熟练使用AFNetworking、MBProgressHUD、MJRefresh等三方库。
* 8、熟练掌握GCD、NSOperation、NSThread多线程编程技术。
* 9、熟悉NSUserDefault、Plist和Json等数据持久化技术及网络数据的解析。
* 10、了解地图定位、定制大头针、搜索、导航、地理编码与反编码等功能。
* 11、高新技术：二维码、摇一摇、蓝牙技术、发短信打电话发邮件、应用间切换、本地通知。
#
#简介
SuperAPP框架是集合了以下功能系列：
1.是主流的APP框架，四个tabBar，分别为首页、服务、发现、我的。
2.启动从storyboard和APPDelegate启动，首先会启动utility/BaseFile/HomeTabBarController，该类调用自定义的HomeTabBar和HomeNavigationController。
3.初始设置绑定storyboard对应的TabBarcontroller和NavigationController并做相应的配置。
4.启动自带Coredata数据库处理功能，使用github源代码管理工具Cocoapods导入第三方库。
5.Utility类封装了有关登录注册 userDefaults 时间戳 数据格式化 定位 振动与抖动提醒 视图与界面 元件创建  蓝牙 语音识别 支付 分享 即时聊天 打电话以及版本更新等功能。
6.Foundation用于封装系统中常用的简单方法，Foundation_API用于封装系统要用到的所有外界接口连接，Foundation_defines用于封装第三方平台需要注册的内容（如支付宝、微信、百度等）。
7.category文件夹聚集了常用的系统类的功能扩展，让开发更加随意简便。
8.BaseFile文件夹封装了最为常用的类，继承之可以急速创建好相应的功能和界面。如UIViewController,UITableView,UIScrollVie,UICollectionView。
9.尽量所有界面控制器都继承BaseViewController 其封装的TableView和CollectionView以及界面跳转之间的传值等功能很好用。
10.another文件夹中放有常用到的注册、登录和找回密码的功能与界面。
11.Others/language文件是大字典用于匹配APP的中英文，只需要用宏定义一个方法就可以自由切换中英文状态。
12.系统采用逻辑性文件夹管理模式，四个主功能分别存放四个文件夹，ThirdSDK存放无法通过cocoapods自动导入的第三方库，如微信SDK，支付宝SDK，百度SDK等。
13.Others文件夹存放平时少用到的系统文件，如Coredata，AppDelegate，PrefixHeader，main，info，readme等。
14.utility存放开发过程中经常用到的方法，分别封装在对应的类之中。
15.resource和Assets用于存放开发中要用到的本地文件，如图片、plist、txt等。框架采用cocoapods，详情可见Podfile，详细记录使用了那些三方库，它们的功能及网址。
#
#更新记录
* 1、使用Cocoapods建立了整个APP系统层，包括网络请求框架，图片缓存框架，JSON与对象，友盟分享，SharedSDK，提示性信息，数据库，即时聊天，特效以及其他系列功能架构。                 2016.09.01
* 2、建立了整个APP辅助层，包括各个系统类功能的扩展、分类和继承以及基本类，如BaseViewController，categorys,手动导入的三方库。                                              2016.09.02
* 3、完善了APP整个框架的基本配置，如info.plist,PrefixHeader,Foundation,README记录,封装了工具类Utility，导入了应用中可能用到的系列库(Linked Frameworks and Libraries)。  2016.09.03
* 4、建立了Coredata使用框架以及Database使用框架，应用中将充分利用Coredata，Database，Sqlite，Plist，Archive,本地文件(如TXT)读取结合网络请求与JSON解析处理数据。            2016.09.04
* 5、建立了APP整个框架结构的文件夹，有效分类了所有功能系列，并建立了所有功能应用的基础框架，如各自的Storyboard，TabBarViewController，ViewController。                      2016.09.05
* 6、建立了基本的数据库系列，如icons.txt  TotalData  UserData.plist  MyCoreData.xcdatamodeld  Coredata.json                                                     2016.09.06
* 7、引入了APP整个系列功能要用到的通用图片。                                                                                                                      2016.09.07
* 8、修复了已知bug和冲突，如MRC与ARC，Objective和Swift，配置了APPICON，LaunchScreen，真机测试运行成功。                                                              2016.09.08
#
#未完成的功能
* 1、微信支付
* 2、支付宝支付
* 3、第三方登录与分享
* 4、即时聊天
* 5、蓝牙
* 6、远程推送
#
#个人简介
1.	本人酷爱互联网行业的软件开发工作，做事积极负责，有很强的内驱力。
2.	基础扎实，思路清晰，有良好的编程习惯，结构清晰，命名规范，逻辑性强，代码冗余率低。
3.	具有较强需求分析、逻辑思维、程序设计、技术钻研精神。
4.	另外心思缜密，创新意识，文档写作，组织协调沟通与表达以及团队合作的能力。
5.	自学能力强，勇于面对和克服困难，能承受较大的工作压力。
#
#高新技术
1.支付宝相关功能接入:支付 会员 营销 理财 开店 社交功能。 https://open.alipay.com/platform/home.htm
2.微信相关功能接入:移动应用开发 网站应用开发 公众号开发 公众号第三方开发  支付 登录 分享 收藏 图像识别 语音识别 语音合成 语义理解。 https://open.weixin.qq.com
3.MOB接入:社会化分享 免费短信验证码 手游录像分享 MobAPI。 http://www.mob.com
4.融云RONGCLOUD接入:IM系列 即时聊天 音视频通讯 视频直播 在线客服 推送和短信。http://www.rongcloud.cn
5.网易云信接入:IM即时通讯 音视频通讯 教学白板 聊天室 短信  http://netease.im  网易视频云接入:直播 点播 互动直播 http://vcloud.163.com 网易易盾接入:广告过滤 智能鉴黄 暴恐识别 谣言排查 http://dun.163.com
6.环信接入:IM即时通讯 音视频通讯 多种消息格式 红包功能 http://www.easemob.com
7.容联云通讯:IM即时通讯+办公 音视频通讯 红包 电话 短信 语音通知 http://www.yuntongxun.com
8.友盟接入:大数据 应用统计 线下分析 行业报告 分享 推送 http://www.umeng.com
9.个推接入:推送  http://www.getui.com
10.腾讯云接入:云服务器 云硬盘 云API 云通讯 短信 视频服务 推送 https://www.qcloud.com
11.极光接入:推送 IM即时通讯 短信 统计 https://www.jiguang.cn
12.FFmpeg接入:音视频编码、解码、记录、转换，视频直播等功能。https://ffmpeg.org  
案例:http://download.csdn.net/download/baitxaps/8657935  https://github.com/leixiaohua1020/simplest_ffmpeg_mobile  https://github.com/xiayuanquan/FFmpegDemo
13.微吼直播接入:直播功能。http://www.vhall.com/business/page-85.html
14.科大讯飞接入:语音识别 语音合成 语音扩展 人脸识别 声纹识别 http://www.xfyun.cn
15.百度接入http://open.baidu.com http://app.baidu.com
16.百度云接入:https://cloud.baidu.com
17.百度阅读接入:http://yuedu.baidu.com
18.腾讯接入:http://open.qq.com
19.阿里巴巴接入:https://open.1688.com
高端案例
指纹识别登录 https://github.com/zonghongyan/EVNTouchIDDemo
iOS操作HTML5页面及JS交互 http://www.jianshu.com/p/8ceb99e154f7 http://blog.csdn.net/zhangmengleiblog/article/details/51801994 http://www.cnblogs.com/wanxudong/p/5581367.html
推送教程http://www.2cto.com/kf/201607/530214.html http://www.jb51.net/Special/888.htm
邓白氏码申请教程https://developer.apple.com/support/D-U-N-S/cn/
数据库操作管理软件http://www.orsoon.com/Mac/85386.html
iOS录音并播放http://blog.sina.com.cn/s/blog_7d1531ed01019cxb.html
音视频录制、播放与处理http://www.cnblogs.com/kenshincui/p/4186022.html
iOS开发系列--通讯录、蓝牙、内购、GameCenter、iCloud、Passbook系统服务开发汇总 http://www.cnblogs.com/kenshincui/p/4220402.html
iOS开发系列--Swift语言http://www.cnblogs.com/kenshincui/p/4717450.html  http://www.cnblogs.com/kenshincui/p/4824810.html http://www.cnblogs.com/kenshincui/p/5594951.html
iOS开发系列--扩展http://www.cnblogs.com/kenshincui/p/5644803.html
iOS开发系列--Kenshin博客 http://www.cnblogs.com/kenshincui/default.aspx
iOS语音通话（语音对讲）http://blog.csdn.net/u011619283/article/details/39613335
史上最全的开源库整理http://blog.csdn.net/u010551217/article/details/52946139  http://blog.csdn.net/liu1039950258/article/details/51656144
#
#支付心得
//IOS之收集到的很好的网址（博客，网站）http://www.cnblogs.com/goodboy-heyang/category/733290.html
//GitHub 上有哪些完整的 iOS-App 源码值得参考？http://www.cnblogs.com/goodboy-heyang/p/5248379.html
//酷炫动画github源码下载地址：https://github.com/lichtschlag/Dazzle
//IOS开发之支付功能概述 http://www.cnblogs.com/goodboy-heyang/p/5252159.html
//本工具类封装了微信和支付宝的接口，内涵微信的发消息或文件到朋友，朋友圈以及收藏内容还有分享到支付宝的消息。还有微信支付和支付宝支付的功能。另含微信的高级接口包括语音识别，图像识别等。
#pragma mark 微信接入https://open.weixin.qq.com
/* 1.接入微信必须注册一个微信开放平台账号：https://open.weixin.qq.com
2.填写相关资料及实名认证并花300元申请开发者资质认证。https://open.weixin.qq.com/cgi-bin/profile?t=setting/dev&lang=zh_CN&token=8699abf1cc006cd477c0fa38add3e628394455d6
3.在管理中心按需创建应用的相关信息并开通相应的功能(移动应用、网站应用、公众账号、公众号第三方平台),获取AppKey和AppSecret.https://open.weixin.qq.com/cgi-bin/applist?t=manage/list&lang=zh_CN&token=8699abf1cc006cd477c0fa38add3e628394455d6
4.如果开通了微信支付填写好相应的信息审核通过会下发一个商户账号(如:账号:1419747302@1419747302密码:847281 APPID:wx1e84e84a6e551aff)，根据商户账号密码到网址登录可查看用户交易等数据信息。https://pay.weixin.qq.com/index.php/core/info
5.在资源中心阅读相应的开发文档。https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&lang=zh_CN&token=8699abf1cc006cd477c0fa38add3e628394455d6&appid=wx1e84e84a6e551aff
6.下载微信SDK并配置开发环境。https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417694084&token=8699abf1cc006cd477c0fa38add3e628394455d6&lang=zh_CN
7.在APPDelegate中导入头文件WXApi.h并遵守WXApiDelegate。在didFinishLaunch中注册微信ID及Secret。参照demo重写AppDelegate的handleOpenURL和openURL方法。
8.参照开发文档，按需接入微信登录、发消息、分享、收藏、支付、图像识别、语音识别、语音合成、语义理解
9.在数据中心可查看微信用户的分析数据以及分享、收藏、登录、智能等用户行为统计数据信息。https://open.weixin.qq.com/cgi-bin/frame?t=statistics/analysis_tmpl&lang=zh_CN&token=8699abf1cc006cd477c0fa38add3e628394455d6
10.微信样例//@简书地址:   http://www.jianshu.com/p/af8cbc9d51b0  @Github地址: https://github.com/lyoniOS/WxPayDemo
##https://github.com/SwiftyJSON/SwiftyJSON
#pod 'ACMediaFrame'
##https://github.com/honeycao/ACMediaFrame 媒体库选择和展示的框架。
#pod 'TZImagePickerController'
#pod 'SDCycleScrollView'
##https://github.com/gsdios/SDCycleScrollView 图片轮播
#pod 'JHChart'
#pod 'AAInfographics'
##https://github.com/AAChartModel/AAChartKit-Swift
#pod 'HYBUnicodeReadable'
#pod 'ReactiveCocoa', '~> 7.0'
#pod 'ReactiveSwift', '~> 3.0'
##https://github.com/ReactiveCocoa/ReactiveSwift
#pod 'SwiftyJSONModel'
#pod 'RxSwift',    '~> 4.0'
#pod 'RxCocoa',    '~> 4.0'
#pod 'SmartJSWebView'
##https://github.com/pcjbird/SmartJSWebView/
#pod 'Moya/RxSwift'
##https://github.com/Moya/Moya
#pod 'Moya/ReactiveSwift', '~> 11.0'
#这是一个不错的小伙子，封装了好多有用的东西。
#https://github.com/NJHu/iOSProject
#https://github.com/vsouza/awesome-ios
#https://github.com/xswm1123/TYSlidePageScrollView
#https://github.com/codeWorm2015/videoPlayer
*/
#pragma mark 支付宝接入https://open.alipay.com
/*1.接入支付宝必须注册一个支付宝账户：https://open.alipay.com/platform/home.htm
2.填写相关资料及实名认证并设置应用密匙其他项可选设置，获取AppID和AppSecret。https://openhome.alipay.com/platform/setting.htm https://doc.open.alipay.com/docs/doc.htm?spm=a219a.7629140.0.0.ZyhHVp&treeId=193&articleId=105310&docType=1
3.在研发管理创建应用并填写相应信息以及开通相应功能。https://openhome.alipay.com/platform/appManage.htm
4.在文档中心详细阅读支付宝接入文档。https://doc.open.alipay.com
5.下载支付宝SDK并集成开发环境。https://doc.open.alipay.com/doc2/detail.htm?treeId=204&articleId=105295&docType=1  https://doc.open.alipay.com/doc2/detail.htm?treeId=54&articleId=104509&docType=1
6.在AppDelegate中导入<AlipaySDK/AlipaySDK.h>头文件并参照demo重写openURL的方法。
7.在文档中心详细阅读支付宝API文档。https://doc.open.alipay.com/doc2/apiList?docType=4
8.按需接入支付宝的相应功能。支付能力、理财能力、口碑开店能力、会员营销、支付宝卡券、会员能力、生活号、行业能力、信用能力、安全能力、云监控、社交能力、服务市场管理以及基础能力。
报错：openssl/asn1.h file not found 在header searchPaths：$(PROJECT_DIR)/GuangFuBao/wechart&alipay/alipaySKD
使用alipaySDK需要在buildsettings searchPath header  增加这一行："$(SRCROOT)/SuperAPP框架/ThirdSDK/alipaySDK"
支付宝样例http://www.jianshu.com/p/b3063678c462
*/
#pragma mark 支付宝分享
/*1.导入alipayShareSDK然后做一般情况下相应的配置。
2.在AppDelegate遵守APOpenAPIDelegate协议，在didFinishLaunching方法中注册申请的appID：[APOpenAPI registerApp:@"alisdkdemo"]，在application:openURL方法中[APOpenAPI handleOpenURL:url delegate:self]
3.重写两个方法
//收到一个来自支付宝的请求，第三方应用程序处理完后调用sendResp向支付宝发送结果
- (void)onReq:(APBaseReq*)req{}
//  第三方应用程序发送一个sendReq后，收到支付宝的响应结果*resp : 第三方应用收到的支付宝的响应结果类，目前支持的类型包括 APSendMessageToAPResp(分享消息)
- (void)onResp:(APBaseResp*)resp{}
*/
#pragma mark 苹果官方支付https://developer.apple.com https://developer.apple.com/apple-pay/
/*1.不用导入三方库，也不用在AppDelegate中设置什么。target导入PassKit.framework库。
2.注册 Merchant ID。使用 Apple Pay 的前提是必须注册一个 `Merchant ID`
a. 在开发者后台选择 [Merchant IDs 标签](https://developer.apple.com/account/ios/identifiers/merchant/merchantCreate.action) ，设置你的 `Merchant ID`，注册系统会默认添加 `merchant.` 前缀，如下图 ![merchant id](imgs/merchant_id.png)
b. 注册完成后再次选择 [Merchant IDs 标签](https://developer.apple.com/account/ios/identifiers/merchant/merchantList.action)，在列表中点击 `ApplePayDemo`，点击 `Edit`
c. 由于我们是在中国区使用 `Apple Pay`，所以在 `Merchant Settings` 的 `Are you processing your payments outside of the United States?` 选项中勾选 `Yes` ![outside us](imgs/outside_us.png)
d. 继续生成 `CSR`，这一步跟 `APNS` 的 `CSR` 生成步骤是一样的，不再赘述，请大家参考相关资料
3.注册 App ID
a. 在开发者后台选择 [App IDs 标签](https://developer.apple.com/account/ios/identifiers/) 注册 `App ID` 并指定 `Bundle ID`，例如 `com.example.appid`，在 `App Services` 中记得勾选 `Apple Pay`   ![App Services](imgs/app_services.png)
b. 注册完成再次选择 [App IDs 标签](https://developer.apple.com/account/ios/identifiers/)，点击刚才所注册的 `App ID`，点击 `Edit` 按钮  ![App ID Settings](imgs/app_id_settings.png)
c. 在 `Apple Pay` 中点击 `Edit`，然后选择你刚才生成的 `Merchant ID` ![configure merchant id](imgs/app_id_configure_merchant_id.png)
4. 生成 `Provisioning Profile` 并配置 Xcode 项目
a. 在开发者后台选择 [Provisioning Profiles 标签](https://developer.apple.com/account/ios/profile/profileList.action) ，根据刚才的 `App ID` 生成 `Profile`，完成后下载文件，双击文件完成导入
b. 创建 Xcode 项目，设置相应的 `Bundle ID`。完成后在项目的 `TARGETS` 项中选择 `Capabilities` 标签，打开 `Apple Pay` 选项并配置相应的 `Merchant ID` </br>
c.打开wallet，设置allow all。![Xcode project settings](imgs/xcode_project_settings.png)
5. 开发。在开发中需要用的类
#import <PassKit/PassKit.h>并遵守<PKPaymentAuthorizationViewControllerDelegate>协议。实现见Wechart&AlipayViewController。如有疑问查看ApplePay文件夹图片。
*/
#pragma mark 银联支付https://open.unionpay.com/ajweb/index
/*1.接入银联必须先注册银联开发账号，然后按照指引往下走。https://open.unionpay.com/ajweb/help/toPage
2.选择银联服务产品查看说明然后登陆商户服务系统选择创建相应的服务https://open.unionpay.com/ajweb/product https://merchant.unionpay.com/portal/
3.导入银联的SDK，info中加入URL Schemes:UPPayDemo。设置OtherLinkerFlags:-ObjC  导入LocalAuthentication.framework  libPaymentControl.a  CFNetwork.framework  libz.tbd  SystemConfiguration.framework
4.在AppDelegate中引入头文件并加入对应的代码：代码见notes.md文件
5.参考API进行开发 https://open.unionpay.com/ajweb/help/api
详情见Wechart&AlipayViewController
*/
#pragma mark 连连支付 https://apple.lianlianpay.com/OpenPlatform/
/*
1.接入连连支付ApplePay必须注册连连开发账号。邮箱激活即可获得AppID。创建应用。在苹果官网登陆apple账号注册Merchant ID。下载连连的csr文件上传到苹果并下载对应的cer证书，上传该cer证书到连连并提交。
2.查看待完成事项，完善商户基本信息、财务信息并签署纸质合同回寄到指定地址。https://apple.lianlianpay.com/OpenPlatform/appAdmin.action
3.下载LianlianSDK，查看连连技术文档，开始开发。https://apple.lianlianpay.com/OpenPlatform/technical_documents.jsp
4.其中有个静态库.a与支付宝的静态库冲突，删除即可：libRsaCrypto.a
*/
#pragma mark QQ钱包支付 http://qpay.qq.com/
/*
1.接入QQ钱包必须注册QQ钱包开发账号。填写经营信息、商户信息、结算账户、提交审核、验证账户、签署协议、接入成功。
2.查看开发文档，选择接入方式。下载SDK，根据开发文档配置环境开始开发。https://qpay.qq.com/qpaywiki.shtml
3.记得在info中添加:LSApplicationQueriesSchemes:mqqwallet
*/
#pragma mark web支付 https://www.baidu.com
//直接跳转支付的网页即可，说明略。
