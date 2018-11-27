//
//  RCDMainTabBarViewController.h
//  RCloudMessage
//
//  Created by Jue on 16/7/30.
//  Copyright © 2016年 RongCloud. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "RCWKRequestHandler.h"
@interface RCDMainTabBarViewController : UITabBarController<RCWKAppInfoProvider>
+ (RCDMainTabBarViewController *)shareInstance;
- (void)saveConversationInfoForMessageShare;
- (void)insertSharedMessageIfNeed;
- (void)firstInitRongCloud;
@end
