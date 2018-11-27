//
//  TeamDesigner.m
//  BeeNests
//
//  Created by 贾杰 on 2017/10/18.
//  Copyright © 2017年 厦门蜜蜂巢科技有限公司. All rights reserved.
#import "TeamDesigner.h"
#import <SDWebImage/SDImageCache.h>
@interface CardModel : NSObject
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *artPhoto;
@end
@implementation CardModel
@end
@class JLDragCardView;
@protocol JLDragCardDelegate <NSObject>
-(void)swipCard:(JLDragCardView *)cardView Direction:(BOOL) isRight;
-(void)moveCards:(CGFloat)distance;
-(void)moveBackCards;
-(void)adjustOtherCards;
@end
@interface JLDragCardView : UIView
@property (weak,   nonatomic) id <JLDragCardDelegate> delegate;
@property (assign, nonatomic) CGAffineTransform originalTransform;
@property (assign, nonatomic) CGPoint pointFromCenter;
@property (assign, nonatomic) CGPoint originalCenter;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (nonatomic,strong) CardModel *model;
@end
@implementation JLDragCardView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius      = 4;
        self.layer.shadowRadius      = 3;
        self.layer.shadowOpacity     = 0.2;
        self.layer.shadowOffset      = CGSizeMake(1, 1);
        self.layer.shadowPath        = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        [self addGestureRecognizer:panGesture];
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.mj_h-175)];
        self.headerImageView.backgroundColor = [UIColor lightGrayColor];
        self.headerImageView.userInteractionEnabled = YES;
        [self addSubview:self.headerImageView];
        self.layer.allowsEdgeAntialiasing               = YES;
        self.headerImageView.layer.allowsEdgeAntialiasing = YES;
    }
    return self;
}
#pragma mark ------------- 拖动手势
-(void)beingDragged:(UIPanGestureRecognizer *)gesture {
    self.pointFromCenter = [gesture translationInView:self];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:break;
        case UIGestureRecognizerStateChanged: {
            CGFloat rotationStrength = MIN(self.pointFromCenter.x / 414, 1);
            CGFloat rotationAngel = (CGFloat) (M_PI/8 * rotationStrength);
            CGFloat scale = MAX(1 - fabs(rotationStrength) / 4, 0.93);
            self.center = CGPointMake(self.originalCenter.x + self.pointFromCenter.x, self.originalCenter.y + self.pointFromCenter.y);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.transform = scaleTransform;
            [self.delegate moveCards:self.pointFromCenter.x];
        }break;
        case UIGestureRecognizerStateEnded: {
            [self followUpActionWithDistance:self.pointFromCenter.x andVelocity:[gesture velocityInView:self.superview]];
        }break;
        default:break;
    }
}
#pragma mark ----------- 后续动作判断
-(void)followUpActionWithDistance:(CGFloat)distance andVelocity:(CGPoint)velocity {
    if (self.pointFromCenter.x > 0 && (distance > 150 || velocity.x > 400 )) {
        [self rightAction:velocity];
    } else if(self.pointFromCenter.x < 0 && (distance < - 150 || velocity.x < -400)) {
        [self leftAction:velocity];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
             self.center = self.originalCenter;
             self.transform = CGAffineTransformMakeRotation(0);
         }];
        [self.delegate moveBackCards];
    }
}
-(void)rightAction:(CGPoint)velocity {
    CGFloat distanceX=[[UIScreen mainScreen]bounds].size.width+333+self.originalCenter.x;//横向移动距离
    CGFloat distanceY=distanceX*self.pointFromCenter.y/self.pointFromCenter.x;//纵向移动距离
    CGPoint finishPoint = CGPointMake(self.originalCenter.x+distanceX, self.originalCenter.y+distanceY);//目标center点
    CGFloat vel=sqrtf(pow(velocity.x, 2)+pow(velocity.y, 2));//滑动手势横纵合速度
    CGFloat displace=sqrt(pow(distanceX-self.pointFromCenter.x,2)+pow(distanceY-self.pointFromCenter.y,2));//需要动画完成的剩下距离
    CGFloat duration=MAX(0.3,MIN(0.6,fabs(displace/vel)));//动画时间
    [UIView animateWithDuration:duration animations:^{
         self.center = finishPoint;
         self.transform = CGAffineTransformMakeRotation(M_PI/8);
     }completion:^(BOOL complete){
         [self.delegate swipCard:self Direction:YES];
     }];
    [self.delegate adjustOtherCards];
}
-(void)leftAction:(CGPoint)velocity {
    CGFloat distanceX = -333;// - self.originalPoint.x;
    CGFloat distanceY = distanceX*self.pointFromCenter.y/self.pointFromCenter.x;
    CGPoint finishPoint = CGPointMake(self.originalCenter.x+distanceX, self.originalCenter.y+distanceY);//目标center点
    CGFloat vel = sqrtf(pow(velocity.x, 2) + pow(velocity.y, 2));
    CGFloat displace = sqrtf(pow(distanceX - self.pointFromCenter.x, 2) + pow(distanceY - self.pointFromCenter.y, 2));
    CGFloat duration=MAX(0.3,MIN(0.6,fabs(displace/vel)));//动画时间
    [UIView animateWithDuration:duration animations:^{
         self.center = finishPoint;
         self.transform = CGAffineTransformMakeRotation(-M_PI/8);
     } completion:^(BOOL finished) {
         [self.delegate swipCard:self Direction:NO];
     }];
    [self.delegate adjustOtherCards];
}
-(void)setModel:(CardModel *)model{
    _model = model;
    model.artPhoto = @"group1/M00/01/5D/CjNYDVi1dkyEcWFGAAAAAM3Rr8Q661.jpg";
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://images.mfchao.com/%@", model.artPhoto]]];
}
@end
@interface TeamDesigner ()<JLDragCardDelegate>
@property (assign, nonatomic) CGPoint lastCardCenter;
@property (assign, nonatomic) CGAffineTransform lastCardTransform;
@property (nonatomic,strong) NSMutableArray *allCards;
@property (assign, nonatomic) NSInteger page;
@end
@implementation TeamDesigner
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
    }
    return self;
}
-(void)setSourceObject:(NSMutableArray *)sourceObject{
    _sourceObject = sourceObject;
    self.allCards = [[NSMutableArray alloc] init];
    [self addCards];
    if (self.sourceObject.count>0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6), dispatch_get_main_queue(), ^{
            [self loadAllCards];
        });
    }
}
#pragma mark - 刷新所有卡片
-(void)refreshAllCards{
    self.sourceObject=[@[] mutableCopy];
    self.page = 0;
    for (int i=0; i<_allCards.count ;i++) {
        JLDragCardView *card=self.allCards[i];
        CGPoint finishPoint = CGPointMake(-333, 2*120+card.frame.origin.y);
        [UIView animateKeyframesWithDuration:0.5 delay:0.06*i options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            card.center = finishPoint;
            card.transform = CGAffineTransformMakeRotation(-M_PI/8);
        } completion:^(BOOL finished) {
            card.transform = CGAffineTransformMakeRotation(M_PI/8);
            card.hidden=YES;
            card.center=CGPointMake([[UIScreen mainScreen]bounds].size.width+333, self.center.y);
            if (i==_allCards.count-1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2), dispatch_get_main_queue(), ^{
                    [self loadAllCards];
                });
                
            }
        }];
    }
}
#pragma mark - 重新加载卡片
-(void)loadAllCards{
    for (int i=0; i<_allCards.count ;i++) {
        JLDragCardView *draggableView=self.allCards[i];
        CardModel *model = [self.sourceObject firstObject];
        draggableView.model=model;
        [self.sourceObject removeObjectAtIndex:0];
        [self.sourceObject addObject:model];
        CGPoint finishPoint = CGPointMake(self.center.x, (APPH-64-49-80)/2 + 20);
        [UIView animateKeyframesWithDuration:0.5 delay:0.06*i options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            draggableView.center = finishPoint;
            draggableView.transform = CGAffineTransformMakeRotation(0);
            if (i>0&&i<4-1) {
                JLDragCardView *preDraggableView=[_allCards objectAtIndex:i-1];
                draggableView.transform=CGAffineTransformScale(draggableView.transform, pow(0.95, i), pow(0.95, i));
                CGRect frame=draggableView.frame;
                frame.origin.y=preDraggableView.frame.origin.y+(preDraggableView.frame.size.height-frame.size.height)+10*pow(0.7,i);
                draggableView.frame=frame;
            }else if (i==4-1) {
                JLDragCardView *preDraggableView=[_allCards objectAtIndex:i-1];
                draggableView.transform=preDraggableView.transform;
                draggableView.frame=preDraggableView.frame;
            }
        } completion:^(BOOL finished) {
        }];
        draggableView.originalCenter=draggableView.center;
        draggableView.originalTransform=draggableView.transform;
        if (i==4-1) {
            self.lastCardCenter=draggableView.center;
            self.lastCardTransform=draggableView.transform;
        }
    }
}
#pragma mark - 首次添加卡片
-(void)addCards{
    for (int i = 0; i<4; i++) {
        JLDragCardView *draggableView = [[JLDragCardView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width+APPW-40, self.center.y-(APPH-64-49-80)/2, APPW-40, APPH-64-49-80)];
        if (i>0&&i<4-1) {
            draggableView.transform=CGAffineTransformScale(draggableView.transform, pow(0.95, i), pow(0.95, i));
        }else if(i==4-1){
            draggableView.transform=CGAffineTransformScale(draggableView.transform, pow(0.95, i-1), pow(0.95, i-1));
        }
        draggableView.transform = CGAffineTransformMakeRotation(M_PI/8);
        draggableView.delegate = self;
        [_allCards addObject:draggableView];
    }
    for (int i=(int)4-1; i>=0; i--){
        [self addSubview:_allCards[i]];
    }
}
///FIXME:代理
//滑动中更改其他卡片位置
-(void)moveCards:(CGFloat)distance{
    if (fabs(distance)<=120) {
        for (int i = 1; i<4-1; i++) {
            JLDragCardView *draggableView=_allCards[i];
            JLDragCardView *preDraggableView=[_allCards objectAtIndex:i-1];
            draggableView.transform=CGAffineTransformScale(draggableView.originalTransform, 1+(1/0.95-1)*fabs(distance/120)*0.6, 1+(1/0.95-1)*fabs(distance/120)*0.6);//0.6为缩减因数，使放大速度始终小于卡片移动速度
            CGPoint center=draggableView.center;
            center.y=draggableView.originalCenter.y-(draggableView.originalCenter.y-preDraggableView.originalCenter.y)*fabs(distance/120)*0.6;//此处的0.6同上
            draggableView.center=center;
        }
    }
}
//滑动后调整其他卡片位置
-(void)adjustOtherCards{
    [UIView animateWithDuration:0.2 animations:^{
         for (int i = 1; i<4-1; i++) {
             JLDragCardView *draggableView=_allCards[i];
             JLDragCardView *preDraggableView=[_allCards objectAtIndex:i-1];
             draggableView.transform=preDraggableView.originalTransform;
             draggableView.center=preDraggableView.originalCenter;
         }
     }completion:^(BOOL complete){
     }];
}
//滑动后续操作
-(void)swipCard:(JLDragCardView *)cardView Direction:(BOOL)isRight {
    [_allCards removeObject:cardView];
    cardView.transform = self.lastCardTransform;
    cardView.center = self.lastCardCenter;
    [self insertSubview:cardView belowSubview:[_allCards lastObject]];
    [_allCards addObject:cardView];
    if ([self.sourceObject firstObject]!=nil) {
        cardView.model=[self.sourceObject firstObject];
        CardModel *model = [self.sourceObject firstObject];
        [self.sourceObject removeObjectAtIndex:0];
        [self.sourceObject addObject:model];
        [cardView layoutSubviews];
        if (self.sourceObject.count<10) {
            [self refreshAllCards];
        }
    }else{
        [self refreshAllCards];
    }
    for (int i = 0; i<4; i++) {
        JLDragCardView*draggableView=[_allCards objectAtIndex:i];
        draggableView.originalCenter=draggableView.center;
        draggableView.originalTransform=draggableView.transform;
    }
}
//滑动终止后复原其他卡片
-(void)moveBackCards{
    for (int i = 1; i<4-1; i++) {
        JLDragCardView *draggableView=_allCards[i];
        [UIView animateWithDuration:0.3 animations:^{
             draggableView.transform=draggableView.originalTransform;
             draggableView.center=draggableView.originalCenter;
         }];
    }
}
@end
