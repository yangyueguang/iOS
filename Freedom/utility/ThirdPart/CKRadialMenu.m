//  CKRadialView.m
//  Freedom
//  Created by Super on 12/7/14.
#import "CKRadialMenu.h"
#import "UIView+expanded.h"
@interface CKRadialMenu()
@property(nonatomic,strong)NSMutableDictionary *poputIDs;
@property(nonatomic,strong)NSMutableArray<NSArray*> *popViewArray;
@property(nonatomic,assign)int lastTapnumber;
@end
@implementation CKRadialMenu
-(instancetype)init {
  self = [self initWithFrame:CGRectZero];
  return self;
}
- (id)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
      self.lastTapnumber = 0;
      self.popViewArray = [NSMutableArray array];
    self.popoutViews = [NSMutableArray new];
    self.poputIDs = [NSMutableDictionary new];
    self.menuIsExpanded = false;
    self.centerView = nil;
    self.centerView.frame = self.bounds;
    self.startAngle = -75;
    self.distanceBetweenPopouts = 2*180/10;
    self.distanceFromCenter = 100;
    self.stagger = 0.1;
    self.animationDuration = 0.4;
    [self addSubview:self.centerView];
    NSLog(@"半径: %.02f\n起始角度: %.02f\n间距: %.02f\n动画时间间距: %.02f\n动画总时间: %.02f", self.distanceFromCenter,self.startAngle,self.distanceBetweenPopouts,self.stagger,self.animationDuration);
  }
  return self;
}
#pragma mark 关于中间的按钮
- (void) setCenterView:(UIView *)centerView {
    if (!centerView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"ZUAN"];
        view.layer.cornerRadius = self.frame.size.width/2;
        view.layer.shadowColor = [[UIColor blackColor] CGColor];
        view.layer.shadowOpacity = 0.6;
        view.layer.shadowRadius = 2.0;
        view.layer.shadowOffset = CGSizeMake(0, 3);
        centerView = view;
    }
    _centerView = centerView;
    _centerView.userInteractionEnabled= YES;
    UITapGestureRecognizer *singleTap = [UITapGestureRecognizer new];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [singleTap addTarget:self action:@selector(didTapCenterView:)];
    [self.centerView addGestureRecognizer:singleTap];
    UITapGestureRecognizer *doubleTap = [UITapGestureRecognizer new];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [doubleTap addTarget:self action:@selector(didTapCenterView:)];
    [self.centerView addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    UIPanGestureRecognizer *panner = [UIPanGestureRecognizer new];
    [panner addTarget:self action:@selector(didPanCenterView:)];
    [self.centerView addGestureRecognizer:panner];
    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongpressCenterView)];
    longP.minimumPressDuration = 0.5;
    [self.centerView addGestureRecognizer:longP];
}
-(void) didPanCenterView:(UIPanGestureRecognizer *)sender {
    self.center = [sender locationInView:self.window];
    sender.view.center = [sender locationInView:self];
}
-(void)didLongpressCenterView{
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc =[StoryBoard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    CATransition *animation = [CATransition animation];
    animation.duration = 2.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    [[self getCurrentViewController].view.window.layer addAnimation:animation forKey:nil];
    UIWindow *win =[UIApplication sharedApplication].keyWindow;
    win.rootViewController = vc;
    [win makeKeyAndVisible];
}
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}
-(void)setFrame:(CGRect)frame{
  [super setFrame:frame];
  self.centerView.frame = self.bounds;
}
- (void) didTapCenterView: (UITapGestureRecognizer *) sender {
    NSInteger tapNumber = sender.numberOfTapsRequired - 1;
    NSLog(@"=====%ld",tapNumber);
    if(_lastTapnumber != tapNumber && self.popViewArray.count>0){
        _lastTapnumber = tapNumber;
        if(self.menuIsExpanded){
            [self retract];
        }
        self.popoutViews = [NSMutableArray arrayWithArray:self.popViewArray[tapNumber]];
    }
  if (self.menuIsExpanded) {
    [self retract];
  } else {
    [self expand];
  }
}
//发射按钮
- (void)expand{
    NSInteger i = 0;
    for (UIView *subView in self.popoutViews) {
      subView.alpha = 0;
      [UIView animateWithDuration:self.animationDuration
                            delay:self.stagger*i
           usingSpringWithDamping:0.7
            initialSpringVelocity:0.4
                          options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            subView.alpha = 1;
                            subView.transform = [self getTransformForPopupViewAtIndex:i];
                          } completion:^(BOOL finished) {
                              if(self.didSelectBlock){
                                  self.didSelectBlock(self, YES, NO, nil);
                              }
                          }];
      i++;
    }
    self.menuIsExpanded = true;
}
//收回按钮
- (void)retract{
    NSInteger i = 0;
    for (UIView *subView in self.popoutViews) {
      [UIView animateWithDuration:self.animationDuration
                            delay:self.stagger*i
           usingSpringWithDamping:0.7
            initialSpringVelocity:0.4
                          options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            subView.transform = CGAffineTransformIdentity;
                            subView.alpha = 0;
                          } completion:^(BOOL finished) {
                              if(self.didSelectBlock){
                                  self.didSelectBlock(self, NO, YES, nil);
                              }
                          }];
      i++;
    }
    self.menuIsExpanded = false;
}
#pragma mark 发射出来的按钮或视图
- (void)addPopoutView:(UIView *)popoutView withIndentifier:(NSString *)identifier{
    [self configPopView:popoutView];
    [self.popoutViews addObject:popoutView];
    [self.poputIDs setObject:popoutView forKey:identifier];
    [self bringSubviewToFront:popoutView];
    [self sendSubviewToBack:popoutView];
}
-(void)addPopoutViews:(NSArray<UIView *> *)popoutViews{
    if(self.popViewArray.count==0){
        [self.popViewArray addObject:self.popoutViews];
    }
    for(int i=0;i<popoutViews.count;i++){
        UIView *popView = popoutViews[i];
        [self configPopView:popView];
        [self.poputIDs setObject:popView forKey:[NSString stringWithFormat:@"%ld",i + self.popViewArray.count * 100]];
        [self sendSubviewToBack:popView];
    }
    [self.popViewArray addObject:popoutViews];
}
-(void)configPopView:(UIView*)popoutView{
    if(!popoutView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/1.5, self.frame.size.height / 1.5)];
        view.layer.cornerRadius = view.frame.size.width/2;
        view.layer.shadowColor = [[UIColor blackColor] CGColor];
        view.layer.shadowOpacity = 0.6;
        view.layer.shadowRadius = 3.0;
        view.layer.shadowOffset = CGSizeMake(0, 3);
        view.backgroundColor = [UIColor redColor];
        popoutView = view;
    }
    UIGestureRecognizer *tap = [UITapGestureRecognizer new];
    [tap addTarget:self action:@selector(didTapPopoutView:)];
    UIPanGestureRecognizer *panner = [UIPanGestureRecognizer new];
    [panner addTarget:self action:@selector(didPanPopout:)];
    [popoutView addGestureRecognizer:panner];
    popoutView.userInteractionEnabled = YES;
    [popoutView addGestureRecognizer:tap];
    popoutView.alpha = 0;
    popoutView.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2,self.bounds.origin.y + self.bounds.size.height/2);
    [self addSubview:popoutView];
}
- (void)didTapPopoutView:(UITapGestureRecognizer *)sender{
    UIView *view = sender.view;
    NSString * key = [self.poputIDs allKeysForObject:view][0];
    if(self.didSelectBlock){
        self.didSelectBlock(self, NO, NO, key);
    }
}
-(UIView *)getPopoutViewWithIndentifier:(NSString *)identifier {
  return [self.poputIDs objectForKey:identifier];
}
#pragma mark Helper Methods
- (CGAffineTransform)getTransformForPopupViewAtIndex:(NSInteger)index {
 self.distanceBetweenPopouts = 2 * 180 /self.popoutViews.count;
  CGFloat newAngle = self.startAngle + (self.distanceBetweenPopouts * index);
  CGFloat deltaY = -self.distanceFromCenter * cos(newAngle/ 180.0 * M_PI);
  CGFloat deltaX = self.distanceFromCenter * sin(newAngle/ 180.0 * M_PI);
  return CGAffineTransformMakeTranslation(deltaX, deltaY);
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
  if (CGRectContainsPoint(self.bounds, point)) {
    return true;
  }
  for (UIView *subView in self.popoutViews) {
    if (CGRectContainsPoint(subView.frame, point)) {
      return true;
    }
  }
  return false;
}
-(void)didPanPopout:(UIPanGestureRecognizer *)sender{
  UIView *view = sender.view;
  NSInteger i = [self.popoutViews indexOfObject:view];
  CGPoint point = [sender locationInView:self];
  CGFloat centerX = self.bounds.origin.x + self.bounds.size.width/2;
  CGFloat centerY = self.bounds.origin.y + self.bounds.size.height/2;
  if (sender.state == UIGestureRecognizerStateChanged) {
    CGFloat deltaX = point.x - centerX;
    CGFloat deltaY = point.y - centerY;
    CGFloat angle = atan2(deltaX, -deltaY) * 180.0 / M_PI ;
    CGFloat distanceFromCenter = sqrt(pow(point.x - centerX, 2) + pow(point.y - centerY, 2));
    self.distanceFromCenter = distanceFromCenter;
    self.startAngle = angle - self.distanceBetweenPopouts * i;
//    NSLog(@"半径: %.02f\n起始角度: %.02f", self.distanceFromCenter, self.startAngle);
    view.center = point;
    view.transform = CGAffineTransformIdentity;
    NSInteger i = 0;
    for (UIView *subView in self.popoutViews) {
      if (subView != view) {
        subView.transform = [self getTransformForPopupViewAtIndex:i];
      }
      i++;
    }
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    view.center = CGPointMake(centerX, centerY);
    NSInteger i = 0;
    for (UIView *subView in self.popoutViews) {
        subView.transform = [self getTransformForPopupViewAtIndex:i];
      i++;
    }
  }
}
- (void)distanceSliderChanged:(UISlider *)sender {
  if (!self.menuIsExpanded){
    [self expand];
  }
  self.distanceBetweenPopouts = sender.value;
  NSLog(@"距离: %.02f", self.distanceBetweenPopouts);
  NSInteger i = 0;
  for (UIView *subView in self.popoutViews) {
    subView.transform = [self getTransformForPopupViewAtIndex:i];
    i++;
  }
}
@end
