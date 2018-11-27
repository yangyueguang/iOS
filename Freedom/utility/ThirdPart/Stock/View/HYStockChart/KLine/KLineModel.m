//
//  KLineModel.m
//  HTFProject
//
#import "KLineModel.h"
#import "HYStockChartConstant.h"
#import "StockCategory.h"
#import "HYStockChartTool.h"
@interface HYKLine()
@property(nonatomic,assign) CGContextRef context;
@property(nonatomic,assign) CGPoint lastDrawDatePoint;
@end
@implementation HYKLine
#pragma mark 根据context初始化
-(instancetype)initWithContext:(CGContextRef)context{
    self = [super init];
    if (self) {
        _context = context;
        _lastDrawDatePoint = CGPointZero;
    }
    return self;
}
#pragma mark 绘制K线
-(UIColor *)draw{
    //如果没有数据，直接返回
    if (!self.kLineModel || !self.context || !self.kLineModel) {
        return nil;
    }
    CGContextRef context = self.context;
    //设置画笔颜色
    UIColor *strokeColor = nil;
    //减少的
    if (self.kLinePositionModel.openPoint.y < self.kLinePositionModel.closePoint.y) {
        strokeColor = DecreaseColor;
    }else{
        strokeColor = IncreaseColor;
    }
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    //画中间的开收盘线
    //设置开收盘线的宽度
    CGContextSetLineWidth(context, [HYStockChartTool kLineWidth]);
    //画实体线
    const CGPoint solidPoints[] = {self.kLinePositionModel.openPoint,self.kLinePositionModel.closePoint};
    CGContextStrokeLineSegments(context, solidPoints, 2);
    //画上影线和下影线
    //设置上影线和下影线的线的宽度
    CGContextSetLineWidth(context, [self shadowLineWidth]);
    //画出上下影线
    const CGPoint shadowPoints[] = {self.kLinePositionModel.highPoint,self.kLinePositionModel.lowPoint};
    CGContextStrokeLineSegments(context, shadowPoints, 2);
    if (self.kLineModel.isFirstTradeDate) {
        NSString *dateStr = self.kLineModel.date;
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"MM/dd/yyyy";
        NSDate *date = [formatter dateFromString:dateStr];
        formatter.dateFormat = @"yyyy-MM-dd";
        dateStr = [formatter stringFromDate:date];
        CGSize dateSize = [dateStr sizeWithAttributes:@{NSFontAttributeName:[UIFont hlFontWithSize:11]}];
        CGPoint drawDatePoint = CGPointMake(self.kLinePositionModel.highPoint.x-dateSize.width/2, self.maxY+2);
        
        if (CGPointEqualToPoint(self.lastDrawDatePoint, CGPointZero) || drawDatePoint.x - self.lastDrawDatePoint.x > 100) {
            [dateStr drawAtPoint:drawDatePoint withAttributes:@{NSFontAttributeName:[UIFont hlFontWithSize:11],NSForegroundColorAttributeName:AssistTextColor}];
            self.lastDrawDatePoint = drawDatePoint;
            
            CGPoint startPoint = CGPointMake(self.kLinePositionModel.highPoint.x, HYStockChartKLineAboveViewMinY);
            CGPoint endPoint = CGPointMake(self.kLinePositionModel.highPoint.x, self.maxY);
            [self drawline:context startPoint:startPoint stopPoint:endPoint color:GridLineColor lineWidth:0.25];
        }
    }
    return strokeColor;
}
#pragma mark - **************** 绘制线
- (void)drawline:(CGContextRef)context
      startPoint:(CGPoint)startPoint
       stopPoint:(CGPoint)stopPoint
           color:(UIColor *)color
       lineWidth:(CGFloat)lineWitdth{
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, lineWitdth);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, stopPoint.x,stopPoint.y);
    CGContextStrokePath(context);
}
/**
 *  影线的宽度
 */
-(CGFloat)shadowLineWidth{
    return 1.0f;
}
@end
@implementation KLineModel
@end
@implementation HYKLineModel
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"date":@"Date",
             @"high":@"High",
             @"low":@"Low",
             @"close":@"Last",
             @"open":@"Open",
             @"volume":@"Volume",
             @"MA10":@"MA10",
             @"MA20":@"MA20",
             @"MA5":@"MA5",
             @"changeFromLastClose":@"ChangeFromLastClose",
             @"changeFromOpen":@"ChangeFromOpen",
    @"percentChangeFromLastClose":@"PercentChangeFromLastClose",
             @"percentChangeFromOpen":@"PercentChangeFromOpen"
             };
}
@end
@implementation JMSKLineGroupModel
+(NSDictionary *)objectClassInArray{
    return @{@"GlobalQuotes":@"JMSKLineModel"};
}
@end
@implementation JMSKLineModel
@end
@implementation HYKLinePositionModel
#pragma mark 用属性创建一个模型
+(instancetype)modelWithOpen:(CGPoint)openPoint close:(CGPoint)closePoint high:(CGPoint)highPoint low:(CGPoint)lowPoint{
    HYKLinePositionModel *model = [HYKLinePositionModel new];
    model.openPoint = openPoint;
    model.closePoint = closePoint;
    model.highPoint = highPoint;
    model.lowPoint = lowPoint;
    return model;
}
@end
