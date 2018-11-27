//  TLRootViewController.h
//  Freedom
// Created by Super
#import "TLTabBarController.h"
@interface TLRootViewController : TLTabBarController
+ (TLRootViewController *) sharedRootViewController;
/*获取tabbarController的第Index个VC（不是navController）
 *
 *  @return navController的rootVC*/
- (id)childViewControllerAtIndex:(NSUInteger)index;
@end
