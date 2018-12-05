//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XAPP : NSObject
@property (nonatomic,copy) NSString *bundleId;//
@property (nonatomic,copy) NSString *trackId;//
@property (nonatomic,copy) NSString *trackName;//
@property (nonatomic,copy) NSString *scheme;//不是自带的属性,是属性的扩展.
@property (nonatomic,copy) NSString *version;//版本
@property (nonatomic,copy) NSString *sdkVersion;//sdk版本
@property (nonatomic,copy) UIImage  *icon;//图标
@property (nonatomic,copy) NSString *fileSizeBytes;//大小
@property (nonatomic,copy) NSString *artistViewUrl;//appStore
@property (nonatomic,copy) NSString *artworkUrl60;//60像素icon
@property (nonatomic,copy) NSString *artworkUrl512;//512像素icon
@property (nonatomic,copy) NSString *kind;//类型
@property (nonatomic,copy) NSString *releaseDate;//更新时间
@property (nonatomic,copy) NSString *releaseNotes;//更新日志
@property (nonatomic,copy) NSString *minimumOsVersion;//最低版本要求
@property (nonatomic,assign) long artistId;//作者id
@property (nonatomic,copy) NSString *artistName;//作者名字
@property (nonatomic,assign) float price;//价格
@property (nonatomic,copy) NSString *currency;//币种
@property (nonatomic,copy) NSString *formattedPrice;//收费信息
@property (nonatomic,copy) NSString *sellerName;//销售员
@property (nonatomic,copy) NSString *sellerUrl;//销售官网
@property (nonatomic,copy) NSArray<NSString*> *screenshotUrls;//截屏
@property (nonatomic,copy) NSArray<NSString*> *advisories;//广告
@property (nonatomic,copy) NSArray<NSString*> *features;//特征
@property (nonatomic,copy) NSArray<NSString*> *genres;//流派分类
@property (nonatomic,copy) NSArray<NSString*> *supportedDevices;//支持设备
@property (nonatomic,copy) NSArray<NSString*> *languageCodesISO2A;//支持语言
@property (nonatomic,copy) NSString *descrip;//描述===================
///以下是已经安装的APP属性
@property (nonatomic,copy) NSString *applicationDSID;
@property (nonatomic,copy) NSString *applicationIdentifier;
@property (nonatomic,copy) NSString *roleIdentifier;
@property (nonatomic,copy) NSString *sourceAppIdentifier;
@property (nonatomic,copy) NSNumber *staticDiskUsage;
@property (nonatomic,copy) NSNumber *dynamicDiskUsage;
@property (nonatomic,assign) BOOL isHiddenApp;
- (instancetype)initWithBundleIdentifier:(NSString*)bundleIdentifier;
- (instancetype)initWithPrivateProxy:(id)privateProxy;
- (instancetype)initWithiTunesDict:(NSDictionary*)iTune;
@end
@interface AppManager : NSObject
@property (nonatomic, readonly) NSArray<XAPP*>* installedApplications;
- (BOOL)openAppWithBundleIdentifier:(NSString*)bundleIdentifier;
- (BOOL)openAppWithScheme:(NSString*)scheme;
- (BOOL)isInstalledAppWithIdentifier:(NSString*)bundleIdentifier;
- (void)gotiTunesInfoWithTrackIds:(NSArray<NSString*>*)tracks completion:(void(^)(NSArray<XAPP*> *apps))completion;
- (NSArray*)privateURLSchemes;
- (NSArray*)publicURLSchemes;
+ (instancetype)sharedInstance;
@end
