//  ToutiaoVideoViewController.m
//  Created by Super on 16/8/25.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "ToutiaoVideoViewController.h"
#import "ToutiaoHomeSampleViewController.h"
static CGFloat const titleHeight = 40;
@interface ToutiaoVideoViewController()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView * titleScrollView;//标题ScrollView
@property (nonatomic,weak) UIScrollView * contentScrollView;//内容scrollView
@property (nonatomic,weak) UIButton * selTitlebutton;//标题中的按钮
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) NSMutableArray *titles;
@end
@implementation ToutiaoVideoViewController
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.titles =[NSMutableArray arrayWithArray:@[@"太阳能",@"地方政策",@"报告",@"清洁",@"新能源汽车",@"智联网",@"这个16",@"招聘简章",@"重工  "]];
    //设置头标题栏
    [self setTitleScrollView];
    //设置内容
    [self setupContentScrollView];
    //添加自控制器
    [self addChildViewController];
    //设置标题
    [self setTitle];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * APPW, 0);
    //支持整页滑动
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
}
#pragma mark - 设置头标题栏
-(void) setTitleScrollView{
    CGRect rect = CGRectMake(0, 20, APPW, titleHeight);
    UIScrollView * titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:titleScrollView];
    self.titleScrollView = titleScrollView;
}
#pragma mark - 设置内容
-(void) setupContentScrollView{
    CGRect rect = CGRectMake(0, YH(self.titleScrollView), APPW, APPH);
    UIScrollView * contentScrollView = [[UIScrollView alloc]initWithFrame:rect];
    [self.view addSubview:contentScrollView];
    self.contentScrollView = contentScrollView;
}
#pragma mark - 加入子控制器
-(void) addChildViewController{
    NSArray *tagids = @[@"33",@"34",@"36",@"37",@"38",@"40",@"41",@"42",@"43"];
    for(int i=0;i<self.titles.count;i++){
        ToutiaoHomeSampleViewController *vc = [[ToutiaoHomeSampleViewController alloc]init];
        vc.tagID = tagids[i];
        vc.title = self.titles[i];
        [self addChildViewController:vc];
    }
}
#pragma mark - 设置标题
-(void) setTitle{
    self.buttons = [NSMutableArray array];
    NSUInteger count = self.childViewControllers.count;
    CGFloat x = 0;
    CGFloat w = 80;
    CGFloat h = titleHeight;
    for (int i = 0; i<count; i++) {
        UIViewController * vc = self.childViewControllers[i];
        //设置标题的位置
        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton * button = [[UIButton alloc]initWithFrame:rect];
        button.tag = i;
        [button setTitle:vc.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
        [self.buttons addObject:button];
        [self.titleScrollView addSubview:button];
        if(i == 0){
            [self click:button];
        }
    }
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
}
#pragma mark - 按钮点击时间改变contentScrollView的值
-(void) click:(UIButton *) button{
    NSUInteger i = button.tag;
    CGFloat x = i * APPW;
    //改变按钮
    [self setTitleBtn:button];
    //转到下一个viewController
    [self setOnchildViewController:i];
    //移动childViewController
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
}
#pragma  mark - 改变按钮
-(void) setTitleBtn:(UIButton *) button{
    [self.selTitlebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selTitlebutton.transform = CGAffineTransformIdentity;
    //文字变红
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //放大的效果,放大1.5倍
    button.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.selTitlebutton = button;
    [self setUpTitleCenter:button];
}
-(void) setOnchildViewController:(NSUInteger) i{
    CGFloat x = i * APPW;
    UIViewController * vc = self.childViewControllers[i];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, APPW, APPH - YH(self.titleScrollView));
    [self.contentScrollView addSubview:vc.view];
}
//实现一个移动后标题居中
-(void) setUpTitleCenter:(UIButton *) button{
    //判断ScrollView的contentoffset的值
    CGFloat offset = button.center.x - APPW * 0.5 ;
    //在当前的左边
    if(offset < 0){
        offset = 0;
    }
    CGFloat maxOffset = self.titleScrollView.contentSize.width - APPW;
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}
#pragma mark - 利用协议解决滑动contentViewController
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger i = self.contentScrollView.contentOffset.x / APPW;
    [self setTitleBtn:self.buttons[i]];
    [self setOnchildViewController:i];
}
#pragma mark - 实现字体颜色大小的渐变
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    //定义一个两个变量控制左右按钮的渐变
    NSInteger left = offset/APPW;
    NSInteger right = 1 + left;
    UIButton * leftButton = self.buttons[left];
    UIButton * rightButton = nil;
    if (right < self.buttons.count) {
        rightButton = self.buttons[right];
    }
    //切换左右按钮
    CGFloat scaleR = offset/APPW - left;
    CGFloat scaleL = 1 - scaleR;
    //左右按钮的缩放比例
    CGFloat tranScale = 1.2 - 1 ;
    //宽和高的缩放(渐变)
    leftButton.transform = CGAffineTransformMakeScale(scaleL * tranScale + 1, scaleL * tranScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(scaleR * tranScale + 1, scaleR * tranScale + 1);
    //颜色的渐变
    UIColor * rightColor = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
    UIColor * leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
    //重新设置颜色
    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
    
}
@end
