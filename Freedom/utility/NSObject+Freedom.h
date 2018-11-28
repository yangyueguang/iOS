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

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;
@property (nonatomic) CGFloat frameHeight;
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
@interface UIImage (Freedom)
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
typedef void (^BarButtonActionBlock)();
@interface UIBarButtonItem (expanded)
- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style actionBlick:(BarButtonActionBlock)actionBlock;
- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style actionBlick:(BarButtonActionBlock)actionBlock;
- (id)initWithBackTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setActionBlock:(BarButtonActionBlock)actionBlock;
@end
@interface UINavigationBar (expanded)
/** 设置导航栏背景颜色*/
- (void)wr_setBackgroundColor:(UIColor *)color;
- (void)wr_setBackgroundAplha:(CGFloat)alpha;
/** 设置导航栏所有BarButtonItem的透明度 */
- (void)wr_setBarButtonItemsAlpha:(CGFloat)alpha hasSystemBackIndicator:(BOOL)hasSystemBackIndicator;
/** 设置导航栏在垂直方向上平移多少距离 */
- (void)wr_setTranslationY:(CGFloat)translationY;
/** 清除在导航栏上设置的背景颜色、透明度、位移距离等属性 */
- (void)wr_clear;
@end
@interface NSString(expanded)
- (NSString*)urlEncodedString;
- (NSString*)urlDecodedString;
- (NSString *) pinyin;
- (NSDictionary *)dictionaryFromURLParameters;
- (NSString *)emoji;
//是否为emoji字符
- (BOOL)isEmoji;
- (CGSize)sizeOfFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeOfFont:(UIFont *)font;
/** 查找多个匹配方案结果 */
- (NSArray *)matchesWithPattern:(NSString *)pattern;
/** 查找多个匹配方案结果，并根据键值数组生成对应的字典数组 */
- (NSArray *)matchesWithPattern:(NSString *)pattern keys:(NSArray *)keys;
@end
@interface NSDate (expanded)
- (NSUInteger)weeklyOrdinality;
- (NSDateComponents *)YMDComponents;
-(NSString *)getWeekString;
-(NSString *)timeToNow;
- (BOOL) isInFuture;
- (BOOL) isInPast;
- (BOOL) isToday;
@end
@interface UIView(Addition)
-(BOOL) containsSubView:(UIView *)subView;
-(BOOL) containsSubViewOfClassType:(Class)aclass;
-(void)addSubviews:(UIView *)view,...;
-(void)imageWithURL:(NSString *)url useProgress:(BOOL)useProgress useActivity:(BOOL)useActivity defaultImage:(NSString *)strImage;
-(void)bestRoundCorner;
@end
@interface UIColor (Extention)

+ (UIColor *)colorWithRGBHex:(UInt32)hex ;
@end
