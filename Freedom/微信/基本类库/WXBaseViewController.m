//
//  WXBaseViewController.m
//  Freedom
//
//  Created by Super on 2018/5/11.
//  Copyright © 2018年 Super. All rights reserved.
#import "WXBaseViewController.h"
#import <UMMobClick/MobClick.h>
@implementation UIViewController (JZExtension)
- (void)setHidesNavigationBarWhenPushed:(BOOL)hidesNavigationBarWhenPushed {
    objc_setAssociatedObject(self, @selector(hidesNavigationBarWhenPushed), @(hidesNavigationBarWhenPushed), OBJC_ASSOCIATION_ASSIGN);
}
- (void)setNavigationBarBackgroundHidden:(BOOL)navigationBarBackgroundHidden {
    CGFloat alpha = navigationBarBackgroundHidden ? 0 : 1-self.navigationController._navigationBarBackgroundReverseAlpha;
    [[self.navigationController.navigationBar valueForKey:@"_backgroundView"] setAlpha:alpha];
    objc_setAssociatedObject(self, @selector(isNavigationBarBackgroundHidden), @(navigationBarBackgroundHidden), OBJC_ASSOCIATION_ASSIGN);
}
- (void)setNavigationBarBackgroundHidden:(BOOL)navigationBarBackgroundHidden animated:(BOOL)animated {
    [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration : 0.f animations:^{
        [self setNavigationBarBackgroundHidden:navigationBarBackgroundHidden];
    }];
}
- (BOOL)hidesNavigationBarWhenPushed {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (BOOL)isNavigationBarBackgroundHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
@end
@interface WXBaseViewController ()
@end
@implementation WXBaseViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:colorGrayBG];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.analyzeTitle];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.analyzeTitle];
}
- (void)dealloc{
    DLog(@"dealloc %@", self.navigationItem.title);
}
#pragma mark - Getter -
- (NSString *)analyzeTitle{
    if (_analyzeTitle == nil) {
        return self.navigationItem.title;
    }
    return _analyzeTitle;
}
@end
