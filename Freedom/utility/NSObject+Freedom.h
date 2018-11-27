//  NSObject+Freedom.h
//  Freedom
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface RCUnderlineTextField : UITextField
@end
@interface NSObject (Freedom)
//获取对象的所有属性，不包括属性值
- (NSArray *)getAllProperties;
//获取对象的所有属性及属性类型
- (NSDictionary*)propertiesDictionary;
//获取类的属性的数据类型
- (const char*)findPropertyTypeWithName:(NSString*)name;
//获取对象的所有方法
- (NSArray*)getMothList;
@end
@interface UIView (Freedom)
- (void)shake;
- (UIImage *)imageFromView ;

-(void)linearColorFromcolors:(NSArray<UIColor*>*)colors;
-(void)linearColorFromcolors:(NSArray<UIColor*>*)colors isHorizantal:(BOOL)hor;
-(UIImage*)gotCircleLinearFromColors:(NSArray<UIColor*> *)colors;
///渐变色字体，需要在加入父视图之后调用
-(void)linearTextColorFromSuperView:(UIView *)bgView colors:(NSArray<UIColor*> *)colors;
@end
@interface UIViewController (DismissKeyboard)
-(void)showAlerWithtitle:(NSString*)t message:(NSString*)m style:(UIAlertControllerStyle)style ac1:(UIAlertAction* (^)(void))ac1 ac2:(UIAlertAction* (^)(void))ac2 ac3:(UIAlertAction* (^)(void))ac3 completion:(void(^)())completion;
-(void)setupForDismissKeyboard;
@end
