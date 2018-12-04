//
//  HYTimeLineBelowView.m
//  JimuStockChartDemo
#import "HYTimeLineBelowView.h"
#import "TimeLineModel.h"
#import "HYStockChartConstant.h"
#import "StockCategory.h"

///边框线颜色
#define GridLineColor [FreedomTools colorWithRGBHex:0x999999]
/************************分时线下面的view的位置模型************************/
@interface HYTimeLineBelowPositionModel : NSObject
@property(nonatomic,assign) CGPoint startPoint;
@property(nonatomic,assign) CGPoint endPoint;
@end
@implementation HYTimeLineBelowPositionModel
@end
/************************分时线上成交量的画笔************************/
@interface HYTimeLineVolume : NSObject
@property(nonatomic,strong) NSArray *timeLineVolumnPositionModels;
//当前视图的宽度
@property (nonatomic,assign)CGFloat currentXWidth;
//显示颜色数
@property(nonatomic,strong) NSArray *colorArray;
-(instancetype)initWithContext:(CGContextRef)context;
-(void)draw;
@end
@interface HYTimeLineVolume()
@property(nonatomic,assign) CGContextRef context;
@end
@implementation HYTimeLineVolume
-(instancetype)initWithContext:(CGContextRef)context{
    self = [super init];
    if (self) {
        _context = context;
    }
    return self;
}
-(void)draw{
    NSAssert(self.timeLineVolumnPositionModels && self.context, @"timeLineVolumnPositionModels不能为空！");
    CGContextRef context = self.context;
    CGFloat volumeLineWidth = self.currentXWidth / self.timeLineVolumnPositionModels.count - 1.0;
    CGContextSetLineWidth(self.context, volumeLineWidth);
    NSInteger index = 0;
    for (HYTimeLineBelowPositionModel *positionModel in self.timeLineVolumnPositionModels) {
        UIColor *color = self.colorArray[index];
        CGContextSetStrokeColorWithColor(self.context, color.CGColor);
        //画实体线
        const CGPoint solidPoints[] = {positionModel.startPoint,positionModel.endPoint};
        CGContextStrokeLineSegments(context, solidPoints, 2);
        index ++;
    }
}
@end
@implementation YYTimeLineBelowMaskView
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawDashLine];
}
/**
 绘制长按的背景线
 */
- (void)drawDashLine {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat lengths[] = {3,3};
    CGContextSetLineDash(ctx, 0, lengths, 2);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:102/255.0 alpha:1].CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    //CGFloat x = self.timeLineView.frame.origin.x + self.selectedPoint.x - self.stockScrollView.contentOffset.x;
    //绘制横线
    CGContextMoveToPoint(ctx, HYStockChartTimeLineAboveViewMinX,  self.selectedPoint.y);
    CGContextAddLineToPoint(ctx, HYStockChartTimeLineAboveViewMinX + self.frame.size.width,  self.selectedPoint.y);
    //绘制竖线
    CGContextMoveToPoint(ctx, self.selectedPoint.x, self.frame.origin.y);
    CGContextAddLineToPoint(ctx, self.selectedPoint.x, self.frame.size.height);
    CGContextStrokePath(ctx);
    //绘制交叉圆点
    //    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite102].CGColor);
    //    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    //    CGContextSetLineWidth(ctx, 1.5);
    //    CGContextSetLineDash(ctx, 0, NULL, 0);
    //    CGContextAddArc(ctx, self.selectedPoint.x, self.selectedPoint.y, 3.0, 0, 2 * M_PI, 0);
    //    CGContextDrawPath(ctx, kCGPathFillStroke);
    //绘制选中日期
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor colorWithWhite:153/255.0 alpha:1]};
    //绘制选中价格
    NSString *priceText = [NSString stringWithFormat:@"%zd",[self.selectedModel volume] ];
    CGRect priceRect = [self rectOfNSString:priceText attribute:attribute];
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    //    CGContextFillRect(ctx, CGRectMake(HYStockChartTimeLineAboveViewMaxX - priceRect.size.width - 4, self.selectedPoint.y - priceRect.size.height/2.f - 2, priceRect.size.width + 4, priceRect.size.height + 4));
    [priceText drawInRect:CGRectMake( 2,  2, priceRect.size.width, priceRect.size.height) withAttributes:attribute];
    
}
- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                      options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}
@end
@interface HYTimeLineBelowView()
@property(nonatomic,strong) NSArray *positionModels;
@end
@implementation HYTimeLineBelowView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _positionModels = nil;
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (!self.positionModels) {
        return;
    }
    [self drawGridBackground:rect];
    if (self.centerViewType == HYStockChartCenterViewTypeBrokenLine) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        //添加分时线宽度
        CGContextSetLineWidth(context, 0.25);
        //添加分时线颜色
    CGContextSetStrokeColorWithColor(context,GridLineColor.CGColor);
        for (int i = 0; i < 4; i ++){
            CGFloat xzhouriqi = (HYStockChartTimeLineAboveViewMaxX-HYStockChartTimeLineAboveViewMinX) * (i + 1 ) / 5.0;
            CGContextMoveToPoint(context,xzhouriqi, 0);
            CGContextAddLineToPoint(context, xzhouriqi, self.frame.size.height);
            CGContextStrokePath(context);
        }
    }
    HYTimeLineVolume *timeLineVolumn = [[HYTimeLineVolume alloc] initWithContext:UIGraphicsGetCurrentContext()];
    timeLineVolumn.timeLineVolumnPositionModels = self.positionModels;
    timeLineVolumn.currentXWidth = HYStockChartTimeLineAboveViewMaxX-HYStockChartTimeLineAboveViewMinX;
    timeLineVolumn.colorArray = self.colorArray;
    [timeLineVolumn draw];
}
#pragma mark - **************** 画边框
- (void)drawGridBackground:(CGRect)rect;{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * backgroundColor = [UIColor whiteColor];
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    //画边框
    CGContextSetLineWidth(context, HYStockChartTimeLineGridWidth);
CGContextSetStrokeColorWithColor(context,GridLineColor.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width , rect.size.height));
    if (self.centerViewType == HYStockChartCenterViewTypeTimeLine){
        //画中间的线
        [self drawline:context startPoint:CGPointMake((rect.size.width ) / 2,0) stopPoint:CGPointMake(rect.size.width / 2, rect.size.height) color:GridLineColor lineWidth:HYStockChartTimeLineGridWidth];
    }
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
#pragma mark - 时间
-(void)drawBelowView{
    [self private_convertTimeLineModelsPositionModels];
    NSAssert(self.positionModels, @"positionModels不能为空");
    [self setNeedsDisplay];
}
#pragma mark - 私有方法
#pragma mark 将分时线的模型数组转换成Y坐标的
-(NSArray *)private_convertTimeLineModelsPositionModels{
    NSAssert(self.timeLineModels && self.xPositionArray && self.timeLineModels.count == self.xPositionArray.count, @"timeLineModels不能为空!");
    //1.算y轴的单元值
    HYTimeLineModel *firstModel = [self.timeLineModels firstObject];
    __block CGFloat minVolume = firstModel.volume;
    __block CGFloat maxVolume = firstModel.volume;
    [self.timeLineModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HYTimeLineModel *timeLineModel = (HYTimeLineModel *)obj;
        if (timeLineModel.volume < minVolume) {
            minVolume = timeLineModel.volume;
        }
        if (timeLineModel.volume > maxVolume) {
            maxVolume = timeLineModel.volume;
        }
        if (timeLineModel.volume < 0) {
            NSLog(@"%ld",timeLineModel.volume);
        }
    }];
    CGFloat minY = HYStockChartTimeLineBelowViewMinY;
    CGFloat maxY = HYStockChartTimeLineBelowViewMaxY;
    CGFloat yUnitValue = (maxVolume - minVolume)/(maxY-minY);
    NSMutableArray *positionArray = [NSMutableArray array];
    NSInteger index = 0;
    for (HYTimeLineModel *timeLineModel in self.timeLineModels) {
        CGFloat xPosition = [self.xPositionArray[index] floatValue];
        CGFloat yPosition = (maxY - (timeLineModel.volume - minVolume)/yUnitValue);
        HYTimeLineBelowPositionModel *positionModel = [HYTimeLineBelowPositionModel new];
        positionModel.startPoint = CGPointMake(xPosition, maxY);
        positionModel.endPoint = CGPointMake(xPosition, yPosition);
        [positionArray addObject:positionModel];
        index++;
    }
    _positionModels = positionArray;
    return positionArray;
}
- (void)timeLineAboveViewLongPressAboveLineModel:(HYTimeLineModel *)selectedModel selectPoint:(CGPoint)selectedPoint{
    NSAssert(self.timeLineModels && self.xPositionArray && self.timeLineModels.count == self.xPositionArray.count, @"timeLineModels不能为空!");
    //1.算y轴的单元值
    HYTimeLineModel *firstModel = [self.timeLineModels firstObject];
    __block CGFloat minVolume = firstModel.volume;
    __block CGFloat maxVolume = firstModel.volume;
    [self.timeLineModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HYTimeLineModel *timeLineModel = (HYTimeLineModel *)obj;
        if (timeLineModel.volume < minVolume) {
            minVolume = timeLineModel.volume;
        }
        if (timeLineModel.volume > maxVolume) {
            maxVolume = timeLineModel.volume;
        }
        if (timeLineModel.volume < 0) {
            NSLog(@"%ld",timeLineModel.volume);
        }
    }];
    CGFloat minY = HYStockChartTimeLineBelowViewMinY;
    CGFloat maxY = HYStockChartTimeLineBelowViewMaxY;
    CGFloat yUnitValue = (maxVolume - minVolume)/(maxY-minY);
    CGFloat xPosition = selectedPoint.x;
    CGFloat yPosition = (maxY - (selectedModel.volume - minVolume)/yUnitValue);
    CGPoint vSelectedPoint = CGPointMake(xPosition,yPosition);
    if (!self.maskView) {
        _maskView = [YYTimeLineBelowMaskView new];
        _maskView.backgroundColor = [UIColor clearColor];
        [self addSubview:_maskView];
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    } else {
        self.maskView.hidden = NO;
    }
    self.maskView.selectedModel = selectedModel;
    self.maskView.selectedPoint = vSelectedPoint;
    self.maskView.timeLineView = self;
    [self.maskView setNeedsDisplay];
}
- (void)timeLineAboveViewLongPressDismiss{
    self.maskView.hidden = YES;
}
@end
