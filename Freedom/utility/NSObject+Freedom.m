//  NSObject+Freedom.m
//  Freedom
//  Created by htf on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import "NSObject+Freedom.h"
@implementation NSObject (Freedom)
@end
@implementation UIImagePickerController (Fixed)
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:RGBACOLOR(46.0, 49.0, 50.0, 1.0)];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:colorGrayBG];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17.5f]}];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
@end
@implementation UINavigationItem (Fixed)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)setLeftBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated{
    if (item == nil) {
        [self setRightBarButtonItems:nil animated:animated];
    }else if (item.title != nil) {
        [self setLeftBarButtonItems:@[item] animated:animated];
    }else{
        [self setLeftBarButtonItems:@[[UIBarButtonItem fixItemSpace:-NAVBAR_ITEM_FIXED_SPACE], item] animated:animated];
    }
}
- (void)setRightBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated{
    if (item == nil) {
        [self setRightBarButtonItems:nil animated:animated];
    }else if (item.title != nil) {
        [self setRightBarButtonItems:@[item] animated:animated];
    }else{
        [self setRightBarButtonItems:@[[UIBarButtonItem fixItemSpace:-NAVBAR_ITEM_FIXED_SPACE], item] animated:animated];
    }
}
#pragma clang diagnostic pop
@end
@implementation UIFont (expanded)
+ (UIFont *) fontNavBarTitle{
    return [UIFont boldSystemFontOfSize:17.5f];
}
+ (UIFont *) fontConversationUsername{
    return [UIFont systemFontOfSize:17.0f];
}
+ (UIFont *) fontConversationDetail{
    return [UIFont systemFontOfSize:14.0f];
}
+ (UIFont *) fontConversationTime{
    return [UIFont systemFontOfSize:12.5f];
}
+ (UIFont *) fontFriendsUsername{
    return [UIFont systemFontOfSize:17.0f];
}
+ (UIFont *) fontMineNikename{
    return [UIFont systemFontOfSize:17.0f];
}
+ (UIFont *) fontMineUsername{
    return [UIFont systemFontOfSize:14.0f];
}
+ (UIFont *) fontSettingHeaderAndFooterTitle{
    return [UIFont systemFontOfSize:14.0f];
}
+ (UIFont *)fontTextMessageText{
    CGFloat size = [[NSUserDefaults standardUserDefaults] doubleForKey:@"CHAT_FONT_SIZE"];
    if (size == 0) {
        size = 16.0f;
    }
    return [UIFont systemFontOfSize:size];
}
@end
#import "User.h"
@implementation UIViewController (add)
-(void)radialMenu:(CKRadialMenu *)radialMenu didSelectPopoutWithIndentifier:(NSString *)identifier{
    DLog(@"代理通知发现点击了控制器%@", identifier);
    NSArray *theNewItems = @[@"Kugou",@"JuheData",@"Iqiyi",@"Taobao",@"Sina",@"Alipay",@"Resume",@"MyDatabase",@"MicroEnergy",@"Wechart",@"Dianping",@"Toutiao",@"Books",@"Freedom",@"PersonalApply"];
    int a = [identifier intValue];
    [radialMenu didTapCenterView:nil];
    NSString *controlName = theNewItems[a];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if([controlName isEqualToString:@"Sina"]){
        NSString *s =[NSString stringWithFormat:@"%@TabBarController",controlName];
        UIViewController *con = [[NSClassFromString(s) alloc]init];
        CATransition *animation = [CATransition animation];
        animation.duration = 1;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self presentViewController:con animated:NO completion:^{
        }];
        return;
    }
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:controlName bundle:nil];
    UIViewController *con = [StoryBoard instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"%@TabBarController",controlName]];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
    [self.view.window.layer addAnimation:animation forKey:nil];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    win.rootViewController = con;
    [win makeKeyAndVisible];
}
#pragma mark 摇一摇
/** 开始摇一摇 */
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSArray *theNewItems = [User getControllerData];
    CKRadialMenu *theMenu = [[CKRadialMenu alloc] initWithFrame:CGRectMake(APPW/2-25, APPH/2-25, 50, 50)];
    for(int i = 0;i<theNewItems.count;i++){
        UIImageView *a = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        a.image = [UIImage imageNamed:[theNewItems[i] valueForKey:@"icon"]];
        [theMenu addPopoutView:a withIndentifier:[NSString stringWithFormat:@"%d",i]];
    }
    [theMenu enableDevelopmentMode];
    theMenu.distanceBetweenPopouts = 2*180/theNewItems.count;
    theMenu.delegate = self;
    [self.view addSubview:theMenu];
    theMenu.center = self.view.center;
    UIWindow *win = [[UIApplication sharedApplication]keyWindow];
    [win addSubview:theMenu];
    [win bringSubviewToFront:theMenu];
    
}
@end
