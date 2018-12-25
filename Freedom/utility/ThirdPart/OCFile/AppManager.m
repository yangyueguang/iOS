//
#import "AppManager.h"
@interface UIImage ()
+ (id)_iconForResourceProxy:(id)arg1 variant:(int)arg2 variantsScale:(float)arg3;
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(double)arg3;
@end
@interface PrivateApi_LSApplicationProxy
+ (instancetype)applicationProxyForIdentifier:(NSString*)identifier;
@property (nonatomic, readonly) NSString* localizedShortName;
@property (nonatomic, readonly) NSString* localizedName;
@property (nonatomic, readonly) NSString* bundleIdentifier;
@property (nonatomic, readonly) NSArray* appTags;
@property (nonatomic, readonly) NSString *applicationDSID;
@property (nonatomic, readonly) NSString *applicationIdentifier;
@property (nonatomic, readonly) NSString *applicationType;
@property (nonatomic, readonly) NSNumber *dynamicDiskUsage;
@property (nonatomic, readonly) NSArray *groupIdentifiers;
@property (nonatomic, readonly) NSNumber *itemID;
@property (nonatomic, readonly) NSString *itemName;
@property (nonatomic, readonly) NSString *minimumSystemVersion;
@property (nonatomic, readonly) NSArray *requiredDeviceCapabilities;
@property (nonatomic, readonly) NSString *roleIdentifier;
@property (nonatomic, readonly) NSString *sdkVersion;
@property (nonatomic, readonly) NSString *shortVersionString;
@property (nonatomic, readonly) NSString *sourceAppIdentifier;
@property (nonatomic, readonly) NSNumber *staticDiskUsage;
@property (nonatomic, readonly) NSString *teamID;
@property (nonatomic, readonly) NSString *vendorName;
@end
@implementation XAPP{
    PrivateApi_LSApplicationProxy* _applicationProxy;
    UIImage* _icon;
}
- (instancetype)initWithBundleIdentifier:(NSString*)bundleIdentifier{
    PrivateApi_LSApplicationProxy *proxy = [NSClassFromString(@"LSApplicationProxy") applicationProxyForIdentifier:bundleIdentifier];
    return [self initWithPrivateProxy:proxy];
}
- (instancetype)initWithPrivateProxy:(id)privateProxy{
    self = [super init];
    if(self){
        _applicationProxy = (PrivateApi_LSApplicationProxy*)privateProxy;
        _trackName = _applicationProxy.localizedName ?: _applicationProxy.localizedShortName;
        _bundleId = [_applicationProxy bundleIdentifier];
        _icon = [UIImage _applicationIconImageForBundleIdentifier:_bundleId format:10 scale:2.0];
        _trackId = [NSString stringWithFormat:@"%@",_applicationProxy.itemID];
        _artistId = _applicationProxy.teamID.longLongValue;
        _artistName = _applicationProxy.itemName;
        _sellerName = _applicationProxy.vendorName;
        _version = _applicationProxy.shortVersionString;
        _kind = _applicationProxy.applicationType;
        _features = _applicationProxy.groupIdentifiers;
        _minimumOsVersion = _applicationProxy.minimumSystemVersion;
        _supportedDevices = _applicationProxy.requiredDeviceCapabilities;
        _isHiddenApp = [[_applicationProxy appTags] indexOfObject:@"hidden"] != NSNotFound;
        _sdkVersion = _applicationProxy.sdkVersion;
        _staticDiskUsage = _applicationProxy.staticDiskUsage;
        _applicationDSID = _applicationProxy.applicationDSID;
        _applicationIdentifier = _applicationProxy.applicationIdentifier;
        _descrip = _applicationProxy.localizedShortName;
        NSLog(@"%@",_applicationProxy);
    }
    return self;
}
- (instancetype)initWithiTunesDict:(NSDictionary*)iTune{
    self = [super init];
    if(self){
        [self setValuesForKeysWithDictionary:iTune];
        self.descrip = [iTune objectForKey:@"description"];
        NSString *iconStr = [self.artworkUrl60 stringByReplacingOccurrencesOfString:@"60x60bb.jpg" withString:@"128x128-75.png"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.icon = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iconStr]]];
        });
    }
    return self;
}
@end
@interface PrivateApi_LSApplicationWorkspace
- (NSArray*)allInstalledApplications;
- (BOOL)applicationIsInstalled:(id)arg1;
- (bool)openApplicationWithBundleID:(id)arg1;
- (NSArray*)privateURLSchemes;
- (NSArray*)publicURLSchemes;
@end
@implementation AppManager{
  PrivateApi_LSApplicationWorkspace* _workspace;
  NSArray* _installedApplications;
}
+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init{
	self = [super init];
	if(self != nil){
		_workspace = [NSClassFromString(@"LSApplicationWorkspace") new];
	}
	return self;
}
- (NSArray*)privateURLSchemes{
    return [_workspace privateURLSchemes];
}
- (NSArray*)publicURLSchemes{
    return [_workspace publicURLSchemes];
}
- (NSArray<XAPP*>*)installedApplications{
	if(!_installedApplications){
        NSArray* allInstalledApplications = [_workspace allInstalledApplications];
        NSMutableArray* applications = [NSMutableArray arrayWithCapacity:allInstalledApplications.count];
        for(id proxy in allInstalledApplications){
            XAPP* app = [[XAPP alloc]initWithPrivateProxy:proxy];
            if(!app.isHiddenApp){
                [applications addObject:app];
            }
        }
		_installedApplications = applications;
	}
	return _installedApplications;
}
- (BOOL)openAppWithBundleIdentifier:(NSString *)bundleIdentifier{
	return (BOOL)[_workspace openApplicationWithBundleID:bundleIdentifier];
}
- (BOOL)isInstalledAppWithIdentifier:(NSString*)bundleIdentifier{
    BOOL isInstall = [_workspace applicationIsInstalled:bundleIdentifier];
    if(!isInstall){
        PrivateApi_LSApplicationProxy *proxy = [NSClassFromString(@"LSApplicationProxy") applicationProxyForIdentifier:bundleIdentifier];
        isInstall = [_workspace applicationIsInstalled:proxy];
    }
    return isInstall;
}
- (BOOL)openAppWithScheme:(NSString *)scheme{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:scheme];
    if([application canOpenURL:url]){
        [application openURL:url options:@{} completionHandler:^(BOOL success) {
        }];
        return YES;
    }else{
        return NO;
    }
}
-(void)gotiTunesInfoWithTrackIds:(NSArray<NSString*>*)tracks completion:(void(^)(NSArray<XAPP*> *apps))completion{
    NSString *trackId = [tracks componentsJoinedByString:@","];
    NSString *country = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@&country=%@",trackId,country];
    NSURL *url = [NSURL URLWithString: urlStr];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSArray *tempApps = [resultJSON objectForKey:@"results"];
            NSMutableArray *apps = [NSMutableArray array];
            for(NSDictionary *dict in tempApps){
                XAPP *app = [[XAPP alloc]initWithiTunesDict:dict];
                [apps addObject:app];
            }
            completion(apps);
        }else{
            completion(nil);
        }
    }] resume];
}
@end
