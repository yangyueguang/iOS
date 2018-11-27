//  NetEngine.h
//  Freedom
//  Created by Super on 17/1/18.
//  Copyright © 2017年 Super. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import "SVProgressHUD.h"
@interface NetEngine : AFHTTPSessionManager
typedef void (^ResponseBlock)(id resData,BOOL isCache);
typedef void (^ErrorBlock)(NSError *error);
///单例创建对象
+(id)Share;
+(NSURLSessionDataTask*) createGetAction:(NSString*)url onCompletion:(ResponseBlock) completion;
///普通网络请求post数据
+(NSURLSessionDataTask*) createPostAction:(NSString*)url withParams:(NSDictionary*)params onCompletion:(ResponseBlock) completion;
///文件下载
+(NSURLSessionTask*) createFileAction:(NSString*) url onCompletion:(ResponseBlock) completionBlock onError:(ErrorBlock) errorBlock withMask:(SVProgressHUDMaskType)mask;
///文件上传@[@{@"fileData":data,@"fileKey":@"image",@"fileName":@"name.jpg"}]
+(NSURLSessionDataTask*) uploadAllFileAction:(NSString*)url withParams:(NSDictionary*)params fileArray:(NSMutableArray *)fileArray onCompletion:(ResponseBlock)completionBlock onError:(ErrorBlock)errorBlock withMask:(SVProgressHUDMaskType)mask;
///清空内存文件
+(void)emptyCacheDefault;
@end
