//  TLRootViewController.h
//  Freedom
// Created by Super
#import "WXTabBarController.h"
@interface WXRootViewController : WXTabBarController
+ (WXRootViewController *) sharedRootViewController;
/*获取tabbarController的第Index个VC（不是navController）
 *
 *  @return navController的rootVC*/
- (id)childViewControllerAtIndex:(NSUInteger)index;
@end
