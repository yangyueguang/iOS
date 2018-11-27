//
//  HYTimeLineBelowView.h
//  JimuStockChartDemo
#import <UIKit/UIKit.h>
#import "HYStockChartConstant.h"
#import "TimeLineModel.h"
#import "HYTimeLineAboveView.h"
@interface YYTimeLineBelowMaskView : UIView
//当前长按选中的model
@property (nonatomic, strong) HYTimeLineModel *selectedModel;
//当前长按选中的位置model
@property (nonatomic, assign) CGPoint selectedPoint;
//当前的滑动scrollview
@property (nonatomic, strong) HYTimeLineAboveView *timeLineView;
@end
@class HYTimeLineModel;
/************************分时线下面的view************************/
@interface HYTimeLineBelowView : UIView <HYTimeLineAboveViewDelegate>
@property(nonatomic,strong) NSArray *timeLineModels;
//x轴的位置数组
@property(nonatomic,strong) NSArray *xPositionArray;
@property(nonatomic,assign) HYStockChartCenterViewType centerViewType;
//显示颜色数
@property(nonatomic,strong) NSArray *colorArray;
@property (nonatomic,strong)YYTimeLineBelowMaskView *maskView;
//选中的点和位置
-(void)timeLineAboveViewLongPressLineModel:(HYTimeLineModel *)selectedModel selectPoint:(CGPoint)selectedPoint;
///画下面的view
-(void)drawBelowView;
/// 根据指定颜色清除背景
-(void)clearRectWithColor:(UIColor *)bgColor NS_DEPRECATED_IOS(2_0,2_0,"这个方法暂时没有实现!");
@end
