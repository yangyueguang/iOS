//  NSObject+Freedom.m
//  Freedom
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>
#include <string.h>
#import <objc/runtime.h>
@implementation RCUnderlineTextField
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:161 green:163 blue:168 alpha:0.2f].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextBeginPath(context);
    CGFloat baselineOffset = 45.0f;
    CGContextMoveToPoint(context, self.bounds.origin.x, baselineOffset);
    CGContextAddLineToPoint(context, self.bounds.size.width - 10, baselineOffset);
    CGContextClosePath(context);
    CGContextStrokePath(context);
}
@end
@implementation UIView (Freedom)
- (CGFloat)frameHeight {
    return self.frame.size.height;
}
- (void)setFrameHeight:(CGFloat)newHeight {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            self.frame.size.width, newHeight);
}
- (CGFloat)frameX {
    return self.frame.origin.x;
}
- (void)setFrameX:(CGFloat)newX {
    self.frame = CGRectMake(newX, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}
- (CGFloat)frameY {
    return self.frame.origin.y;
}
- (void)setFrameY:(CGFloat)newY {
    self.frame = CGRectMake(self.frame.origin.x, newY,
                            self.frame.size.width, self.frame.size.height);
}
- (void)shake{
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:0.5f];
    CGFloat x = self.center.x;
    CGFloat y = self.center.y;
    CGFloat xarray[10] = {x,x-5,x+5,x,x-5,x+5,x,x-5,x+5,x};
    NSMutableArray *array = [NSMutableArray array];
    int lenth = sizeof(xarray)/sizeof(CGFloat);
    for(int i = 0;i<lenth;i++){
        CGFloat a = xarray[i];
        [array addObject:[NSValue valueWithCGPoint:CGPointMake(a, y)]];
    }
    [keyAn setValues:array];
    NSArray *times = [[NSArray alloc] initWithObjects:@0.1f,@0.2f,@0.3f,@0.4f,@0.5f,@0.6f,@0.7f,@0.8f,@0.9f,@1.0f, nil];
    [keyAn setKeyTimes:times];
    [self.layer addAnimation:keyAn forKey:@"Shark"];
}
- (UIImage *)imageFromView {
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
-(void)linearColorFromcolors:(NSArray<UIColor *> *)colors{
    [self linearColorFromcolors:colors isHorizantal:YES];
}
-(void)linearColorFromcolors:(NSArray<UIColor*>*)colors isHorizantal:(BOOL)hor{
    if(colors.count < 2){
        self.backgroundColor = colors.firstObject;
        return;
    }
    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
    NSMutableArray *locations = [NSMutableArray arrayWithCapacity:colors.count];
    CGFloat lenth = 1.0 / (colors.count - 1);
    for(int i = 0;i < colors.count;i++){
        [locations addObject:[NSNumber numberWithFloat:i * lenth]];
        UIColor *color = colors[i];
        [cgColors addObject:(id)color.CGColor];
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = cgColors;
    if(hor){
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 1);
    }else{
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(0, 0);
    }
    gradientLayer.locations = locations;
    [self.layer addSublayer:gradientLayer];
}
-(UIImage*)gotCircleLinearFromColors:(NSArray<UIColor*> *)colors{
    CGRect rect = self.bounds;
    CGAffineTransform ra = CGAffineTransformMakeScale(1, 1);
    CGPathRef path = CGPathCreateWithRect(rect,&ra);
    // 绘制渐变层
    {
        NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
        for(UIColor *co in colors){
            [cgColors addObject:(id)co.CGColor];
        }
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)cgColors, NULL);
        CGRect pathRect = CGPathGetBoundingBox(path);
        CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
        CGFloat radius = MAX(pathRect.size.width / 2.0, pathRect.size.height / 2.0) * sqrt(2);
        CGContextSaveGState(context);
        CGContextAddPath(context, path);
        CGContextClip(context);
        CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, kCGGradientDrawsBeforeStartLocation);
        CGContextRestoreGState(context);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    }
    CGPathRelease(path);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(void)linearTextColorFromSuperView:(UIView *)bgView colors:(NSArray<UIColor*> *)colors{
    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
    for(UIColor *co in colors){
        [cgColors addObject:(id)co.CGColor];
    }
    CAGradientLayer* gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = self.frame;
    gradientLayer1.colors = cgColors;
    gradientLayer1.startPoint = CGPointMake(0, 0);
    gradientLayer1.endPoint = CGPointMake(1, 0);
    [bgView.layer addSublayer:gradientLayer1];
    gradientLayer1.mask = self.layer;
    self.frame = gradientLayer1.bounds;
}
@end
@implementation UIViewController (DismissKeyboard)
-(void)showAlerWithtitle:(NSString*)t message:(NSString*)m style:(UIAlertControllerStyle)style ac1:(UIAlertAction* (^)(void))ac1 ac2:(UIAlertAction* (^)(void))ac2 ac3:(UIAlertAction* (^)(void))ac3 completion:(void(^)())completion{
    UIAlertController *alvc = [UIAlertController alertControllerWithTitle:t message:m preferredStyle:style];
    [alvc addAction:ac1()];
    if(ac2){
        [alvc addAction:ac2()];
    }
    if(ac3){
        UIAlertAction *ac = ac3();
        [alvc addAction:ac];
        if(ac.style != UIAlertActionStyleCancel){
            [alvc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        }
    }
    [self presentViewController:alvc animated:YES completion:completion];
}
- (void)setupForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    __weak UIViewController *weakSelf = self;
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification object:nil queue:mainQuene usingBlock:^(NSNotification *note){
        [weakSelf.view addGestureRecognizer:singleTapGR];
    }];
    [nc addObserverForName:UIKeyboardWillHideNotification object:nil queue:mainQuene usingBlock:^(NSNotification *note){
        [weakSelf.view removeGestureRecognizer:singleTapGR];
    }];
}
- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}
@end
@implementation NSObject (Freedom)
//获取对象的所有属性，不包括属性值
- (NSArray *)getAllProperties{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++){
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject:[NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}
//获取对象的所有属性及属性类型
- (NSDictionary*)propertiesDictionary{
    if (self == NULL){return nil;}
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        const char *realType = getPropertyType(property);
        NSLog(@"属性名：%s 属性类型：%s", propName, realType);
        [results setObject:[NSString stringWithUTF8String:realType] forKey:[NSString stringWithUTF8String:propName]];
    }
    free(properties);
    return [NSDictionary dictionaryWithDictionary:results];
}
static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);//获取属性描述字符串
    char *type;
    if (attributes[1] == '@') {//对象数据类型
        char buffer[1 + strlen(attributes)];
        strcpy(buffer, attributes);
        char *state = buffer;
        char *attribute = strsep(&state, ",");
        NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
        type = (char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
    }else{//普通数据类型
        const char *t = [[[[NSString stringWithUTF8String:attributes]componentsSeparatedByString:@","][0]substringFromIndex:1]UTF8String];
        if (strcmp(t, @encode(char)) == 0) {
            type = "char";
        } else if (strcmp(t, @encode(int)) == 0) {
            type = "int";
        } else if (strcmp(t, @encode(short)) == 0) {
            type = "short";
        } else if (strcmp(t, @encode(long)) == 0) {
            type = "long";
        } else if (strcmp(t, @encode(long long)) == 0) {
            type = "long long";
        } else if (strcmp(t, @encode(unsigned char)) == 0) {
            type = "unsigned char";
        } else if (strcmp(t, @encode(unsigned int)) == 0) {
            type = "unsigned int";
        } else if (strcmp(t, @encode(unsigned short)) == 0) {
            type = "unsigned short";
        } else if (strcmp(t, @encode(unsigned long)) == 0) {
            type = "unsigned long";
        } else if (strcmp(t, @encode(unsigned long long)) == 0) {
            type = "unsigned long long";
        } else if (strcmp(t, @encode(float)) == 0) {
            type = "float";
        } else if (strcmp(t, @encode(double)) == 0) {
            type = "double";
        } else if (strcmp(t, @encode(_Bool)) == 0 || strcmp(t, @encode(bool)) == 0) {
            type = "BOOL";
        } else if (strcmp(t, @encode(void)) == 0) {
            type = "void";
        } else if (strcmp(t, @encode(char *)) == 0) {
            type = "char *";
        } else if (strcmp(t, @encode(id)) == 0) {
            type = "id";
        } else if (strcmp(t, @encode(Class)) == 0) {
            type = "Class";
        } else if (strcmp(t, @encode(SEL)) == 0) {
            type = "SEL";
        } else {
            type = "";
        }
    }
    return type;
}

//获取类的属性的数据类型
- (const char*)findPropertyTypeWithName:(NSString*)name{
    const char * propertyName = name.UTF8String;
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *property_name = property_getName(property);
        if (strcmp(property_name, propertyName) == 0) {//找到了对应的属性
            return getPropertyType(property);
        }
    }
    return nil;
}
//获取对象的所有方法
- (NSArray*)getMothList{
    unsigned int mothCout_f =0;
    NSMutableArray *meths = [NSMutableArray array];
    Method* mothList_f = class_copyMethodList([self class],&mothCout_f);
    for(int i=0;i<mothCout_f;i++){
        Method temp_f = mothList_f[i];
        //        IMP imp_f = method_getImplementation(temp_f);
        //        imp_f();
        SEL name_f = method_getName(temp_f);
        const char* name_s =sel_getName(name_f);
        int arguments = method_getNumberOfArguments(temp_f);
        //        const char* encoding =method_getTypeEncoding(temp_f);
        //        SEL nas = NSSelectorFromString([NSString stringWithUTF8String:name_s]);
        [meths addObject:[NSString stringWithUTF8String:name_s]];
        NSLog(@"方法名：%@ 参数个数：%d",NSStringFromSelector(name_f),arguments);
    }
    free(mothList_f);
    return [NSArray arrayWithArray:meths];
}
@end
@implementation UIImage (Freedom)

+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return theImage;
}

@end
char * const UIBarButtonItemActionBlock = "UIBarButtonItemActionBlock";

@implementation UIBarButtonItem (expanded)
- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style actionBlick:(BarButtonActionBlock)actionBlock{
    if (self = [self initWithTitle:title style:style target:nil action:nil]) {
        [self setActionBlock:actionBlock];
    }
    return self;
}
- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style actionBlick:(BarButtonActionBlock)actionBlock{
    if (self = [self initWithImage:image style:style target:nil action:nil]) {
        [self setActionBlock:actionBlock];
    }
    return self;
}
- (id)initWithBackTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIButton *view = [[UIButton alloc] init];
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_back"]];
    [view addSubview:imageView];
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label setTextColor:[UIColor whiteColor]];
    [view addSubview:label];
    if (self = [self initWithCustomView:view]) {
        [imageView setFrame:CGRectMake(0, 0, 17, 34)];
        CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        [label setFrame:CGRectMake(17, 0, size.width, 34)];
        [view setFrame:CGRectMake(0, 0, label.frame.origin.x+label.frame.size.width, 34)];
    }
    return self;
}
- (void)performActionBlock {
    dispatch_block_t block = self.actionBlock;
    if (block)block();
}
- (BarButtonActionBlock)actionBlock {
    return objc_getAssociatedObject(self, UIBarButtonItemActionBlock);
}
- (void)setActionBlock:(BarButtonActionBlock)actionBlock{
    if (actionBlock != self.actionBlock) {
        [self willChangeValueForKey:@"actionBlock"];
        objc_setAssociatedObject(self,UIBarButtonItemActionBlock,
                                 actionBlock,OBJC_ASSOCIATION_COPY);
        [self setTarget:self];
        [self setAction:@selector(performActionBlock)];
        [self didChangeValueForKey:@"actionBlock"];
    }
}
@end

@implementation UINavigationBar (expanded)
static char kBackgroundViewKey;
- (UIView*)backgroundView{
    return objc_getAssociatedObject(self, &kBackgroundViewKey);
}
- (void)setBackgroundView:(UIView*)backgroundView{
    objc_setAssociatedObject(self, &kBackgroundViewKey, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)wr_setBackgroundColor:(UIColor *)color{
    if (self.backgroundView == nil){
        // 设置导航栏本身全透明
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height)];
        // _UIBarBackground是导航栏的第一个子控件
        [self.subviews.firstObject insertSubview:self.backgroundView atIndex:0];
        // 隐藏导航栏底部默认黑线
        [self setShadowImage:[UIImage new]];
    }
    self.backgroundView.backgroundColor = color;
}
- (void)wr_setBackgroundAplha:(CGFloat)alpha{
    if (self.backgroundView != nil) {
        self.backgroundView.alpha = alpha;
    }
}
- (void)wr_setBarButtonItemsAlpha:(CGFloat)alpha hasSystemBackIndicator:(BOOL)hasSystemBackIndicator{
    for (UIView *view in self.subviews){
        if (hasSystemBackIndicator == YES){
            // _UIBarBackground对应的view是系统导航栏，不需要改变其透明度
            if (![view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                view.alpha = alpha;
            }
        }else{
            // 这里如果不做判断的话，会显示 backIndicatorImage
            if (![view isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")] && ![view isKindOfClass:NSClassFromString(@"_UIBarBackground")]){
                view.alpha = alpha;
            }
        }
    }
}
- (void)wr_setTranslationY:(CGFloat)translationY{
    // CGAffineTransformMakeTranslation  平移
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}
- (void)wr_clear{
    // 设置导航栏不透明
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

@end


#import <CommonCrypto/CommonDigest.h>
@implementation NSString(expanded)
- (NSString*) urlEncodedString {
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}
- (NSString*) urlDecodedString {
    return [self stringByRemovingPercentEncoding];
}

- (BOOL)notEmptyOrNull{
    if ([self isEqualToString:@""]||[self isEqualToString:@"null"] || [self isEqualToString:@"\"\""] || [self isEqualToString:@"''"]) {
        return NO;
    }
    return YES;
}

- (NSString *)md5{
    const char *concat_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, (unsigned int)strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];

}
#pragma mark 计算字符串大小
- (CGSize)sizeOfFont:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize;
}
- (NSString *) pinyin{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSDictionary *)dictionaryFromURLParameters{
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1] stringByRemovingPercentEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

- (NSString *)emoji{
    char *charCode = (char *)self.UTF8String;
    int intCode = (int)strtol(charCode, NULL, 16);
    int symbol = ((((0x808080F0 | (intCode & 0x3F000) >> 4) | (intCode & 0xFC0) << 10) | (intCode & 0x1C0000) << 18) | (intCode & 0x3F) << 24);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    if (string == nil) { // 新版Emoji
        string = [NSString stringWithFormat:@"%C", (unichar)intCode];
    }
    return string;
}
// 判断是否是 emoji表情
- (BOOL)isEmoji{
    BOOL returnValue = NO;
    const unichar hs = [self characterAtIndex:0];
    // surrogate pair
    if (0xd800 <= hs && hs <= 0xdbff) {
        if (self.length > 1) {
            const unichar ls = [self characterAtIndex:1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f) {
                returnValue = YES;
            }
        }
    } else if (self.length > 1) {
        const unichar ls = [self characterAtIndex:1];
        if (ls == 0x20e3) {
            returnValue = YES;
        }
    } else {
        // non surrogate
        if (0x2100 <= hs && hs <= 0x27ff) {
            returnValue = YES;
        } else if (0x2B05 <= hs && hs <= 0x2b07) {
            returnValue = YES;
        } else if (0x2934 <= hs && hs <= 0x2935) {
            returnValue = YES;
        } else if (0x3297 <= hs && hs <= 0x3299) {
            returnValue = YES;
        } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
            returnValue = YES;
        }
    }

    return returnValue;
}
- (CGSize)sizeOfFont:(UIFont *)font maxW:(CGFloat)maxW{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (CGSize)sizeOfFont:(UIFont *)font{
    return [self sizeOfFont:font maxW:MAXFLOAT];
}


- (NSArray *)matchesWithPattern:(NSString *)pattern{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:&error];
    if (error) {
        NSLog(@"匹配方案错误:%@", error.localizedDescription);
        return nil;
    }
    return [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
}


-(NSString*)deleteSpace{
    NSMutableString *allStr = [self mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)allStr);
    return allStr;
}


@end

@implementation NSDate (expanded)
/*计算这个月的第一天是礼拜几*/
- (NSUInteger)weeklyOrdinality{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:self];
}
//获取年月日对象
- (NSDateComponents *)YMDComponents{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal fromDate:self];
}

//通过数字返回星期几
-(NSString *)getWeekString{
    NSString *str_week;
    int a = self.YMDComponents.weekday;
    switch (a) {
        case 1:str_week = @"周日";break;
        case 2:str_week = @"周一";break;
        case 3:str_week = @"周二";break;
        case 4:str_week = @"周三";break;
        case 5:str_week = @"周四";break;
        case 6:str_week = @"周五";break;
        case 7:str_week = @"周六";break;
    }
    return str_week;
}
-(NSString *)timeToNow{
    NSString *timeString = @"";
    NSTimeInterval late=[self timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha=(now-late)>0 ? (now-late) : 0;
    if (cha/60<1) {
        timeString=@"刚刚";
    }else if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ 分前", timeString];
    }else if (cha/3600>1 && cha/3600<12) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ 小时前", timeString];
    }else if(cha/3600<24){
        timeString = @"今天";
    }else if(cha/3600<48){
        timeString = @"昨天";
    }else if(cha/3600/24<10){
        timeString = [NSString stringWithFormat:@"%.0f 天前",cha/3600/24];
    }else if(cha/3600/24<365){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM月dd日"];
        timeString=[dateFormatter stringFromDate:self];
    }else{
        timeString = [NSString stringWithFormat:@"%d年前",(int)cha/3600/24/365];
    }
    return timeString;
}

- (BOOL) isInFuture{
    return ([self compare:[NSDate date]] == NSOrderedDescending);

}
- (BOOL)isInPast{
    return ([self compare:[NSDate date]] == NSOrderedAscending);
}

- (BOOL) isToday{
    NSDateComponents *components1 = [self YMDComponents];
    NSDateComponents *components2 = [[NSDate date]YMDComponents];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}
@end
@implementation UIView(Addition)
-(BOOL) containsSubView:(UIView *)subView{
    for (UIView *view in [self subviews]) {
        if ([view isEqual:subView]) {
            return YES;
        }
    }
    return NO;
}
-(BOOL) containsSubViewOfClassType:(Class)aclass {
    for (UIView *view in [self subviews]) {
        if ([view isMemberOfClass:aclass]) {
            return YES;
        }
    }
    return NO;
}

-(void)bestRoundCorner{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.bounds.size];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.frame = self.bounds;
    layer.path = path.CGPath;
    self.layer.mask = layer;
}

-(void)addSubviews:(UIView *)view,...{
    [self addSubview:view];
    va_list ap;
    va_start(ap, view);
    UIView *akey=va_arg(ap,id);
    while (akey) {
        [self addSubview:akey];
        akey=va_arg(ap,id);
    }
    va_end(ap);
}

-(void)imageWithURL:(NSString *)url useProgress:(BOOL)useProgress useActivity:(BOOL)useActivity defaultImage:(NSString *)strImage{
    if ([self isKindOfClass:[UIImageView class]]) {
        UIView *tempView = nil;
        UIImageView *imgView = (UIImageView *)self;
        if (![strImage isEqualToString:@""]&&![strImage isEqualToString:@"null"]&&![strImage isEqualToString:@"\"\""] &&![strImage isEqualToString:@"''"]) {
            imgView.image=[UIImage imageNamed:strImage];
        }
        if ([url isEqualToString:@""]||[url isEqualToString:@"null"] || [url isEqualToString:@"\"\""] || [url isEqualToString:@"''"]) {
            return;
        }
        if (useProgress) {
            CGFloat width = self.frame.size.width *0.8;
            CGFloat fX = (self.frame.size.width - width)/2.0;
            CGFloat fY = self.frame.size.height/2.0 - 10;
            UIProgressView *progressIndicator = [[UIProgressView alloc] initWithFrame:CGRectMake(fX, fY, width, 20)];
            [progressIndicator setProgressViewStyle:UIProgressViewStyleBar];
            //            [progressIndicator setProgressTintColor:[UIColor grayColor]];
            [progressIndicator setProgressTintColor:[UIColor colorWithRed:0 green:97 blue:167 alpha:1]];
            [progressIndicator setTrackTintColor:[UIColor grayColor]];
            tempView = progressIndicator;
            progressIndicator.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
        }else if (useActivity){
            UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [activityIndicatorView setCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0)];
            [activityIndicatorView startAnimating];
            tempView = activityIndicatorView;
            activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        }
        [self addSubview:tempView];
    }
}

@end
@implementation UIColor (Extention)
+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}
@end
