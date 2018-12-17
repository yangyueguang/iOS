//  NSObject+Freedom.h
//  Freedom
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface UIView (Freedom)
- (void)shake;
- (UIImage *)imageFromView ;
-(void)addSubviews:(UIView *)view,...;
@end
@interface UIViewController (DismissKeyboard)
-(void)showAlerWithtitle:(NSString*)t message:(NSString*)m style:(UIAlertControllerStyle)style ac1:(UIAlertAction* (^)(void))ac1 ac2:(UIAlertAction* (^)(void))ac2 ac3:(UIAlertAction* (^)(void))ac3 completion:(void(^)())completion;
@end
typedef void (^BarButtonActionBlock)();
@interface UIBarButtonItem (expanded)
- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style actionBlick:(BarButtonActionBlock)actionBlock;
- (void)setActionBlock:(BarButtonActionBlock)actionBlock;
@end

@interface NSString(expanded)
- (NSString *)pinyin;
- (NSString*)pinyinFirstLetter;
- (NSDictionary *)dictionaryFromURLParameters;
- (CGSize)sizeOfFont:(UIFont *)font maxW:(CGFloat)maxW;
@end
@interface NSDate (expanded)
- (NSDateComponents *)YMDComponents;
-(NSString *)timeToNow;
@end

