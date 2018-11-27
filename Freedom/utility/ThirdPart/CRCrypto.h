//
//  CRCrypto.h
//  CryptoDemo
//
//  Created by 蔡凌 on 2017/7/7.
//  Copyright © 2017年 蔡凌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface CRCrypto : NSObject

// 大文件专用
- (instancetype)initWithKey:(NSString *)key
                         iv:(NSString *)iv
                  Operation:(CCOptions)operation
                 bufferSize:(NSUInteger)bufferSize;

- (BOOL)update:(NSData *)inData OutBuffer:(NSData **)outData;
- (BOOL)finalWithOutBuffer:(NSData **)outData;

// 小型data
+ (NSData*)AESEecryptWithKey:(NSString *)key
                          iv:(NSString *)iv
                        data:(NSData *)sourceData;

+ (NSData*)AESDecryptWithKey:(NSString *)key
                          iv:(NSString *)iv
                        data:(NSData *)sourceData;

+ (NSString *)md5:(NSString *)string;
+ (NSString *)md5_16:(NSString *)string;
+ (NSString *)fileMD5:(NSURL *)fileUrl;
+ (NSDictionary*)unzipJsonDataWithSpotCode:(int)SpotCode SenicCode:(int)code updateTime:(long)time;
@end
