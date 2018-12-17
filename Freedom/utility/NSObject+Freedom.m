//  NSObject+Freedom.m
//  Freedom
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import "NSObject+Freedom.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>
#include <string.h>
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>

@implementation UIView (Freedom)
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
@end

char * const UIBarButtonItemActionBlock = "UIBarButtonItemActionBlock";

@implementation UIBarButtonItem (expanded)
- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style actionBlick:(BarButtonActionBlock)actionBlock{
    if (self = [self initWithTitle:title style:style target:nil action:nil]) {
        [self setActionBlock:actionBlock];
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

@implementation NSString(expanded)
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

- (NSString *)pinyin{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString*)pinyinFirstLetter {
    NSString *pinyin = self.pinyin;
//    char a = [pinyin UTF8String][0];
    return [[pinyin capitalizedString]substringToIndex:1];
//    return [pinyin characterAtIndex:0];
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
- (CGSize)sizeOfFont:(UIFont *)font maxW:(CGFloat)maxW{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end

@implementation NSDate (expanded)
//获取年月日对象
- (NSDateComponents *)YMDComponents{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal fromDate:self];
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

@end
