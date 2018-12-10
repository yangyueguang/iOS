//  NSObject+Freedom.h
//  Freedom
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface RCUnderlineTextField : UITextField
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
typedef void (^BarButtonActionBlock)();
@interface UIBarButtonItem (expanded)
- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style actionBlick:(BarButtonActionBlock)actionBlock;
- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style actionBlick:(BarButtonActionBlock)actionBlock;
- (id)initWithBackTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setActionBlock:(BarButtonActionBlock)actionBlock;
@end

@interface NSString(expanded)
- (NSString *) pinyin;
- (NSString*)pinyinFirstLetter;
- (NSDictionary *)dictionaryFromURLParameters;
- (NSString *)emoji;
//是否为emoji字符
- (BOOL)isEmoji;
- (CGSize)sizeOfFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeOfFont:(UIFont *)font;
@end
@interface NSDate (expanded)
- (NSDateComponents *)YMDComponents;
-(NSString *)timeToNow;
@end
@interface UIView(Addition)
-(BOOL) containsSubView:(UIView *)subView;
-(BOOL) containsSubViewOfClassType:(Class)aclass;
-(void)addSubviews:(UIView *)view,...;
-(void)bestRoundCorner;
@end


@interface NSArray (Safe)
@end
@interface NSMutableArray (Safe)
- (void)safeAddObject:(id)anObject;
- (void)safeRemoveObjectAtIndex:(NSUInteger)index;
- (BOOL)expanNSMutableArray;
@end
@interface NSMutableDictionary (Safe)
@end
@interface NSString (Safe)
/** 删除线 */
- (NSAttributedString *)strickout;
@end

