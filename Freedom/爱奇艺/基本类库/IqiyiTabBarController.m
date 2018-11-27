//  IqiyiTabBarController.m
//  Created by Super on 16/8/19.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "IqiyiTabBarController.h"
#import "KugouViewController.h"
#import "JFClassifyViewController.h"
#import "JFDiscoverViewController.h"
#import "JFMineViewController.h"
#import "JFSubscribeViewController.h"
#import "IqiyiNavigationController.h"
@interface JFTabBarButton : UIButton
@property (nonatomic , weak)UITabBarItem *item;
@end
@implementation JFTabBarButton
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        //图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        //文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        //字体居中
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        //文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:redcolor forState:UIControlStateSelected];
        
        //添加一个提醒数字按钮
        UIButton *badgeButton = [[UIButton alloc]init];
        [self addSubview:badgeButton];
    }
    return  self;
}
-(void)setHighlighted:(BOOL)highlighted{
    
}
//-(CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    CGFloat imageW = contentRect.size.width;
//    CGFloat imageH = contentRect.size.height * JFTabBarButtonImageRatio;
//    return CGRectMake(0, 0, imageW, imageH);
//}
//-(CGRect)titleRectForContentRect:(CGRect)contentRect{
//    CGFloat  titleY = contentRect.size.height * JFTabBarButtonImageRatio;
//    CGFloat titleW = contentRect.size.width;
//    CGFloat titleH = contentRect.size.height -titleY ;
//    return  CGRectMake(0, titleY, titleW, titleH);
//}
-(void)setItem:(UITabBarItem *)item{
    _item = item;
    [self setTitle:item.title forState:UIControlStateNormal];
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
}
@end
@class JFTabBar;
//给每个按钮定义协议 与 方法
@protocol tabbarDelegate <NSObject>
@optional
-(void)tabBar:(JFTabBar * )tabBar didselectedButtonFrom:(int)from to:(int)to;
@end
@interface JFTabBar : UIView
@property (weak ,nonatomic)JFTabBarButton *selectedButton;
/*给自定义的tabbar添加按钮*/
-(void)addTabBarButtonWithItem:(UITabBarItem *)itme;
@property(nonatomic , weak) id <tabbarDelegate> delegate;
@end
@implementation JFTabBar
-(void)addTabBarButtonWithItem:(UITabBarItem *)item{
    //1.创建按钮
    JFTabBarButton *button = [[JFTabBarButton alloc]init];
    [self addSubview:button];
    /*
     [button setTitle:itme.title forState:UIControlStateNormal];
     [button setImage:itme.image forState:UIControlStateNormal];
     [button setImage:itme.selectedImage forState:UIControlStateSelected];
     [button setBackgroundImage:[UIImage imageWithName:@"tabbar_slider"] forState:UIControlStateSelected];
     */
    //设置数据把buttonitem模型传给button
    button.item = item;
    
    //监听点击button
    [button addTarget:self  action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    //默认选中
    if (self.subviews.count == 1) {
        [self buttonClick:button];
    }
    
    
}
/**
 * button监听事件
 **/
-(void)buttonClick:(JFTabBarButton*)button{
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didselectedButtonFrom:to:)]
        )
    {
        [self.delegate tabBar:self didselectedButtonFrom:(int)self.selectedButton.tag to:(int)button.tag];
    }
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat buttonW = self.frame.size.width/ self.subviews.count ;
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonY = 0 ;
    
    for ( int index = 0; index < self.subviews.count; index++) {
        //1.取出按钮
        JFTabBarButton *button = self.subviews[index];
        
        //2. 设置按钮的frame
        
        CGFloat buttonX = index * buttonW;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH) ;
        
        //绑定tag;
        button.tag = index;
    }
}
@end
@interface IqiyiTabBarController ()<tabbarDelegate>
@property(nonatomic ,strong)JFTabBar *costomTabBar;
@end
@implementation IqiyiTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化tabbar
//    [self setUpTabBar];
    //添加子控制器
//    [self setUpAllChildViewController];
}
//取出系统自带的tabbar并把里面的按钮删除掉
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    for ( UIView * child in  self.tabBar.subviews) {
//        if ([child isKindOfClass:[UIControl class]]) {
//            [child removeFromSuperview];
//        }
//    }
}
-(void)setUpTabBar{
    JFTabBar *customTabBar = [[JFTabBar alloc]init];
    customTabBar.delegate = self;
    //    customTabBar.backgroundColor = [UIColor redColor];
    customTabBar.frame = self.tabBar.bounds;
    self.costomTabBar = customTabBar;
    [self.tabBar addSubview:customTabBar];
    
}
-(void)tabBar:(JFTabBar *)tabBar didselectedButtonFrom:(int)from to:(int)to{
    self.selectedIndex = to;
    
}
-(void)setUpAllChildViewController{
//    KugouViewController *homeVC = [[KugouViewController alloc]init];
//    [self setupChildViewController:homeVC title:@"首页" imageName:@"home_homepage_notselected" seleceImageName:@"home_homepage_selected"];
//    
//    JFClassifyViewController *visitVC = [[JFClassifyViewController alloc]init];
//    [self setupChildViewController:visitVC title:@"分类" imageName:@"home_classify_notselected" seleceImageName:@"home_classify_selected"];
//    
//    JFSubscribeViewController *merchantVC = [[JFSubscribeViewController alloc]init];
//    [self setupChildViewController:merchantVC title:@"订阅" imageName:@"home_subscribe" seleceImageName:@"home_subscribe_selected"];
//    
//    JFDiscoverViewController *mineVC = [[JFDiscoverViewController alloc]init];
//    [self setupChildViewController:mineVC title:@"发现" imageName:@"home_find_notselected" seleceImageName:@"home_find_selected"];
//    
//    JFMineViewController *moreVC = [[JFMineViewController alloc]init];
//    [self setupChildViewController:moreVC title:@"我的" imageName:@"home_mine_notselected" seleceImageName:@"home_mine_selected"];
    
}
-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName{
    //    controller.title = title;
    controller.tabBarItem.title = title;//跟上面一样效果
    controller.tabBarItem.image = [UIImage imageNamed:imageName];
    controller.tabBarItem.selectedImage = [UIImage imageNamed:selectImageName];
    //包装导航控制器
    IqiyiNavigationController *nav = [[IqiyiNavigationController alloc]initWithRootViewController:controller];
    [self addChildViewController:nav];
    [self.costomTabBar addTabBarButtonWithItem:controller.tabBarItem];
}
@end
