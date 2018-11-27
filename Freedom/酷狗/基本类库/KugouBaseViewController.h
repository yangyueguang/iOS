//  KugouBaseViewController.h
//  Created by Super on 16/8/31.
//  Copyright © 2016年 Super. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface KugouBaseViewController : UIViewController
@property (strong, nonatomic) UIView       *navBar;
@property (strong, nonatomic) UIImageView            *backItem;
@property (strong, nonatomic) UIImageView            *leftItem;
@property (strong, nonatomic) UIImageView            *rightItem;
@property (strong, nonatomic) UIButton               *leftButton;
@property (strong, nonatomic) UIButton               *rightButton;
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UILabel *titleLine;
- (void)backItemTouched:(id)sender;
- (void)leftItemTouched:(id)sender;
- (void)rightItemTouched:(id)sender;
- (void)leftButtonClick:(id)sender;
- (void)rightButtonClick:(id)sender;
- (void)goBack;
- (void)addBackItem;
- (void)addleftItem:(NSString *)leftItemImageName;
- (void)addrightItem:(NSString *)rightItemImageName;
- (void)addleftButton:(NSString *)Title;
- (void)addrightButton:(NSString *)Title;
@end
