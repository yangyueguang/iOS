//  FreedomTools.h
//  Freedom
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "RCloudModel.h"
#import "NSObject+Freedom.h"
@interface FreedomTools : NSObject
+(FreedomTools *)sharedManager;
//重定向log到本地问题 在info.plist中打开Application supports iTunes file sharing
+(void)expireLogFiles;
//验证手机号码
+ (BOOL)validateMobile:(NSString *)mobile;
//验证电子邮箱
+ (BOOL)validateEmail:(NSString *)email;
//+ (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName;
+ (NSString *)defaultGroupPortrait:(RCGroup *)groupInfo;
+ (NSString *)defaultUserPortrait:(RCUserInfo *)userInfo;
+ (NSString *)getIconCachePath:(NSString *)fileName;
+ (NSString *)hanZiToPinYinWithString:(NSString *)hanZi;
+ (NSString *)getFirstUpperLetter:(NSString *)hanzi;
+ (NSMutableDictionary *)sortedArrayWithPinYinDic:(NSArray *)userList;
+ (BOOL)isContains:(NSString *)firstString withString:(NSString *)secondString;
+ (UIImage*)imageWithColor:(UIColor*)color;
/// 正则判断字符串是否是中文
+ (BOOL)isChinese:(NSString *)str;
+ (void)show:(NSString *)msg;
+ (UIColor *)colorWithRGBHex:(UInt32)hex ;
@end
