//
//  WXBaseViewController.h
//  Freedom
//
//  Created by Super on 2018/5/11.
//  Copyright © 2018年 Super. All rights reserved.
//
#import "WXNavigationController.h"
@interface UIViewController (JZExtension)
@property(nonatomic, assign) BOOL hidesNavigationBarWhenPushed; // If YES, then when this view controller is pushed into a controller hierarchy with a navigation bar, the navigation bar will slide out. Default is NO.
@property (nonatomic, assign, getter=isNavigationBarBackgroundHidden) BOOL navigationBarBackgroundHidden;
- (void)setNavigationBarBackgroundHidden:(BOOL)navigationBarBackgroundHidden animated:(BOOL)animated NS_AVAILABLE_IOS(8_0); // Hide or show the navigation bar background. If animated, it will transition vertically using UINavigationControllerHideShowBarDuration.
@end
@interface WXBaseViewController : UIViewController
@property (nonatomic, strong) NSString *analyzeTitle;
@end
