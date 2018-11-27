//  EnergySuperMarketTabBarController.h
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MicroEnergyTabBarController.h"
@interface EnergySuperMarketTabBarController : BaseTabBarController
+ (EnergySuperMarketTabBarController *)sharedRootViewController;
@property(nonatomic,assign)NSInteger backTab;
@property(nonatomic,strong)MicroEnergyTabBarController *superTabbar;
@end
