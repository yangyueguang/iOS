//  NSData+KRCParse.h
//  Created by Super on 16/8/31.
//  Copyright © 2016年 Super. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface NSData (KRCParse)
/// Return an autoreleased NSData w/ the result of gzipping the bytes.
//  Uses the default compression level.
+ (NSData *)gtm_dataByGzippingBytes:(const void *)bytes
                             length:(NSUInteger)length;
/// Return an autoreleased NSData w/ the result of gzipping the payload of |data|.
//  Uses the default compression level.
+ (NSData *)gtm_dataByGzippingData:(NSData *)data;
/// Return an autoreleased NSData w/ the result of gzipping the bytes using |level| compression level.
// |level| can be 1-9, any other values will be clipped to that range.
+ (NSData *)gtm_dataByGzippingBytes:(const void *)bytes
                             length:(NSUInteger)length
                   compressionLevel:(int)level;
/// Return an autoreleased NSData w/ the result of gzipping the payload of |data| using |level| compression level.
+ (NSData *)gtm_dataByGzippingData:(NSData *)data
                  compressionLevel:(int)level;
// NOTE: deflate is *NOT* gzip.  deflate is a "zlib" stream.  pick which one
// you really want to create.  (the inflate api will handle either)
/// Return an autoreleased NSData w/ the result of deflating the bytes.
//  Uses the default compression level.
+ (NSData *)gtm_dataByDeflatingBytes:(const void *)bytes
                              length:(NSUInteger)length;
/// Return an autoreleased NSData w/ the result of deflating the payload of |data|.
//  Uses the default compression level.
+ (NSData *)gtm_dataByDeflatingData:(NSData *)data;
/// Return an autoreleased NSData w/ the result of deflating the bytes using |level| compression level.
// |level| can be 1-9, any other values will be clipped to that range.
+ (NSData *)gtm_dataByDeflatingBytes:(const void *)bytes
                              length:(NSUInteger)length
                    compressionLevel:(int)level;
/// Return an autoreleased NSData w/ the result of deflating the payload of |data| using |level| compression level.
+ (NSData *)gtm_dataByDeflatingData:(NSData *)data
                   compressionLevel:(int)level;
/// Return an autoreleased NSData w/ the result of decompressing the bytes.
// The bytes to decompress can be zlib or gzip payloads.
+ (NSData *)gtm_dataByInflatingBytes:(const void *)bytes
                              length:(NSUInteger)length;
/// Return an autoreleased NSData w/ the result of decompressing the payload of |data|.
// The data to decompress can be zlib or gzip payloads.
+ (NSData *)gtm_dataByInflatingData:(NSData *)data;
@end
