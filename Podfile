xcodeproj ‘Freedom’
workspace ‘Freedom’
platform:ios, '10.0'
inhibit_all_warnings!
#source 'https://github.com/yangyueguang/MyCocoaPods.git'
target 'Freedom' do
    use_frameworks!
pod 'FMDB'
#Objective-C.frameworks
#pod 'HYBUnicodeReadable'
pod 'SSKeychain'  #https://github.com/Mingriweiji-github/sskeychain-master
pod 'AFNetworking'
pod 'MJRefresh'
pod 'MWPhotoBrowser'
pod 'TZImagePickerController'
pod 'iCarousel' #集合视图圆圈
pod 'iOS-Echarts' #图表库Pluto-Y/iOS-Echarts

#Swift.frameworks
pod 'XCarryOn'
pod 'XExtension'
pod 'RealmSwift'
pod 'Kingfisher'
pod 'SnapKit'
pod 'Alamofire'
pod 'RxSwift'
pod 'RxCocoa'
pod 'ReactiveSwift'
pod 'ReactiveCocoa'
pod 'Starscream'
pod 'MonkeyKing'
pod 'AAInfographics' #swift 4.0
pod 'IQKeyboardManagerSwift'

#平台
pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'UMengAnalytics'
pod 'AVOSCloud'
pod 'AVOSCloudIM'
#pod 'LeanCloud'#Swift版AVO通讯
pod 'RongCloudIM/IMLib'
pod 'RongCloudIM/IMKit'
pod 'RongCloudIM/CallLib'
pod 'RongCloudIM/CallKit'
pod 'RongCloudIM/RedPacket'
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
