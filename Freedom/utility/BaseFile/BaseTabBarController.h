//  BaseTabBarController.h
//  Freedom
//  Created by Super on 16/9/20.
//  Copyright © 2016年 Super. All rights reserved.
//
#import <UIKit/UIKit.h>
@class BaseTabBar;
@protocol BaseTabBarDelegate <UITabBarDelegate>
-(void)MyTabBarDidClickCenterButton:(BaseTabBar*)tabBar;
@end
@interface BaseTabBar : UITabBar
@property(nonatomic,weak)id<BaseTabBarDelegate>delegate;
@end
@interface BaseTabBarController : UITabBarController
@end
