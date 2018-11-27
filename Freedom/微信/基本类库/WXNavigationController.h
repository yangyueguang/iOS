//  WechartNavigationController.h
//  Created by Super on 16/8/19.
//  Copyright © 2016年 Super. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface UINavigationController (JZExtension)
@property (nonatomic, assign) BOOL fullScreenInteractivePopGestureRecognizer NS_AVAILABLE_IOS(7_0); // If YES, then you can have a fullscreen
/// gesture recognizer responsible for popping the top view controller off the navigation stack, and the property is still
/// "interactivePopGestureRecognizer", see more for "UINavigationController.h", Default is NO.
@property (nonatomic, assign) CGFloat navigationBarBackgroundAlpha NS_AVAILABLE_IOS(7_0); // navigationBar's background alpha, when 0 your
/// navigationBar will be invisable, default is 1. Animatable
@property (nonatomic, assign) CGFloat toolbarBackgroundAlpha NS_AVAILABLE_IOS(7_0); // Current navigationController's toolbar background alpha,
/// make sure the toolbarHidden property is NO, default is 1. Animatable
@property (nonatomic, readonly, strong) UIViewController *interactivePopedViewController NS_AVAILABLE_IOS(7_0); // The view controller that is being popped
/// when the interactive pop gesture recognizer's UIGestureRecognizerState is UIGestureRecognizerStateChanged.
/// This category helps to change navigationBar or toolBar to any size, if you want default value, then set to 0.f.
@property (nonatomic, assign, readwrite) CGSize navigationBarSize;
@property (nonatomic, assign, readwrite) CGSize toolbarSize;
- (UIViewController *)previousViewControllerForViewController:(UIViewController *)viewController; // Return the gives
/// view controller's previous view controller in the navigation stack.
/// Called at end of animation of push/pop or immediately if not animated.
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
/*@brief  寻找Navigation中的某个viewcontroler对象
 *  @return viewcontroler对象*/
- (id)findViewController:(NSString*)className;
/*@brief  判断是否只有一个RootViewController
 *  @return 是否只有一个RootViewController*/
- (BOOL)isOnlyContainRootViewController;
/*@brief  RootViewController
 *  @return RootViewController*/
- (UIViewController *)rootViewController;
/*@brief  返回指定的viewcontroler
 *  @return pop之后的viewcontrolers*/
- (NSArray *)popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated;
/*@brief  pop n层
 *  @return pop之后的viewcontrolers*/
- (NSArray *)popToViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated;
@property (nonatomic, assign) CGFloat _navigationBarBackgroundReverseAlpha;
@end
@interface WXNavigationController : UINavigationController
@end
