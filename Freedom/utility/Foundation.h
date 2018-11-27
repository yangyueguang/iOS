
#import "Foundation_defines.h"
#import "Foundation_API.h"
#import "Foundation_enum.h"
#import "Foundation_string.h"
#ifdef DEBUG
#define ELog(err) {if(err) NSLog(@"%@", err)}
#define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
//@weakobj(self)[self doSomething^{@strongobj(self)[self back];}];
#if __has_feature(objc_arc)
#define weakobj(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#define strongobj(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define weakobj(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#define strongobj(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#define ELog(err)
#define DLog(...)
#if __has_feature(objc_arc)
#define weakobj(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#define strongobj(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define weakobj(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#define strongobj(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
/**********************       系       统      **********************/
#define APPVersion        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Bundle version"]
#define IOSVersion        ([[[UIDevice currentDevice] systemVersion] floatValue])
#define Version7          ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
#define Version8          ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
#define isIpad            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define APPDelegate       [[UIApplication sharedApplication]delegate]
#define iPhone5           ([UIScreen mainScreen].bounds.size.height == 568)
#define CN 1
#define UI_language(cn,us) CN?cn:us
#define MAS_SHORTHAND// 定义这个常量,就可以在使用Masonry不必总带着前缀 `mas_`:
#define MAS_SHORTHAND_GLOBALS// 定义这个常量,以支持在 Masonry 语法中自动将基本类型转换为 object 类型:
/**********************       方        法      **********************/
#define S2N(x)            [NSNumber numberWithInt:[x intValue]]
#define I2N(x)            [NSNumber numberWithInt:x]
#define F2N(x)            [NSNumber numberWithFloat:x]
#define RViewsBorder(View,radius,width,color)\
[View.layer setCornerRadius:(radius)];[View.layer setMasksToBounds:YES];[View.layer setBorderWidth:(width)];[View.layer setBorderColor:[color CGColor]]
/**********************     网   络   资   源    **********************/
#define FileResource(s)   [[NSBundle mainBundle]pathForResource:s ofType:nil]
#define JSONWebResource(s) [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.isolar88.com/upload/xuechao/json/%@",s]]];
#define __async_opt__  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define __async_main__ dispatch_async(dispatch_get_main_queue()
#define NetBase         [AFHTTPSessionManager manager]
#define Net   ({AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];manager.responseSerializer = [AFJSONResponseSerializer serializer];\
              manager.requestSerializer=[AFHTTPRequestSerializer serializer];[manager.requestSerializer setValue:@"text/json"  forHTTPHeaderField:@"Accept"];\
              [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];\
              manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain", @"application/xml",\
              @"text/xml",@"text/html",@"text/javascript", @"application/x-plist",   @"image/tiff", @"image/jpeg", @"image/gif", @"image/png", @"image/ico",\
              @"image/x-icon", @"image/bmp", @"image/x-bmp", @"image/x-xbitmap", @"image/x-win-bitmap", nil];(manager);})
#define WS(weakSelf)      __weak __typeof(&*self)weakSelf = self;
/**********************     字     符    串     ***********************/
#define alertErrorTxt     @"服务器异常,请稍后再试"
/**********************       尺        寸      ***********************/
#define APPW              [UIScreen mainScreen].bounds.size.width
#define APPH              [UIScreen mainScreen].bounds.size.height
#define ApplicationH      [UIScreen mainScreen].applicationFrame.size.height
#define TopHeight         (Version7?64:44)
#define NavY              (Version7?20:0)
#define TabBarH           60
#define Boardseperad      10
#define W(obj)            (!obj?0:(obj).frame.size.width)
#define H(obj)            (!obj?0:(obj).frame.size.height)
#define X(obj)            (!obj?0:(obj).frame.origin.x)
#define Y(obj)            (!obj?0:(obj).frame.origin.y)
#define XW(obj)           (X(obj)+W(obj))
#define YH(obj)           (Y(obj)+H(obj))
#define CGRectMakeXY(x,y,size) CGRectMake(x,y,size.width,size.height)
#define CGRectMakeWH(origin,w,h) CGRectMake(origin.x,origin.y,w,h)
/***********************       字        体      ************************/
#define fontTitle         Font(15)
#define fontnomal         Font(13)
#define fontSmallTitle    Font(14)
#define BoldFont(x)       [UIFont boldSystemFontOfSize:x]
#define Font(x)           [UIFont systemFontOfSize:x]
/***********************       颜        色      ************************/
#define RGBCOLOR(r,g,b)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RandomColor       RGBCOLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define clearcolor        [UIColor clearColor]
#define gradcolor         RGBACOLOR(224, 225, 226, 1)
#define redcolor          RGBACOLOR(229, 59, 25, 1)
#define yellowcolor       [UIColor yellowColor]
#define greencolor        [UIColor greenColor]
#define whitecolor        RGBACOLOR(256, 256,256,1)
#define blacktextcolor    RGBACOLOR(33, 34, 35, 1)
#define gradtextcolor     RGBACOLOR(116, 117, 118, 1)
#define graycolor         [UIColor grayColor]
/************************   文  件  与  文  件  夹  ***********************/
#define HOMEPATH          NSHomeDirectory()//主页路径
#define documentPath      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0]//Documents路径
#define cachePath         [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define tempPath          NSTemporaryDirectory()
#define DOCUMENTS_FOLDER  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define FOLDERPATH(s)     [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:s]
#define FILEPATH          [DOCUMENTS_FOLDER stringByAppendingPathComponent:[self fileNameString]]
/************************      额  外  的  宏     ************************/
#define JFSearchHistoryPath [cachePath stringByAppendingPathComponent:@"hisDatas.data"]//搜索文件
#define     APP_CHANNEL         @"Github"
#define     DEBUG_LOCAL_SERVER      // 使用本地测试服务器
#ifdef  DEBUG_LOCAL_SERVER
#define     HOST_URL        @"http://127.0.0.1:8000/"            // 本地测试服务器
#else
#define     HOST_URL        @"http://121.42.29.15:8000/"         // 远程线上服务器
#endif
#define     SIZE_SCREEN                 [UIScreen mainScreen].bounds.size
#define     WIDTH_SCREEN                [UIScreen mainScreen].bounds.size.width
#define     HEIGHT_SCREEN               [UIScreen mainScreen].bounds.size.height
#define     HEIGHT_STATUSBAR            20.0f
#define     HEIGHT_TABBAR               49.0f
#define     HEIGHT_NAVBAR               44.0f
#define     NAVBAR_ITEM_FIXED_SPACE     5.0f
#define     BORDER_WIDTH_1PX            ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)
#define     MAX_MESSAGE_WIDTH               WIDTH_SCREEN * 0.58
#define     TLURL(urlString)    [NSURL URLWithString:urlString]
#define     TLNoNilString(str)  (str.length > 0 ? str : @"")
#define     TLTimeStamp(date)   ([NSString stringWithFormat:@"%lf", [date timeIntervalSince1970]])
#define     HEIGHT_CHATBAR_TEXTVIEW         36.0f
#define     HEIGHT_MAX_CHATBAR_TEXTVIEW     111.5f
#define     HEIGHT_CHAT_KEYBOARD            215.0f
#define colorGrayLine RGBACOLOR(200, 200, 200, 1.0)
#define colorGrayBG RGBACOLOR(239.0, 239.0, 244.0, 1.0)
#define colorGreenDefault RGBACOLOR(2.0, 187.0, 0.0, 1.0f)
