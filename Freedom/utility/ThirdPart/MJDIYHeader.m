//
//  MJDIYHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
#import "MJDIYHeader.h"
#define PicW 932.3
@interface MJDIYHeader(){
    CGFloat offsetX;
    CADisplayLink *link;
}
@property (strong, nonatomic) UIScrollView *backView;
@property (strong, nonatomic) UIImageView *icon;
@property (nonatomic,strong)UIImageView *birdShadow;
@end
@implementation MJDIYHeader
- (void)prepare{
    [super prepare];
    // 设置控件的高度
    self.mj_h = 120;
    self.backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,APPW, 83)];
    UIImageView *a = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,PicW, 83)];
    UIImageView *b = [[UIImageView alloc]initWithFrame:CGRectMake(PicW, 0,PicW,83)];
    a.image = [UIImage imageNamed:@"bk"];b.image = [UIImage imageNamed:@"bk"];
    [self.backView addSubview:a];[self.backView addSubview:b];
    offsetX = PicW-APPW;
    self.backView.contentSize = CGSizeMake(PicW*2, 83);
    self.backView.contentOffset = CGPointMake(offsetX, 0);
    [self addSubview:self.backView];
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(APPW/2-15, 10, 30, 27.5)];
    self.icon.image = [UIImage imageNamed:@"bird_03"];
    [self addSubview:self.icon];
    self.birdShadow = [[UIImageView alloc]initWithFrame:CGRectMake(APPW/2-12, 100, 24, 7.5)];
    self.birdShadow.image = [UIImage imageNamed:@"touying"];
    [self addSubview:self.birdShadow];
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews{
    [super placeSubviews];
    self.backView.frame = CGRectMake(0, 0, APPW, 83);
//    self.icon.frame = CGRectMake(APPW/2-15, 30, 30, 27.5);
//    self.icon.center = self.center;
    self.birdShadow.frame = CGRectMake(APPW/2-12, 100, 24, 7.5);
}
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    [super scrollViewContentSizeDidChange:change];
}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
}

-(void)showAnimation{
    CABasicAnimation *fly = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    fly.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fly.fromValue = [NSNumber numberWithFloat:0];
    fly.toValue = [NSNumber numberWithFloat:20];
    fly.duration = 1;
    fly.repeatCount = HUGE_VALF;
    fly.autoreverses = YES;
    fly.speed = 1.0;
    fly.beginTime = 0.0;
    [self.icon.layer addAnimation:fly forKey:@"fly"];
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.birdShadow.layer addAnimation:animation forKey:@"shadow"];
    link = [CADisplayLink displayLinkWithTarget:self selector:@selector(backAnimationaa)];
    link.paused = NO;
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
-(void)backAnimationaa{
    [self.backView setContentOffset:CGPointMake(offsetX, 0)];
    offsetX-=2;
    if(offsetX<=0){
        [self.backView setContentOffset:CGPointMake(PicW,0)];
        offsetX=PicW;
    };
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state{
    [super setState:state];
    switch (state) {
        case MJRefreshStateIdle:{
            [self.icon.layer removeAllAnimations];
            [self.birdShadow.layer removeAllAnimations];
            [link invalidate];
            link = nil;
        }break;
        case MJRefreshStatePulling:
            break;
        case MJRefreshStateRefreshing:
            [self showAnimation];
            break;
        default:{
            [self.icon.layer removeAllAnimations];
            [self.birdShadow.layer removeAllAnimations];
            [link invalidate];
            link = nil;
        }break;
    }
}
#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent{
//    DLog(@"%lf",pullingPercent);
    [super setPullingPercent:pullingPercent];
    self.icon.frameY = 30*pullingPercent;
}
@end
