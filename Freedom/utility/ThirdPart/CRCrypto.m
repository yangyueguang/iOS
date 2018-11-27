//
//  CRCrypto.m
//  CryptoDemo
//
//  Created by 蔡凌 on 2017/7/7.
//  Copyright © 2017年 蔡凌. All rights reserved.
//

#import "CRCrypto.h"

@interface CRCrypto()
{
    CCCryptorRef cryptorRef;
    BOOL isReleaseRef;
    void *buffer;
    NSUInteger _bufferSize;
}
@end

@implementation CRCrypto

- (void)dealloc
{
    if (!isReleaseRef) {
        free(buffer);
        CCCryptorRelease(cryptorRef);
    }
}

- (instancetype)initWithKey:(NSString *)key iv:(NSString *)iv Operation:(CCOptions)operation bufferSize:(NSUInteger)bufferSize
{
    if (self = [super init]) {
        isReleaseRef = NO;
        char keyPtr[kCCKeySizeAES128 + 1]; // room for terminator (unused)
        bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
        
        // fetch key data
        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        
//        char ivPtr[kCCKeySizeAES128 + 1];
//        bzero(ivPtr, sizeof(ivPtr));
//        [iv getCString:ivPtr maxLength:sizeof(iv) encoding:NSUTF8StringEncoding];
        
        NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
        
        OSStatus status = CCCryptorCreate(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES128, [ivData bytes], &cryptorRef);
        if (status != noErr) {
            return nil;
        }
        _bufferSize = bufferSize;
        buffer = malloc(bufferSize);
        bzero(buffer, bufferSize);
    }
    
    return self;
}

- (BOOL)update:(NSData *)inData OutBuffer:(NSData **)outData
{
    NSUInteger dataLength = [inData length];
//    void* buffer                = malloc(bufferSize);
    size_t numBytesOut    = 0;
    
    OSStatus status = CCCryptorUpdate(cryptorRef,
                                      [inData bytes],dataLength,
                                      buffer,
                                      _bufferSize,
                                      &numBytesOut);
    if (numBytesOut > 0) {
//        *outData = [NSData dataWithBytesNoCopy:buffer length:numBytesOut];
        *outData = [NSData dataWithBytes:buffer length:numBytesOut];
    }
    if (status == noErr) {
        return YES;
    }
//    free(buffer);
    return NO;
}

- (BOOL)finalWithOutBuffer:(NSData **)outData
{
//    void* buffer                = malloc(bufferSize);
    size_t numBytesOut    = 0;
    OSStatus status = CCCryptorFinal(cryptorRef, buffer, _bufferSize, &numBytesOut);
    
    if (numBytesOut > 0) {
//        *outData = [NSData dataWithBytesNoCopy:buffer length:numBytesOut];
        *outData = [NSData dataWithBytes:buffer length:numBytesOut];
    }
    else {
        *outData = nil;
    }
    
    if (status == noErr) {
        free(buffer);
        CCCryptorRelease(cryptorRef);
        isReleaseRef = YES;
        
        return YES;
    }
//    free(buffer);
    return NO;
}

+ (NSData *)AESEecryptWithKey:(NSString *)key iv:(NSString *)iv data:(NSData *)sourceData
{
    CRCrypto *crypto = [[CRCrypto alloc] initWithKey:key iv:iv Operation:kCCEncrypt bufferSize:sourceData.length];
    
    NSMutableData *mData = [NSMutableData data];
    NSData *outData = nil;
    OSStatus status = [crypto update:sourceData OutBuffer:&outData];
    if (status == noErr) {
        [mData appendData:outData];
    }
    
    status = [crypto finalWithOutBuffer:&outData];
    if (status == noErr) {
        [mData appendData:outData];
    }
    
    return [NSData dataWithData:mData];
}

+ (NSData *)AESDecryptWithKey:(NSString *)key iv:(NSString *)iv data:(NSData *)sourceData
{
    CRCrypto *crypto = [[CRCrypto alloc] initWithKey:key iv:iv Operation:kCCDecrypt bufferSize:sourceData.length];
    
    NSMutableData *mData = [NSMutableData data];
    NSData *outData = nil;
    
    BOOL status = [crypto update:sourceData OutBuffer:&outData];
    
    if (status) {
        [mData appendData:outData];
    }
    
    status = [crypto finalWithOutBuffer:&outData];
    if (status) {
        if (outData.length > 0) {
            [mData appendData:outData];
        }
    }
    
    return [NSData dataWithData:mData];
}

+ (NSString *)md5:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    
    return result;
}

+ (NSString *)md5_16:(NSString *)string {
    return [[[self md5:string] substringWithRange:NSMakeRange(0, 16)] lowercaseString];
}

+ (NSString *)fileMD5:(NSURL *)fileUrl {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingFromURL:fileUrl error:nil];
    if( handle== nil ) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        @autoreleasepool {
            NSData* fileData = [handle readDataOfLength: 256 ];
            CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
            if( [fileData length] == 0 ) done = YES;
        }
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}

+(NSDictionary *)unzipJsonDataWithSpotCode:(int)SpotCode SenicCode:(int)code updateTime:(long)time{
    NSString *spotResourcePath = @"";
    NSString *path = [NSString stringWithFormat:@"%@/data/%d.json",spotResourcePath,code];
    DLog(@"%@",path);
    NSString *jsonDataKey = [NSString stringWithFormat:@"%d.json%@%@",code,@"",[NSNumber numberWithLong:time]];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSString *md5Key = [[CRCrypto md5:jsonDataKey] lowercaseString];
    NSData *decryptFirstJsonData = [CRCrypto AESDecryptWithKey:[md5Key substringWithRange:NSMakeRange(0, 16)] iv:@"" data:jsonData];
    NSString *jsonStr = [[NSString alloc] initWithData:decryptFirstJsonData encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    if ( jsonStr == nil ) {
        return nil;
    }
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",error);
    return jsonDict;
}
@end
