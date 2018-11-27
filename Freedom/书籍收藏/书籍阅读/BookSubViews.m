//
//  BookSubViews.m
//  Freedom
//
//  Created by Super on 2018/4/27.
//  Copyright © 2018年 Super. All rights reserved.
//
#import "BookSubViews.h"
#import <CoreText/CoreText.h>
#import "BookReadMode.h"
#import <AVFoundation/AVFoundation.h>
#define kE_CursorWidth 2
#import "BookReadMode.h"
#define MAX_FONT_SIZE 27
#define MIN_FONT_SIZE 17
#define MIN_TIPS @"字体已到最小"
#define MAX_TIPS @"字体已到最大"
@import Accelerate;
@interface ILSlider ()
@property (nonatomic, strong) UIColor *lineColor;//整条线的颜色
@property (nonatomic, strong) UIColor *slidedLineColor;//滑动过的线的颜色
@property (nonatomic, strong) UIColor *circleColor;//圆的颜色
@property (nonatomic, assign) CGFloat lineWidth;//线的宽度
@property (nonatomic, assign) CGFloat circleRadius;//圆的半径
@property (nonatomic, assign) BOOL    isSliding;//是否正在滑动
@end
@implementation ILSlider
- (id)initWithFrame:(CGRect)frame direction:(ILSliderDirection)direction{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _minValue = 0;
        _maxValue = 1;
        _direction = direction;
        _lineColor = [UIColor whiteColor];
        _slidedLineColor = [UIColor redColor];
        _circleColor = [UIColor whiteColor];
        _ratioNum = 0.0;//缺省为0
        _lineWidth = 1;
        _circleRadius = 10;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画总体的线
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);//画笔颜色
    CGContextSetLineWidth(context, _lineWidth);//线的宽度
    CGFloat startLineX = (_direction == ILSliderDirectionHorizonal ? _circleRadius : (self.frame.size.width - _lineWidth) / 2);
    CGFloat startLineY = (_direction == ILSliderDirectionHorizonal ? (self.frame.size.height - _lineWidth) / 2 : _circleRadius);//起点
    CGFloat endLineX = (_direction == ILSliderDirectionHorizonal ? self.frame.size.width - _circleRadius : (self.frame.size.width - _lineWidth) / 2);
    CGFloat endLineY = (_direction == ILSliderDirectionHorizonal ? (self.frame.size.height - _lineWidth) / 2 : self.frame.size.height- _circleRadius);//终点
    CGContextMoveToPoint(context, startLineX, startLineY);
    CGContextAddLineToPoint(context, endLineX, endLineY);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    //画已滑动进度的线
    CGContextSetStrokeColorWithColor(context, _slidedLineColor.CGColor);//画笔颜色
    CGContextSetLineWidth(context, _lineWidth);//线的宽度
    CGFloat slidedLineX = (_direction == ILSliderDirectionHorizonal ? MAX(_circleRadius, (_ratioNum * self.frame.size.width - _circleRadius)) : startLineX);
    CGFloat slidedLineY = (_direction == ILSliderDirectionHorizonal ? startLineY : MAX(_circleRadius, (_ratioNum * self.frame.size.height - _circleRadius)));
    CGContextMoveToPoint(context, startLineX, startLineY);
    CGContextAddLineToPoint(context, slidedLineX, slidedLineY);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    //外层圆
    CGFloat penWidth = 1.f;
    CGContextSetStrokeColorWithColor(context, _circleColor.CGColor);//画笔颜色
    CGContextSetLineWidth(context, penWidth);//线的宽度
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);//填充颜色
    CGContextSetShadow(context, CGSizeMake(1, 1), 1.f);//阴影
    CGFloat circleX = (_direction == ILSliderDirectionHorizonal ? MAX(_circleRadius + penWidth, slidedLineX - penWidth ) : startLineX);
    CGFloat circleY = (_direction == ILSliderDirectionHorizonal ? startLineY : MAX(_circleRadius + penWidth, slidedLineY - penWidth));
    CGContextAddArc(context, circleX, circleY, _circleRadius, 0, 2 * M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
    //内层圆
    CGContextSetStrokeColorWithColor(context, nil);
    CGContextSetLineWidth(context, 0);
    CGContextSetFillColorWithColor(context, _circleColor.CGColor);
    CGContextAddArc(context, circleX, circleY, _circleRadius / 2, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
}
#pragma mark 触摸
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateTouchPoint:touches];
    [self callbackTouchEnd:NO];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateTouchPoint:touches];
    [self callbackTouchEnd:NO];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateTouchPoint:touches];
    [self callbackTouchEnd:YES];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateTouchPoint:touches];
    [self callbackTouchEnd:YES];
}
- (void)updateTouchPoint:(NSSet*)touches {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    self.ratioNum = (_direction == ILSliderDirectionHorizonal ? touchPoint.x : touchPoint.y) / (_direction == ILSliderDirectionHorizonal ? self.frame.size.width : self.frame.size.height);
    // DLog(@"_ratioNum == %f",_ratioNum);
}
- (void)setRatioNum:(CGFloat)ratioNum {
    if (_ratioNum != ratioNum) {
        _ratioNum = ratioNum;
        self.value = _minValue + ratioNum * (_maxValue - _minValue);
    }
}
- (void)setValue:(CGFloat)value {
    if (value != _value) {
        if (value < _minValue) {
            _value = _minValue;
            return;
        } else if (value > _maxValue) {
            _value = _maxValue;
            return;
        }
        _value = value;
        [self setNeedsDisplay];
        if (_StateChanged) {
            _StateChanged(value);
        }
    }
}
- (void)sliderChangeBlock:(TouchStateChanged)didChangeBlock{
    _StateChanged = didChangeBlock;
}
- (void)sliderTouchEndBlock:(TouchStateEnd)touchEndBlock{
    _StateEnd = touchEndBlock;
}
- (void)callbackTouchEnd:(BOOL)isTouchEnd {
    _isSliding = !isTouchEnd;
    if (isTouchEnd == YES) {
        _StateEnd(_value);
    }
}
@end
@implementation E_SettingTopBar
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
        [self configUI];
    }
    return self;
}
- (void)configUI{
    UIButton *backBtn = [UIButton buttonWithType:0];
    backBtn.frame = CGRectMake(10, 20, 60, 44);
    [backBtn setTitle:@" 返回" forState:0];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitleColor:[UIColor whiteColor] forState:0];
    [backBtn addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    UIButton *multifunctionBtn = [UIButton buttonWithType:0];
    multifunctionBtn.frame = CGRectMake(self.frame.size.width - 10 - 60, 20, 60, 44);
    [multifunctionBtn setImage:[UIImage imageNamed:@"reader_more"] forState:0];
    [multifunctionBtn setTitleColor:[UIColor whiteColor] forState:0];
    [multifunctionBtn addTarget:self action:@selector(multifunction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:multifunctionBtn];
}
- (void)backToFront{
    [_delegate goBack];
}
- (void)multifunction{
    [_delegate showMultifunctionButton];
}
- (void)showToolBar{
    CGRect newFrame = self.frame;
    newFrame.origin.y += 64;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
    }];
}
- (void)hideToolBar{
    CGRect newFrame = self.frame;
    newFrame.origin.y -= 64;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
@implementation E_SettingBottomBar{
    ILSlider *ilSlider;
    UILabel  *showLbl;
    BOOL isFirstShow;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
        isFirstShow = YES;
        [self configUI];
    }
    return self;
}
- (void)configUI{
    UIButton *menuBtn = [UIButton buttonWithType:0];
    [menuBtn setImage:[UIImage imageNamed:@"reader_cover"] forState:0];
    [menuBtn addTarget:self action:@selector(showDrawerView) forControlEvents:UIControlEventTouchUpInside];
    menuBtn.frame = CGRectMake(10, self.frame.size.height - 54, 60, 44);
    [self addSubview:menuBtn];
    UIButton *commentBtn = [UIButton buttonWithType:0];
    [commentBtn setImage:[UIImage imageNamed:@"reader_comments"] forState:0];
    [commentBtn addTarget:self action:@selector(showCommentView) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.frame = CGRectMake(self.frame.size.width - 70, self.frame.size.height - 54, 60, 44);
    [self addSubview:commentBtn];
    _bigFont = [UIButton buttonWithType:0];
    _bigFont.frame = CGRectMake(110 + (self.frame.size.width - 200)/2, self.frame.size.height - 54, (self.frame.size.width - 200)/2, 44);
    [_bigFont setImage:[UIImage imageNamed:@"reader_font_increase"] forState:0];
    _bigFont.backgroundColor = [UIColor clearColor];
    [_bigFont addTarget:self action:@selector(changeBig) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bigFont];
    _smallFont = [UIButton buttonWithType:0];
    [_smallFont setImage:[UIImage imageNamed:@"reader_font_decrease"] forState:0];
    [_smallFont addTarget:self action:@selector(changeSmall) forControlEvents:UIControlEventTouchUpInside];
    _smallFont.frame =  CGRectMake(90, self.frame.size.height - 54, (self.frame.size.width - 200)/2, 44);
    [self addSubview:_smallFont];
    showLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, self.frame.size.height - kBottomBarH - 70, self.frame.size.width - 140 , 60)];
    showLbl.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    [showLbl setTextColor:[UIColor whiteColor]];
    showLbl.font = [UIFont systemFontOfSize:18];
    showLbl.textAlignment = NSTextAlignmentCenter;
    showLbl.numberOfLines = 2;
    showLbl.alpha = 0.7;
    showLbl.hidden = YES;
    [self addSubview:showLbl];
    ilSlider = [[ILSlider alloc] initWithFrame:CGRectMake(50, self.frame.size.height - 54 - 40 - 50 , self.frame.size.width - 100, 40) direction:ILSliderDirectionHorizonal];
    ilSlider.maxValue = 3;
    ilSlider.minValue = 1;
    [ilSlider sliderChangeBlock:^(CGFloat value) {
        if (!isFirstShow) {
            showLbl.hidden = NO;
            double percent = (value - ilSlider.minValue)/(ilSlider.maxValue - ilSlider.minValue);
            showLbl.text = [NSString stringWithFormat:@"第%ld章\n%.1f%@",_currentChapter,percent*100,@"%"];
        }
        isFirstShow = NO;
    }];
    [ilSlider sliderTouchEndBlock:^(CGFloat value) {
        showLbl.hidden = YES;
        float percent = (value - ilSlider.minValue)/(ilSlider.maxValue - ilSlider.minValue);
        NSInteger page = (NSInteger)round(percent * _chapterTotalPage);
        if (page == 0) {
            page = 1;
        }
        [_delegate sliderToChapterPage:page];
    }];
    [self addSubview:ilSlider];
    //前一章 按钮
    UIButton *preChapterBtn = [UIButton buttonWithType:0];
    preChapterBtn.frame = CGRectMake(5, self.frame.size.height - 54 - 40 - 50, 40, 40);
    preChapterBtn.backgroundColor = [UIColor clearColor];
    [preChapterBtn setTitle:@"上一章" forState:0];
    [preChapterBtn addTarget:self action:@selector(goToPreChapter) forControlEvents:UIControlEventTouchUpInside];
    preChapterBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [preChapterBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self addSubview:preChapterBtn];
    //后一章 按钮
    UIButton *nextChapterBtn = [UIButton buttonWithType:0];
    nextChapterBtn.frame = CGRectMake(self.frame.size.width - 45, self.frame.size.height - 54 - 40 - 50, 40, 40);
    nextChapterBtn.backgroundColor = [UIColor clearColor];
    [nextChapterBtn setTitle:@"下一章" forState:0];
    [nextChapterBtn addTarget:self action:@selector(goToNextChapter) forControlEvents:UIControlEventTouchUpInside];
    nextChapterBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [nextChapterBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self addSubview:nextChapterBtn];
    //主题颜色滚动条
    UIScrollView *themeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(30, self.frame.size.height - 54 - 50 , self.frame.size.width - 60, 40)];
    themeScroll.backgroundColor = [UIColor clearColor];
    [self addSubview:themeScroll];
    NSInteger themeID = [E_CommonManager Manager_getReadTheme];
    for (int i = 1; i <= 4; i ++) {
        UIButton * themeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        themeButton.layer.cornerRadius = 2.0f;
        themeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        themeButton.frame = CGRectMake(0 + 36*i + (self.frame.size.width - 60 - 6 *36)*(i - 1)/3, 2, 36, 36);
        if (i == 1) {
            [themeButton setBackgroundColor:[UIColor whiteColor]];
        }else{
            [themeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%d",i]] forState:UIControlStateNormal];
            [themeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%d",i]] forState:UIControlStateSelected];
        }
        if (i == themeID) {
            themeButton.selected = YES;
        }
        [themeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg_s"]] forState:UIControlStateSelected];
        [themeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg_s"]] forState:UIControlStateHighlighted];
        themeButton.tag = 7000+i;
        [themeButton addTarget:self action:@selector(themeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [themeScroll addSubview:themeButton];
    }
}
- (void)themeButtonPressed:(UIButton *)sender{
    [sender setSelected:YES];
    for (int i = 1; i <= 5; i++) {
        UIButton * button = (UIButton *)[self viewWithTag:7000+i];
        if (button.tag != sender.tag) {
            [button setSelected:NO];
        }
    }
    [_delegate themeButtonAction:self themeIndex:sender.tag-7000];
    [E_CommonManager saveCurrentThemeID:sender.tag-7000];
}
- (void)goToNextChapter{
    [_delegate turnToNextChapter];
    
}
- (void)goToPreChapter{
    [_delegate turnToPreChapter];
}
#pragma mark - 小
- (void)changeSmall{
    NSUInteger fontSize = [E_CommonManager fontSize];
    if (fontSize <= MIN_FONT_SIZE) {
        [E_HUDView showMsg:MIN_TIPS inView:self];
        return;
    }
    fontSize--;
    [E_CommonManager saveFontSize:fontSize];
    [self updateFontButtons];
    [_delegate fontSizeChanged:(int)fontSize];
    [_delegate shutOffPageViewControllerGesture:NO];
}
- (void)changeBig{
    NSUInteger fontSize = [E_CommonManager fontSize];
    if (fontSize >= MAX_FONT_SIZE) {
        [E_HUDView showMsg:MAX_TIPS inView:self];
        return;
    }
    fontSize++;
    [E_CommonManager saveFontSize:fontSize];
    [self updateFontButtons];
    [_delegate fontSizeChanged:(int)fontSize];
    [_delegate shutOffPageViewControllerGesture:NO];
    
}
- (void)updateFontButtons{
    NSUInteger fontSize = [E_CommonManager fontSize];
    _bigFont.enabled = fontSize < MAX_FONT_SIZE;
    _smallFont.enabled = fontSize > MIN_FONT_SIZE;
}
- (void)showDrawerView{
    [_delegate callDrawerView];
}
- (void)changeSliderRatioNum:(float)percentNum{
    ilSlider.ratioNum = percentNum;
}
- (void)showCommentView{
    [_delegate callCommentView];
}
- (void)showToolBar{
    CGRect newFrame = self.frame;
    newFrame.origin.y -= kBottomBarH;
    float currentPage = [[NSString stringWithFormat:@"%ld",_chapterCurrentPage] floatValue] + 1;
    float totalPage = [[NSString stringWithFormat:@"%ld",_chapterTotalPage] floatValue];
    if (currentPage == 1) {//强行放置头部
        ilSlider.ratioNum = 0;
    }else{
        ilSlider.ratioNum = currentPage/totalPage;
    }
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
    }];
}
- (void)hideToolBar{
    CGRect newFrame = self.frame;
    newFrame.origin.y += kBottomBarH;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
@implementation E_CursorView
- (id)initWithType:(CursorType)type andHeight:(float)cursorHeight byDrawColor:(UIColor *)drawColor{
    self = [super init];
    if (self) {
        _direction = type;
        _cursorHeight = cursorHeight;
        _cursorColor = drawColor;
        self.clipsToBounds = NO;
    }
    return self;
}
- (void)setSetupPoint:(CGPoint)setupPoint{
    self.backgroundColor = _cursorColor;
    if (_dragDot) {
        [_dragDot removeFromSuperview];
        _dragDot = nil;
    }
    _dragDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"r_drag-dot"]];
    if (_direction == CursorLeft) {
        self.frame = CGRectMake(setupPoint.x - kE_CursorWidth, setupPoint.y - _cursorHeight, kE_CursorWidth, _cursorHeight);
        _dragDot.frame = CGRectMake(-7, -8, 15, 17);
        
    }else{
        self.frame = CGRectMake(setupPoint.x, setupPoint.y - _cursorHeight, kE_CursorWidth, _cursorHeight);
        _dragDot.frame = CGRectMake(-6, _cursorHeight - 8, 15, 17);
    }
    [self addSubview:_dragDot];
}
- (void)dealloc{
}
@end
#define ListViewW (3* self.frame.size.width/4)
@implementation E_DrawerView
- (id)initWithFrame:(CGRect)frame parentView:(UIView *)p{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.parent = p;
        self.alpha = 0;
        UIImage *background = [self blurredSnapshot];
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundView.image = background;
        [self addSubview:backgroundView];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDrawView)];
        tapGes.delegate = self;
        [self addGestureRecognizer:tapGes];
        [self configUI];
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint touchPoint = [touch locationInView:self];
    CGRect blurRect = CGRectMake(ListViewW, 0, self.frame.size.width - ListViewW, self.frame.size.height);
    if (CGRectContainsPoint(blurRect, touchPoint)) {
        return YES;
    }else{
        return NO;
    }
}
- (void)hideDrawView{
    [UIView animateWithDuration:0.25 animations:^{
        _listView.frame = CGRectMake(-ListViewW, 0, ListViewW, self.frame.size.height);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_listView removeFromSuperview];
        _listView = nil;
        [_delegate openTapGes];
        [self removeFromSuperview];
    }];
}
- (void)removeE_ListView{
    [_listView removeFromSuperview];
    _listView = nil;
    [_delegate openTapGes];
    [self removeFromSuperview];
}
- (void)configUI{
    if (_listView == nil) {
        _listView = [[E_ListView alloc] initWithFrame:CGRectMake(- ListViewW, 0, ListViewW, self.frame.size.height)];
        _listView.delegate = self;
        [self addSubview:_listView];
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _listView.frame = CGRectMake(0, 0, ListViewW, self.frame.size.height);
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }else{
    }
}
- (void)clickMark:(E_Mark *)eMark{
    [UIView animateWithDuration:0.25 animations:^{
        _listView.frame = CGRectMake(-ListViewW, 0, ListViewW, self.frame.size.height);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_listView removeFromSuperview];
        _listView = nil;
        [_delegate openTapGes];
        [_delegate turnToClickMark:eMark];
        [self removeFromSuperview];
    }];
}
- (void)clickChapter:(NSInteger)chaperIndex{
    [UIView animateWithDuration:0.25 animations:^{
        _listView.frame = CGRectMake(-ListViewW, 0, ListViewW, self.frame.size.height);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_listView removeFromSuperview];
        _listView = nil;
        [_delegate openTapGes];
        [_delegate turnToClickChapter:chaperIndex];
        [self removeFromSuperview];
    }];
    
}
- (UIImage *)blurredSnapshot {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.parent.frame), CGRectGetHeight(self.parent.frame)), NO, 1.0f);
    [self.parent drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.parent.frame), CGRectGetHeight(self.parent.frame)) afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *blurredSnapshotImage = [self applyBlurImage:snapshotImage WithRadius:2 tintColor:[UIColor colorWithWhite:1.0 alpha:0.1] saturationDeltaFactor:1.8 maskImage:nil];
    UIGraphicsEndImageContext();
    return blurredSnapshotImage;
}
- (UIImage *)applyBlurImage:(UIImage*)image WithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage{
    // Check pre-conditions.
    if (image.size.width < 1 || image.size.height < 1) {
        DLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", image.size.width, image.size.height, image);
        return nil;
    }
    if (!image.CGImage) {
        DLog (@"*** error: image must be backed by a CGImage: %@", image);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        DLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    CGRect imageRect = { CGPointZero, image.size };
    UIImage *effectImage = image;
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -image.size.height);
        CGContextDrawImage(effectInContext, imageRect, image.CGImage);
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        if (hasBlur) {
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }else{
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -image.size.height);
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, image.CGImage);
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}
@end
@implementation E_HUDView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
+ (void)showMsg:(NSString *)msg inView:(UIView*)theView{
    E_HUDView *alert = [[E_HUDView alloc] initWithMsg:msg];
    if (!theView){
        [[self getUnhiddenFrontWindowOfApplication] addSubview:alert];
    }else{
        [[E_HUDView getWindow] addSubview:alert];
    }
    [alert showAlert];
}
- (void)showAlert{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    self.alpha = 0.0;
    CGPoint center=[E_HUDView getWindow].center;
    //    //调整位置
    //    center.y -= (int)((SCREEN_HEIGHT - self.frame.size.height) / 164.0f * 36 / 2);
    self.center=center;
    CAKeyframeAnimation* opacityAnimation= [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = _totalDuration;
    opacityAnimation.cumulative = YES;
    opacityAnimation.repeatCount = 1;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeBoth;
    opacityAnimation.values = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.2],
                               [NSNumber numberWithFloat:0.92],
                               [NSNumber numberWithFloat:0.92],
                               [NSNumber numberWithFloat:0.1], nil];
    opacityAnimation.keyTimes = [NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:0.0f],
                                 [NSNumber numberWithFloat:0.08f],
                                 [NSNumber numberWithFloat:0.92f],
                                 [NSNumber numberWithFloat:1.0f], nil];
    opacityAnimation.timingFunctions = [NSArray arrayWithObjects:
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], nil];
    CAKeyframeAnimation* scaleAnimation =[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = _totalDuration;
    scaleAnimation.cumulative = YES;
    scaleAnimation.repeatCount = 1;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.values = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:self.animationTopScale],
                             [NSNumber numberWithFloat:1.0f],
                             [NSNumber numberWithFloat:1.0f],
                             [NSNumber numberWithFloat:self.animationTopScale],
                             nil];
    scaleAnimation.keyTimes = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:0.085f],
                               [NSNumber numberWithFloat:0.92f],
                               [NSNumber numberWithFloat:1.0f], nil];
    scaleAnimation.timingFunctions = [NSArray arrayWithObjects:
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], nil];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = _totalDuration;
    group.delegate = self;
    group.animations = [NSArray arrayWithObjects:opacityAnimation,scaleAnimation, nil];
    [self.layer addAnimation:group forKey:@"group"];
    
}
- (id)initWithMsg:(NSString*)_msg{
    if (self = [super init]) {
        self.msg = _msg;
        self.leftMargin = 20;
        self.topMargin = 10;
        self.totalDuration = 1.2f;
        self.animationTopScale = 1.2;
        self.animationLeftScale = 1.2;
        msgFont = [UIFont systemFontOfSize:14.0f];
        CGSize textSize = [self getSizeFromString:_msg];
        
        self.bounds = CGRectMake(0, 0, 160, 50);
        self.labelText = [[UILabel alloc] init];
        _labelText.text = _msg;
        _labelText.numberOfLines = 0;
        _labelText.font = msgFont;
        _labelText.backgroundColor = [UIColor clearColor];
        _labelText.textColor = [UIColor whiteColor];
        _labelText.textAlignment = NSTextAlignmentCenter;
        [_labelText setFrame:CGRectMake((160 - textSize.width) / 2, 18,textSize.width, textSize.height)];
        [self  addSubview:_labelText];
        self.layer.cornerRadius = 10;
        
    }
    return self;
}
+ (UIWindow *) getUnhiddenFrontWindowOfApplication{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    NSInteger windowCnt = [windows count];
    for (int i = windowCnt - 1; i >= 0; i--) {
        UIWindow* window = [windows objectAtIndex:i];
        if (FALSE == window.hidden) {
            //定制：防止产生bar提示，用的是新增window,排除这个window
            if (window.frame.size.height > 50.0f) {
                return window;
            }
        }
    }
    return NULL;
}
+ (UIWindow*)getWindow{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}
- (CGSize)getSizeFromString:(NSString*)_theString{
    UIFont *theFont = msgFont;
    CGSize size = CGSizeMake(160, 2000);
    //     = [_theString sizeWithFont:theFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attributes = @{ NSFontAttributeName:theFont, NSParagraphStyleAttributeName:[[NSMutableParagraphStyle alloc]init]};
    CGSize tempSize = [_theString boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    return tempSize;
}
@end
@implementation E_ListView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:234/255.0 alpha:1.0];
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        dataCount = [E_ReaderDataSource shareInstance].totalChapter;
        [self configListView];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEListView:)];
        [self addGestureRecognizer:panGes];
        
    }
    return self;
}
- (void)panEListView:(UIPanGestureRecognizer *)recongnizer{
    CGPoint touchPoint = [recongnizer locationInView:self];
    switch (recongnizer.state) {
        case UIGestureRecognizerStateBegan:{
            _panStartX = touchPoint.x;
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            CGFloat offSetX = touchPoint.x - _panStartX;
            CGRect newFrame = self.frame;
            //DLog(@"offSetX == %f",offSetX);
            newFrame.origin.x += offSetX;
            if (newFrame.origin.x >= 0){//试图向上滑动 阻止
                
                newFrame.origin.x = 0;
                self.frame = newFrame;
                return;
            }else{
                self.frame = newFrame;
            }
        }break;
        case UIGestureRecognizerStateEnded:{
            float duringTime = (self.frame.size.width + self.frame.origin.x)/self.frame.size.width * 0.25;
            if (self.frame.origin.x < 0) {
                [UIView animateWithDuration:duringTime animations:^{
                    self.frame = CGRectMake(-self.frame.size.width , 0,  self.frame.size.width, self.frame.size.height);
                } completion:^(BOOL finished) {
                    [_delegate removeE_ListView];
                }];
                
            }
        }break;
        case UIGestureRecognizerStateCancelled:break;
        default:break;
    }
}
- (void)configListView{
    _isMenu = YES;
    _isMark = NO;
    _isNote = NO;
    [self configListViewHeader];
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.frame.size.width, self.frame.size.height - 80 - 60)];
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.backgroundColor = [UIColor clearColor];
    [self addSubview:_listView];
    UIButton *otherBtn = [UIButton buttonWithType:0];
    otherBtn.frame = CGRectMake(70, self.frame.size.height - 40, self.frame.size.width - 140, 20);
    otherBtn.layer.borderWidth = 1.0;
    otherBtn.layer.cornerRadius = 2.0;
    otherBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [otherBtn setTitleColor:[UIColor colorWithRed:233/255.0 green:64/255.0 blue:64/255.0 alpha:1.0] forState:0];
    [otherBtn setTitle:@"备用按钮" forState:0];
    otherBtn.layer.borderColor = [UIColor colorWithRed:233/255.0 green:64/255.0 blue:64/255.0 alpha:1.0].CGColor;
    [self addSubview:otherBtn];
    
}
- (void)configListViewHeader{
    NSArray *segmentedArray = @[@"目录",@"书签"];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    _segmentControl.frame = CGRectMake(15, 30, self.bounds.size.width - 30 , 40);
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.tintColor = [UIColor colorWithRed:233/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
    [self addSubview:_segmentControl];
    [_segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    [_segmentControl setTitleTextAttributes:dict forState:0];
}
- (void)segmentAction:(UISegmentedControl *)sender{
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:{
            _isMenu = YES;
            _isMark = NO;
            _isNote = NO;
            dataCount = [E_ReaderDataSource shareInstance].totalChapter;
            [_listView reloadData];
        }
            break;
        case 1:{
            _isMenu = NO;
            _isMark = YES;
            _isNote = NO;
            _dataSource = [E_CommonManager Manager_getMark];
            [_listView reloadData];
        }
            break;
            //        case 2:{
            //                _isMenu = NO;
            //                _isMark = NO;
            //                _isNote = YES;
            //            }
            //            break;
            
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isMark) {
        return 100;
    }
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isMark) {
        return _dataSource.count;
    }
    return dataCount;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isMark) {
        [_delegate clickMark:[_dataSource objectAtIndex:indexPath.row]];
        return;
    }
    [_delegate clickChapter:indexPath.row];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isMenu == YES) {
        static NSString *cellStr = @"menuCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld章",indexPath.row + 1];
        return cell;
    }else if(_isMark){
        static NSString *cellStr = @"markCell";
        E_MarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[E_MarkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.chapterLbl.text = [NSString stringWithFormat:@"第%@章",[(E_Mark *)[_dataSource objectAtIndex:indexPath.row] markChapter]];
        cell.timeLbl.text    = [(E_Mark *)[_dataSource objectAtIndex:indexPath.row] markTime];
        cell.contentLbl.text = [(E_Mark *)[_dataSource objectAtIndex:indexPath.row] markContent];
        return cell;
    }else{
        static NSString *cellStr = @"noteCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld章",indexPath.row + 1];
        return cell;
        
    }
    return nil;
}
@end
@implementation E_MagnifiterView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, 80, 80)]) {
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 40;
        self.layer.masksToBounds = YES;
    }
    return self;
}
- (void)setTouchPoint:(CGPoint)touchPoint {
    _touchPoint = touchPoint;
    self.center = CGPointMake(touchPoint.x, touchPoint.y - 70);
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.frame.size.width * 0.5,self.frame.size.height * 0.5);
    CGContextScaleCTM(context, 1.5, 1.5);
    CGContextTranslateCTM(context, -1 * (_touchPoint.x), -1 * (_touchPoint.y));
    [self.viewToMagnify.layer renderInContext:context];
}
@end
#define kEpubView_H self.frame.size.height
#define kItemCopy           @"复制"
#define kItemHighLight      @"高亮"
#define kItemCiBa           @"词霸"
#define kItemRead           @"朗读"
@implementation E_ReaderView{
    CTFrameRef _ctFrame;
    NSRange selectedRange;//选择区域
    //  CGSize suggestedSize;
    UIGestureRecognizer *panRecognizer;
    UITapGestureRecognizer *tapRecognizer;
    UILongPressGestureRecognizer *longRecognizer;
    NSMutableArray *highLightRangeArray;//高亮区域 注：翻页后高亮便不存在，若需让其存在，请本地化该数组
    NSMutableString *_totalString;
}
- (void)dealloc{
    if (_ctFrame != NULL) {
        CFRelease(_ctFrame);
    }
}
#pragma mark - 初始化一些手势等
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        highLightRangeArray = [[NSMutableArray alloc] initWithCapacity:0];
        longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressAction:)];
        longRecognizer.enabled = YES;
        [self addGestureRecognizer:longRecognizer];
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapAction:)];
        tapRecognizer.enabled = NO;
        [self addGestureRecognizer:tapRecognizer];
        panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(PanAction:)];
        [self addGestureRecognizer:panRecognizer];
        panRecognizer.enabled = NO;
    }
    return self;
}
#pragma mark - 绘制相关方法
- (void)drawRect:(CGRect)rect{
    if (!_ctFrame) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGAffineTransform transform = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, transform);
    if (_keyWord == nil || [_keyWord isEqualToString:@""]) {
    }else{
        [self showSearchResultRect:[self calculateRangeArrayWithKeyWord:_keyWord]];
    }
    // [self showHighLightRect:highLightRangeArray];
    [self showSelectRect:selectedRange];
    [self showCursor];
    CTFrameDraw(_ctFrame, context);
}
- (NSMutableArray *)calculateRangeArrayWithKeyWord:(NSString *)searchWord{
    NSMutableString *blankWord = [NSMutableString string];
    for (int i = 0; i < searchWord.length; i ++) {
        [blankWord appendString:@" "];
    }
    NSMutableArray *feedBackArray = [NSMutableArray array];
    for (int i = 0; i < INT_MAX; i++){
        if ([_totalString rangeOfString:searchWord options:1].location != NSNotFound){
            NSRange newRange = [_totalString rangeOfString:searchWord options:1];
            [feedBackArray addObject:NSStringFromRange(newRange)];
            [_totalString replaceCharactersInRange:newRange withString:blankWord];
        }else{
            break;
        }
    }
    return feedBackArray;
}
- (NSDictionary *)coreTextAttributes{
    UIFont *font_ = [UIFont systemFontOfSize:self.font];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = font_.pointSize / 2;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary *dic = @{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName:font_};
    return dic;
}
- (void)render{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString  alloc] initWithString:self.text];
    _totalString = [NSMutableString stringWithString:self.text];
    [attrString setAttributes:self.coreTextAttributes range:NSMakeRange(0, attrString.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CGPathRef path = CGPathCreateWithRect(self.bounds, NULL);
    if (_ctFrame != NULL) {
        CFRelease(_ctFrame), _ctFrame = NULL;
    }
    _ctFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    //计算高度的方法****************************
    //    suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), NULL, CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT), NULL);
    //    suggestedSize = CGSizeMake(ceilf(suggestedSize.width), ceilf(suggestedSize.height));
    //
    //    DLog(@"height == %f",suggestedSize.height);
    //****************************************
    CFRelease(path);
    CFRelease(frameSetter);
}
- (CTFrameRef)getCTFrame{
    return _ctFrame;
}
#pragma mark - 搜索结果
- (void)showSearchResultRect:(NSMutableArray *)resultArray{
    for (int i = 0; i < resultArray.count; i ++) {
        [self drawHighLightRect:NSRangeFromString([resultArray objectAtIndex:i])];
    }
}
#pragma mark -高亮区域
- (void)showHighLightRect:(NSMutableArray *)highArray{
    for (int i = 0; i < highArray.count; i ++) {
        [self drawHighLightRect:NSRangeFromString([highArray objectAtIndex:i])];
    }
}
#pragma mark - 计算高亮区域 （懒得写枚举区分，就直接复制下面得 选择区域了）
- (void)drawHighLightRect:(NSRange)selectRect{
    if (selectRect.length == 0 || selectRect.location == NSNotFound) {
        return;
    }
    NSMutableArray *pathRects = [[NSMutableArray alloc] init];
    NSArray *lines = (NSArray*)CTFrameGetLines([self getCTFrame]);
    CGPoint *origins = (CGPoint*)malloc([lines count] * sizeof(CGPoint));
    CTFrameGetLineOrigins([self getCTFrame], CFRangeMake(0,0), origins);
    for (int i = 0; i < lines.count; i ++) {
        CTLineRef line = (__bridge CTLineRef) [lines objectAtIndex:i];
        CFRange lineRange = CTLineGetStringRange(line);
        NSRange range = NSMakeRange(lineRange.location==kCFNotFound ? NSNotFound : lineRange.location, lineRange.length);
        NSRange intersection = [self rangeIntersection:range withSecond:selectRect];
        if (intersection.length > 0) {
            
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);//获取整段文字中charIndex位置的字符相对line的原点的x值
            
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, intersection.location + intersection.length, NULL);
            CGPoint origin = origins[i];
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CGRect selectionRect = CGRectMake(origin.x + xStart, origin.y - descent, xEnd - xStart, ascent + descent);
            [pathRects addObject:NSStringFromCGRect(selectionRect)];//放入数组
        }
    }
    free(origins);
    [self drawHighLightPathFromRects:pathRects];//画选择框
    
}
#pragma mark - 画高亮部分
- (void)drawHighLightPathFromRects:(NSMutableArray*)array{
    if (array==nil || [array count] == 0)
    {
        return;
    }
    // 创建一个Path句柄
    CGMutablePathRef _path = CGPathCreateMutable();
    [[UIColor orangeColor]setFill];
    for (int i = 0; i < [array count]; i++) {
        
        CGRect firstRect = CGRectFromString([array objectAtIndex:i]);
        CGPathAddRect(_path, NULL, firstRect);//向path路径添加一个矩形
        
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, _path);
    CGContextFillPath(ctx);//用当前的填充颜色或样式填充路径线段包围的区域。
    CGPathRelease(_path);
}
#pragma mark - 计算选择区域
- (void)showSelectRect:(NSRange)selectRect{
    if (selectRect.length == 0 || selectRect.location == NSNotFound) {
        return;
    }
    NSMutableArray *pathRects = [[NSMutableArray alloc] init];
    NSArray *lines = (NSArray*)CTFrameGetLines([self getCTFrame]);
    CGPoint *origins = (CGPoint*)malloc([lines count] * sizeof(CGPoint));
    CTFrameGetLineOrigins([self getCTFrame], CFRangeMake(0,0), origins);
    for (int i = 0; i < lines.count; i ++) {
        CTLineRef line = (__bridge CTLineRef) [lines objectAtIndex:i];
        CFRange lineRange = CTLineGetStringRange(line);
        NSRange range = NSMakeRange(lineRange.location==kCFNotFound ? NSNotFound : lineRange.location, lineRange.length);
        NSRange intersection = [self rangeIntersection:range withSecond:selectRect];
        if (intersection.length > 0) {
            
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);//获取整段文字中charIndex位置的字符相对line的原点的x值
            
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, intersection.location + intersection.length, NULL);
            CGPoint origin = origins[i];
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CGRect selectionRect = CGRectMake(origin.x + xStart, origin.y - descent, xEnd - xStart, ascent + descent);
            [pathRects addObject:NSStringFromCGRect(selectionRect)];//放入数组
        }
    }
    free(origins);
    [self drawPathFromRects:pathRects];//画选择框
    
}
#pragma mark- 画背景色
- (void)drawPathFromRects:(NSMutableArray*)array{
    if (array==nil || [array count] == 0){
        return;
    }
    // 创建一个Path句柄
    CGMutablePathRef _path = CGPathCreateMutable();
    [[UIColor colorWithRed:228/255.0 green:100/255.0 blue:166/255.0 alpha:0.6]setFill];
    for (int i = 0; i < [array count]; i++) {
        CGRect firstRect = CGRectFromString([array objectAtIndex:i]);
        CGPathAddRect(_path, NULL, firstRect);//向path路径添加一个矩形
    }
    [self resetCursor:array];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, _path);
    CGContextFillPath(ctx);//用当前的填充颜色或样式填充路径线段包围的区域。
    CGPathRelease(_path);
}
#pragma mark- 重新设置光标的位置
- (void)resetCursor:(NSMutableArray*)rectArray{
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    CGPoint leftCursorPoint = CGRectFromString([rectArray objectAtIndex:0]).origin;
    leftCursorPoint = CGPointApplyAffineTransform(leftCursorPoint, transform);
    _leftCursor.setupPoint = leftCursorPoint;
    CGPoint rightCursorPoint = CGRectFromString([rectArray lastObject]).origin;
    rightCursorPoint.x = rightCursorPoint.x + CGRectFromString([rectArray lastObject]).size.width;
    rightCursorPoint = CGPointApplyAffineTransform(rightCursorPoint, transform);
    _rightCursor.setupPoint = rightCursorPoint;
}
#pragma mark - 初始化光标
- (void)showCursor{
    if (selectedRange.length == 0 || selectedRange.location == NSNotFound || _rightCursor != nil || _leftCursor != nil) {
        return;
    }
    [self removeCursor];
    _leftCursor = [[E_CursorView alloc] initWithType:CursorLeft andHeight:self.font byDrawColor:[UIColor blueColor]];
    _rightCursor = [[E_CursorView alloc] initWithType:CursorRight andHeight:self.font byDrawColor:[UIColor blueColor]];
    [self addSubview:_leftCursor];
    [self addSubview:_rightCursor];
    [self setNeedsDisplay];
}
#pragma mark - 长按手势
- (void)LongPressAction:(UILongPressGestureRecognizer *)longPress{
    CGPoint point = [longPress locationInView:self];
    if (longPress.state == UIGestureRecognizerStateBegan ||
        longPress.state == UIGestureRecognizerStateChanged){
        [_delegate shutOffGesture:YES];
        [_delegate hideSettingToolBar];
        CFIndex index = [self getTouchIndexWithTouchPoint:point];
        if (index != -1 && index < self.text.length) {
            NSRange range = [self characterRangeAtIndex:index doFrame:[self getCTFrame]];//智能字典串（判断单词 人名 xxxxxx）
            selectedRange = NSMakeRange(range.location, range.length);
        }
        self.magnifierView.touchPoint = point;
    }else{
        [self removeMaginfierView];
        [self showCursor];
        if (selectedRange.length == 0) {
            panRecognizer.enabled = NO;
        }else{
            [self showMenuUI];
        }
        tapRecognizer.enabled = YES;
    }
    if (selectedRange.length != 0) {
        panRecognizer.enabled = YES;
    }
}
#pragma mark -平移拖动
- (void)PanAction:(UIPanGestureRecognizer *)panGes{
    CGPoint point = [panGes locationInView:self];
    if (panGes.state == UIGestureRecognizerStateBegan) {
        if (_leftCursor && CGRectContainsPoint(CGRectInset(_leftCursor.frame, -25, -10), point)) {//左
            _leftCursor.tag = 1;
        } else if (_rightCursor && CGRectContainsPoint(CGRectInset(_rightCursor.frame, -25, -10), point)) {//右
            _rightCursor.tag = 1;
        }else{
            [self removeMaginfierView];
        }
    }else if (panGes.state == UIGestureRecognizerStateChanged){
        [self hideMenuUI];
        CFIndex index = [self getTouchIndexWithTouchPoint:point];
        if (index == -1) {
            return;
        }
        if (_leftCursor.tag == 1 && index < selectedRange.length + selectedRange.location) {
            selectedRange.length = selectedRange.location - index + selectedRange.length;
            selectedRange.location = index;
            self.magnifierView.touchPoint = point;
        } else if (_rightCursor.tag == 1 && index > selectedRange.location) {
            selectedRange.location = selectedRange.location;
            selectedRange.length =  index - selectedRange.location;
            self.magnifierView.touchPoint = point;
        }
    }else if (panGes.state == UIGestureRecognizerStateEnded ||
              panGes.state == UIGestureRecognizerStateCancelled) {
        _leftCursor.tag = 0;
        _rightCursor.tag = 0;
        [self removeMaginfierView];
        if (selectedRange.length == 0) {
            panRecognizer.enabled = NO;
        }else{
            [self showMenuUI];
        }
    }
    [self setNeedsDisplay];
}
#pragma mark - 隐藏menu
- (void)hideMenuUI {
    if ([self resignFirstResponder]) {
        UIMenuController *theMenu = [UIMenuController sharedMenuController];
        [theMenu setMenuVisible:NO animated:YES];
    }
}
#pragma mark - 显示menu
- (void)showMenuUI{
    longRecognizer.enabled = NO;
    if ([self becomeFirstResponder]) {
        CGRect selectedRect = [self getMenuRect];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *menuItemCopy = [[UIMenuItem alloc]
                                    initWithTitle:kItemCopy
                                    action:@selector(copyword:)];
        //        UIMenuItem *menuItemHighLight = [[UIMenuItem alloc]
        //                                          initWithTitle:kItemHighLight
        //                                          action:@selector(highLight:)];
        UIMenuItem *menuItemCiBa = [[UIMenuItem alloc] initWithTitle:kItemCiBa action:@selector(ciBa:)];
        UIMenuItem *menuItmeRead = [[UIMenuItem alloc] initWithTitle:kItemRead action:@selector(readText:)];
        NSArray *mArray = [NSArray arrayWithObjects:
                           menuItemCopy,
                           //  menuItemHighLight,
                           menuItemCiBa,
                           menuItmeRead,
                           nil];
        [menuController setMenuItems:mArray];
        CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        selectedRect = CGRectApplyAffineTransform(selectedRect, transform);
        [menuController setTargetRect:selectedRect inView:self];
        [menuController setMenuVisible:YES animated:YES];
    }
}
- (CGRect )getMenuRect{
    if (selectedRange.length == 0 || selectedRange.location == NSNotFound) {
        return CGRectZero;
    }
    NSMutableArray *pathRects = [[NSMutableArray alloc] init];
    NSArray *lines = (NSArray*)CTFrameGetLines([self getCTFrame]);
    CGPoint *origins = (CGPoint*)malloc([lines count] * sizeof(CGPoint));
    CTFrameGetLineOrigins([self getCTFrame], CFRangeMake(0,0), origins);
    for (int i = 0; i < lines.count; i ++) {
        CTLineRef line = (__bridge CTLineRef) [lines objectAtIndex:i];
        CFRange lineRange = CTLineGetStringRange(line);
        NSRange range = NSMakeRange(lineRange.location==kCFNotFound ? NSNotFound : lineRange.location, lineRange.length);
        NSRange intersection = [self rangeIntersection:range withSecond:selectedRange];
        if (intersection.length > 0) {
            
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);//获取整段文字中charIndex位置的字符相对line的原点的x值
            
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, intersection.location + intersection.length, NULL);
            CGPoint origin = origins[i];
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CGRect selectionRect = CGRectMake(origin.x + xStart, origin.y - descent, xEnd - xStart, ascent + descent);
            [pathRects addObject:NSStringFromCGRect(selectionRect)];//放入数组
        }
    }
    free(origins);
    return  CGRectFromString([pathRects firstObject]);
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    //|| action == @selector(highLight:)
    if (action == @selector(copyword:) || action == @selector(ciBa:) || action == @selector(readText:)) {
        return YES;
    }
    return NO;
}
#pragma mark - 高亮
//- (void)highLight:(id)sender{
//     [_delegate shutOffGesture:NO];
//    [highLightRangeArray addObject:NSStringFromRange(selectedRange)];
//    selectedRange.location = 0;
//    selectedRange.length = 0;
//    [self removeCursor];
//    [self hideMenuUI];
//    [self setNeedsDisplay];
//    panRecognizer.enabled = NO;
//    tapRecognizer.enabled = NO;
//    longRecognizer.enabled = YES;
//}
- (void)resetting{
    selectedRange.location = 0;
    selectedRange.length = 0;
    [self removeCursor];
    [self hideMenuUI];
    [self setNeedsDisplay];
    panRecognizer.enabled = NO;
    tapRecognizer.enabled = NO;
    longRecognizer.enabled = YES;
}
//朗读
- (void)readText:(id)sender{
    [_delegate shutOffGesture:NO];
    NSString *readText = [NSString stringWithFormat:@"%@",[self.text substringWithRange:NSMakeRange(selectedRange.location, selectedRange.length)]];
    AVSpeechSynthesizer *av = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:readText];  //需要转换的文本
    utterance.rate = 0.2;
    utterance.pitchMultiplier = 0.5;
    [av speakUtterance:utterance];
    [self resetting];
}
//词霸
- (void)ciBa:(id)sender{
    [_delegate shutOffGesture:NO];
    NSString *ciBaString = [NSString stringWithFormat:@"%@",[self.text substringWithRange:NSMakeRange(selectedRange.location, selectedRange.length)]];
    [_delegate ciBa:ciBaString];
    [self resetting];
}
//拷贝
#pragma mark - copy
- (void)copyword:(id)sender{
    [_delegate shutOffGesture:NO];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[NSString stringWithFormat:@"%@",[self.text substringWithRange:NSMakeRange(selectedRange.location, selectedRange.length)]]];
    DLog(@"copyString == %@",[NSString stringWithFormat:@"%@",[self.text substringWithRange:NSMakeRange(selectedRange.location, selectedRange.length)]]);
    [self resetting];
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
#pragma mark -单击手势
- (void)TapAction:(UITapGestureRecognizer *)doubleTap{
    [_delegate shutOffGesture:NO];
    selectedRange.location = 0;
    selectedRange.length = 0;
    [self removeCursor];
    [self hideMenuUI];
    [self setNeedsDisplay];
    panRecognizer.enabled = NO;
    tapRecognizer.enabled = NO;
    longRecognizer.enabled = YES;
}
#pragma mark -移除放大镜
- (void)removeMaginfierView {
    if (_magnifierView) {
        [_magnifierView removeFromSuperview];
        _magnifierView = nil;
    }
}
#pragma mark -移除光标
- (void)removeCursor{
    if (_leftCursor) {
        [_leftCursor removeFromSuperview];
        _leftCursor = nil;
    }
    if (_rightCursor) {
        [_rightCursor removeFromSuperview];
        _rightCursor = nil;
    }
    
}
#pragma mark -根据用户手指的坐标获得 手指下面文字在整页文字中的index
- (CFIndex)getTouchIndexWithTouchPoint:(CGPoint)touchPoint{
    CTFrameRef textFrame = [self getCTFrame];
    NSArray *lines = (NSArray*)CTFrameGetLines(textFrame);
    if (!lines) {
        return -1;
    }
    CFIndex index = -1;
    NSInteger lineCount = [lines count];
    CGPoint *origins = (CGPoint*)malloc(lineCount * sizeof(CGPoint));
    if (lineCount != 0) {
        CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, 0), origins);
        
        for (int i = 0; i < lineCount; i++){
            
            CGPoint baselineOrigin = origins[i];
            baselineOrigin.y = CGRectGetHeight(self.frame) - baselineOrigin.y;
            
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
            CGFloat ascent, descent;
            CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            
            CGRect lineFrame = CGRectMake(baselineOrigin.x, baselineOrigin.y - ascent, lineWidth, ascent + descent);
            if (CGRectContainsPoint(lineFrame, touchPoint)){
                index = CTLineGetStringIndexForPosition(line, touchPoint);
            }
        }
    }
    free(origins);
    return index;
}
#pragma mark - 中文字典串
- (NSRange)characterRangeAtIndex:(NSInteger)index doFrame:(CTFrameRef)frame{
    __block NSArray *lines = (NSArray*)CTFrameGetLines(_ctFrame);
    NSInteger count = [lines count];
    __block NSRange returnRange = NSMakeRange(NSNotFound, 0);
    for (int i=0; i < count; i++) {
        
        __block CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
        CFRange cfRange = CTLineGetStringRange(line);
        CFRange cfRange_Next = CFRangeMake(0, 0);
        if (i < count - 1) {
            __block CTLineRef line_Next = (__bridge CTLineRef)[lines objectAtIndex:i+1];
            cfRange_Next = CTLineGetStringRange(line_Next);
        }
        
        NSRange range = NSMakeRange(cfRange.location == kCFNotFound ? NSNotFound : cfRange.location, cfRange.length == kCFNotFound ? 0 : cfRange.length);
        
        if (index >= range.location && index <= range.location+range.length) {
            
            if (range.length > 1) {
                NSRange newRange = NSMakeRange(range.location, range.length + cfRange_Next.length);
                [self.text enumerateSubstringsInRange:newRange options:NSStringEnumerationByWords usingBlock:^(NSString *subString, NSRange subStringRange, NSRange enclosingRange, BOOL *stop){
                    
                    if (index - subStringRange.location <= subStringRange.length&&index - subStringRange.location!=0) {
                        returnRange = subStringRange;
                        
                        if (returnRange.length <= 2 && self.text.length > 1) {//为的是长按选择的文字永远大于或等于2个，方便拖动
                            returnRange.length = 2;
                        }
                        *stop = YES;
                    }
                }];
            }
        }
    }
    return returnRange;
}
- (E_MagnifiterView *)magnifierView {
    if (_magnifierView == nil) {
        _magnifierView = [[E_MagnifiterView alloc] init];
        if (_magnifiterImage == nil) {
            _magnifierView.backgroundColor = [UIColor whiteColor];
        }else{
            _magnifierView.backgroundColor = [UIColor colorWithPatternImage:_magnifiterImage];
        }
        _magnifierView.viewToMagnify = self;
        [self addSubview:_magnifierView];
        //        DLog(@"go here=------");
    }
    return _magnifierView;
}
#pragma mark- Range区域
- (NSRange)rangeIntersection:(NSRange)first withSecond:(NSRange)second{
    NSRange result = NSMakeRange(NSNotFound, 0);
    if (first.location > second.location){
        NSRange tmp = first;
        first = second;
        second = tmp;
    }
    if (second.location < first.location + first.length){
        result.location = second.location;
        NSUInteger end = MIN(first.location + first.length, second.location + second.length);
        result.length = end - result.location;
    }
    return result;
}
@end
@implementation E_MarkTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _chapterLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
        _chapterLbl.textColor = [UIColor redColor];
        _chapterLbl.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_chapterLbl];
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(APPW*3/4 - 125, 5, 110, 20)];
        _timeLbl.textColor = [UIColor redColor];
        _timeLbl.textAlignment = NSTextAlignmentRight;
        _timeLbl.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLbl];
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 28, APPW*3/4 - 50, 60)];
        _contentLbl.numberOfLines = 3;
        _contentLbl.font = [UIFont systemFontOfSize:16];
        _contentLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:_contentLbl];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
@end
@implementation E_SearchTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _chapterLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
        _chapterLbl.textColor = [UIColor grayColor];
        _chapterLbl.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_chapterLbl];
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 29, APPW - 40, 24)];
        _contentLbl.textColor = [UIColor blackColor];
        _contentLbl.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _contentLbl.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_contentLbl];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
@implementation BookSubViews
@end
