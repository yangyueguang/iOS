
#import "Foundation_API.h"
#import "Foundation_enum.h"
#ifdef DEBUG
#define ELog(err) {if(err) NSLog(@"%@", err)}
#define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
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
#define isIpad            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define APPDelegate       [[UIApplication sharedApplication]delegate]
#define CN 1
#define MAS_SHORTHAND// 定义这个常量,就可以在使用Masonry不必总带着前缀 `mas_`:
#define MAS_SHORTHAND_GLOBALS// 定义这个常量,以支持在 Masonry 语法中自动将基本类型转换为 object 类型:
/**********************     网   络   资   源    **********************/
#define FileResource(s)   [[NSBundle mainBundle]pathForResource:s ofType:nil]
#define JSONWebResource(s) [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.isolar88.com/upload/xuechao/json/%@",s]]];
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
#define TopHeight         (IOSVersion >= 7.0?64:44)
#define NavY              (IOSVersion >= 7.0?20:0)
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
#define APP_CHANNEL         @"Github"
#define PlaceHolder @" "
#define PQRCode @"u_QRCode"
#define PuserLogo @"userLogo"
#define     HEIGHT_TABBAR               49.0f
#define     HEIGHT_NAVBAR               44.0f
#define     BORDER_WIDTH_1PX            ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)
#define     TLURL(urlString)    [NSURL URLWithString:urlString]
#define     TLNoNilString(str)  (str.length > 0 ? str : @"")
#define colorGrayLine RGBACOLOR(200, 200, 200, 1.0)
#define colorGrayBG RGBACOLOR(239.0, 239.0, 244.0, 1.0)
#define colorGreenDefault RGBACOLOR(2.0, 187.0, 0.0, 1.0f)
#define baseDomain   @"www.baidu.com"
#define basePort     @"80"
#define basePath     @"app"
#define basePicPath  @"www.baidu.com/"
#define BaseURL      @"http://www.isolar88.com/app/upload/xuechao"
/******************           支      付     宝           *******************/
#define PartnerID  @""//合作身份者id，以2088开头的16位纯数字
#define SellerID   @"zfb@"//收款支付宝账号
#define MD5_KEY @""//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define AlipayPubKey    @""//支付宝公钥
#define alipayBackUrl @""//支付宝回掉路径
/******************           微             信           *******************/
// UMeng
#define     UMENG_APPKEY        @"56b8ba33e0f55a15480020b0"
//#define     UMENG_APPKEY        @"563755cbe0f55a5cb300139c"
// JSPatch
#define     JSPATCH_APPKEY      @"7eadab71a29a784e"
// 七牛云存储
#define     QINIU_APPKEY        @"28ed72E3r7nfEjApnsHWQhItdqyZqTLCtcfQZp9I"
#define     QINIU_SECRET        @"aRYPqQYF9rK9EVJfcu849VY0PAky2Sfj97Sp349S"
// Mob SMS
#define     MOB_SMS_APPKEY      @"1133dc881b63b"
#define     MOB_SMS_SECRET      @"b4882225b9baee69761071c8cfa848f3"
#define GoogleAppKey @"AIzaSyCegO8LjPujwaTtxijzowN3kCUQTop8tRA"
// 融云
#define RONGCLOUD_IM_APPKEY @"n19jmcy59f1q9"
//@"k51hidwqked9b" //自由主义
//@"n19jmcy59f1q9" //online key
//@"c9kqb3rdkbb8j" //pre key
//@"e0x9wycfx7flq" //offline key
/******************           微             博           *******************/
/******************               shareSDK               *******************/
/******************           百      度    SDK           *******************/
/******************           科   大   讯   飞           *******************/
/******************           易            信           *******************/
/******************           蓝            牙           *******************/
