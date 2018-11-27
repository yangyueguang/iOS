//  BaseTabBarController.m
//  Freedom
//  Created by Super on 16/9/20.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
@interface BaseTabBar()
@property(nonatomic,weak)UIButton *centerButton;
@end
@implementation BaseTabBar
//告知系统动态处理delegate
@dynamic delegate;
-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        UIButton *centerbutton=[[UIButton alloc]init];
        [centerbutton setImage:[UIImage imageNamed:@"sports.png"] forState:UIControlStateNormal];
        centerbutton.frame=CGRectMake(0, 0, centerbutton.currentImage.size.width, centerbutton.currentImage.size.height);
        [self addSubview:centerbutton];
        self.centerButton=centerbutton;
        //为centerButton添加时间
        [centerbutton addTarget:self action:@selector(centerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }return self;
}
-(void)centerButtonClick{
    if([self.delegate respondsToSelector:@selector(MyTabBarDidClickCenterButton:)]){
        [self.delegate MyTabBarDidClickCenterButton:self];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //1.设置中间按钮的位置
    self.centerButton.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5-12);
    //计算每个UITabBarButton的宽
    CGFloat tabbarButtonW = self.bounds.size.width/5;
    CGFloat buttonIndex = 0;
    //2.设置系统根据子vc创建的4个UITabBarButton的位置
    for (UIView *child in self.subviews) {
        //根据字符串做类名，找到该类型的类型信息
        Class class = NSClassFromString(@"UITabBarButton");
        //判断当前遍历到的子视图是否是class类型
        if ([child isKindOfClass:class]) {
            //先拿出button原有的frame
            CGRect frame = child.frame;
            //改子视图的宽
            frame.size.width = tabbarButtonW;
            //改子视图的x
            frame.origin.x = buttonIndex*tabbarButtonW;
            //再把改完的frame赋会给button
            child.frame = frame;
            buttonIndex++;
            if (buttonIndex==2) {
                buttonIndex++;
            }
        }
    }
}
@end
@interface BaseTabBarController ()
@property (nonatomic, strong) NSMutableArray *items;
@end
@implementation BaseTabBarController
- (NSMutableArray *)items{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }return _items;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //通过设置文本属性来设置字体颜色
    for(UIViewController *s in self.childViewControllers){
        NSMutableDictionary *attM = [NSMutableDictionary dictionary];
        [attM setObject:[UIColor greenColor] forKey:NSForegroundColorAttributeName];
        [s.tabBarItem setTitleTextAttributes:attM forState:UIControlStateSelected];
        s.tabBarItem.image = [s.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        s.tabBarItem.selectedImage = [s.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    //管理子控制器
    //        [self setUpAllChildViewController];
}
#pragma mark 添加所有子控制器
-(void)setUpAllChildViewController{
    //首页
//    FirstViewController *home = [[FirstViewController alloc] init];
//    [self setUpOneChildViewController:home image:@"2x" selectedImage:@"pressed@2x" title:@"首页"];
//    //服务
//    ServiceViewController *deal = [[ServiceViewController alloc] init];
//    [self setUpOneChildViewController:deal image:@"2x" selectedImage:@"pressed@2x" title:@"服务"];
//    //发现
//    DiscoveryViewController *discover = [[DiscoveryViewController alloc] init];
//    [self setUpOneChildViewController:discover image:@"2x" selectedImage:@"pressed@2x" title:@"发现"];
//    //我的
//    MineViewController *profile = [[MineViewController alloc] init];
//    [self setUpOneChildViewController:profile image:@"2x" selectedImage:@"pressed@2x" title:@"我的"];
}
#pragma mark 添加一个子控制器
-(void)setUpOneChildViewController:(UIViewController *)viewController image:(NSString *)imageName selectedImage:(NSString *)selectedImageName title:(NSString *)title{
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:imageName];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //通过设置文本属性来设置字体颜色
    NSMutableDictionary *attM = [NSMutableDictionary dictionary];
    [attM setObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];
    [viewController.tabBarItem setTitleTextAttributes:attM forState:UIControlStateSelected];
    // 保存tabBarItem模型到数组
    [self.items addObject:viewController.tabBarItem];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:nav];
}
//#import "MyTabBarController.h"
//#import "MyTabBar.h"
//@interface MyTabBarController ()<MyTabBarDelegate>
//@end
//@implementation MyTabBarController
//-(void)MyTabBarDidClickCenterButton:(MyTabBar *)tabBar{
////    WeChartViewController *WeChartC=[self.storyboard instantiateViewControllerWithIdentifier:@"wechartNavigationController"];
////    [self presentViewController:WeChartC animated:YES completion:nil];
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    //遍历TabBarController管理的所有子vc//通过这个子vc拿到与此vc关联的那个UITabBarItem//才能修改里面被选中的图片的渲染模式
//    for (UIViewController *vc in self.viewControllers){
//        UIImage *selectedImage = vc.tabBarItem.selectedImage;
//        vc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    }
//    //获取UITabbarItem的样品实例
//    UITabBarItem *barItem = [UITabBarItem appearance];
//    //保存正常状态下的文本属性
//    NSMutableDictionary *normalAttributes = [NSMutableDictionary dictionary];
//    normalAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
//    normalAttributes[NSForegroundColorAttributeName] = [UIColor grayColor];
//    [barItem setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
//    //保存选中状态下的文本属性
//    NSMutableDictionary *selectedAttributes = [NSMutableDictionary dictionary];
//    selectedAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
//    selectedAttributes[NSForegroundColorAttributeName] = [UIColor colorWithRed:26/255.0 green:178/255.0 blue:10/255.0  alpha:1.0];
//    [barItem setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
//    //2.替换系统自带的tabbar
//    MyTabBar *tabbar = [[MyTabBar alloc]init];
//    tabbar.delegate = self;
//    [self setValue:tabbar forKey:@"tabBar"];
//}
//@end
@end
