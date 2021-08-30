//  FreedomTools.h
//  Freedom
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import <Foundation/Foundation.h>
#define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#define WS(weakSelf)      __weak __typeof(&*self)weakSelf = self;
/**********************       尺        寸      ***********************/
#define APPW              [UIScreen mainScreen].bounds.size.width
#define APPH              [UIScreen mainScreen].bounds.size.height
#define TopHeight         (([[[UIDevice currentDevice] systemVersion] floatValue]) >= 7.0?64:44)
#define RGBCOLOR(r,g,b)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define UIColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define GoogleAppKey @"AIzaSyCegO8LjPujwaTtxijzowN3kCUQTop8tRA"
//// 融云
#define RONGCLOUD_IM_APPKEY @"n19jmcy59f1q9"
@interface NSString(expanded)
- (NSString *)pinyin;
- (NSString*)pinyinFirstLetter;
@end
@interface UIView (Freedom)
- (UIImage *)imageFromView ;
-(void)addSubviews:(UIView *)view,...;
@end
@interface UIViewController (DismissKeyboard)
-(void)showAlerWithtitle:(NSString*)t message:(NSString*)m style:(UIAlertControllerStyle)style ac1:(UIAlertAction* (^)(void))ac1 ac2:(UIAlertAction* (^)(void))ac2 ac3:(UIAlertAction* (^)(void))ac3 completion:(void(^)())completion;
@end
typedef void (^BarButtonActionBlock)();
@interface UIBarButtonItem (expanded)
- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style actionBlick:(BarButtonActionBlock)actionBlock;
@end

@interface FreedomTools : NSObject
+(FreedomTools *)sharedManager;
//重定向log到本地问题 在info.plist中打开Application supports iTunes file sharing
+ (NSMutableDictionary *)sortedArrayWithPinYinDic:(NSArray *)userList;
+ (void)show:(NSString *)msg;
+ (UIImage*)imageWithColor:(UIColor*)color;
+ (UIColor*)colorWithRGBHex:(UInt32)hex ;

@end
