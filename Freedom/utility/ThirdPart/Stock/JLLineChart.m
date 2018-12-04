//
//  JLLineChart.m
//  JLChartDemo
#import "JLLineChart.h"
#import "TimeLineModel.h"
#define TextColor [UIColor lightGrayColor]
#define IndicateColor [UIColor colorWithRed:238.0f/255.0f green:64.0f/225.0f blue:0.0f alpha:1.0f]
#define IndicateBackColor [UIColor colorWithRed:238.0f/255.0f green:64.0f/225.0f blue:0.0f alpha:0.4f]
#define LabelFont [UIFont systemFontOfSize:12.0f]
@interface JLChartPointItem()
@property (nonatomic, copy, readwrite) NSString *rawX;
@property (nonatomic, copy, readwrite) NSString *rawY;
@end
@implementation JLChartPointItem
+ (instancetype)pointItemWithRawX:(NSString *)rawx andRowY:(NSString *)rowy{
    return [[JLChartPointItem alloc]initWithX:rawx andY:rowy];
}
- (id)initWithX:(NSString *)x andY:(NSString *)y{
    if (self = [super init]) {
        self.rawX = x;
        self.rawY = y;
    }return self;
}
@end
@implementation JLChartPointSet
- (instancetype)init{
    if (self = [super init]) {
        [self setupDefaultValues];
    }return self;
}
- (void)setupDefaultValues{
    _items = @[].mutableCopy;
    _type = LineChartPointSetTypeNone;
    _buyPointColor = [UIColor colorWithRed:238.0f/255.0f green:64.0f/225.0f blue:0.0f alpha:1.0f];
    _relocatePointColor = [UIColor colorWithRed:155.0f/255.0f green:48.0f/225.0f blue:1.0f alpha:1.0f];
    _pointRadius = 2.0f;
}
@end

@implementation JLBaseChart
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setDefaultValues];
    }
    return self;
}

- (void)setDefaultValues{
    
    _xLabelFont = LabelFont;
    _xLabelColor = TextColor;
    _yLabelFont = [UIFont systemFontOfSize:10.0f];
    _yLabelColor = TextColor;
    _yLabelWidthPadding = 5.0f;
    _signedValue = YES;
    //    _yLabelFormat = @"%.2f";
    _yLabelSuffix = @"";//@"%";
    _stepCount = 4;
    
    _chartMarginLeft = 10.0f;
    _chartMarginRight = 10.0f;
    _chartMarginTop = 10.0f;
    _chartMarginBottom = 10.0f;
    
    _axisType = ChartAxisTypeBoth | ChartAxisTypeDash;
    _axisWidth = 0.6f;
    _axisColor = TextColor;
    
    _indicateLineType = ChartIndicateLineTypeBoth | ChartIndicateLineTypeDash;
    _indicatePointColor = IndicateColor;
    _indicatePointBackColor = IndicateBackColor;
    _xIndicateLineWidth = 0.6f;
    _xIndicateLineColor = IndicateColor;
    _xIndicateLabelFont = LabelFont;
    _xIndicateLabelTextColor = [UIColor whiteColor];
    _xIndicateLabelBackgroundColor = IndicateColor;
    
    _yIndicateLineWidth = 0.6f;
    _yIndicateLineColor = IndicateColor;
    _yIndicateLabelFont = LabelFont;
    _yIndicateLabelTextColor = [UIColor whiteColor];
    _yIndicateLabelBackgroundColor = IndicateColor;
    
    _displayAnimated = NO;
    _animateDuration = 1.0f;
}

- (void)setAxisType:(ChartAxisType)axisType{
    if (_axisType != axisType) {
        _axisType = axisType;
    }
}

- (void)setAxisWidth:(CGFloat)axisWidth{
    if (_axisWidth != axisWidth) {
        _axisWidth = axisWidth;
    }
}

- (void)setAxisColor:(UIColor *)axisColor{
    if (_axisColor != axisColor) {
        _axisColor = axisColor;
    }
}

@end

@implementation JLLineChartData
- (instancetype)init{
    if (self = [super init]) {
        [self setupDefaultValues];
    }
    return self;
}
- (void)setupDefaultValues{
    _sets = @[].mutableCopy;
    _lineColor = [UIColor colorWithRed:0.0f green:191.0f/225.0f blue:1.0f alpha:1.0f];
    _lineWidth = 1.0f;
    _fillColor = [UIColor colorWithRed:0 green:0.3 blue:1 alpha:1];
}
@end

@interface JLLineChart ()<CAAnimationDelegate>{
    NSMutableArray *animas;
    double totalDurationLenth;
    NSInteger frameAnimateIndex;
}
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat scaleX;
//layer
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *lineLayerArray;//线图层
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *fillLayerArray;//填充图层
//@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *nomarlPointLayerArray;//普通点图层 //暂无
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *buyPointLayerArray;//买点图层
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *relocatePointLayerArray;//调仓点图层

//path
@property (nonatomic, strong) NSMutableArray <UIBezierPath *> *linePathArray;//线数组
//@property (nonatomic, strong) NSMutableArray <UIBezierPath *> *normalPointPathArray;//普通点 //暂无
@property (nonatomic, strong) NSMutableArray <UIBezierPath *> *buyPointPathArray;//买点
@property (nonatomic, strong) NSMutableArray <UIBezierPath *> *relocatePointPathArray;//调仓点
//indicate Line
@property (nonatomic, strong) UIView *horizonLine;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *curveValueLabel;
@property (nonatomic, strong) UIView *indicatePoint;
@end
@implementation JLLineChart
///FIXME:初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILongPressGestureRecognizer *longPGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGestureRecognizerHandle:)];
        [longPGR setMinimumPressDuration:0.3f];
        [longPGR setAllowableMovement:frame.size.width - self.chartMarginLeft - self.chartMarginBottom];
        [self addGestureRecognizer:longPGR];
        animas = [NSMutableArray array];
        self.foreView = [[UIView alloc]init];
        self.foreView.backgroundColor = [UIColor whiteColor];
        self.xLabelColor = self.yLabelColor = [FreedomTools colorWithRGBHex:0x333333];
        [self addSubview:self.foreView];
    }
    return self;
}
- (void)setChartDatas:(NSMutableArray<JLLineChartData *> *)chartDatas{
    if (chartDatas != _chartDatas) {
        _chartDatas =chartDatas;
        [self computeMaxYandMinY];
        [self drawXLabelsAndYLabels];
        [self initLayers];
    }
}
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    [super drawLayer:layer inContext:ctx];
}
///FIXME:开始绘制
- (void)strokeChart{
    self.foreView.frame = CGRectMake(self.chartMarginLeft, self.chartMarginTop, self.bounds.size.width-self.chartMarginLeft, self.bounds.size.height-self.chartMarginBottom-self.chartMarginTop);
    [self bringSubviewToFront:self.foreView];
    [self calculateBezierPathsForChart];
    [self setNeedsDisplay];
    for (int i = 0; i < _lineLayerArray.count; i ++) {
        if(i>=_linePathArray.count)break;
        _lineLayerArray[i].path = _linePathArray[i].CGPath;
    }
    for (int i = 0; i < _buyPointLayerArray.count; i ++) {
        _buyPointLayerArray[i].path = _buyPointPathArray[i].CGPath;
    }
    for (int i = 0; i < _relocatePointLayerArray.count; i ++) {
        _relocatePointLayerArray[i].path = _relocatePointPathArray[i].CGPath;
    }
    totalDurationLenth = 0;
    [animas removeAllObjects];
    for (JLLineChartData *data in _chartDatas) {
        for (JLChartPointSet *set in data.sets) {
            if(set.type == LineChartPointSetTypeNone) {
                for (int i = 1; i < set.items.count; i ++) {
                    JLChartPointItem *item1 = set.items[i-1];
                    JLChartPointItem *item2 = set.items[i];
                    double lenth = sqrt(pow(item2.x-item1.x,2)+pow(item2.y-item1.y, 2));
                    totalDurationLenth += lenth;
                    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"frame"];
                    ani.beginTime = 0;
                    ani.autoreverses = NO;
                    ani.delegate = self;
                    ani.duration = lenth/set.items.count;
                    ani.fromValue = (id)[NSValue valueWithCGRect:CGRectMake(item1.x, self.chartMarginTop, self.bounds.size.width-item1.x,self.bounds.size.height-self.chartMarginBottom-self.chartMarginTop)];
                    ani.toValue = (id)[NSValue valueWithCGRect:CGRectMake(item2.x,self.chartMarginTop, self.bounds.size.width-item2.x, self.bounds.size.height-self.chartMarginBottom-self.chartMarginTop)];
                    [animas addObject:ani];
                }
            }
        }
    }
    if(totalDurationLenth==0)totalDurationLenth = 1;
    frameAnimateIndex = 0;
    if(animas.count>150||animas.count==0){
        [UIView animateWithDuration:self.displayAnimated?1:0 animations:^{
            self.foreView.frame = CGRectMake(self.bounds.size.width, self.chartMarginTop, 0, self.bounds.size.height-self.chartMarginBottom-self.chartMarginTop);
        }];
    }else{
        [self animatNext];
    }
}
-(void)animatNext{
    if(frameAnimateIndex>=animas.count){
        return;
    }
    CABasicAnimation *a = animas[frameAnimateIndex];
    [UIView animateWithDuration:a.duration/totalDurationLenth animations:^{
        self.foreView.frame = [a.toValue CGRectValue];
    } completion:^(BOOL finished) {
        frameAnimateIndex++;
        [self animatNext];
    }];
}
- (void)animationDidStart:(CAAnimation *)anim{
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
}
- (void)updateChartWithChartData:(NSMutableArray<JLLineChartData *> *)chartData{
    self.chartDatas = chartData;
    [self strokeChart];
}
-(NSArray *)private_convertTimeLineModlesToPositionModel{
    //2.算出x轴的单元值
    CGFloat xUnitValue = 0.5;//self.axisWidth
    NSMutableArray *positionArray = [NSMutableArray array];
    CGFloat xPosition = 0;
    CGFloat yPosition = 0;
    
    for (int i=0;i<100;i++) {
        xPosition += xUnitValue * 2;
        yPosition = random()%100;
        HYTimeLineAbovePositionModel *positionModel = [[HYTimeLineAbovePositionModel alloc]init];
        positionModel.currentPoint = CGPointMake(xPosition, yPosition);
        [positionArray addObject:positionModel];
    }
    return positionArray;
}
///FIXME:画参考线
- (void)drawRect:(CGRect)rect{
    float leftW = 0;// [self caculatRectWithString:[self formatYLabelWith:_maxY] andFont:self.yLabelFont].size.width;
    CGFloat vMargin = (rect.size.height - self.chartMarginTop - self.chartMarginBottom) / self.stepCount;
    CGFloat hMargin = (rect.size.width - self.chartMarginLeft - leftW - self.chartMarginRight)/ (self.stepCount - 1.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    CGContextSetLineWidth(ctx, self.axisWidth);
    CGContextSetStrokeColorWithColor(ctx, [self.axisColor CGColor]);
    BOOL haveValue = _chartDatas.firstObject.sets.firstObject.items.count>0;
    if (self.axisType == (ChartAxisTypeBoth | ChartAxisTypeDash) &&
        haveValue) {
        //solid x axis
        CGContextMoveToPoint(ctx, self.chartMarginLeft+leftW, self.chartMarginTop + self.stepCount * vMargin);
        CGContextAddLineToPoint(ctx, rect.size.width - self.chartMarginRight+leftW, self.chartMarginTop + self.stepCount * vMargin);
        CGContextStrokePath(ctx);
        CGFloat dash[] = {1.0f,2.0f};//虚线中虚实长度
        CGContextSetLineDash(ctx, 1.0f, dash, 2.0f);
        for (NSInteger i = 0 ; i < self.stepCount; i ++) {
            //画横参考线
            CGContextMoveToPoint(ctx, self.chartMarginLeft+leftW, self.chartMarginTop + i * vMargin);
            CGContextAddLineToPoint(ctx, rect.size.width - self.chartMarginRight+leftW, self.chartMarginTop + i * vMargin);
            CGContextStrokePath(ctx);
            //画竖参考线
//            CGContextMoveToPoint(ctx, self.chartMarginLeft + i * hMargin, self.chartMarginTop);
//            CGContextAddLineToPoint(ctx, self.chartMarginLeft + i * hMargin, rect.size.height - self.chartMarginBottom);
//            CGContextStrokePath(ctx);
        }
    }else if(_chartDatas){
        [@"暂无数据" drawAtPoint:CGPointMake(rect.size.width/2-50, rect.size.height/2-10) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithWhite:0.3 alpha:1]}];
        CGContextDrawPath(ctx, kCGPathFill);
    }
    [self fillLineChart];
    [super drawRect:rect];
    [self.yLabeleUnit drawAtPoint:CGPointMake(5,0) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[FreedomTools colorWithRGBHex:0x333333]}];
}
///FIXME:画上下左右的label
- (void)drawXLabelsAndYLabels{
    //clear labels
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    BOOL haveValue = _chartDatas.firstObject.sets.firstObject.items.count>0;
    if (!haveValue)return;
    [self drawXLabels];
    [self drawYLabels];
}

- (void)drawYLabels{
    CGFloat vMargin = (self.bounds.size.height - self.chartMarginTop - self.chartMarginBottom) / self.stepCount;
    if (_maxY == _minY) {
        CGFloat step = (_maxY * 2.0f)/self.stepCount;
        for (int i = 0; i < self.stepCount + 1; i ++) {
            NSString *leftY = [self formatYLabelWith:_maxY * 2.0f - i * step];
            CGRect leftRect = [self caculatRectWithString:leftY andFont:self.yLabelFont];
            UILabel *leftYLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.chartMarginTop + i * vMargin - leftRect.size.height/2 , leftRect.size.width +self.yLabelWidthPadding, leftRect.size.height)];
            leftYLabel.text = leftY;
            leftYLabel.textAlignment = NSTextAlignmentCenter;
            leftYLabel.font = self.yLabelFont;
            leftYLabel.textColor = self.yLabelColor;
            [self addSubview:leftYLabel];
        }
    }else{
        CGFloat step = (_maxY - _minY)/self.stepCount;
        for (int i = 0; i < self.stepCount + 1; i ++) {
            NSString *leftY = [self formatYLabelWith:_maxY - i * step];
            CGRect leftRect = [self caculatRectWithString:leftY andFont:self.yLabelFont];
            UILabel *leftYLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.chartMarginTop + i * vMargin - leftRect.size.height/2 , leftRect.size.width + self.yLabelWidthPadding, leftRect.size.height)];
            leftYLabel.text = leftY;
            leftYLabel.textAlignment = NSTextAlignmentCenter;
            leftYLabel.font = self.yLabelFont;
            leftYLabel.textColor = self.yLabelColor;
            [self addSubview:leftYLabel];
        }
    }
}
//only show left and right
- (void)drawXLabels{
    NSString *leftX = [[[_chartDatas firstObject].sets firstObject].items firstObject].rawX;
    CGRect leftRect = [self caculatRectWithString:leftX andFont:self.xLabelFont];
    UILabel *leftXLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.chartMarginLeft, self.bounds.size.height - self.chartMarginBottom, leftRect.size.width, leftRect.size.height+5)];
    leftXLabel.textColor = self.xLabelColor;
    leftXLabel.font = self.xLabelFont;
    leftXLabel.text = leftX;
    [self addSubview:leftXLabel];
    NSString *rightX = [[[_chartDatas firstObject].sets firstObject].items lastObject].rawX;
    CGRect rightRect = [self caculatRectWithString:rightX andFont:self.xLabelFont];
    UILabel *rightXLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width - self.chartMarginRight - rightRect.size.width, self.bounds.size.height - self.chartMarginBottom, rightRect.size.width, rightRect.size.height+5)];
    rightXLabel.textColor = self.xLabelColor;
    rightXLabel.font = self.xLabelFont;
    rightXLabel.text = rightX;
    [self addSubview:rightXLabel];
}

///FIXME:初始化存储layer图层
- (void)initLayers{
    for (CALayer *layer in self.lineLayerArray) {
        [layer removeFromSuperlayer];
    }
    for (CALayer *layer in self.fillLayerArray) {
        [layer removeFromSuperlayer];
    }
    for (CALayer *layer in self.buyPointLayerArray) {
        [layer removeFromSuperlayer];
    }
    for (CALayer *layer in self.relocatePointLayerArray) {
        [layer removeFromSuperlayer];
    }
    //init layers
    self.lineLayerArray = @[].mutableCopy;
    self.fillLayerArray = @[].mutableCopy;
    self.buyPointLayerArray = @[].mutableCopy;
    self.relocatePointLayerArray = @[].mutableCopy;
    for (JLLineChartData *data in _chartDatas) {
        for (JLChartPointSet *set in data.sets) {
            if (set.type == LineChartPointSetTypeNone) {
                //line shapelayer
                CAShapeLayer *lineLayer = [CAShapeLayer layer];
                lineLayer.frame = self.bounds;
                lineLayer.lineCap = kCALineCapRound;
                lineLayer.lineJoin = kCALineJoinBevel;
                lineLayer.fillColor = nil;
                lineLayer.strokeColor = [data.lineColor CGColor];
                lineLayer.lineWidth = data.lineWidth;
                [self.layer addSublayer:lineLayer];
                [self.lineLayerArray addObject:lineLayer];
            }else if (set.type == LineChartPointSetTypeBuy) {
                CAShapeLayer *lineLayer = [CAShapeLayer layer];
                lineLayer.frame = self.bounds;
                lineLayer.lineCap = kCALineCapRound;
                lineLayer.lineJoin = kCALineJoinBevel;
                lineLayer.fillColor = [set.buyPointColor CGColor];
                lineLayer.strokeColor = nil;
                [self.layer addSublayer:lineLayer];
                [self.buyPointLayerArray addObject:lineLayer];
            }else if (set.type == LineChartPointSetTypeRelocate){
                CAShapeLayer *fillLayer = [CAShapeLayer layer];
                fillLayer.frame = self.bounds;
                fillLayer.lineCap = kCALineCapRound;
                fillLayer.lineJoin = kCALineJoinBevel;
                fillLayer.fillColor = [set.relocatePointColor CGColor];
                fillLayer.strokeColor = nil;
                [self.layer addSublayer:fillLayer];
                [self.relocatePointLayerArray addObject:fillLayer];
            }
            //fillSharpLayer
            if (data.fillColor) {
                CAShapeLayer *fillLayer = [CAShapeLayer layer];
                fillLayer.frame = self.bounds;
                fillLayer.lineCap = kCALineCapRound;
                fillLayer.lineJoin = kCALineJoinBevel;
                fillLayer.fillColor = [data.fillColor CGColor];
                fillLayer.strokeColor = [UIColor greenColor].CGColor;
                [self.layer addSublayer:fillLayer];
                [self.fillLayerArray addObject:fillLayer];
            }
        }
        
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
- (void)fillLineChart{
    if(!_chartDatas)return;
    CGFloat height = self.bounds.size.height - self.chartMarginTop - self.chartMarginBottom;
    height = self.bounds.size.height-self.chartMarginBottom;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef fillPath = CGPathCreateMutable();
    for (JLLineChartData *data in _chartDatas) {
        for (JLChartPointSet *set in data.sets) {
            if(set.items.count==0)return;
            for (int index = 0; index < set.items.count; index ++) {
                JLChartPointItem *point = set.items[index];
                //绘制渐变图
                if (0 == index){
                    CGPathMoveToPoint(fillPath, NULL, point.x, height);
                    CGPathAddLineToPoint(fillPath, NULL, point.x,point.y);
                }else{
                    CGPathAddLineToPoint(fillPath, NULL, point.x,point.y);
                }
                if ((set.items.count - 1) == index) {
                    CGPathAddLineToPoint(fillPath, NULL, point.x, point.y);
                    CGPathAddLineToPoint(fillPath, NULL, point.x, height);
                    CGPathCloseSubpath(fillPath);
                }
            }
        }
    }
    [self drawLinearGradient:context path:fillPath alpha:0.15f startColor:UIColor(246,85,14,1).CGColor endColor:UIColor(246,85,14,0.5).CGColor];
    CGPathRelease(fillPath);
}
///FIXME:绘制趋势图
- (void)calculateBezierPathsForChart{
    _linePathArray = @[].mutableCopy;
    _buyPointPathArray = @[].mutableCopy;
    _relocatePointPathArray = @[].mutableCopy;
    CGFloat height = self.bounds.size.height - self.chartMarginTop - self.chartMarginBottom;
    for (JLLineChartData *data in _chartDatas) {
        for (JLChartPointSet *set in data.sets) {
            if(set.type == LineChartPointSetTypeNone) {
                UIBezierPath *path = [UIBezierPath bezierPath];
                for (int i = 0; i < set.items.count; i ++) {
                    JLChartPointItem *item = set.items[i];
                    item.x = self.chartMarginLeft + i * _scaleX;
                    item.y = _minY == _maxY ? height/2.0f + self.chartMarginTop : (_maxY - [item.rawY floatValue])*(height / (_maxY - _minY)) + self.chartMarginTop;
                    CGPoint point = CGPointMake(item.x, item.y);
                    if (i == 0) {
                        [path moveToPoint:point];
                    }else{
                        [path addLineToPoint:point];
                    }
                }
                [_linePathArray addObject:path];
            }else if (set.type == LineChartPointSetTypeBuy) {
                UIBezierPath *buyPath = [UIBezierPath bezierPath];
                for (int i=0;i<set.items.count;i++) {
                    JLChartPointItem *buyItem = set.items[i];
                    buyItem.x = self.chartMarginLeft+i* _scaleX;
                    buyItem.y = _minY == _maxY ? height/2.0f + self.chartMarginTop : (_maxY - [buyItem.rawY floatValue])*(height / (_maxY - _minY)) + self.chartMarginTop;
                    CGPoint point = CGPointMake(buyItem.x, buyItem.y);
                    [buyPath addArcWithCenter:point radius:set.pointRadius startAngle:0.0f endAngle:M_PI *2.0f clockwise:YES];
                }
                [_buyPointPathArray addObject:buyPath];
            }else if (set.type == LineChartPointSetTypeRelocate){
                UIBezierPath *relocatePath = [UIBezierPath bezierPath];
                for (int i=0;i<set.items.count;i++) {
                    JLChartPointItem *relocateItem = set.items[i];
                    relocateItem.x = self.chartMarginLeft+i* _scaleX;
                    relocateItem.y = _minY == _maxY ? height/2.0f + self.chartMarginTop : (_maxY - [relocateItem.rawY floatValue])*(height / (_maxY - _minY)) + self.chartMarginTop;
                    CGPoint point = CGPointMake(relocateItem.x, relocateItem.y);
                    [relocatePath addArcWithCenter:point radius:set.pointRadius startAngle:0.0f endAngle:M_PI *2.0f clockwise:YES];
                }
                [_relocatePointPathArray addObject:relocatePath];
            }
        }
    }
}

- (void)drawNormalPathWithItems:(NSMutableArray *)items WithScale:(CGFloat)scale{
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < items.count; i ++) {
        JLChartPointItem *item = items[i];
        if (i == 0) {
            [path moveToPoint:CGPointMake(self.chartMarginLeft, (_maxY - [item.rawY floatValue])*scale)];
        }else{
            [path addLineToPoint:CGPointMake(self.chartMarginLeft + i * _scaleX, (_maxY - [item.rawY floatValue])*scale)];
        }
    }
    [_linePathArray addObject:path];
}

///FIXME:计算数据最大最小值
- (void)computeMaxYandMinY{
    _maxY = - MAXFLOAT;
    _minY = MAXFLOAT;
    for(JLLineChartData *data in _chartDatas){
        for (JLChartPointSet *set in data.sets) {
//            if (set.type == LineChartPointSetTypeNone) {
                _scaleX = (self.bounds.size.width - self.chartMarginLeft - self.chartMarginRight)/(set.items.count - 1.000f);
                for (JLChartPointItem *item in set.items) {
                    if ([item.rawY floatValue] >= _maxY) {
                        _maxY = [item.rawY floatValue];
                    }
                    if ([item.rawY floatValue] <= _minY) {
                        _minY = [item.rawY floatValue];
                    }
                }
//            }
        }
    }
    if(_maxY<_minY){
        _maxY = _minY = 0;
    }
    CGFloat extra = (_maxY -_minY)/(self.stepCount *2.000f);//expan y axis
    _maxY += extra;
    _minY -= extra;
}

- (void)longGestureRecognizerHandle:(UILongPressGestureRecognizer*)longResture{
    if (longResture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [longResture locationInView:self];
        [self drawIndicatesWith:point];
    }else if (longResture.state == UIGestureRecognizerStateEnded){
        if(self.valueChangedBlock){
            self.valueChangedBlock(nil);
        }
        [_horizonLine removeFromSuperview];
        [_verticalLine removeFromSuperview];
        [_indicatePoint removeFromSuperview];
        [_dateLabel removeFromSuperview];
        [_curveValueLabel removeFromSuperview];
        _horizonLine = nil;
        _verticalLine = nil;
        _indicatePoint = nil;
        _dateLabel = nil;
        _curveValueLabel = nil;
    }
}
///FIXME:根据手势及时更新对齐线的位置
- (void)drawIndicatesWith:(CGPoint )point{
    JLLineChartData *data = _chartDatas[0];
    for (JLChartPointSet *set in data.sets) {
        if (set.type == LineChartPointSetTypeNone) {
            for (JLChartPointItem *item in set.items) {
                if (item.x >= point.x - _scaleX/2.0f && item.x <= point.x + _scaleX/2.0f) {
                    self.horizonLine.frame = CGRectMake(self.chartMarginLeft, item.y - 2.0f, self.bounds.size.width - self.chartMarginLeft - self.chartMarginRight, 4);
                    self.verticalLine.frame = CGRectMake(item.x - 2.0f, self.chartMarginTop, 4.0f, self.bounds.size.height - self.chartMarginTop - self.chartMarginBottom);
                    self.indicatePoint.frame = CGRectMake(item.x - 3.0f, item.y - 3.0f, 6.0f, 6.0f);
                    if (item.x <= self.chartMarginLeft + 35.0f) {
                        self.dateLabel.frame = CGRectMake(self.chartMarginLeft, self.chartMarginTop - 15.0f, 70.0f, 15.0f);
                    }else if (item.x >= self.bounds.size.width - 35.0f - self.chartMarginRight){
                        self.dateLabel.frame = CGRectMake(self.bounds.size.width - self.chartMarginRight - 70.0f, self.chartMarginTop - 15.0f, 70.0f, 15.0f);
                    }else{
                        self.dateLabel.frame = CGRectMake(item.x - 35.0f, self.chartMarginTop - 15.0f, 70.0f, 15.0f);
                    }
                    _dateLabel.text = item.rawX;
                    if(self.valueChangedBlock){
                        self.valueChangedBlock(item);
                    }
                    if (item.x <= self.bounds.size.width/2.0f) {
                        self.curveValueLabel.frame = CGRectMake(self.bounds.size.width - self.chartMarginRight - 60.0f , item.y - 7.5f, 60.0f, 15.0f);
                    }else{
                        self.curveValueLabel.frame = CGRectMake(self.chartMarginLeft , item.y - 7.5f, 60.0f, 15.0f);
                    }
                    _curveValueLabel.text = [self formatYLabelWith:[item.rawY floatValue]];
                    _horizonLine.hidden = NO;
                    _verticalLine.hidden = NO;
                    _indicatePoint.hidden = NO;
                    _dateLabel.hidden = NO;
                    _curveValueLabel.hidden = NO;
                    break;
                }
            }
        }
    }
}

///FIXME:懒加载视图
- (UIView *)horizonLine{
    if(!_horizonLine){
        _horizonLine = [[UIView alloc]initWithFrame:CGRectMake(self.chartMarginLeft, self.bounds.size.height/2.0f - 2.0f, self.bounds.size.width - self.chartMarginLeft - self.chartMarginRight, 4.0f)];
        _horizonLine.backgroundColor = [UIColor clearColor];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0.0f,0.0f, self.bounds.size.width - self.chartMarginLeft - self.chartMarginRight, 4.0f);
        layer.strokeColor = self.xIndicateLineColor.CGColor;
        layer.lineWidth = self.xIndicateLineWidth;
        layer.lineDashPattern = @[@2.0f, @2.0f];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0.0f, 2.0f)];
        [path addLineToPoint:CGPointMake(_horizonLine.bounds.size.width, 2.0f)];
        layer.path = path.CGPath;
        [_horizonLine.layer addSublayer:layer];
        _horizonLine.hidden = YES;
        [self addSubview: _horizonLine];
    }
    return _horizonLine;
}

- (UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2.0f - 2.0f, self.chartMarginTop, 4.0f, self.bounds.size.height - self.chartMarginTop - self.chartMarginBottom)];
        _verticalLine.backgroundColor = [UIColor clearColor];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0.0f, 0.0f, 4.0f, self.bounds.size.height - self.chartMarginTop - self.chartMarginBottom);
        layer.strokeColor = self.yIndicateLineColor.CGColor;
        layer.lineWidth = self.yIndicateLineWidth;
        layer.lineDashPattern = @[@2.0f, @2.0f];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(2.0f, 0.0f)];
        [path addLineToPoint:CGPointMake(2.0f, _verticalLine.bounds.size.height)];
        layer.path = path.CGPath;
        [_verticalLine.layer addSublayer:layer];
        _verticalLine.hidden = YES;
        [self addSubview:_verticalLine];
    }
    return _verticalLine;
}

- (UIView *)indicatePoint{
    if (!_indicatePoint) {
        _indicatePoint = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2.0f - 3.0f, self.bounds.size.height/2.0f - 3.0f, 6.0f, 6.0f)];
        _indicatePoint.backgroundColor = [UIColor clearColor];
        CAShapeLayer *indicatePointBackLayer = [CAShapeLayer layer];
        indicatePointBackLayer.frame = CGRectMake(0.0f, 0.0f, 6.0f, 6.0f);
        indicatePointBackLayer.fillColor= self.indicatePointBackColor.CGColor;
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(3.0f, 3.0f) radius:3.0f startAngle:0.0f endAngle:M_PI *2.0f clockwise:YES];
        indicatePointBackLayer.path = path1.CGPath;
        [_indicatePoint.layer addSublayer:indicatePointBackLayer];
        CAShapeLayer *indicatePointLayer = [CAShapeLayer layer];
        indicatePointLayer.frame = CGRectMake(0.0f, 0.0f, 6.0f, 6.0f);
        indicatePointLayer.fillColor= self.indicatePointColor.CGColor;
        UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(3.0f, 3.0f) radius:2.0f startAngle:0.0f endAngle:M_PI *2.0f clockwise:YES];
        indicatePointLayer.path = path2.CGPath;
        [_indicatePoint.layer addSublayer:indicatePointLayer];
        _indicatePoint.hidden = YES;
        [self addSubview:_indicatePoint];
    }
    return _indicatePoint;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.font = self.xIndicateLabelFont;
        _dateLabel.textColor = self.xIndicateLabelTextColor;
        _dateLabel.backgroundColor = self.xIndicateLabelBackgroundColor;
        _dateLabel.textAlignment =NSTextAlignmentCenter;
        _dateLabel.hidden = YES;
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

- (UILabel *)curveValueLabel{
    if (!_curveValueLabel) {
        _curveValueLabel = [[UILabel alloc]init];
        _curveValueLabel.font = self.yIndicateLabelFont;
        _curveValueLabel.textColor = self.yIndicateLabelTextColor;
        _curveValueLabel.backgroundColor = self.yIndicateLabelBackgroundColor;
        _curveValueLabel.textAlignment =NSTextAlignmentCenter;
        _curveValueLabel.hidden = YES;
        [self addSubview:_curveValueLabel];
    }
    return _curveValueLabel;
}
///FIXME:私有方法
- (CGRect )caculatRectWithString:(NSString *)string andFont:(UIFont *)font{
    return [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]
                                context:nil];
}

- (NSString *)formatYLabelWith:(CGFloat)value{
    if(self.dataFormat){
        return [NSString stringWithFormat:self.dataFormat,value,self.yLabelSuffix];
    }else{
        if (self.signedValue) {
            return [NSString stringWithFormat:@"%.3f%@",value,self.yLabelSuffix];
        }else{
            return [NSString stringWithFormat:@"%.2f%@",value,self.yLabelSuffix];
        }
    }
}
@end
