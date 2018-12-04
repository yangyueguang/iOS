//
#import <Foundation/Foundation.h>
/// 分时图渐变色
#define FenShiGradientColor [FreedomTools colorWithRGBHex:0x1860FE]
///分时线界面线的颜色
#define TimeLineLineColor [FreedomTools colorWithRGBHex:0x1860FE]
///边框线颜色
#define GridLineColor [FreedomTools colorWithRGBHex:0x999999]
/// 根据十六进制转换成UIColor @param hex UIColor的十六进制
//+(UIColor *)colorWithRGBHex:(UInt32)hex;
///边框线颜色
#define GridLineColor [FreedomTools colorWithRGBHex:0x999999]
/// 涨的颜色
#define IncreaseColor [UIColor colorWithRed:206/255.0 green:65/255.0 blue:51/255.0 alpha:1.0]
/// 跌的颜色
#define DecreaseColor [UIColor colorWithRed:37/255.0 green:174/255.0 blue:68/255.0 alpha:1.0]
/// 主文字颜色
#define MainTextColor [FreedomTools colorWithRGBHex:0xe1e2e6]
/// 辅助文字颜色
#define AssistTextColor [FreedomTools colorWithRGBHex:0x565a64]
///分时线下面的成交量线的颜色
#define TimeLineVolumeLineColor [FreedomTools colorWithRGBHex:0x2d333a]
///长按时线的颜色
#define LongPressLineColor [FreedomTools colorWithRGBHex:0x666666]
@interface NSDateFormatter (HYStockChart)
+(NSDateFormatter *)shareDateFormatter;
@end

@interface UIFont (HYStockChart)
///黑体-简 细体
+(UIFont *)blackSimpleFontWithSize:(CGFloat)size;
+(UIFont *)hlFontWithSize:(CGFloat)size;
///Helvetica Neue字体
+(UIFont *)hnFontWithSize:(CGFloat)size;
///Adobe 黑体
+(UIFont *)adobeBlackFontWithSize:(CGFloat)size;
@end
@interface UIView (HXCircleAnimation)
-(void)showCircleAnimationLayerWithColor:(UIColor *)circleColor andScale:(CGFloat)scale;
@end
