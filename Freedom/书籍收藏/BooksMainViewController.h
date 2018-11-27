//  BooksMainViewController.h
//  Freedom
//  Created by Super on 17/2/9.
//  Copyright © 2017年 Super. All rights reserved.
//
#import "BaseViewController.h"
@interface BooksMainViewController : BaseViewController
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
