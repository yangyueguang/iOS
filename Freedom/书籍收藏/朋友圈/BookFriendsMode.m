//
//  BookFriendsMode.m
#import "BookFriendsMode.h"
#import <CoreText/CoreText.h>
#import <BlocksKit/BlocksKit.h>
@implementation WFHudView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
+(void)showMsg:(NSString *)msg inView:(UIView*)theView{
    WFHudView *alert = [[WFHudView alloc] initWithMsg:msg];
    if (!theView){
        [[self getUnhiddenFrontWindowOfApplication] addSubview:alert];
    }else{
        [[WFHudView getWindow] addSubview:alert];
    }
    [alert showAlert];
}
-(void)showAlert{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    self.alpha = 0.0;
    CGPoint center = [WFHudView getWindow].center;
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
                               @0.2,@0.92,@0.92,@0.1,nil];
opacityAnimation.keyTimes = [NSArray arrayWithObjects:
@0.0f,@0.08f,@0.92f,@1.0f,nil];
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
     [NSNumber numberWithFloat:self.animationTopScale],@1.0f,@1.0f,[NSNumber numberWithFloat:self.animationTopScale],nil];
scaleAnimation.keyTimes = [NSArray arrayWithObjects:
@0.0f,@0.085f,@0.92f,@1.0f, nil];
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
-(id)initWithMsg:(NSString*)_msg{
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
        if ([self getSizeFromString:_msg].height > 32) {
            [_labelText setFrame:CGRectMake((160 - textSize.width) / 2, 8,textSize.width, textSize.height)];
        }
        [self  addSubview:_labelText];
        self.layer.cornerRadius = 10;
    }
    return self;
}
+(UIWindow *) getUnhiddenFrontWindowOfApplication{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    NSInteger windowCnt = [windows count];
    for (NSInteger i = windowCnt - 1; i >= 0; i--) {
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
+(UIWindow*)getWindow{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}
-(CGSize)getSizeFromString:(NSString*)_theString{
    UIFont *theFont = msgFont;
    CGSize size = CGSizeMake(160, 2000);
    //    CGSize tempSize = [_theString sizeWithFont:theFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attributes = @{ NSFontAttributeName:theFont, NSParagraphStyleAttributeName:[[NSMutableParagraphStyle alloc]init]};
    CGSize tempSize = [_theString boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
return tempSize;
}
@end
@implementation WFTextView{
NSString *_oldString;//未替换含有如[em:02:]的字符串
    NSString *_newString;//替换过含有如[em:02:]的字符串
NSMutableArray *_selectionsViews;
CTTypesetterRef typesetter;
    CTFontRef helvetica;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _selectionsViews = [NSMutableArray arrayWithCapacity:0];
        _isFold = YES;
        _canClickAll = YES;//默认可点击全部
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyself:)];
        [self addGestureRecognizer:tapGes];
        _replyIndex = -1;//默认为-1 代表点击的是说说的整块区域
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMyself:)];
        [self addGestureRecognizer:longGes];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)dealloc{
if (typesetter != NULL) {
        CFRelease(typesetter);
    }
}
- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
}
- (void)setOldString:(NSString *)oldString andNewString:(NSString *)newString{
    _oldString = oldString;
    _newString = newString;
    [self cookEmotionString];
}
#pragma mark -
- (NSArray *)offsetRangesInArray:(NSArray*)array By:(NSUInteger)offset{
    NSUInteger aOffset = 0;
    NSUInteger prevLength = 0;
    NSMutableArray *ranges = [[NSMutableArray alloc] initWithCapacity:[array count]];
    for(NSInteger i = 0; i < [array count]; i++){
        @autoreleasepool {
            NSRange range = [[array objectAtIndex:i] rangeValue];
            prevLength    = range.length;
            range.location -= aOffset;
            range.length    = offset;
            [ranges addObject:NSStringFromRange(range)];
            aOffset = aOffset + prevLength - offset;
        }
    }
    return ranges;
}
- (NSMutableArray *)items:(NSString*)str ForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index{
    if ( !pattern ) return nil;
    NSError *error = nil;
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error){
    }else{
        NSMutableArray *results = [[NSMutableArray alloc] init];
        NSRange searchRange = NSMakeRange(0, [str length]);
        [regx enumerateMatchesInString:str options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange groupRange =  [result rangeAtIndex:index];
            NSString *match = [str substringWithRange:groupRange];
            [results addObject:match];
        }];
        return results;
    }
    return nil;
}
- (void)cookEmotionString{
// 使用正则表达式查找特殊字符的位置
    NSArray *itemIndexes = [YMTextData itemIndexesWithPattern:@"\\[em:(\\d+):\\]" inString:_oldString];
NSArray *names = nil;
NSArray *newRanges = nil;
    names = [self items:_oldString ForPattern:@"\\[em:(\\d+):\\]" captureGroupIndex:1];
newRanges = [self offsetRangesInArray:itemIndexes By:[PlaceHolder length]];
    _emotionNames = names;
    _attrEmotionString = [self createAttributedEmotionStringWithRanges:newRanges
                                            forString:_newString];
    typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)
                                        (_attrEmotionString));
if (_isDraw == NO) {
        // CFRelease(typesetter);
        return;
    }
    [self setNeedsDisplay];
}
#pragma mark -
/*根据调整后的字符串，生成绘图时使用的 attribute string
 *  @param ranges  占位符的位置数组
 *  @param aString 替换过含有如[em:02:]的字符串
 *  @return 富文本String*/
- (NSAttributedString *)createAttributedEmotionStringWithRanges:(NSArray *)ranges forString:(NSString*)aString{
NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:aString];
    helvetica = CTFontCreateWithName(CFSTR("Helvetica"),15, NULL);
    [attrString addAttribute:(id)kCTFontAttributeName value: (id)CFBridgingRelease(helvetica) range:NSMakeRange(0,[attrString.string length])];
[attrString addAttribute:(id)kCTForegroundColorAttributeName value:(id)([UIColor blackColor].CGColor) range:NSMakeRange(0,[attrString length])];
if (_textColor == nil) {
        _textColor = [UIColor blueColor];
    }
for (int i = 0; i < _attributedData.count; i ++) {
        NSString *str = [[[_attributedData objectAtIndex:i] allKeys] objectAtIndex:0];
        [attrString addAttribute:(id)kCTForegroundColorAttributeName value:(id)(_textColor.CGColor) range:NSRangeFromString(str)];
    }
for(NSInteger i = 0; i < [ranges count]; i++){
        NSRange range = NSRangeFromString([ranges objectAtIndex:i]);
        NSString *emotionName = [self.emotionNames objectAtIndex:i];
        [attrString addAttribute:@"ImageName" value:emotionName range:range];
        [attrString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)newEmotionRunDelegate() range:range];
    }
return attrString;
}
// 通过表情名获得表情的图片
- (UIImage *)getEmotionForKey:(NSString *)key{
NSString *nameStr = [NSString stringWithFormat:@"%@",key];
    return [UIImage imageNamed:nameStr];
}
CTRunDelegateRef newEmotionRunDelegate(){
static NSString *emotionRunName = @"emotionRunName";
CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = WFRunDelegateDeallocCallback;
    imageCallbacks.getAscent = WFRunDelegateGetAscentCallback;
    imageCallbacks.getDescent = WFRunDelegateGetDescentCallback;
    imageCallbacks.getWidth = WFRunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks,(__bridge void *)(emotionRunName));
return runDelegate;
}
#pragma mark - Run delegate
void WFRunDelegateDeallocCallback( void* refCon ){
    // CFRelease(refCon);
}
CGFloat WFRunDelegateGetAscentCallback( void *refCon ){
    return 15;
}
CGFloat WFRunDelegateGetDescentCallback(void *refCon){
    return 0.0;
}
CGFloat WFRunDelegateGetWidthCallback(void *refCon){
    // EmotionImageWidth + 2 * ImageLeftPadding
    return  19.0;
}
#pragma mark - 绘制
- (void)drawRect:(CGRect)rect{
    // 没有内容时取消本次绘制
    if (!typesetter)   return;
CGFloat w = CGRectGetWidth(self.frame);
    CGContextRef context = UIGraphicsGetCurrentContext();
UIGraphicsPushContext(context);
// 翻转坐标系
    Flip_Context(context, 15);
CGFloat y = 0;
    CFIndex start = 0;
    NSInteger length = [_attrEmotionString length];
    int tempK = 0;
    while (start < length){
        CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        CGContextSetTextPosition(context, 0, y);
        // 画字
        CTLineDraw(line, context);
        // 画表情
        Draw_Emoji_For_Line(context, line, self, CGPointMake(0, y));
        start += count;
        y -= 15 + 10;
        CFRelease(line);
        tempK ++;
        if (tempK == 4) {
                _limitCharIndex = start;
            //  DLog(@"limitCharIndex = %ld",self.limitCharIndex);
        }
    }
UIGraphicsPopContext();
}
// 翻转坐标系
static inline
void Flip_Context(CGContextRef context, CGFloat offset){// offset为字体的高度
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -offset);
}
// 生成每个表情的 frame 坐标
static inline
CGPoint Emoji_Origin_For_Line(CTLineRef line, CGPoint lineOrigin, CTRunRef run){
    CGFloat x = lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL) + 2;
    CGFloat y = lineOrigin.y - 3;
    return CGPointMake(x, y);
}
// 绘制每行中的表情
void Draw_Emoji_For_Line(CGContextRef context, CTLineRef line, id owner, CGPoint lineOrigin){
    CFArrayRef runs = CTLineGetGlyphRuns(line);
// 统计有多少个run
    NSUInteger count = CFArrayGetCount(runs);
// 遍历查找表情run
    for(NSInteger i = 0; i < count; i++){
        CTRunRef aRun = CFArrayGetValueAtIndex(runs, i);
        CFDictionaryRef attributes = CTRunGetAttributes(aRun);
        NSString *emojiName = (NSString *)CFDictionaryGetValue(attributes, @"ImageName");
        if (emojiName){
            // 画表情
            CGRect imageRect = CGRectZero;
            imageRect.origin = Emoji_Origin_For_Line(line, lineOrigin, aRun);
            imageRect.size = CGSizeMake(15, 15);
            CGImageRef img = [[owner getEmotionForKey:emojiName] CGImage];
            CGContextDrawImage(context, imageRect, img);
        }
    }
}
- (float)getTextHeight{
CGFloat w = CGRectGetWidth(self.frame);
    CGFloat y = 0;
    CFIndex start = 0;
    NSInteger length = [_attrEmotionString length];
    int tempK = 0;
    while (start < length){
        CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        start += count;
        y -= 15 + 10;
        CFRelease(line);
        tempK++;
        if (tempK == 4  && _isFold == YES) {
                break;
        }
    }
return -y;
}
#pragma mark - 获得行数
- (int)getTextLines{
int textlines = 0;
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat y = 0;
    CFIndex start = 0;
    NSInteger length = [_attrEmotionString length];
while (start < length){
        CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        start += count;
        y -= 15 + 10;
        CFRelease(line);
        textlines ++;
    }
    return textlines;
}
- (void)manageGesture:(UIGestureRecognizer *)gesture gestureType:(GestureType)gestureType{
CGPoint point = [gesture locationInView:self];
CGFloat w = CGRectGetWidth(self.frame);
    CGFloat y = 0;
    CFIndex start = 0;
    NSInteger length = [_newString length];
BOOL isSelected = NO;//判断是否点到selectedRange内 默认没点到
while (start < length){
        CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        CGFloat ascent, descent;
        CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
        CGRect lineFrame = CGRectMake(0, -y, lineWidth, ascent + descent);
        if (CGRectContainsPoint(lineFrame, point)) { //没进此判断 说明没点到文字 ，点到了文字间距处
                CFIndex index = CTLineGetStringIndexForPosition(line, point);
            if ([self judgeIndexInSelectedRange:index withWorkLine:line] == YES) {//点到selectedRange内
                        isSelected = YES;
                    }else{
                //点在了文字上 但是不在selectedRange内
                    }
        }
        start += count;
        y -= 15 + 10;
        CFRelease(line);
    }
if (isSelected == YES) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_selectionsViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    });
        return;
    }else{
        if (gestureType == TapGesType) {
            if (_canClickAll == YES) {
                [self clickAllContext];
            }
        }else{
            if (_canClickAll == YES) {
                [self longClickAllContext];
            }
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_selectionsViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    });
}
#pragma mark - 长按自己
- (void)longPressMyself:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self manageGesture:gesture gestureType:LongGesType];
    }
if (gesture.state == UIGestureRecognizerStateEnded) {
        [self removeLongClickArea];
    }
}
#pragma mark -点击自己
- (void)tapMyself:(UITapGestureRecognizer *)gesture{
[self manageGesture:gesture gestureType:TapGesType];
}
- (BOOL)judgeIndexInSelectedRange:(CFIndex) index withWorkLine:(CTLineRef)workctLine{
for (int i = 0; i < _attributedData.count; i ++) {
        NSString *key = [[[_attributedData objectAtIndex:i] allKeys] objectAtIndex:0];
        NSRange keyRange = NSRangeFromString(key);
        if (index>=keyRange.location && index<= keyRange.location + keyRange.length) {
            if (_isFold) {
                if ((_limitCharIndex > keyRange.location) && (_limitCharIndex < keyRange.location + keyRange.length)){
        keyRange = NSMakeRange(keyRange.location, _limitCharIndex - keyRange.location);
                }
            }else{
                //Do nothing
            }
        NSMutableArray *arr = [self getSelectedCGRectWithClickRange:keyRange];
            [self drawViewFromRects:arr withDictValue:[[_attributedData objectAtIndex:i] valueForKey:key]];
                NSString *feedString = [[_attributedData objectAtIndex:i] valueForKey:key];
            self.didClickCoreText(feedString, _replyIndex, NO);
            return YES;
        }
    }
return NO;
}
- (NSMutableArray *)getSelectedCGRectWithClickRange:(NSRange)tempRange{
NSMutableArray *clickRects = [[NSMutableArray alloc] init];
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat y = 0;
    CFIndex start = 0;
    NSInteger length = [_attrEmotionString length];
while (start < length){
        CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        start += count;
        CFRange lineRange = CTLineGetStringRange(line);
        NSRange range = NSMakeRange(lineRange.location==kCFNotFound ? NSNotFound : lineRange.location, lineRange.length);
        NSRange intersection = [self rangeIntersection:range withSecond:tempRange];
        if (intersection.length > 0){
                CGFloat xStart = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);//获取整段文字中charIndex位置的字符相对line的原点的x值
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, intersection.location + intersection.length, NULL);
                CGFloat ascent, descent;
            //,leading;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CGRect selectionRect = CGRectMake(xStart, -y, xEnd -  xStart , ascent + descent + 2);//所画选择之后背景的 大小 和起始坐标 2为微调
            [clickRects addObject:NSStringFromCGRect(selectionRect)];
            }
        y -= 15 + 10;
        CFRelease(line);
    }
    return clickRects;
    
}
//超出1行 处理
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
- (void)drawViewFromRects:(NSArray *)array withDictValue:(NSString *)value{
    //用户名可能超过1行的内容 所以记录在数组里，有多少元素 就有多少view
    // selectedViewLinesF = array.count;
for (int i = 0; i < [array count]; i++) {
        UIView *selectedView = [[UIView alloc] init];
        selectedView.frame = CGRectFromString([array objectAtIndex:i]);
        selectedView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        selectedView.layer.cornerRadius = 4;
        [self addSubview:selectedView];
        [_selectionsViews addObject:selectedView];
    }
    
}
- (void)clickAllContext{
UIView *myselfSelected = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    myselfSelected.tag = 10102;
    [self insertSubview:myselfSelected belowSubview:self];
    myselfSelected.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.didClickCoreText(@"", _replyIndex, NO);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self viewWithTag:10102]) {
            [[self viewWithTag:10102] removeFromSuperview];
        }
    });
}
- (void)longClickAllContext{
UIView *myselfSelected = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    myselfSelected.tag = 10102;
    [self insertSubview:myselfSelected belowSubview:self];
    myselfSelected.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    if (_replyIndex == -1) {
        self.didClickCoreText(_oldString, _replyIndex, YES);
    }else{
        self.didClickCoreText(@"", _replyIndex, YES);
    }
}
- (void)removeLongClickArea{
    if ([self viewWithTag:10102]) {
        [[self viewWithTag:10102] removeFromSuperview];
    }
    [WFHudView showMsg:@"复制成功" inView:nil];
}
@end
@implementation WFMessageBody
@end
@implementation WFReplyBody
@end
@implementation YMTextData{
    NSInteger typeview;
    int tempInt;
}
+ (NSArray *)itemIndexesWithPattern:(NSString *)pattern inString:(NSString *)findingString{
    NSAssert(pattern != nil, @"%s: pattern 不可以为 nil", __PRETTY_FUNCTION__);
    NSAssert(findingString != nil, @"%s: findingString 不可以为 nil", __PRETTY_FUNCTION__);
    NSError *error = nil;
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:
                                   pattern options:NSRegularExpressionCaseInsensitive error:&error];
    // 查找匹配的字符串
    NSArray *result = [regExp matchesInString:findingString options:
                       NSMatchingReportCompletion range:
                       NSMakeRange(0, [findingString length])];
    if (error) {
        //  DLog(@"ERROR: %@", result);
        return nil;
    }
    NSUInteger count = [result count];
    // 没有查找到结果，返回空数组
    if (0 == count) {
        return [NSArray array];
    }
    // 将返回数组中的 NSTextCheckingResult 的实例的 range 取出生成新的 range 数组
    NSMutableArray *ranges = [[NSMutableArray alloc] initWithCapacity:count];
    for(NSInteger i = 0; i < count; i++){
        @autoreleasepool {
            NSRange aRange = [[result objectAtIndex:i] range];
            [ranges addObject:[NSValue valueWithRange:aRange]];
        }
    }
    return ranges;
}
- (id)init{
    self = [super init];
    if (self) {
        self.completionReplySource = [[NSMutableArray alloc] init];
        self.attributedDataReply = [[NSMutableArray alloc] init];
        self.attributedDataShuoshuo = [[NSMutableArray alloc] init];
        self.attributedDataFavour = [[NSMutableArray alloc] init];
        _foldOrNot = YES;
        _islessLimit = NO;
    }
    return self;
}
- (void)setMessageBody:(WFMessageBody *)messageBody{
    _messageBody = messageBody;
    _showImageArray = messageBody.posterPostImage;
    _foldOrNot = YES;
    _showShuoShuo = messageBody.posterContent;
    _defineAttrData = [self findAttrWith:messageBody.posterReplies];
    _replyDataSource = messageBody.posterReplies;
    _favourArray = messageBody.posterFavour;
    _hasFavour = messageBody.isFavour;
}
- (NSMutableArray *)findAttrWith:(NSMutableArray *)replies{
NSMutableArray *feedBackArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < replies.count; i++) {
        WFReplyBody *replyBody = (WFReplyBody *)[replies objectAtIndex:i];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        if ([replyBody.repliedUser isEqualToString:@""]) {
                NSString *range = NSStringFromRange(NSMakeRange(0, replyBody.replyUser.length));
            [tempArr addObject:range];
            }else{
            NSString *range1 = NSStringFromRange(NSMakeRange(0, replyBody.replyUser.length));
            NSString *range2 = NSStringFromRange(NSMakeRange(replyBody.replyUser.length + 2, replyBody.repliedUser.length));
            [tempArr addObject:range1];
            [tempArr addObject:range2];
        }
        [feedBackArray addObject:tempArr];
    }
    return feedBackArray;
    
}
- (NSString *)replaceCharacters:(NSString*)str AtIndexes:(NSArray *)indexes withString:(NSString *)aString{
    NSAssert(indexes != nil, @"%s: indexes 不可以为nil", __PRETTY_FUNCTION__);
    NSAssert(aString != nil, @"%s: aString 不可以为nil", __PRETTY_FUNCTION__);
    NSUInteger offset = 0;
    NSMutableString *raw = [str mutableCopy];
    NSInteger prevLength = 0;
    for(NSInteger i = 0; i < [indexes count]; i++){
        @autoreleasepool {
            NSRange range = [[indexes objectAtIndex:i] rangeValue];
            prevLength = range.length;
            range.location -= offset;
            [raw replaceCharactersInRange:range withString:aString];
            offset = offset + prevLength - [aString length];
        }
    }
    return raw;
}
- (float)calculateFavourHeightWithWidth:(float)sizeWidth{
typeview = 1;
    float height = .0f;
NSString *matchString = [_favourArray componentsJoinedByString:@","];
    _showFavour = matchString;
    NSArray *itemIndexs = [YMTextData itemIndexesWithPattern:@"\\[em:(\\d+):\\]" inString:matchString];
    NSString *newString = [self replaceCharacters:matchString AtIndexes:itemIndexs withString:PlaceHolder];
    //存新的
    self.completionFavour = newString;
[self matchString:newString fromView:typeview];
WFTextView *_wfcoreText = [[WFTextView alloc] initWithFrame:CGRectMake(20 + 30,10, sizeWidth - 2*20 - 30, 0)];
_wfcoreText.isFold = NO;
    _wfcoreText.isDraw = NO;
[_wfcoreText setOldString:_showFavour andNewString:newString];
return [_wfcoreText getTextHeight];
return height;
}
//计算replyview高度
- (float) calculateReplyHeightWithWidth:(float)sizeWidth{
typeview = 2;
    float height = .0f;
for (int i = 0; i < self.replyDataSource.count; i ++ ) {
        tempInt = i;
        WFReplyBody *body = (WFReplyBody *)[self.replyDataSource objectAtIndex:i];
        NSString *matchString;
        if ([body.repliedUser isEqualToString:@""]) {
            matchString = [NSString stringWithFormat:@"%@:%@",body.replyUser,body.replyInfo];
            }else{
            matchString = [NSString stringWithFormat:@"%@回复%@:%@",body.replyUser,body.repliedUser,body.replyInfo];
            }
        NSArray *itemIndexs = [YMTextData itemIndexesWithPattern:@"\\[em:(\\d+):\\]" inString:matchString];
    NSString *newString = [self replaceCharacters:matchString AtIndexes:itemIndexs withString:PlaceHolder];
        //存新的
        [self.completionReplySource addObject:newString];
        [self matchString:newString fromView:typeview];
        WFTextView *_ilcoreText = [[WFTextView alloc] initWithFrame:CGRectMake(20,10, sizeWidth - 20 * 2, 0)];
        _ilcoreText.isFold = NO;
        _ilcoreText.isDraw = NO;
        [_ilcoreText setOldString:matchString andNewString:newString];
        height =  height + [_ilcoreText getTextHeight] + 5;
    }
[self calculateShowImageHeight];
return height;
    
}
//图片高度
- (void)calculateShowImageHeight{
if (self.showImageArray.count == 0) {
        self.showImageArray = 0;
    }else{
        self.showImageHeight = (80 + 10) * ((self.showImageArray.count - 1)/3 + 1);
    }
    
}
- (NSMutableArray *)matchMobileLink:(NSString *)pattern{
    NSMutableArray *linkArr = [NSMutableArray arrayWithCapacity:0];
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(\\(86\\))?(13[0-9]|15[0-35-9]|18[0125-9])\\d{8}" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray* array=[regular matchesInString:pattern options:0 range:NSMakeRange(0, [pattern length])];
    for( NSTextCheckingResult * result in array){
        NSString * string=[pattern substringWithRange:result.range];
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:string,NSStringFromRange(result.range), nil];
        [linkArr addObject:dic];
    }
    return linkArr;
}
- (NSMutableArray *)matchWebLink:(NSString *)pattern{
    NSMutableArray *linkArr = [NSMutableArray arrayWithCapacity:0];
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray* array=[regular matchesInString:pattern options:0 range:NSMakeRange(0, [pattern length])];
    for( NSTextCheckingResult * result in array){
        NSString * string=[pattern substringWithRange:result.range];
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:string,NSStringFromRange(result.range), nil];
        [linkArr addObject:dic];
    }
    // DLog(@"linkArr == %@",linkArr);
    return linkArr;
}
- (void)matchString:(NSString *)dataSourceString fromView:(NSInteger) isReplyV{
if (isReplyV == 2) {
        NSMutableArray *totalArr = [NSMutableArray arrayWithCapacity:0];
        //**********号码******
        NSMutableArray *mobileLink = [self matchMobileLink:dataSourceString];
        for (int i = 0; i < mobileLink.count; i ++) {
                [totalArr addObject:[mobileLink objectAtIndex:i]];
        }
        //*************************
        //***********匹配网址*********
        NSMutableArray *webLink = [self matchWebLink:dataSourceString];
        for (int i = 0; i < webLink.count; i ++) {
                [totalArr addObject:[webLink objectAtIndex:i]];
        }
        //******自行添加**********
        if (_defineAttrData.count != 0) {
            NSArray *tArr = [_defineAttrData objectAtIndex:tempInt];
            for (int i = 0; i < [tArr count]; i ++) {
                NSString *string = [dataSourceString substringWithRange:NSRangeFromString([tArr objectAtIndex:i])];
                [totalArr addObject:[NSDictionary dictionaryWithObject:string forKey:NSStringFromRange(NSRangeFromString([tArr objectAtIndex:i]))]];
            }
            }
        //***********************
        [self.attributedDataReply addObject:totalArr];
    }
if(isReplyV == 0){
        [self.attributedDataShuoshuo removeAllObjects];
        //**********号码******
        NSMutableArray *mobileLink = [self matchMobileLink:dataSourceString];
        for (int i = 0; i < mobileLink.count; i ++) {
                [self.attributedDataShuoshuo addObject:[mobileLink objectAtIndex:i]];
        }
        //*************************
        //***********匹配网址*********
        NSMutableArray *webLink = [self matchWebLink:dataSourceString];
        for (int i = 0; i < webLink.count; i ++) {
                [self.attributedDataShuoshuo addObject:[webLink objectAtIndex:i]];
        }
    }
if (isReplyV == 1) {
        [self.attributedDataFavour removeAllObjects];
        int originX = 0;
        for (int i = 0; i < _favourArray.count; i ++) {
            NSString *text = [_favourArray objectAtIndex:i];
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:text,NSStringFromRange(NSMakeRange(originX, text.length)), nil];
            [self.attributedDataFavour addObject:dic];
            originX += (1 + text.length);
        }
    }
}
//说说高度
- (float) calculateShuoshuoHeightWithWidth:(float)sizeWidth withUnFoldState:(BOOL)isUnfold{
typeview = 0;
NSString *matchString =  _showShuoShuo;
NSArray *itemIndexs = [YMTextData itemIndexesWithPattern:@"\\[em:(\\d+):\\]" inString:matchString];
//用PlaceHolder 替换掉[em:02:]这些
    NSString *newString = [self replaceCharacters:matchString AtIndexes:itemIndexs withString:PlaceHolder];
    //存新的
    self.completionShuoshuo = newString;
[self matchString:newString fromView:typeview];
WFTextView *_wfcoreText = [[WFTextView alloc] initWithFrame:CGRectMake(20,10, sizeWidth - 2*20, 0)];
_wfcoreText.isDraw = NO;
[_wfcoreText setOldString:_showShuoShuo andNewString:newString];
if ([_wfcoreText getTextLines] <= 4) {
        self.islessLimit = YES;
    }else{
        self.islessLimit = NO;
    }
if (!isUnfold) {
        _wfcoreText.isFold = YES;
    }else{
        _wfcoreText.isFold = NO;
    }
    return [_wfcoreText getTextHeight];
    
}
@end
