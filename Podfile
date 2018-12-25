xcodeproj ‘Freedom’
workspace ‘Freedom’
platform:ios, '10.0'
inhibit_all_warnings!  # ：屏蔽所有warnings
#source 'https://github.com/Artsy/Specs.git'
target 'Freedom' do
    use_frameworks!
    #即将手写替代的
#pod 'ScottAlertController'
#pod 'UAProgressView'
#pod 'FLAnimatedImage'
pod 'FMDB'
pod 'StarWars' #swift 3.0

#Objective-C.frameworks
#pod 'HYBUnicodeReadable'
pod 'SSKeychain'  #https://github.com/Mingriweiji-github/sskeychain-master
pod 'AFNetworking'
pod 'AXWebViewController'
pod 'MJRefresh'
pod 'MWPhotoBrowser'
pod 'TZImagePickerController'

#Swift.frameworks
pod 'XCarryOn'
pod 'XExtension'
pod 'IQKeyboardManagerSwift'
pod 'RealmSwift'
pod 'Kingfisher'
pod 'SnapKit'
pod 'Alamofire'
pod 'AAInfographics' #swift 4.0
pod 'ReactiveCocoa'
pod 'ReactiveSwift'
pod 'RxSwift'
pod 'RxCocoa'
pod 'Moya'
pod 'Moya/RxSwift'
pod 'Moya/ReactiveSwift'
pod 'Starscream'

#平台
#支付集成接口，包括支付宝，微信，银联和苹果
#pod 'Pingpp'
#pod 'Pingpp/Alipay'
#pod 'Pingpp/Wx'
#pod 'Pingpp/UnionPay'
#pod 'Pingpp/ApplePay'
pod 'Bugly'
pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'UMengAnalytics'
pod 'RongCloudIM/IMLib'
pod 'RongCloudIM/IMKit'
pod 'RongCloudIM/CallLib'
pod 'RongCloudIM/CallKit'
pod 'RongCloudIM/RedPacket'
#https://github.com/MobClub/ShareSDK-for-iOS
pod 'MOBFoundation' # 公共库(必须)
pod 'ShareSDK2'     # 主模块(必须)
pod 'ShareSDK2/UI'  # UI模块(含所有UI样式,可选)
pod 'ShareSDK2/Connection'# 分享&登录链接模块(含所有平台,可选)
pod 'ShareSDK2/Comment'# 评论和赞模块(可选)
pod 'AVOSCloud'
pod 'AVOSCloudIM'
pod 'LeanCloud'#Swift版AVO通讯

#其它的
pod 'iCarousel' #集合视图圆圈
pod 'iOS-Echarts' #图表库Pluto-Y/iOS-Echarts
pod 'pop'
pod 'MonkeyKing'
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
