//
//  APIWebImageDownloaderOperation.m
//  iTour
//
//  Created by Ling.Cai on 2017/7/14.
//  Copyright © 2017年 薛超. All rights reserved.
//

#import "APIWebImageDownloaderOperation.h"


@implementation APIWebImageDownloaderOperation

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {

#warning 正式发布的时候记得修改证书信任设置
//#if DEBUG
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengeUseCredential;
    __block NSURLCredential *credential = nil;
    credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
//#else
//    [super URLSession:session task:task didReceiveChallenge:challenge completionHandler:completionHandler];
//#endif
}

@end
