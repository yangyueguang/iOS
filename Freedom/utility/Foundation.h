
#import "Foundation_API.h"
#import "Foundation_enum.h"
#define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#define Net   ({AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];manager.responseSerializer = [AFJSONResponseSerializer serializer];\
              manager.requestSerializer=[AFHTTPRequestSerializer serializer];[manager.requestSerializer setValue:@"text/json"  forHTTPHeaderField:@"Accept"];\
              [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];\
              manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain", @"application/xml",\
              @"text/xml",@"text/html",@"text/javascript", @"application/x-plist",   @"image/tiff", @"image/jpeg", @"image/gif", @"image/png", @"image/ico",\
              @"image/x-icon", @"image/bmp", @"image/x-bmp", @"image/x-xbitmap", @"image/x-win-bitmap", nil];(manager);})
#define WS(weakSelf)      __weak __typeof(&*self)weakSelf = self;
/**********************       尺        寸      ***********************/
#define APPW              [UIScreen mainScreen].bounds.size.width
#define APPH              [UIScreen mainScreen].bounds.size.height
#define TopHeight         (([[[UIDevice currentDevice] systemVersion] floatValue]) >= 7.0?64:44)
/***********************       字        体      ************************/
#define fontTitle         Font(15)
#define fontSmall         Font(13)
#define fontMiddle       Font(14)
#define BoldFont(x)       [UIFont boldSystemFontOfSize:x]
#define Font(x)           [UIFont systemFontOfSize:x]
/***********************       颜        色      ************************/
#define RGBCOLOR(r,g,b)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define UIColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
/************************      额  外  的  宏     ************************/
#define APP_CHANNEL @"Github"
#define PlaceHolder @" "
#define PQRCode @"u_QRCode"
#define PuserLogo @"userLogo"
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
