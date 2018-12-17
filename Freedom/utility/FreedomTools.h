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
+ (NSString *)defaultGroupPortrait:(RCGroup *)groupInfo;
+ (NSString *)defaultUserPortrait:(RCUserInfo *)userInfo;
+ (NSMutableDictionary *)sortedArrayWithPinYinDic:(NSArray *)userList;
+ (void)show:(NSString *)msg;
+ (UIImage*)imageWithColor:(UIColor*)color;
+ (UIColor*)colorWithRGBHex:(UInt32)hex ;

/// 解析KRC歌词文件
+ (NSString *)parseKRCWordWithPath: (NSString * )filePath;
// |level| can be 1-9, any other values will be clipped to that range. level 默认Z_DEFAULT_COMPRESSION
+ (NSData *)gtm_data:(NSData *)data compressionLevel:(int)level useGzip:(BOOL)useGzip;
+ (NSData *)gtm_dataByInflatingData:(NSData *)data;
@end
