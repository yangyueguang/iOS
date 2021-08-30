#
#安装cocoapods
```sudo gem install cocoapods
pod setup
如果失败，运行下面命令
sudo gem update --system
gem sources -l
gem sources --remove https://rubygems.org/
gem sources -a http://ruby.taobao.org/
https://rubygems.org/   https://ruby.taobao.org/
sudo gem install cocoapods
sudo gem update cocoapods
如果没有权限
sudo gem install -n /usr/local/bin sass 
sudo gem install -n /usr/local/bin cocoapods
```
# MyCocoaPods
这是我所有自己上传和使用的cocoapods集合

help http://www.cocoachina.com/ios/20160415/15939.html

error http://www.jianshu.com/p/e5209ac6ce6b

# podspec

```
Pod::Spec.new do |s|
s.name         = "GRBNavigationKit"
s.version      = "0.0.5"
s.summary      = "Yes ,this is my Summary is A short description of KNavigate."
s.frameworks = 'UIKit','Foundation'
s.requires_arc = true
s.platform = :ios
s.ios.deployment_target = '8.0'
s.description  = "this is the description you know ? yes ,so ,what do you want to do?Yes you are right"
s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
# s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
s.license      = "MIT"
# s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
s.author             = { "yangyueguang" => "邮箱" }
# Or just: s.author    = ""
# s.authors            = { "" => "" }
# s.social_media_url   = "http://twitter.com/"
# s.platform     = :ios
# s.platform     = :ios, "5.0"
#  When using multiple platforms
# s.ios.deployment_target = "5.0"
# s.osx.deployment_target = "10.7"
# s.watchos.deployment_target = "2.0"
# s.tvos.deployment_target = "9.0"
s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
s.source_files  = "GRBNavigationKit"
#, "GestureNavi/*.{h,m}"
# s.public_header_files = "Classes/**/*.h"
# s.resource  = "icon.png"
# s.resources = "Resources/*.png"
# s.preserve_paths = "FilesToSave", "MoreFilesToSave"
# s.framework  = "SomeFramework"
# s.frameworks = "SomeFramework", "AnotherFramework"
# s.library   = "iconv"
# s.libraries = "iconv", "xml2"
# s.requires_arc = true
# s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
# s.dependency "JSONKit", "~> 1.4"
    s.subspec 'JSONKit' do |js|
    js.source_files = 'GRBNavigationKit/JSONKit'
    js.requires_arc = false
    end
    s.subspec 'VRPlayer' do |ss|
    ss.source_files = 'GRBNavigationKit/VRPlayer'
    # ss.public_header_files = 'VRPlayer/*.h'
    ss.ios.frameworks = 'MobileCoreServices'
    end
end
```

#创建github项目=》创建本地podspec文件=》github上release版本=》注册CocoaPods账号=》上传代码到cocoapods=》更新框架版本

```
git clone https://github/xx.git
git add .
git commit -m "建立代码仓库"
git push
git tag 0.0.1
git push --tag //到github上更新release #给源代码打版本标签，与podspec文件中version一致即可
pod spec create name //touch name.podspec
vim name.podspec
echo "3.0" > .swift-version 如果swift版本不对的话s.dependency "SDWebImage", "~> 3.7.1"
pod lib lint name.podspec --allow-warnings
#如果饮用了包涵静态库的.a文件，则需要加上 --use-libraries
#如果遇到simclt问题则使用sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
pod lib lint --verbose
pod trunk register 邮箱 'yangyueguang' -description='薛超'
pod trunk me
pod spec lint --allow-warnings
pod trunk COMMAND
pod trunk push name.podspec  --allow-warnings
pod repo update
pod search name
```
# 更新内容
```
pod 'XExtension'
pod 'XCarryOn'
pod 'XWechartSDK'
```
# RepositoryBranch
## 这是只克隆一个仓库中的某个文件夹或某个分支到本地进行修改并上传的说明。
```
Desktop super$ mkdir devops
Desktop super$ cd devops/
Desktop super$ git init    #初始化空库 <br>
Desktop super$ git remote add -f origin https://github.com/yangyueguang/RepositoryBranch.git   #拉取remote的all objects信息
```
>\*Updating origin<br>
remote: Counting objects: 70, done.<br>
remote: Compressing objects: 100% (66/66), done.<br>
remote: Total 70 (delta 15), reused 0 (delta 0)<br>
Unpacking objects: 100% (70/70), done.<br>
From https://github.com/yangyueguang/RepositoryBranch<br>
\* [new branch]      master     -> origin/master<br>
```
Desktop super$ git config core.sparsecheckout true   #开启sparse clone
Desktop super$ echo "devops/" >> .git/info/sparse-checkout   #设置需要pull的目录，*表示所有，!表示匹配相反的
Desktop super$ echo "another/sub/tree" >> .git/info/sparse-checkout
Desktop super$ more .git/info/sparse-checkout
Desktop super$ git pull origin master  #更新
```
>From https://github.com/yangyueguang/RepositoryBranch<br>
\* branch            master     -> FETCH_HEAD
```
Desktop super$ git add .
Desktop super$ git commit -m "change"
Desktop super$ git push
```
```

# Swift 版本声明
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if ['LightRoute', 'Kakapo'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      end
      else
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '5.0'
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      end
    end
  end
end

```

# 前言
Freedom是集合了以下功能系列：
社交类   微信
金融类   支付宝
音乐类   酷狗
视频类   爱奇艺
商务类   淘宝
web2.0  新浪微博
生活类   大众点评
资讯类   今日头条
全网类   聚合数据
公众号   微能量
个人应用
我的简历
书籍收藏
个性特色自由主义
我的数据库
这是一款我自己设计开发的自由主义APP
有个浮标可以自由切换这些功能系列之间。
#
#简介
* 1、功能多样
一般情况下默认一倍图片大小为30，60 ，90
#
#更新记录
* 1、完善了整个APP框架的设计，生成了《王子设计总结初版.rp》。                                                                                                      2016.07.07
* 2、使用Cocoapods建立了整个APP系统层，包括网络请求框架，图片缓存框架，JSON与对象，友盟分享，SharedSDK，提示性信息，数据库，即时聊天，特效以及其他系列功能架构。                 2016.07.14
* 3、建立了整个APP辅助层，包括各个系统类功能的扩展、分类和继承以及基本类，如BaseViewController，categorys,手动导入的三方库。                                              2016.07.22
* 4、完善了APP整个框架的基本配置，如info.plist,PrefixHeader,Foundation,README记录,封装了工具类Utility，导入了应用中可能用到的系列库(Linked Frameworks and Libraries)。  2016.07.25
* 5、建立了Coredata使用框架以及Database使用框架，应用中将充分利用Coredata，Database，Sqlite，Plist，Archive,本地文件(如TXT)读取结合网络请求与JSON解析处理数据。            2016.08.01
* 6、建立了APP整个框架结构的文件夹，有效分类了所有功能系列，并建立了所有功能应用的基础框架，如各自的Storyboard，TabBarViewController，ViewController。                      2016.08.08
* 7、建立了基本的数据库系列，如icons.txt  TotalData  UserData.plist  MyCoreData.xcdatamodeld  Coredata.json                                                     2016.08.12
* 8、引入了APP整个系列功能要用到的通用图标  UserData  JSON  HomePictures，封装了从本地获取图片和从网络获取图片的方法。                                                   2016.08.15
* 9、完成了主界面的代码设计以及流水式左滑设置页面和右滑功能库界面还有基本的配置与搜索界面，浮标的自由切换效果等。                                                             2016.08.20
* 10、修复了已知bug和冲突，如MRC与ARC，Objective和Swift，配置了APPICON，LaunchScreen，真机测试运行成功，并完成了《Freedom框架版.zip》。                               2016.08.22
* 11、初步实现了微信的系列功能。如消息，通讯录，发现，我，朋友圈，个人信息，设置等内容。                                                                                  2016.08.25
* 12、初步实现了新浪微博的系列功能。如获取API，授权，获取微博数据，首页，消息，发微博，发现，我以及一些设置。                                                                2016.08.30
* 13、初步实现了支付宝的系列功能。如支付宝，口碑，朋友，我的，余额宝等。                                                                                               2016.09.05
* 14、初步实现了淘宝的系列功能。如淘宝主页。                                                                                                                      2016.09.07
* 15、初步实现了今日头条的系列功能。如主要框架和响应页面功能，包括首页，视频。                                                                                          2016.09.09
* 16、初步实现了大众点评的系列功能。如首页，闪惠团购，发现，我的。                                                                                                    2016.09.12
* 17、初步实现了酷狗的系列功能。如首页，左侧设置，右侧界面，听，看，唱，本地音乐和播放界面等。                                                                             2016.09.15
* 18、初步实现了爱奇艺的系列功能。如精选视频，服务，订阅推荐，我的，分类，和播放界面等                                                                                    2016.09.20
* 19、初步实现了书籍收藏系列功能。如首页，朋友圈，书籍阅读界面等。                                                                                                    2016.09.23
* 20、初步实现了聚合数据的系列功能。如联系我们，常见问题，数据接口，聚合动态，个人中心等。                                                                                2016.09.25
* 21、初步实现了微能量的系列功能。  如经典案例，新闻动态，主页面，精品人人店，联系我们等页面。                                                                            2016.09.30
* 22、初步实现了个人应用的系列功能。如行业列表界面，企业列表界面，企业详情界面。                                                                                        2016.10.03
* 23、初步实现了我的简历系列功能。如首页，事业合作，理论体系，联系我等。                                                                                               2016.10.05
* 24、初步实现了个性特色自由主义的系列功能。如个性特色自由主义书库界面，书籍阅读界面，编辑页面等。                                                                         2016.10.10
* 25、初步实现了我的数据库系列功能。如数据库首页的集合界面，打开编辑界面。                                                                                             2016.10.15
* 第二步:截获数据接口。生成API.h
* 26、在能力范围之内截获了以上所有APP的数据接口API，并完善了Foundation.h   Foundation_API.h     Foundation_defines.h                                               2016.10.18
* 27、优化了部分功能，重构了系统框架，增加了utility里面的MJExtension文件夹、Tools文件夹、BaseFile文件夹、ThirdPart文件夹。                                               2016.10.20
* 28、在plist中增加大部分访问用户隐私的授权属性，增加摇一摇功能在各个板块之间的跳转。                                                                                    2016.10.21
* 29、完善所有系列功能……………………
* 30、完善封装所有系列功能的类和方法……………………
* 31、测试与初步运营上线………………
* 32、在测试与实践的基础上优化APP……………………
* 33、功能完善，正式投放市场，上线运营。
