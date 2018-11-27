//  XFNavigationController.m
//  Freedom
//  Created by Fay on 15/9/14.
#import "XFNavigationController.h"
#import "UIBarButtonItem+expanded.h"
@implementation XFNavigationController
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
        
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:PcellLeftA heighlightImage:PcellLeftA_y];
        
        
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:Pnavi3p_b heighlightImage:Pnavi3p_y];
    }
    
    
    
}
-(void)back {
    
    [self popViewControllerAnimated:YES];
    
}
-(void)more {
    
    [self popToRootViewControllerAnimated:YES];
    
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
