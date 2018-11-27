//
//  KLineModel.h
//  HTFProject
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "KLineModel.h"
@class HYKLinePositionModel;
@class HYKLineModel;
/************************K线的画笔************************/
@interface HYKLine : NSObject
///K线模型
@property(nonatomic,strong) HYKLinePositionModel *kLinePositionModel;
/// kLineModel模型
@property(nonatomic,strong) HYKLineModel *kLineModel;
///最大的Y
@property(nonatomic,assign) CGFloat maxY;
///根据context初始化
-(instancetype)initWithContext:(CGContextRef)context;
/// 绘制K线
-(UIColor *)draw;
@end
@interface KLineModel : NSObject
@end
@interface HYKLineModel : NSObject
///这个日期的格式必须为MM/dd/yyyy
@property(nonatomic,copy) NSString *date;
@property(nonatomic,assign) CGFloat high;
@property(nonatomic,assign) CGFloat low;
@property(nonatomic,assign) CGFloat open;
@property(nonatomic,assign) CGFloat close;
@property(nonatomic,assign) CGFloat volume;
//10日平均线
@property(nonatomic,assign) CGFloat MA10;
//20日平均线
@property(nonatomic,assign) CGFloat MA20;
//5日平均线
@property(nonatomic,assign) CGFloat MA5;
@property(nonatomic,assign)  CGFloat MA30;
@property(nonatomic,assign) CGFloat changeFromLastClose;
@property(nonatomic,assign) CGFloat changeFromOpen;
@property(nonatomic,assign) CGFloat percentChangeFromLastClose;
@property(nonatomic,assign) CGFloat percentChangeFromOpen;
///是否是某个月的第一个交易日
@property(nonatomic,assign) BOOL isFirstTradeDate;
@end
@interface JMSKLineGroupModel : NSObject
@property(nonatomic,copy) NSString *StartDate;
@property(nonatomic,copy) NSString *EndDate;
///K线的数组
@property(nonatomic,strong) NSArray *GlobalQuotes;
@end
///股票类型
typedef NS_ENUM(NSInteger, JMSStockType){
    JMSStockTypeUSA = 1,        //美股
    JMSStockTypeA,              //A股
    JMSStockTypeHK,             //港股
    JMSStockTypeChinaConcept,   //中概股
    JMSStockTypeNone            //没有赋值的类型
};
@interface JMSKLineModel : NSObject
@property(nonatomic,copy) NSString *Symbol;
@property(nonatomic,copy) NSString *Currency;
//股票类型
@property(nonatomic,assign) JMSStockType StockType;
//交易所代码
@property(nonatomic,copy) NSString *ExchangeCode;
@property(nonatomic,assign) CGFloat ChangeFromLastClose;
@property(nonatomic,assign) CGFloat ChangeFromOpen;
@property(nonatomic,assign) CGFloat CummulativeCashDividend;
@property(nonatomic,assign) CGFloat CummulativeStockDividendRatio;
@property(nonatomic,copy) NSString *DataConfidence;
@property(nonatomic,copy) NSString *Date;
///最高价
@property(nonatomic,assign) CGFloat High;
///收盘价
@property(nonatomic,assign) CGFloat Last;
@property(nonatomic,assign) CGFloat LastClose;
///最低价
@property(nonatomic,assign) CGFloat Low;
/// 开盘价
@property(nonatomic,assign) CGFloat Open;
///收盘价相对于开盘价的增减比例
@property(nonatomic,assign) CGFloat PercentChangeFromLastClose;
@property(nonatomic,assign) CGFloat PercentChangeFromOpen;
///成交量
@property(nonatomic,assign) NSInteger Volume;
@property(nonatomic,assign) CGFloat MA5;
@property(nonatomic,assign) CGFloat MA10;
@property(nonatomic,assign) CGFloat MA20;
@property(nonatomic,assign)  CGFloat MA30;
@end
/************************K线数据模型************************/
@interface HYKLinePositionModel : NSObject
///开盘点
@property(nonatomic,assign) CGPoint openPoint;
/// 收盘点
@property(nonatomic,assign) CGPoint closePoint;
///最高点
@property(nonatomic,assign) CGPoint highPoint;
///最低点
@property(nonatomic,assign) CGPoint lowPoint;
///根据属性创建模型的工厂方法
+(instancetype)modelWithOpen:(CGPoint)openPoint close:(CGPoint)closePoint high:(CGPoint)highPoint low:(CGPoint)lowPoint;
@end
