//  ILRegularExpressionManager.h
//  Freedom
//  Created by Super on 14/10/22.
#import <Foundation/Foundation.h>
@interface ILRegularExpressionManager : NSObject
+ (NSArray *)itemIndexesWithPattern:(NSString *)pattern inString:(NSString *)findingString;
+ (NSMutableArray *)matchMobileLink:(NSString *)pattern;
+ (NSMutableArray *)matchWebLink:(NSString *)pattern;
@end
