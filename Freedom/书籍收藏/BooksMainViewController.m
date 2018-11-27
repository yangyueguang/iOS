//  BooksMainViewController.m
//  Freedom
//  Created by Super on 17/2/9.
//  Copyright © 2017年 Super. All rights reserved.
//
#import "BooksMainViewController.h"
#import "BooksViewController.h"
#import "WXViewController.h"
#import "E_ScrollViewController.h"
@interface BooksMainViewController ()
@property (nonatomic , strong) UIView *rightMaskView ;  //右半透明蒙版
@property (nonatomic , strong) UIView *leftMaskView;    //左半透明蒙版
@property (nonatomic, strong) UIPanGestureRecognizer *leftGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *rightGesture;
@end
@implementation BooksMainViewController
-(UIView *)rightMaskView{
    if (!_rightMaskView) {
        _rightMaskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _rightMaskView.backgroundColor = [UIColor blackColor];
    }
    return _rightMaskView;
}
-(UIView *)leftMaskView{
    if (!_leftMaskView) {
        _leftMaskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _leftMaskView.backgroundColor = [UIColor blackColor];
    }
    return _leftMaskView;
}
-(instancetype)initWithLeftViewController:(UIViewController *)leftViewController CenterViewController:(UIViewController *)centerViewController RigthViewController:(UIViewController *)rightViewController{
    if (self) {
        self.leftViewController = leftViewController;
        self.CenterViewController = centerViewController;
        self.rightViewController = rightViewController;
        [self.view addSubview:leftViewController.view];
        [self.view addSubview:self.rightViewController.view];
        [self.view addSubview:centerViewController.view];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    BooksViewController *bookshelf = [[BooksViewController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:bookshelf];
    WXViewController *left = [[WXViewController alloc]init];
//    UINavigationController *na2 = [[UINavigationController alloc]initWithRootViewController:left];
    E_ScrollViewController *right = [[E_ScrollViewController alloc]init];
//    UINavigationController *na3 = [[UINavigationController alloc]initWithRootViewController:right];
    self.leftViewController = left;
    self.CenterViewController = na;
    self.rightViewController = right;
    [self.view addSubview:left.view];
    [self.view addSubview:self.rightViewController.view];
    [self.view addSubview:na.view];
    self.leftWidth = APPW*0.8;
    self.rightWidth = APPW;
    
    
    self.view.backgroundColor = [UIColor grayColor];
    //初始位置
    self.leftViewController.view.frame = CGRectMake(-APPW*0.3, 0, APPW, APPH);
    self.rightViewController.view.frame = CGRectMake(APPW*0.8, 0, APPW, APPH);
    [self.rightViewController.view addSubview:self.rightMaskView];
    [self.leftViewController.view addSubview:self.leftMaskView];
    [self setupGestureRecognizer];
    
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight|UIRectEdgeBottom;
}
//右侧视图设置手势
-(void)setupRightGesture{
    self.rightGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(rightPanGesture:)];
    [self.rightViewController.view addGestureRecognizer:self.rightGesture];
}
//中间视图设置手势
-(void)setupGestureRecognizer{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self.CenterViewController.view addGestureRecognizer:panGesture];
}
//左侧视图设置手势
-(void)setupLeftGesture{
    self.leftGesture  = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(leftPaneGesture:)];
    [self.leftViewController.view addGestureRecognizer:self.leftGesture];
}
//显示左侧视图
-(void)showSideWithAnimation:(BOOL)animation{
    [UIView animateWithDuration:animation?0.5:0 animations:^{
        self.leftViewController.view.frame = CGRectMake(0, 0,APPW,  APPH) ;
        self.CenterViewController.view.frame = CGRectMake(APPW*0.8, 0, APPW, APPH);
        self.leftMaskView.alpha = [self alphaWithOffsetX:self.CenterViewController.view.frame.origin.x totalOffsetX:APPW*0.8];
    } completion:^(BOOL finished) {
        [self setupLeftGesture];
    } ];
}
//关闭左侧视图
-(void)dismissSideWithAnimation:(BOOL)animation{
    [UIView animateWithDuration:animation ? 0.5 : 0 animations:^{
        self.leftViewController.view.frame = CGRectMake(-APPW*0.3, 0,APPW,  APPH) ;
        self.CenterViewController.view.frame = CGRectMake(0, 0, APPW, APPH);
        self.leftMaskView.alpha = [self alphaWithOffsetX:self.CenterViewController.view.frame.origin.x totalOffsetX:APPW*0.8];
    } completion:^(BOOL finished) {
        [self.leftViewController.view removeGestureRecognizer:self.leftGesture];
    }];
}
//显示右侧视图
-(void)showRightViewWithAnimation:(BOOL)animation{
    [UIView animateWithDuration:animation?0.5:0 animations:^{
        self.rightViewController.view.frame = CGRectMake(APPW - APPW, 0,APPW,  APPH) ;
        self.CenterViewController.view.frame = CGRectMake(-APPW, 0, APPW, APPH);
        self.rightMaskView.alpha = [self alphaWithOffsetX:self.CenterViewController.view.frame.origin.x totalOffsetX:APPW];
    } completion:^(BOOL finished) {
        [self setupRightGesture];
    } ];
}
//关闭右侧视图
-(void)dismissRigthViewWithAnimation:(BOOL)animation{
    [UIView animateWithDuration:animation ? 0.5 : 0 animations:^{
        self.rightViewController.view.frame = CGRectMake(0.8*APPW , 0,APPW,  APPH) ;
        self.CenterViewController.view.frame = CGRectMake(0, 0, APPW, APPH);
        self.rightMaskView.alpha = [self alphaWithOffsetX:self.rightViewController.view.frame.origin.x totalOffsetX:APPW];
    } completion:^(BOOL finished) {
        [self.rightViewController.view removeGestureRecognizer:self.rightGesture];
    }];
}
//中间视图手势事件
-(void)panGesture:(UIPanGestureRecognizer *)pan{
    CGPoint transion = [pan translationInView:self.CenterViewController.view];
    CGFloat offSetX = transion.x;
    if (offSetX < 0 && self.CenterViewController.view.frame.origin.x > 0) {
        //左滑关闭左视图
        self.leftViewController.view.frame = [self leftViewFrameWithOffsetX:offSetX];
        self.CenterViewController.view.frame = [self centerViewFrameWithOffsetX:offSetX];
        self.leftMaskView.alpha = [self alphaWithOffsetX:self.CenterViewController.view.frame.origin.x totalOffsetX:0.8*APPW];
    } else if (offSetX< 0 && self.CenterViewController.view.frame.origin.x <= 0){
        //左滑显示右视图
        self.rightMaskView.hidden = NO;
        self.rightViewController.view.frame = [self rightViewFrameWithOffsetX:offSetX];
        self.CenterViewController.view.frame = [self centerViewFrameWithOffsetX:offSetX];
        self.rightMaskView.alpha = [self alphaWithOffsetX:self.CenterViewController.view.frame.origin.x totalOffsetX:APPW];
    } else if(offSetX > 0 && self.CenterViewController.view.frame.origin.x >= 0){
        //右滑显示左视图
        self.leftMaskView.hidden = NO;
        self.leftMaskView.alpha = [self alphaWithOffsetX:self.CenterViewController.view.frame.origin.x totalOffsetX:0.8*APPW];
        self.leftViewController.view.frame = [self leftViewFrameWithOffsetX:offSetX];
        self.CenterViewController.view.frame = [self centerViewFrameWithOffsetX:offSetX];
    } else {
        //油滑关闭右视图
        self.rightMaskView.alpha = [self alphaWithOffsetX:self.rightViewController.view.frame.origin.x totalOffsetX:APPW];
        self.rightViewController.view.frame = [self rightViewFrameWithOffsetX:offSetX];
        self.CenterViewController.view.frame = [self centerViewFrameWithOffsetX:offSetX];
    }
    [pan setTranslation:CGPointZero inView:self.CenterViewController.view];
    //手势操作结束 判断该显示还是该关闭
    if (pan.state == UIGestureRecognizerStateEnded) {
        self.leftMaskView.hidden = NO;
        self.rightMaskView.hidden = NO;
        if (self.CenterViewController.view.frame.origin.x > 0) {
            if (self.CenterViewController.view.frame.origin.x > APPW*0.8 / 2) {
                [self showSideWithAnimation:YES];
            } else {
                [self dismissSideWithAnimation:YES];
            }
        } else {
            if (self.CenterViewController.view.frame.origin.x < -APPW / 2) {
                [self showRightViewWithAnimation:YES];
            } else {
                [self dismissRigthViewWithAnimation:YES];
            }
        }
    }
}
//右侧视图的手势事件 右拉显示中间视图
-(void)rightPanGesture:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:self.rightViewController.view];
    CGFloat offsetX = point.x;
    //右侧视图禁止左滑
    if (offsetX < 0 ) {
        return;
    }
    
    if (offsetX > 0 ) {
        self.CenterViewController.view.frame = [self centerViewFrameWithOffsetX:offsetX];
        self.rightViewController.view.frame = [self rightViewFrameWithOffsetX:offsetX];
        self.rightMaskView.alpha = [self alphaWithOffsetX:self.CenterViewController.view.frame.origin.x totalOffsetX:APPW];
    }
    [pan setTranslation:CGPointZero inView:self.rightViewController.view];
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.CenterViewController.view.frame.origin.x >= -0.5*APPW) {
            [self dismissRigthViewWithAnimation:YES];
        } else {
            [self showRightViewWithAnimation:YES];
        }
    }
}
//左侧视图的手势事件 左拉显示中间视图
- (void)leftPaneGesture:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:self.leftViewController.view];
    CGFloat offsetX = point.x;
    //左侧视图 禁止向左滑手势
    if (offsetX > 0 ) {
        return;
    }
    
    if (offsetX < 0) {
        self.CenterViewController.view.frame = [self centerViewFrameWithOffsetX:offsetX];
        self.leftViewController.view.frame = [self leftViewFrameWithOffsetX:offsetX];
        self.leftMaskView.alpha = [self alphaWithOffsetX:self.CenterViewController.view.frame.origin.x totalOffsetX:0.8 * APPW];
    }
    [pan setTranslation:CGPointZero inView:self.leftViewController.view];
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.CenterViewController.view.frame.origin.x <= 0.4 * APPW) {
            [self dismissSideWithAnimation:YES];
        } else {
            [self showSideWithAnimation:YES];
        }
    }
}
//根据当前偏移量和总偏移量动态改变蒙版的alpha值
-(CGFloat)alphaWithOffsetX:(CGFloat)offsetX totalOffsetX:(CGFloat)totalOffsetX{
    CGFloat m =  fabs(offsetX) / totalOffsetX;
    CGFloat alpha = 1 - m;
    if (alpha > 0.5) {
        alpha = 0.5;
    }
    return alpha;
}
//根据偏移量动态改变视图的frame
- (CGRect)centerViewFrameWithOffsetX:(CGFloat)offsetX{
    CGRect perframe = self.CenterViewController.view.frame;
    perframe.origin.x += offsetX;
    return perframe;
}
- (CGRect)leftViewFrameWithOffsetX:(CGFloat)offsetX{
    CGRect perframe = _leftViewController.view.frame;
    perframe.origin.x += offsetX * 0.5;
    if (perframe.origin.x >= 0) {
        perframe.origin.x = 0;
    }
    return perframe;
}
-(CGRect)rightViewFrameWithOffsetX:(CGFloat)offsetX{
    CGRect perframe = _rightViewController.view.frame;
    perframe.origin.x += offsetX ;
    return perframe;
}
@end
