//  NSString+NSString_ILExtension.h
//  Freedom
//  Created by Super on 14/10/22.
#import <Foundation/Foundation.h>
@interface NSString (NSString_ILExtension)
- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes withString:(NSString *)aString;
- (NSMutableArray *)itemsForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index;
@end
