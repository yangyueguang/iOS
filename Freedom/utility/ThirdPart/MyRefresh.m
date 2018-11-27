
//
//  MyRefresh.m
//  iTour
//
//  Created by Super on 2017/8/25.
//  Copyright © 2017年 薛超. All rights reserved.
//

#import "MyRefresh.h"
#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)
#define DefaultHeight 100.f
@interface MyRefresh ()
@property (nonatomic,strong) UIImageView *sunImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,assign) BOOL forbidSunSet;
@end
@implementation MyRefresh
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, APPW, DefaultHeight)];
    UIView *refreshHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, DefaultHeight)];
    self.sunImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 20, 100, 100)];
    self.sunImageView.image = [UIImage imageNamed:@"compasspointer"];
    [refreshHead addSubview:self.sunImageView];
    self.clipsToBounds = YES;
    refreshHead.backgroundColor = [UIColor redColor];
    [self addSubview:refreshHead];
    [self.layer addSublayer:refreshHead.layer];
    return self;
}
-(void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}
- (void)attachToScrollView:(UIScrollView *)scrollView {
    self.scrollView = scrollView;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self setFrame:CGRectMake(0.f, 0.f, APPW, 0.f)];
    [scrollView addSubview:self];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self setFrame:CGRectMake(0.f,0.f,APPW,self.scrollView.contentOffset.y)];
    if(self.scrollView.contentOffset.y <= -DefaultHeight){
        if(self.scrollView.contentOffset.y < -120){
            [self.scrollView setContentOffset:CGPointMake(0.f, -120)];
        }
        CGFloat buildigsScaleRatio = (DefaultHeight / 100) * -self.scrollView.contentOffset.y / 100;
        if(buildigsScaleRatio <= 1.7){
            CGFloat skyScale = (0.85 + (1 - buildigsScaleRatio));
            [UIView animateWithDuration:0.5 animations:^{
                [self.sunImageView setTransform:CGAffineTransformMakeScale(skyScale,skyScale)];
            }];
        }
        if(!self.forbidSunSet){
            self.forbidSunSet = YES;
            CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = @(M_PI * 2.0);
            rotationAnimation.duration = 0.9;
            rotationAnimation.autoreverses = NO;
            rotationAnimation.repeatCount = HUGE_VALF;
            rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            [self.sunImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
    if(!self.scrollView.dragging && self.forbidSunSet && self.scrollView.decelerating ){
        [self beginRefreshing];
    }
    if(!self.forbidSunSet){
        CGFloat rotationAngle = (360.0 / 100) * (DefaultHeight / 100) * -self.scrollView.contentOffset.y;
        self.sunImageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(rotationAngle));
    }
}
-(void)beginRefreshing {
    [self.scrollView setContentInset:UIEdgeInsetsMake(DefaultHeight, 0.f, 0.f, 0.f)];
    [self.scrollView setContentOffset:CGPointMake(0.f, -DefaultHeight) animated:YES];
}
-(void)endRefreshing{
    if(self.scrollView.contentOffset.y > -DefaultHeight){
        [self performSelector:@selector(returnToDefaultState) withObject:nil afterDelay:1];
    }else{
        [self returnToDefaultState];
    }
}
-(void)returnToDefaultState{
    [UIView animateWithDuration:1 delay:0.f usingSpringWithDamping:0.4 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0.f, 0.f, 0.f)];
    } completion:nil];
    self.forbidSunSet = NO;
    [self.sunImageView.layer removeAnimationForKey:@"rotationAnimation"];
}

@end
