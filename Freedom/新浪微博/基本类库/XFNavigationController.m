//  XFNavigationController.m
//  Freedom
//  Created by Fay on 15/9/14.
#import "SinaNavigationController.h"
@implementation SinaNavigationController
+(void)initialize {
    UIBarButtonItem *item= [UIBarButtonItem appearance];
    //设置导航栏按钮字体颜色
    NSMutableDictionary *textArr = [NSMutableDictionary dictionary];
    textArr[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textArr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textArr forState:UIControlStateNormal];
    //不可选中状态
    NSMutableDictionary *disableTextArr = [NSMutableDictionary dictionary];
    disableTextArr[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    disableTextArr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:disableTextArr forState:UIControlStateDisabled];
    
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [super pushViewController:viewController animated:animated];
    
    if (self.viewControllers.count > 1) {
        
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"u_cellLeftA" heighlightImage:@"u_cellLeftA_y"];
        
        
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"u_navi3p_b" heighlightImage:@"u_navi3p_y"];
    }
    
    
    
}
-(void)back {
    
    [self popViewControllerAnimated:YES];
    
}
-(void)more {
    
    [self popToRootViewControllerAnimated:YES];
    
}
@end
