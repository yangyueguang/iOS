//
//  NSDateFormatter+HYStockChart.m
//  jimustock
#import "StockCategory.h"
@implementation NSDateFormatter (HYStockChart)
+(NSDateFormatter *)shareDateFormatter{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    });
    return formatter;
}
@end

@implementation UIFont (Extension)
#pragma mark 黑体-简 细体
+(UIFont *)blackSimpleFontWithSize:(CGFloat)size{
    return [UIFont systemFontOfSize:size];
}
+(UIFont *)hlFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"Helvetica Light" size:size];
}
#pragma mark Helvetica Neue字体
+(UIFont *)hnFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
}
#pragma mark Adobe 黑体
+(UIFont *)adobeBlackFontWithSize:(CGFloat)size{
    return [UIFont systemFontOfSize:size];
}
@end
@implementation UIView (HXCircleAnimation)
-(void)showCircleAnimationLayerWithColor:(UIColor *)circleColor andScale:(CGFloat)scale{
    if (!self.superview && circleColor) {
        return;
    }
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.layer.cornerRadius];
    CGPoint shapePosition = [self.superview convertPoint:self.center fromView:self.superview];
    //内圈
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = circleColor.CGColor;//
    circleShape.lineWidth = 0.6;
    [self.superview.layer addSublayer:circleShape];
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    //scaleAnimation.duration = 2;
    scaleAnimation.duration = 1.0;
    scaleAnimation.repeatCount = MAXFLOAT;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [circleShape addAnimation:scaleAnimation forKey:nil];
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    // alphaAnimation.duration = 1.8;
    alphaAnimation.duration = 1.0;
    alphaAnimation.repeatCount = MAXFLOAT;
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:alphaAnimation forKey:nil];
    //内圈
    CAShapeLayer *circleShape2 = [CAShapeLayer layer];
    circleShape2.path = path.CGPath;
    circleShape2.position = shapePosition;
    circleShape2.fillColor = circleColor.CGColor;//
    circleShape2.opacity = 0;
    circleShape2.strokeColor = [UIColor clearColor].CGColor;
    circleShape2.lineWidth = 0;
    [self.superview.layer insertSublayer:circleShape2 atIndex:0];
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation2.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    // scaleAnimation2.duration = 2;
    scaleAnimation2.duration = 1.0;
    scaleAnimation2.repeatCount = MAXFLOAT;
    scaleAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [circleShape2 addAnimation:scaleAnimation2 forKey:nil];
    CABasicAnimation *alphaAnimation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation2.fromValue = @0.8;
    alphaAnimation2.toValue = @0;
    // alphaAnimation2.duration = 1.7;
    alphaAnimation2.duration = 1.0;
    alphaAnimation2.repeatCount = MAXFLOAT;
    alphaAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape2 addAnimation:alphaAnimation2 forKey:nil];
    //    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    //    dispatch_after(time, dispatch_get_main_queue(), ^{
    //        [circleShape removeFromSuperlayer];
    //        [circleShape2 removeFromSuperlayer];
    //    });
}
@end
