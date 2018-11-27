//  NSObject+Freedom.m
//  Freedom
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>
#include <string.h>
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
