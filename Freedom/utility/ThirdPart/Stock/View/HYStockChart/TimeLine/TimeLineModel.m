//
#import "TimeLineModel.h"
#import "HYStockChartConstant.h"
#import "StockCategory.h"
#import "MJExtension.h"
@implementation HYTimeLineAbovePositionModel
@end
@interface HYTimeLine ()
@property(nonatomic,assign) CGContextRef context;
@end
@implementation HYTimeLine
-(instancetype)initWithContext:(CGContextRef)context{
    self = [super init];
    if (self) {
        self.context = context;
        _horizontalYPosition = -1;
    }
    return self;
}
-(void)draw{
    NSAssert(self.context && self.positionModels, @"context或者positionModel不能为空!");
    NSInteger count = self.positionModels.count;
    NSArray *positionModels = self.positionModels;
    //添加分时线宽度
    CGContextSetLineWidth(self.context, HYStockChartTimeLineLineWidth);
    //添加分时线颜色
    CGContextSetStrokeColorWithColor(self.context, TimeLineLineColor.CGColor);
    CGMutablePathRef fillPath = CGPathCreateMutable();
    CGFloat maxY = self.timeLineViewMaxY;
    for (NSInteger index = 0; index < count; index++) {
        //当前的点
        HYTimeLineAbovePositionModel *positionModel = (HYTimeLineAbovePositionModel *)positionModels[index];
        //当前点是否包含X，Y
        if (isnan(positionModel.currentPoint.x) || isnan(positionModel.currentPoint.y)) {
            continue;
        }
        NSAssert(!isnan(positionModel.currentPoint.x) && !isnan(positionModel.currentPoint.y) && !isinf(positionModel.currentPoint.x) && !isinf(positionModel.currentPoint.y), @"不符合要求的点！");
        
        
         CGContextSetStrokeColorWithColor(self.context, TimeLineLineColor.CGColor);
        //移动到当前点
        CGContextMoveToPoint(self.context, positionModel.currentPoint.x, positionModel.currentPoint.y);
        //绘制分时线条
        if (index+1 < count) {
            HYTimeLineAbovePositionModel *nextPositionModel = (HYTimeLineAbovePositionModel *)positionModels[index+1];
            CGContextAddLineToPoint(self.context, nextPositionModel.currentPoint.x, nextPositionModel.currentPoint.y);
        }
        CGContextStrokePath(self.context);
        
        
        
//         CGContextSetStrokeColorWithColor(self.context, [UIColor redColor].CGColor);
//        //移动到当前点
//        CGContextMoveToPoint(self.context, positionModel.currentPoint.x, positionModel.currentPoint.y+5);
//        //绘制分时线条
//        if (index+1 < count) {
//            HYTimeLineAbovePositionModel *nextPositionModel = (HYTimeLineAbovePositionModel *)positionModels[index+1];
//            CGContextAddLineToPoint(self.context, nextPositionModel.currentPoint.x, nextPositionModel.currentPoint.y+5);
//        }
//        CGContextStrokePath(self.context);
        
        
        
        
        
        
        //绘制渐变图
        if (0 == index){
            CGPathMoveToPoint(fillPath, NULL, positionModel.currentPoint.x, maxY);
            CGPathAddLineToPoint(fillPath, NULL, positionModel.currentPoint.x,positionModel.currentPoint.y);
        }else{
            CGPathAddLineToPoint(fillPath, NULL, positionModel.currentPoint.x,positionModel.currentPoint.y);
        }
        if ((count - 1) == index) {
            CGPathAddLineToPoint(fillPath, NULL, positionModel.currentPoint.x, positionModel.currentPoint.y);
            CGPathAddLineToPoint(fillPath, NULL, positionModel.currentPoint.x, maxY);
            CGPathCloseSubpath(fillPath);
        }
    }
    if (count > 0) {
        [self drawLinearGradient:self.context path:fillPath alpha:0.15f startColor:FenShiGradientColor.CGColor endColor:FenShiGradientColor.CGColor];
    }
    CGPathRelease(fillPath);
    //  CGContextRestoreGState(self.context);
    //绘制当前Y的虚线
    CGContextSetStrokeColorWithColor(self.context, GridLineColor.CGColor);
    const CGFloat lengths[] = {1,3};
    CGContextSetLineDash(self.context, 0, lengths, 2);
    //if (isnumber(self.horizontalYPosition))
    if (self.horizontalYPosition > 0){
        CGContextMoveToPoint(self.context, 0, self.horizontalYPosition);
        CGContextAddLineToPoint(self.context, self.timeLineViewWidth, self.horizontalYPosition);
        CGContextStrokePath(self.context);
    }
}
- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                     alpha:(CGFloat)alpha
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextSetAlpha(context, alpha);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
@end
@implementation TimeLineModel
@end
@implementation HYTimeLineModel
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"currentPrice":@"Close",
             @"currentTime":@"EndTime",
             @"currentDate":@"EndDate",
             @"volume":@"Volume"
             };
}
-(NSString *)currentTime{
    NSString *fullTime = [NSString stringWithFormat:@"%@ %@",_currentDate,_currentTime];
    return fullTime;
}
@end
@implementation HYTimeLineGroupModel
+(instancetype)groupModelWithTimeModels:(NSArray *)timeModels lastDayEndPrice:(CGFloat)lastDayEndPrice{
    HYTimeLineGroupModel *groupModel = [[HYTimeLineGroupModel alloc] init];
    groupModel.timeModels = timeModels;
    groupModel.lastDayEndPrice = lastDayEndPrice;
    return groupModel;
}
@end
@implementation JMSGroupTimeLineModel
@end
@implementation JMSTimeLineModel
@end
