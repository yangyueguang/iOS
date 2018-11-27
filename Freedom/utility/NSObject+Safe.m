//
//  NSObject+Safe.m
//  Freedom
//
//  Created by Super on 2018/7/24.
//  Copyright © 2018年 薛超. All rights reserved.
#import "NSObject+Safe.h"
#import <objc/message.h>
@implementation NSObject (Safe)
- (void)setObjc1:(id)objc1 {
    objc_setAssociatedObject(self, @"objc1", objc1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)objc1 {
    return objc_getAssociatedObject(self, @"objc1");
}
- (void)setObjc2:(id)objc2 {
    objc_setAssociatedObject(self, @"objc2", objc2, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)objc2 {
    return objc_getAssociatedObject(self, @"objc2");
}
+ (NSArray *)allProperties {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        [array addObject:[NSString stringWithCString:cName encoding:NSUTF8StringEncoding]];
    }
    return array;
}
@end
@implementation NSArray (Safe)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(objc_getClass("__NSPlaceholderArray"), @selector(initWithObjects:count:)),class_getInstanceMethod(objc_getClass("__NSPlaceholderArray"), @selector(safe_initWithObjects:count:)));
    method_exchangeImplementations(class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(objectAtIndex:)),class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(empty_objectAtIndex:)));
    method_exchangeImplementations(class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:)),class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(safe_objectAtIndex:)));
    if ([[UIDevice currentDevice] systemVersion].integerValue > 10) { //ios10及以下不可用
        method_exchangeImplementations(class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndexedSubscript:)),class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(safe_objectAtIndexedSubscript:)));
    }
}
- (instancetype)safe_initWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
    BOOL hasNilObject = NO;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (objects[i] == nil) {
            hasNilObject = YES;
            NSLog(@"\"initWithObjects:count:\" at index %lu is nil", i);
        }
    }
    if (hasNilObject) {
        id __unsafe_unretained newObjects[cnt];
        NSUInteger index = 0;
        for (NSUInteger i = 0; i < cnt; ++i) {
            if (objects[i] != nil) {
                newObjects[index++] = objects[i];
            }
        }
        return [self safe_initWithObjects:newObjects count:index];
    }
    return [self safe_initWithObjects:objects count:cnt];
}
- (id)empty_objectAtIndex:(NSUInteger)index {
    return nil;
}
- (id)safe_objectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }
    return [self safe_objectAtIndex:index];
}
- (id)safe_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count) {
        return nil;
    }
    return [self safe_objectAtIndexedSubscript:idx];
}
@end
@implementation NSMutableArray (Safe)
+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(insertObject:atIndex:)),class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(safe_insertObject:atIndex:)));
    method_exchangeImplementations(class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:)),class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(safe_objectAtIndex:)));
    if ([[UIDevice currentDevice] systemVersion].integerValue > 10) { //ios10及以下不可用
        method_exchangeImplementations(class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndexedSubscript:)),class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(safe_objectAtIndexedSubscript:)));
    }
}
- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index {
    @autoreleasepool {
        if (!anObject) {
            return;
        }
        [self safe_insertObject:anObject atIndex:index];
    }
}
- (id)safe_objectAtIndex:(NSUInteger)index {
    @autoreleasepool {
        if (index >= self.count) {
            return nil;
        }
        return [self safe_objectAtIndex:index];
    }
}
- (id)safe_objectAtIndexedSubscript:(NSUInteger)idx {
    @autoreleasepool {
        if (idx >= self.count) {
            return nil;
        }
        return [self safe_objectAtIndexedSubscript:idx];
    }
}
- (void)safeAddObject:(id)anObject{
    if (anObject) {
        [self addObject:anObject];
    }
}
- (void)safeRemoveObjectAtIndex:(NSUInteger)index{
    if (index < [self count]) {
        [self removeObjectAtIndex:index];
    }
}
- (BOOL)expanNSMutableArray{
    if (!self || [self isEqual:[NSNull null]] || self.count < 1) {
        return false;
    }
    return true;
}
@end
@implementation NSMutableDictionary (Safe)
+ (void)load {
    Method setObjectMethod = class_getInstanceMethod(objc_getClass("__NSDictionaryM"), @selector(setObject:forKey:));
    Method safe_setObjectMethod = class_getInstanceMethod(objc_getClass("__NSDictionaryM"), @selector(safe_setObject:forKey:));
    method_exchangeImplementations(setObjectMethod, safe_setObjectMethod);
}
- (void)safe_setObject:(id)object forKey:(NSString *)key {
    if (!object) {
        object = @"";
    }
    [self safe_setObject:object forKey:key];
}
@end

@implementation NSString (Blue)
/** 删除线 */
- (NSAttributedString *)strickout {
    NSDictionary *attributes = @{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)};
    return [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
}
- (NSAttributedString *)imageAttributedString {
    NSTextAttachment *attachment = [NSTextAttachment new];
    attachment.image = [UIImage imageNamed:self];
    //此数值与15号字体想匹配
    attachment.bounds = CGRectMake(0, -2, 15, 15); //负值, 就是向下移, 同时会改变计算的高度
//    NSString *numStr = [self substringWithRange:NSMakeRange(self.length - 2, 2)];
//    NSString *faceStr = [NSString stringWithFormat:@"[#&%ld]", numStr.integerValue + 1]; //为了适应安卓, 做的加1, 显示时需要再减1
    //    attachment.objc1 = faceStr; //将[#&1] 格式字符串保存起来, 遍历时用
    return [NSAttributedString attributedStringWithAttachment:attachment];
}
- (NSMutableAttributedString *)emojiAttributedStringWithFontNumber:(NSInteger)number {
    NSMutableAttributedString *muAtt = [NSMutableAttributedString new];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
    NSArray *array = [[self URLDecodedString] componentsSeparatedByCharactersInSet:set];
    for (NSString *str in array) {
        if ([str hasPrefix:@"#&"]) { //这里要减1, 为了适应安卓
            NSString *imgName = [NSString stringWithFormat:@"NIMKitResouce.bundle/Emoticon/Emoji/emoji_%02ld", [str substringFromIndex:2].integerValue - 1];
            [muAtt appendAttributedString:[imgName imageAttributedString]];
        } else {
            [muAtt appendAttributedString:[[NSAttributedString alloc] initWithString:str]];
        }
    }
    [muAtt addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:number]} range:NSMakeRange(0, muAtt.length)];
    return muAtt;
}
/** 转成带emoji的html字符串 */
- (NSString *)convertToEmojiString {
    NSMutableString *muStr = [NSMutableString string];
    NSArray *array = [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
    for (NSString *str in array) {
        if ([str hasPrefix:@"#&"]) { //这里要减1, 为了适应安卓
            NSString *imgStr = [NSString stringWithFormat:@"<img src='https://chicaikee.oss-cn-hangzhou.aliyuncs.com/emoji/emoji_%02ld%%402x.png' width='15'  height='15'/>", [str substringFromIndex:2].integerValue - 1];
            [muStr appendString:imgStr];
        } else {
            [muStr appendString:str];
        }
    }
    return muStr;
}
- (CGFloat)textHeightWithWidth:(CGFloat)width fontNumber:(NSInteger)fontNumber {
    CGFloat height = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontNumber]}
                                        context:nil].size.height;
    return ceil(height);
}

- (CGFloat)textWidthWithFontNumber:(NSInteger)fontNumber {
    CGFloat width = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontNumber]}
                                       context:nil].size.width;
    return ceil(width);
}
- (NSString *)URLEncodedString {
    NSString *encodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    return encodedString;
}
- (NSString *)URLDecodedString {
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

+ (void)load {
    [NSString exchangeSubstringToIndex];
    [NSString exchangeSubstringFromIndex];
}
+ (void)exchangeSubstringToIndex {
    Method setObjectMethod = class_getInstanceMethod(objc_getClass("__NSCFConstantString"), @selector(substringToIndex:));
    Method safe_setObjectMethod = class_getInstanceMethod(objc_getClass("__NSCFConstantString"), @selector(safe_substringToIndex:));
    method_exchangeImplementations(setObjectMethod, safe_setObjectMethod);
}
+ (void)exchangeSubstringFromIndex {
    Method setObjectMethod = class_getInstanceMethod(objc_getClass("__NSCFConstantString"), @selector(substringFromIndex:));
    Method safe_setObjectMethod = class_getInstanceMethod(objc_getClass("__NSCFConstantString"), @selector(safe_substringFromIndex:));
    method_exchangeImplementations(setObjectMethod, safe_setObjectMethod);
}
- (NSString *)safe_substringToIndex:(NSUInteger)to {
    to = MIN(to, self.length);
    return [self safe_substringToIndex:to];
}
- (NSString *)safe_substringFromIndex:(NSUInteger)from {
    from = MIN(from, self.length);
    return [self safe_substringFromIndex:from];
}
@end
