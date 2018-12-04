xcodeproj ‘Freedom’
workspace ‘Freedom’
platform:ios, '10.0'
inhibit_all_warnings!  # ：屏蔽所有warnings
#source 'https://github.com/Artsy/Specs.git'
target 'Freedom' do
    use_frameworks!
    #pod 'JSONKit', :podspec => 'https://example.com/JSONKit.podspec':指定导入库的podspec文件路径
    #pod '库名', :git => '源码git地址'  :  指定导入库的源码git地址
    #pod '库名', :tag => 'tag名'  :  指定导入库的Tag分支
    #pod 'QueryKit/Attribute'也可以指定一个集合，像下面这样:
    #pod 'QueryKit', :subspecs => ['Attribute', 'QuerySet']
    #Objective-C.frameworks
    pod 'AXWebViewController'
    pod 'SVProgressHUD'
    pod 'MJRefresh'
    pod 'MJExtension'
    pod 'SDWebImage'
    pod 'KissXML'
    pod 'ElasticTransitionObjC'
    pod 'PPRevealSideViewController'
    pod 'AFNetworking'
    pod 'RESideMenu'
    pod 'CocoaAsyncSocket'
    pod 'Masonry'
    pod 'FMDB'
    pod 'Bugly'
    pod 'UMengAnalytics'
    pod 'CocoaLumberjack'
    pod 'BlocksKit'
    pod 'MWPhotoBrowser'
    pod 'UAProgressView'
    pod 'XMLDictionary'
    pod 'FLAnimatedImage'
    pod 'SmartJSWebView'
    pod 'JSONModel'
    pod 'ACMediaFrame'
#    pod 'HYBUnicodeReadable'
    pod 'TZImagePickerController'
    pod 'JSPatch'#https://github.com/bang590/JSPatch
    pod 'ScottAlertController'
    pod 'SSKeychain'  #https://github.com/Mingriweiji-github/sskeychain-master
    pod 'RongCloudIM/IMLib'
    pod 'RongCloudIM/IMKit'
    pod 'RongCloudIM/CallLib'
    pod 'RongCloudIM/CallKit'
    pod 'RongCloudIM/RedPacket'
#Swift.frameworks
pod 'XCarryOn'
pod 'XExtension'
#pod 'XWechartSDK'
pod 'IQKeyboardManagerSwift'
pod 'RealmSwift'
pod 'SnapKit'
pod 'SwiftWebViewBridge'
pod 'Alamofire'
pod 'SwiftyJSON'
pod 'AAInfographics'
pod 'ReactiveCocoa'
pod 'ReactiveSwift'
pod 'RxSwift'
pod 'RxCocoa'
pod 'Moya'
pod 'Moya/RxSwift'
pod 'Moya/ReactiveSwift'

pod 'HandyJSON'
pod 'Starscream'
#其它的
#pod 'SwiftyJSONModel'#冲突了
#pod 'OpenShare'
#pod 'AMap3DMap'
#pod 'AMapNavi'
#pod 'AMap2DMap'#与3D和AMapNavi冲突
#pod 'AMapSearch'
#pod 'AMapLocation'
#pod 'GoogleMaps'
#pod 'GooglePlaces'
#pod 'WechatOpenSDK' #与/Connection冲突，因为已包含WechatSDK。
#pod 'GIFRefreshControl'
#pod 'iCarousel' #集合视图圆圈
#pod 'ZYQAssetPickerController'
#pod 'ViewDeck' #左侧 右侧列表 https://github.com/ViewDeck/ViewDeck
#pod 'CalendarLib' #日历 https://github.com/jumartin/Calendar
#pod 'iOS-Echarts' #图表库 https://github.com/Pluto-Y/iOS-Echarts
#pod 'Pingpp' #支付集成接口，包括支付宝，微信，银联和苹果
#pod 'Pingpp/Alipay'
#pod 'Pingpp/Wx'
#pod 'Pingpp/UnionPay'
#pod 'Pingpp/ApplePay'
#pod 'TMCache'
#pod 'FDFullscreenPopGesture'
#pod 'StarWars'
#pod 'APESuperHUD'
#pod 'JSAnimatedImagesView'
#pod 'YYWebImage'
#pod 'Kingfisher'
#pod 'PKHUD'
#pod 'JSPatchPlatform'
#pod 'WeexSDK'
#pod 'Kingfisher'
#pod 'Zhugeio'
#pod 'pop'
#pod 'MonkeyKing'
#pod 'SWRevealViewController'
#pod 'FTIndicator'
#pod 'swiftScan'
#pod 'APNumberPad'
#pod 'SwiftyTimer'
#pod 'SwiftySound'
#pod 'AVOSCloud'
#pod 'AVOSCloudIM'
#pod 'LeanCloud'#Swift版AVO通讯
#pod 'MIBlurPopup'
#https://github.com/MobClub/ShareSDK-for-iOS
#pod 'MOBFoundation' # 公共库(必须)
#pod 'ShareSDK2'     # 主模块(必须)
#pod 'ShareSDK2/UI'  # UI模块(含所有UI样式,可选)
#pod 'ShareSDK2/Connection'# 分享&登录链接模块(含所有平台,可选)
#pod 'ShareSDK2/Comment'# 评论和赞模块(可选)

end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 8.0
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
            end
        end
    end
end
