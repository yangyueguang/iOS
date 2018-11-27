//
//  NSObject+Safe.h
//  Freedom
//
//  Created by Super on 2018/7/24.
//  Copyright © 2018年 薛超. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface NSObject (Safe)
@property (nonatomic, strong) id objc1;
@property (nonatomic, strong) id objc2;
+ (NSArray *)allProperties;
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
- (NSAttributedString *)imageAttributedString;
- (NSMutableAttributedString *)emojiAttributedStringWithFontNumber:(NSInteger)number;
/** 转成带emoji的html字符串 */
- (NSString *)convertToEmojiString;
- (CGFloat)textHeightWithWidth:(CGFloat)width fontNumber:(NSInteger)fontNumber;
- (CGFloat)textWidthWithFontNumber:(NSInteger)fontNumber;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
@end
