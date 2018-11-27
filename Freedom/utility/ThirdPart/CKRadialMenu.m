//  CKRadialView.m
//  Freedom
//  Created by Freedom on 12/7/14.
#import "CKRadialMenu.h"
#import "FirstViewController.h"
#import "UIView+expanded.h"
@interface CKRadialMenu()
@property (nonatomic, strong) NSMutableDictionary *poputIDs;
@property (nonatomic, strong) UIView *positionView;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *distanceBetweenLabel;
@property (nonatomic, strong) UILabel *angleLabel;
@property (nonatomic, strong) UILabel *staggerLabel;
@property (nonatomic, strong) UILabel *animationLabel;
@end
@implementation CKRadialMenu
#pragma mark 初始化
//-(instancetype)initWithCoder:(NSCoder *)aDecoder{
//  return [self initWithFrame:CGRectZero];
//}
-(instancetype)init {
  self = [self initWithFrame:CGRectZero];
  return self;
}
- (id)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    self.popoutViews = [NSMutableArray new];
    self.poputIDs = [NSMutableDictionary new];
    self.menuIsExpanded = false;
    self.centerView = [self makeDefaultCenterView];
    self.centerView.frame = self.bounds;
    self.startAngle = -75;
    self.distanceBetweenPopouts = 2*180/10;
    self.distanceFromCenter = 100;
    self.stagger = 0.1;
    self.animationDuration = 0.4;
    [self addSubview:self.centerView];
  }
  return self;
}
#pragma mark 关于中间的按钮
- (void) setCenterView:(UIView *)centerView {
    if (!centerView) {
    centerView = [self makeDefaultCenterView];
    }
    _centerView = centerView;
    _centerView.userInteractionEnabled= YES;
    UIGestureRecognizer *tap = [UITapGestureRecognizer new];
    [tap addTarget:self action:@selector(didTapCenterView:)];
    [self.centerView addGestureRecognizer:tap];
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
//    vc.view.alpha = 0;
    animation.duration = 2.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
//    animation.type = kCATransitionPush;
//    animation.subtype = kCATransitionFromLeft;
    [[self getCurrentViewController].view.window.layer addAnimation:animation forKey:nil];
    UIWindow *win =[UIApplication sharedApplication].keyWindow;
    win.rootViewController = vc;
    [win makeKeyAndVisible];
//    [[self getCurrentViewController] presentViewController:vc animated:NO completion:^{vc.view.alpha = 1;}];
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
  if (self.menuIsExpanded) {
    [self retract];
  } else {
    [self expand];
  }
}
//发射按钮
- (void) expand {
  if (![self.delegate respondsToSelector:@selector(radialMenuShouldExpand:)] || [self.delegate radialMenuShouldExpand:self]) {
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
                            if ([self.delegate respondsToSelector:@selector(radialMenuDidExpand:)]) {
                              [self.delegate radialMenuDidExpand:self];
                            }
                          }];
      i++;
    }
    self.menuIsExpanded = true;
  }
}
//收回按钮
- (void) retract {
  if (![self.delegate respondsToSelector:@selector(radialMenuShouldRetract:)] || [self.delegate radialMenuShouldRetract:self]) {
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
                            if ([self.delegate respondsToSelector:@selector(radialMenuDidRetract:)]) {
                              [self.delegate radialMenuDidRetract:self];
                            }
                          }];
      i++;
    }
    self.menuIsExpanded = false;
  }
}
#pragma mark 发射出来的按钮或视图
- (void) addPopoutView: (UIView *) popoutView withIndentifier: (NSString *) identifier {
  if (!popoutView){
    popoutView = [self makeDefaultPopupView];
  }
  [self.popoutViews addObject:popoutView];
  [self.poputIDs setObject:popoutView forKey:identifier];
  UIGestureRecognizer *tap = [UITapGestureRecognizer new];
  [tap addTarget:self action:@selector(didTapPopoutView:)];
    popoutView.userInteractionEnabled = YES;
  [popoutView addGestureRecognizer:tap];
  popoutView.alpha = 0;
  [self addSubview:popoutView];
    [self bringSubviewToFront:popoutView];
  [self sendSubviewToBack:popoutView];
  popoutView.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2,self.bounds.origin.y + self.bounds.size.height/2);
}
-(void)addPopoutViews:(UIView *)popoutView,...{
    if (!popoutView){ popoutView = [self makeDefaultPopupView];}
    int i=0;
    UIGestureRecognizer *tap = [UITapGestureRecognizer new];
    [tap addTarget:self action:@selector(didTapPopoutView:)];
    [popoutView addGestureRecognizer:tap];
    [self.popoutViews addObject:popoutView];
    [self.poputIDs setObject:popoutView forKey:[NSString stringWithFormat:@"%d",i++]];
    popoutView.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2,self.bounds.origin.y + self.bounds.size.height/2);
    [self addSubview:popoutView];
    [self sendSubviewToBack:popoutView];
    va_list ap;
    va_start(ap, popoutView);
    UIView *akey=va_arg(ap,id);
    while (akey) {
        if (!akey){
            akey = [self makeDefaultPopupView];
        }
        [self.popoutViews addObject:akey];
        [self.poputIDs setObject:akey forKey:[NSString stringWithFormat:@"%d",i++]];
        UIGestureRecognizer *tap = [UITapGestureRecognizer new];
        [tap addTarget:self action:@selector(didTapPopoutView:)];
        akey.userInteractionEnabled = YES;
        [akey addGestureRecognizer:tap];
        akey.alpha = 0;
        [self addSubview:akey];
         akey.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2,self.bounds.origin.y + self.bounds.size.height/2);
        
        akey=va_arg(ap,id);
    }
    va_end(ap);
    [self enableDevelopmentMode];
}
- (void) didTapPopoutView: (UITapGestureRecognizer *) sender {
    UIView *view = sender.view;
    NSString * key = [self.poputIDs allKeysForObject:view][0];
    [self.delegate radialMenu:self didSelectPopoutWithIndentifier:key];
}
-(UIView *)getPopoutViewWithIndentifier:(NSString *)identifier {
  return [self.poputIDs objectForKey:identifier];
}
#pragma mark Make Default Views
- (UIView *) makeDefaultCenterView {
  UIImageView *view = [UIImageView new];
    view.image = [UIImage imageNamed:@"ZUAN"];
  view.layer.cornerRadius = self.frame.size.width/2;
//  view.backgroundColor = [UIColor redColor];
  view.layer.shadowColor = [[UIColor blackColor] CGColor];
  view.layer.shadowOpacity = 0.6;
  view.layer.shadowRadius = 2.0;
  view.layer.shadowOffset = CGSizeMake(0, 3);
  return view;
}
- (UIView *) makeDefaultPopupView {
  UIView *view = [UIView new];
  view.frame = CGRectMake(0, 0, self.frame.size.width/1.5, self.frame.size.height / 1.5);
  view.layer.cornerRadius = view.frame.size.width/2;
  view.backgroundColor = [UIColor blueColor];
  view.layer.shadowColor = [[UIColor blackColor] CGColor];
  view.layer.shadowOpacity = 0.6;
  view.layer.shadowRadius = 3.0;
  view.layer.shadowOffset = CGSizeMake(0, 3);
    view.backgroundColor = redcolor;
  return view;
}
#pragma mark Helper Methods
- (CGAffineTransform) getTransformForPopupViewAtIndex: (NSInteger) index {
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
- (void) enableDevelopmentMode {
  UIView *positionView = [UIView new];
  CGRect screenRect = [UIScreen mainScreen].bounds;
  positionView.frame = CGRectMake(screenRect.origin.x, screenRect.origin.y, screenRect.size.width,110);
  [[[[UIApplication sharedApplication] delegate] window] addSubview:positionView];
  [[[[UIApplication sharedApplication] delegate] window] bringSubviewToFront:positionView];
  
  self.distanceLabel = [UILabel new];
  self.distanceLabel.frame = CGRectMake(10, 20, 300, 20);
  self.distanceLabel.text = [NSString stringWithFormat:@"半径: %.02f", self.distanceFromCenter];
  self.distanceLabel.font = [UIFont fontWithName:@"Avenir" size:16];
  
  self.angleLabel = [UILabel new];
  self.angleLabel.frame = CGRectMake(10, 40, 300, 20);
  self.angleLabel.text = [NSString stringWithFormat:@"起始角度: %.02f", self.startAngle];
  self.angleLabel.font = [UIFont fontWithName:@"Avenir" size:16];
  
  self.distanceBetweenLabel = [UILabel new];
  self.distanceBetweenLabel.frame = CGRectMake(10, 60, 200, 20);
  self.distanceBetweenLabel.text = [NSString stringWithFormat:@"间距: %.02f", self.distanceBetweenPopouts];
  self.distanceBetweenLabel.font = [UIFont fontWithName:@"Avenir" size:16];
  UISlider *distanceSlider = [UISlider new];
  distanceSlider.frame = CGRectMake(200, 60, screenRect.size.width - 225, 20);
  distanceSlider.maximumValue = 180;
  distanceSlider.minimumValue = 0;
  distanceSlider.value = self.distanceBetweenPopouts;
  [distanceSlider addTarget:self action:@selector(distanceSliderChanged:) forControlEvents:UIControlEventValueChanged];
  
  self.staggerLabel = [UILabel new];
  self.staggerLabel.frame = CGRectMake(10, 100, 200, 20);
  self.staggerLabel.text = [NSString stringWithFormat:@"动画时间间距: %.02f", self.stagger];
  self.staggerLabel.font = [UIFont fontWithName:@"Avenir" size:16];
  UISlider *staggerSlider = [UISlider new];
  staggerSlider.frame = CGRectMake(200, 100, screenRect.size.width - 225, 20);
  staggerSlider.maximumValue = 1;
  staggerSlider.minimumValue = 0;
  staggerSlider.value = self.stagger;
  [staggerSlider addTarget:self action:@selector(staggerSliderChanged:) forControlEvents:UIControlEventValueChanged];
    
//    [positionView addSubview:self.distanceLabel];
//    [positionView addSubview:self.angleLabel];
//    [positionView addSubview:self.distanceBetweenLabel];
//    [positionView addSubview:self.staggerLabel];
//    [positionView addSubview:distanceSlider];
//    [positionView addSubview:staggerSlider];
//    positionView.backgroundColor = redcolor;
  for (UIView *subView in self.popoutViews) {
    //[subView removeGestureRecognizer:[subView gestureRecognizers][0]];
    UIPanGestureRecognizer *panner = [UIPanGestureRecognizer new];
    [panner addTarget:self action:@selector(didPanPopout:)];
      subView.userInteractionEnabled = YES;
    [subView addGestureRecognizer:panner];
  }
  
}
-(void) didPanPopout:(UIPanGestureRecognizer *)sender {
  UIView *view = sender.view;
  NSInteger i = [self.popoutViews indexOfObject:view];
  CGPoint point = [sender locationInView:self];
  CGFloat centerX = self.bounds.origin.x + self.bounds.size.width/2;
  CGFloat centerY = self.bounds.origin.y + self.bounds.size.height/2;
  if (sender.state == UIGestureRecognizerStateChanged) {
    
    // Do Calculations
    CGFloat deltaX = point.x - centerX;
    CGFloat deltaY = point.y - centerY;
    CGFloat angle = atan2(deltaX, -deltaY) * 180.0 / M_PI ;
    CGFloat distanceFromCenter = sqrt(pow(point.x - centerX, 2) + pow(point.y - centerY, 2));
    
    // Assign Results
    self.distanceFromCenter = distanceFromCenter;
    self.startAngle = angle - self.distanceBetweenPopouts * i;
    
    // Change Labels
    self.distanceLabel.text = [NSString stringWithFormat:@"半径: %.02f", self.distanceFromCenter];
    self.angleLabel.text = [NSString stringWithFormat:@"起始角度: %.02f", self.startAngle];
    
    // Change Position of Views
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
  self.distanceBetweenLabel.text = [NSString stringWithFormat:@"距离: %.02f", self.distanceBetweenPopouts];
  NSInteger i = 0;
  for (UIView *subView in self.popoutViews) {
    subView.transform = [self getTransformForPopupViewAtIndex:i];
    i++;
  }
}
- (void)staggerSliderChanged:(UISlider *)sender {
  self.stagger = sender.value;
  self.staggerLabel.text = [NSString stringWithFormat:@"动画时间间距: %.02f", self.stagger];
}
- (void)durationSliderChanged:(UISlider *)sender {
  self.animationDuration = sender.value;
  self.animationLabel.text = [NSString stringWithFormat:@"动画总时间: %.02f", self.animationDuration];
}
@end
