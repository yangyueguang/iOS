//
//  TimeLineModel.h
//  HTFProject
#import <Foundation/Foundation.h>
#import "TimeLineModel.h"
#import <UIKit/UIKit.h>
/************************分时线上面的view的位置模型************************/
@interface HYTimeLineAbovePositionModel : NSObject
@property(nonatomic,assign) CGPoint currentPoint;
@end
/************************用于画分时线的画笔************************/
@interface HYTimeLine : NSObject
/**曲线点位置数据数组*/
@property(nonatomic,strong) NSArray *positionModels;
/** 昨天收盘价位置*/
@property(nonatomic,assign) CGFloat horizontalYPosition;
@property(nonatomic,assign) CGFloat timeLineViewWidth;
@property(nonatomic,assign) CGFloat timeLineViewMaxY;
-(instancetype)initWithContext:(CGContextRef)context;
-(void)draw;
@end
@interface TimeLineModel : NSObject
@end
@interface HYTimeLineModel : NSObject
@property(nonatomic,assign) CGFloat currentPrice;
@property(nonatomic,copy) NSString *currentTime;
@property(nonatomic,copy) NSString *currentDate;
@property(nonatomic,assign) NSInteger volume;
@property(nonatomic,assign) CGFloat ChangeFromPreClose;
@property(nonatomic,assign) CGFloat PercentChangeFromPreClose;
@end
@interface HYTimeLineGroupModel : NSObject
///这个数组装得是HYTimeLineModel
@property(nonatomic,strong) NSArray *timeModels;
@property(nonatomic,assign) CGFloat lastDayEndPrice;
+(instancetype)groupModelWithTimeModels:(NSArray *)timeModels lastDayEndPrice:(CGFloat)lastDayEndPrice;
@end
@interface JMSGroupTimeLineModel : NSObject
///服务器的数据是PreviousClose
@property(nonatomic,assign) CGFloat lastDayEndPrice;
///里面装的是JMSTimeLineModel
@property(nonatomic,strong) NSArray *timeLineModels;
@end
/************************分时线的Model***********************/
@interface JMSTimeLineModel : NSObject
@property(nonatomic,assign) CGFloat Close;
@property(nonatomic,copy) NSString *EndDate;
@property(nonatomic,copy) NSString *EndTime;
@property(nonatomic,assign) CGFloat High;
@property(nonatomic,assign) CGFloat Low;
@property(nonatomic,assign) CGFloat Open;
@property(nonatomic,copy) NSString *StartDate;
@property(nonatomic,copy) NSString *StartTime;
@property(nonatomic,assign) NSInteger Volume;
@property(nonatomic,assign) CGFloat VWAP;
@property(nonatomic,assign) CGFloat UTCOffset;
@property(nonatomic,assign) CGFloat Trades;
@property(nonatomic,assign) CGFloat TWAP;
@property(nonatomic,assign) CGFloat ChangeFromPreClose;
@property(nonatomic,assign) CGFloat PercentChangeFromPreClose;
@end
