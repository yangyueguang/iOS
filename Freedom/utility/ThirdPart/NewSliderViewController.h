//  NewSliderViewController.h
//  Freedom
//  Created by Super on 16/9/2.
//  Copyright © 2016年 Super. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface NewSliderViewController : UIViewController
@property (strong, nonatomic) UIViewController *leftViewController;
@property (strong, nonatomic) UIViewController *CenterViewController;
@property (strong, nonatomic) UIViewController *rightViewController;
@property (assign, nonatomic) CGFloat leftWidth;
@property (assign,nonatomic) CGFloat rightWidth;
-(instancetype)initWithLeftViewController:(UIViewController *)leftViewController CenterViewController:(UIViewController *)centerViewController RigthViewController:(UIViewController *)rightViewController;
-(void)showSideWithAnimation:(BOOL)animation;
-(void)dismissSideWithAnimation:(BOOL)animation;
-(void)showRightViewWithAnimation:(BOOL)animation;
-(void)dismissRigthViewWithAnimation:(BOOL)animation;
@end
