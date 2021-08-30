xcodeproj ‘Freedom’
workspace ‘Freedom’
platform:ios, '10.0'
inhibit_all_warnings!
target 'Freedom' do
use_frameworks!
#Objective-C.frameworks
#pod 'HYBUnicodeReadable'
pod 'SSKeychain'  
pod 'AFNetworking'
pod 'MJRefresh'
pod 'MWPhotoBrowser'
pod 'TZImagePickerController'
pod 'iCarousel'
pod 'iOS-Echarts'

#Swift.frameworks
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
pod 'LeanCloud'
end

post_install do |installer|
   installer.pods_project.targets.each do |target|
       target.build_configurations.each do |config|
           config.build_settings['ENABLE_BITCODE'] = 'NO'
       end
   end
end
