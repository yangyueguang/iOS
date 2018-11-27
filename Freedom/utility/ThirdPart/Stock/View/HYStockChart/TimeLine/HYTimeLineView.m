//
//  HYTimeLineView.m
//  JimuStockChartDemo
#import "HYTimeLineView.h"
#import "HYTimeLineAboveView.h"
#import "HYTimeLineBelowView.h"
#import "HYStockChartConstant.h"
#import "TimeLineModel.h"
#import "StockCategory.h"
#import "FiveRange_TradeDetailTableView.h"
#import "HYStockChartTool.h"
@class HYTimeLineModel;
/************************分时线长按的简介view************************/
@interface HYTimeLineLongPressProfileView : UIView
+(instancetype)timeLineLongPressProfileView;
@property(nonatomic,strong) HYTimeLineModel *timeLineModel;
@end
@class HYTimeLineModel;
@interface HYTimeLineLongPressView : UIView
+(instancetype)timeLineLongPressProfileView;
@property(nonatomic,strong) HYTimeLineModel *timeLineModel;
@end
@interface HYTimeLineLongPressProfileView ()
@property (strong, nonatomic) UILabel *chineseNameLabel;
@property (strong, nonatomic) UILabel *symbolLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *appliesLabel;
@property (strong, nonatomic) UILabel *volumeLabel;
@property (strong, nonatomic) UILabel *volumeNameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@end
@implementation HYTimeLineLongPressProfileView
+(instancetype)timeLineLongPressProfileView{
    HYTimeLineLongPressProfileView *bllppView = [[HYTimeLineLongPressProfileView alloc]initWithFrame:CGRectMake(0, 0, APPH, 80)];
    bllppView.backgroundColor = [UIColor whiteColor];
    CGFloat width = APPH/5;
    CGFloat height = 40;
    bllppView.chineseNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    bllppView.symbolLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, height, width, height)];
    bllppView.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, 0, width, height)];
    bllppView.appliesLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, height, width, height)];
    bllppView.volumeLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*2, 0, width, height)];
    bllppView.volumeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*2, height, width, height)];
    bllppView.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*3, 0, width, height)];
    bllppView.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*3, height, width, height)];
    [bllppView addSubviews:bllppView.chineseNameLabel,bllppView.symbolLabel,bllppView.priceLabel,bllppView.appliesLabel,bllppView.volumeLabel,bllppView.volumeNameLabel,bllppView.timeLabel,bllppView.dateLabel,nil];
    for(UILabel *v in bllppView.subviews){
        if([v isKindOfClass:[UILabel class]]){
            v.text = @"temp";
            v.font = [UIFont systemFontOfSize:10];
            v.textColor = [UIColor grayColor];
            v.textAlignment = NSTextAlignmentCenter;
        }
    }
    return bllppView;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = AssistBackgroundColor;
    self.chineseNameLabel.textColor = MainTextColor;
    self.symbolLabel.textColor = AssistTextColor;
    self.priceLabel.textColor = MainTextColor;
    self.appliesLabel.textColor = MainTextColor;
    self.volumeLabel.textColor = MainTextColor;
    self.volumeNameLabel.textColor = AssistTextColor;
    self.timeLabel.textColor = MainTextColor;
    self.dateLabel.textColor = AssistTextColor;
}
-(void)setTimeLineModel:(HYTimeLineModel *)timeLineModel{
    NSDateFormatter *formatter = [NSDateFormatter shareDateFormatter];
    _timeLineModel = timeLineModel;
    self.chineseNameLabel.text = [HYStockChartTool stockChineseName];
    self.symbolLabel.text = [HYStockChartTool stockSymbol];
    NSString *currencySymbol = [HYStockChartTool currencySymbol];
    self.priceLabel.text = [NSString stringWithFormat:@"%@%.2f",currencySymbol,timeLineModel.currentPrice];
    self.appliesLabel.text = [NSString stringWithFormat:@"%.2f%%",timeLineModel.PercentChangeFromPreClose];
    UIColor *appliesTextColor = timeLineModel.PercentChangeFromPreClose > 0 ? IncreaseColor : DecreaseColor;
    self.appliesLabel.textColor = appliesTextColor;
    NSString *volumeString = [NSString stringWithFormat:@"%.ld",timeLineModel.volume];
    if (volumeString.length >= 9 ) {
        volumeString = [NSString stringWithFormat:@"%.2f亿股",timeLineModel.volume/100000000.0];
    }else{
        volumeString = [NSString stringWithFormat:@"%.2f万股",timeLineModel.volume/10000.0];
    }
    self.volumeLabel.text = volumeString;
    formatter.dateFormat = @"MM-dd-yyyy hh:mm:ss a";
    NSDate *date = [formatter dateFromString:timeLineModel.currentTime];
    formatter.dateFormat = @"HH:mm:ss";
    NSString *timeStr = [formatter stringFromDate:date];
    formatter.dateFormat = @"yyyy-dd-MM";
    NSString *dateStr = [formatter stringFromDate:date];
    self.timeLabel.text = timeStr;
    self.dateLabel.text = dateStr;
}
@end
@interface HYTimeLineLongPressView ()
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *volumeLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *appliesLabel;
@end
@implementation HYTimeLineLongPressView
+(instancetype)timeLineLongPressProfileView{
    HYTimeLineLongPressView *timeLineLPView = [[HYTimeLineLongPressView alloc]initWithFrame:CGRectMake(0, 0, APPH, 45)];
    timeLineLPView.backgroundColor = [UIColor whiteColor];
    timeLineLPView.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, APPH/5, 45)];
    timeLineLPView.volumeLabel = [[UILabel alloc]initWithFrame:CGRectMake(APPH/4, 0, APPH/5, 45)];
    timeLineLPView.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(APPH/2, 0, APPH/5, 45)];
    timeLineLPView.appliesLabel = [[UILabel alloc]initWithFrame:CGRectMake(APPH/4*3, 0, APPH/5, 45)];
    timeLineLPView.timeLabel.textColor = timeLineLPView.appliesLabel.textColor = timeLineLPView.volumeLabel.textColor = timeLineLPView.priceLabel.textColor = [UIColor grayColor];
    timeLineLPView.timeLabel.font = timeLineLPView.volumeLabel.font = timeLineLPView.priceLabel.font = timeLineLPView.appliesLabel.font = [UIFont systemFontOfSize:12];
    timeLineLPView.timeLabel.text = timeLineLPView.volumeLabel.text = timeLineLPView.priceLabel.text = timeLineLPView.appliesLabel.text = @"temp";
    [timeLineLPView addSubviews:timeLineLPView.timeLabel,timeLineLPView.priceLabel,timeLineLPView.volumeLabel,timeLineLPView.appliesLabel,nil];
    return timeLineLPView;
}
-(void)setTimeLineModel:(HYTimeLineModel *)timeLineModel{
    NSDateFormatter *formatter = [NSDateFormatter shareDateFormatter];
    _timeLineModel = timeLineModel;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",timeLineModel.currentPrice];
    self.appliesLabel.text = [NSString stringWithFormat:@"%.2f%%",timeLineModel.PercentChangeFromPreClose];
    UIColor *appliesTextColor = timeLineModel.PercentChangeFromPreClose > 0 ? IncreaseColor : DecreaseColor;
    self.appliesLabel.textColor = appliesTextColor;
    NSString *volumeString = [NSString stringWithFormat:@"%.ld",timeLineModel.volume];
    if (volumeString.length >= 9 ) {
        volumeString = [NSString stringWithFormat:@"%.2f亿股",timeLineModel.volume/100000000.0];
    }else{
        volumeString = [NSString stringWithFormat:@"%.2f万股",timeLineModel.volume/10000.0];
    }
    self.volumeLabel.text = volumeString;
    formatter.dateFormat = @"MM-dd-yyyy hh:mm:ss a";
    NSDate *date = [formatter dateFromString:timeLineModel.currentTime];
    formatter.dateFormat = @"HH:mm";
    NSString *timeStr = [formatter stringFromDate:date];
    formatter.dateFormat = @"yyyy-dd-MM";
    NSString *dateStr = [formatter stringFromDate:date];
    self.timeLabel.text = timeStr;
}
@end
@class HYTimeLineModel;
@interface HYBrokenLineLongPressView : UIView
+(instancetype)brokenLineLongPressProfileView;
@property(nonatomic,strong) HYTimeLineModel *timeLineModel;
@end
@class HYTimeLineModel;
/************************折线长按的profileView************************/
@interface HYBrokenLineLongPressProfileView : UIView
@property(nonatomic,strong) HYTimeLineModel *timeLineModel;
///工厂方法创建一个折线的详情view
+(instancetype)brokenLineLongPressProfileView;
@end
@interface HYBrokenLineLongPressView ()
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *volumeLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *appliesLabel;
@end
@implementation HYBrokenLineLongPressView
+(instancetype)brokenLineLongPressProfileView{
    HYBrokenLineLongPressView *timeLineLPView = [[HYBrokenLineLongPressView alloc]initWithFrame:CGRectMake(0, 0, APPH, 45)];
    timeLineLPView.backgroundColor = [UIColor whiteColor];
    timeLineLPView.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, APPH/5, 45)];
    timeLineLPView.volumeLabel = [[UILabel alloc]initWithFrame:CGRectMake(APPH/4, 0, APPH/5, 45)];
    timeLineLPView.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(APPH/2, 0, APPH/5, 45)];
    timeLineLPView.appliesLabel = [[UILabel alloc]initWithFrame:CGRectMake(APPH/4*3, 0, APPH/5, 45)];
    timeLineLPView.timeLabel.textColor = timeLineLPView.appliesLabel.textColor = timeLineLPView.volumeLabel.textColor = timeLineLPView.priceLabel.textColor = [UIColor grayColor];
    timeLineLPView.timeLabel.font = timeLineLPView.volumeLabel.font = timeLineLPView.priceLabel.font = timeLineLPView.appliesLabel.font = [UIFont systemFontOfSize:12];
    timeLineLPView.timeLabel.text = timeLineLPView.volumeLabel.text = timeLineLPView.priceLabel.text = timeLineLPView.appliesLabel.text = @"temp";
    [timeLineLPView addSubviews:timeLineLPView.timeLabel,timeLineLPView.priceLabel,timeLineLPView.volumeLabel,timeLineLPView.appliesLabel,nil];
    return timeLineLPView;
}
-(void)setTimeLineModel:(HYTimeLineModel *)timeLineModel{
    NSDateFormatter *formatter = [NSDateFormatter shareDateFormatter];
    _timeLineModel = timeLineModel;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",timeLineModel.currentPrice];
    self.appliesLabel.text = [NSString stringWithFormat:@"%.2f%%",timeLineModel.PercentChangeFromPreClose];
    UIColor *appliesTextColor = timeLineModel.PercentChangeFromPreClose > 0 ? IncreaseColor : DecreaseColor;
    self.appliesLabel.textColor = appliesTextColor;
    NSString *volumeString = [NSString stringWithFormat:@"%.ld",timeLineModel.volume];
    if (volumeString.length >= 9 ) {
        volumeString = [NSString stringWithFormat:@"%.2f亿股",timeLineModel.volume/100000000.0];
    }else{
        volumeString = [NSString stringWithFormat:@"%.2f万股",timeLineModel.volume/10000.0];
    }
    self.volumeLabel.text = volumeString;
    formatter.dateFormat = @"MM-dd-yyyy hh:mm:ss a";
    NSDate *date = [formatter dateFromString:timeLineModel.currentTime];
    formatter.dateFormat = @"HH:mm";
    NSString *timeStr = [formatter stringFromDate:date];
    formatter.dateFormat = @"dd-MM";
    NSString *dateStr = [formatter stringFromDate:date];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",dateStr,timeStr];
}
@end
@interface HYBrokenLineLongPressProfileView ()
@property (strong, nonatomic) UILabel *chineseNameLabel;
@property (strong, nonatomic) UILabel *symbolLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *appliesLabel;
@property (strong, nonatomic) UILabel *volumeLabel;
@property (strong, nonatomic) UILabel *volumeNameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@end
@implementation HYBrokenLineLongPressProfileView
+(instancetype)brokenLineLongPressProfileView{
    HYBrokenLineLongPressProfileView *bllppView = [[HYBrokenLineLongPressProfileView alloc]initWithFrame:CGRectMake(0, 0, APPH, 80)];
    bllppView.backgroundColor = [UIColor whiteColor];
    CGFloat width = APPH/5;
    CGFloat height = 40;
    bllppView.chineseNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    bllppView.symbolLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, height, width, height)];
    bllppView.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, 0, width, height)];
    bllppView.appliesLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, height, width, height)];
    bllppView.volumeLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*2, 0, width, height)];
    bllppView.volumeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*2, height, width, height)];
    bllppView.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*3, 0, width, height)];
    bllppView.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*3, height, width, height)];
    [bllppView addSubviews:bllppView.chineseNameLabel,bllppView.symbolLabel,bllppView.priceLabel,bllppView.appliesLabel,bllppView.volumeLabel,bllppView.volumeNameLabel,bllppView.timeLabel,bllppView.dateLabel,nil];
    for(UILabel *v in bllppView.subviews){
        if([v isKindOfClass:[UILabel class]]){
            v.text = @"temp";
            v.font = [UIFont systemFontOfSize:10];
            v.textColor = [UIColor grayColor];
            v.textAlignment = NSTextAlignmentCenter;
        }
    }
    return bllppView;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = AssistBackgroundColor;
    self.chineseNameLabel.textColor = MainTextColor;
    self.symbolLabel.textColor = AssistTextColor;
    self.priceLabel.textColor = MainTextColor;
    self.appliesLabel.textColor = AssistTextColor;
    self.volumeLabel.textColor = MainTextColor;
    self.volumeNameLabel.textColor = AssistTextColor;
    self.timeLabel.textColor = MainTextColor;
    self.dateLabel.textColor = AssistTextColor;
}
-(void)setTimeLineModel:(HYTimeLineModel *)timeLineModel{
    NSDateFormatter *formatter = [NSDateFormatter shareDateFormatter];
    _timeLineModel = timeLineModel;
    self.chineseNameLabel.text = [HYStockChartTool stockChineseName];
    self.symbolLabel.text = [HYStockChartTool stockSymbol];
    
    NSString *currencySymbol = [HYStockChartTool currencySymbol];
    self.priceLabel.text = [NSString stringWithFormat:@"%@%.2f",currencySymbol,timeLineModel.currentPrice];
    self.appliesLabel.text = [NSString stringWithFormat:@"%.2f%%",timeLineModel.PercentChangeFromPreClose];
    UIColor *appliesTextColor = timeLineModel.PercentChangeFromPreClose > 0 ? IncreaseColor : DecreaseColor;
    self.appliesLabel.textColor = appliesTextColor;
    NSString *volumeString = [NSString stringWithFormat:@"%.ld",timeLineModel.volume];
    if (volumeString.length >= 9 ) {
        volumeString = [NSString stringWithFormat:@"%.2f亿股",timeLineModel.volume/100000000.0];
    }else{
        volumeString = [NSString stringWithFormat:@"%.2f万股",timeLineModel.volume/10000.0];
    }
    self.volumeLabel.text = volumeString;
    formatter.dateFormat = @"MM-dd-yyyy hh:mm:ss a";
    NSDate *date = [formatter dateFromString:timeLineModel.currentTime];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter stringFromDate:date];
    self.dateLabel.text = dateStr;
    formatter.dateFormat = @"HH:mm";
    NSString *timeStr = [formatter stringFromDate:date];
    self.timeLabel.text = timeStr;
}
@end
#define kBtnTag 1000
@interface HYTimeLineView()<HYTimeLineAboveViewDelegate>
@property(nonatomic,strong) HYTimeLineAboveView *aboveView;
@property(nonatomic,strong) HYTimeLineBelowView *belowView;
@property(nonatomic,strong) UIView *timeLineContainerView;
@property(nonatomic,strong) NSArray *timeLineModels;
@property(nonatomic,strong) UIView *verticalView;
@property (nonatomic,weak)FiveRangeTableView *fiveRangeView;
@property (nonatomic,weak)TradeDetailTableView *tradeDetailView;
@property (nonatomic,weak)UIButton *lastBtn;
//水平线
@property(nonatomic,strong) UIView *horizontalView;
@property(nonatomic,strong) HYTimeLineLongPressProfileView *timeLineLongPressProfileView;
@property(nonatomic,strong) HYTimeLineLongPressView *timeLineLongPressView;
@property(nonatomic,strong) HYBrokenLineLongPressProfileView *brokenLineLongPressProfileView;
@property(nonatomic,strong) HYBrokenLineLongPressView *brokenLineLongPressView;
@end
@implementation HYTimeLineView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.aboveViewRatio = 0.7;
        self.belowView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
#pragma mark set&get方法
#pragma mark aboveView的get方法
-(HYTimeLineAboveView *)aboveView{
    if (!_aboveView) {
        _aboveView = [HYTimeLineAboveView new];
        _aboveView.delegate = self;
      //  _aboveView.delegate = self.belowView;
        [self.timeLineContainerView addSubview:_aboveView];
        [_aboveView mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.top.left.right.equalTo(self.timeLineContainerView);
            make.left.equalTo(self.timeLineContainerView).offset(10);
            make.top.equalTo(self.timeLineContainerView);
            make.right.equalTo(self.timeLineContainerView).offset(-110).priorityMedium();
            make.height.equalTo(self.timeLineContainerView).multipliedBy(self.aboveViewRatio);
        }];
    }
    return _aboveView;
}
#pragma mark belowView的get方法
-(HYTimeLineBelowView *)belowView{
    if (!_belowView) {
        _belowView = [HYTimeLineBelowView new];
        [self.timeLineContainerView addSubview:_belowView];
        [_belowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.aboveView.mas_bottom);
           // make.left.right.equalTo(self.timeLineContainerView);
            make.left.equalTo(self.timeLineContainerView).offset(10);
            make.right.equalTo(self.aboveView);
            make.height.equalTo(self.timeLineContainerView).multipliedBy(1-self.aboveViewRatio);
        }];
    }
    return _belowView;
}
#pragma mark timeLineContainerView的get方法
-(UIView *)timeLineContainerView{
    if (!_timeLineContainerView) {
        _timeLineContainerView = [UIView new];
        [self addAllEvent];
        [self addSubview:_timeLineContainerView];
        [_timeLineContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.right.equalTo(self);
            make.height.equalTo(self);
        }];
    }
    return _timeLineContainerView;
}
#pragma mark timeLineLongPressProfileView的get方法
-(HYTimeLineLongPressProfileView *)timeLineLongPressProfileView{
    if (!_timeLineLongPressProfileView) {
        _timeLineLongPressProfileView = [HYTimeLineLongPressProfileView timeLineLongPressProfileView];
        [self addSubview:_timeLineLongPressProfileView];
        [_timeLineLongPressProfileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top).offset(-10);
            make.left.right.equalTo(self);
            make.height.equalTo(@(30));
        }];
    }
    return _timeLineLongPressProfileView;
}
-(HYTimeLineLongPressView *)timeLineLongPressView{
    if (!_timeLineLongPressView) {
        _timeLineLongPressView = [HYTimeLineLongPressView timeLineLongPressProfileView];
        [self addSubview:_timeLineLongPressView];
        [_timeLineLongPressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top).offset(-10);;
            make.left.right.equalTo(self);
            make.height.equalTo(@(30));
        }];
    }
    return _timeLineLongPressView;
}
#pragma mark brokenLineLongPressProfileView的get方法
-(HYBrokenLineLongPressProfileView *)brokenLineLongPressProfileView{
    if (!_brokenLineLongPressProfileView) {
        _brokenLineLongPressProfileView = [HYBrokenLineLongPressProfileView brokenLineLongPressProfileView];
        [self addSubview:_brokenLineLongPressProfileView];
        [_brokenLineLongPressProfileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top);
            make.left.right.equalTo(self);
            make.height.equalTo(@(HYStockChartProfileViewHeight));
        }];
    }
    return _brokenLineLongPressProfileView;
}
-(HYBrokenLineLongPressView *)brokenLineLongPressView{
    if (!_brokenLineLongPressView) {
        _brokenLineLongPressView = [HYBrokenLineLongPressView brokenLineLongPressProfileView];
        [self addSubview:_brokenLineLongPressView];
        [_brokenLineLongPressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top).offset(-10);;
            make.left.right.equalTo(self);
            make.height.equalTo(@(30));
        }];
    }
    return _brokenLineLongPressView;
}
#pragma mark - 模型设置方法
#pragma mark aboveViewRatio设置方法
-(void)setAboveViewRatio:(CGFloat)aboveViewRatio{
    _aboveViewRatio = aboveViewRatio;
    [_aboveView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self).multipliedBy(_aboveViewRatio);
    }];
    [_belowView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self).multipliedBy(1-_aboveViewRatio);
    }];
}
#pragma mark timeLineModels的设置方法
-(void)setTimeLineGroupModel:(HYTimeLineGroupModel *)timeLineGroupModel{
    _timeLineGroupModel = timeLineGroupModel;
    if (timeLineGroupModel) {
        self.timeLineModels = timeLineGroupModel.timeModels;
        self.aboveView.groupModel = timeLineGroupModel;
        self.belowView.timeLineModels = self.timeLineModels;
        [self.aboveView drawAboveView];
    }
}
-(void)setCenterViewType:(HYStockChartCenterViewType)centerViewType{
    _centerViewType = centerViewType;
    if (self.centerViewType == HYStockChartCenterViewTypeTimeLine){
        FiveRangeTableView *fiveRangeView = [[FiveRangeTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.timeLineContainerView insertSubview:fiveRangeView atIndex:0];
        self.fiveRangeView = fiveRangeView;
        TradeDetailTableView *tradeDetailView = [[TradeDetailTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.timeLineContainerView insertSubview:tradeDetailView atIndex:0];
        tradeDetailView.backgroundColor = [UIColor yellowColor];
        self.tradeDetailView = tradeDetailView;
        UIButton *fiveRangeBtn = [[UIButton alloc] init];
        UIButton *tradeDetailBtn = [[UIButton alloc] init];
        [fiveRangeBtn setTitle:@"五档" forState:UIControlStateNormal];
        [tradeDetailBtn setTitle:@"明细" forState:UIControlStateNormal];
        fiveRangeBtn.titleLabel.font = tradeDetailBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [fiveRangeBtn setTitleColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateNormal];
        [tradeDetailBtn setTitleColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateNormal];
        fiveRangeBtn.tag = kBtnTag + 1;
        tradeDetailBtn.tag = kBtnTag + 2;
        [fiveRangeBtn addTarget:self action:@selector(scrollTradeContentClick:) forControlEvents:UIControlEventTouchUpInside];
        [tradeDetailBtn addTarget:self action:@selector(scrollTradeContentClick:) forControlEvents:UIControlEventTouchUpInside];
        fiveRangeBtn.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        tradeDetailBtn.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        self.lastBtn = fiveRangeBtn;
        [self.timeLineContainerView addSubview:fiveRangeBtn];
        [self.timeLineContainerView addSubview:tradeDetailBtn];
        WS(weakSelf);
        [self.aboveView mas_makeConstraints:^(MASConstraintMaker *make) { make.right.equalTo(self.timeLineContainerView).offset(-110);
        }];
        [fiveRangeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(weakSelf.timeLineContainerView).offset(-20);
            make.left.equalTo(weakSelf.aboveView.mas_right).offset(10);
            make.width.mas_equalTo(@100);
            make.top.equalTo(weakSelf.aboveView);
        }];
        [tradeDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(weakSelf.fiveRangeView);
            make.left.equalTo(weakSelf.fiveRangeView.mas_right);
            make.width.equalTo(weakSelf.fiveRangeView);
            make.centerY.equalTo(weakSelf.fiveRangeView);
        }];
        [fiveRangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 16));
            make.top.equalTo(tradeDetailView.mas_bottom);
            make.left.equalTo(weakSelf.fiveRangeView);
        }];
        [tradeDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 16));
            make.top.equalTo(tradeDetailView.mas_bottom);
            make.left.equalTo(fiveRangeBtn.mas_right);
        }];
    }else{
        [self.aboveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.timeLineContainerView).offset(-10);
        }];
    }
    self.aboveView.centerViewType = centerViewType;
    self.belowView.centerViewType = centerViewType;
}
- (void)scrollTradeContentClick:(UIButton *)sender{
    self.lastBtn.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
     sender.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    self.lastBtn = sender;
    NSInteger currentPosition = sender.tag - kBtnTag - 1;
    [UIView animateWithDuration:0.25 animations:^{
        self.tradeDetailView.transform = CGAffineTransformMakeTranslation(-100 * currentPosition, 0);
        self.fiveRangeView.transform = CGAffineTransformMakeTranslation(-100 * currentPosition, 0);
    }];
}
#pragma mark - 私有方法
-(void)addAllEvent{
    //UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(event_longPressMethod:)];
    //[self.timeLineContainerView addGestureRecognizer:longPress];
}
#pragma mark - 公共方法
#pragma mark 重绘
-(void)reDraw{
    [self.aboveView drawAboveView];
}
#pragma mark - Event执行方法
#pragma mark 长按执行方法
-(void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress{
    CGPoint pressPosition = [longPress locationInView:self.aboveView];
    if (UIGestureRecognizerStateBegan == longPress.state || UIGestureRecognizerStateChanged == longPress.state) {
        if (!self.verticalView) {
            //显示竖线
            self.verticalView = [UIView new];
            self.verticalView.clipsToBounds = YES;
            [self.timeLineContainerView addSubview:self.verticalView];
            self.verticalView.backgroundColor = LongPressLineColor;
            [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.width.equalTo(@(HYStockChartLongPressVerticalViewWidth));
                make.height.equalTo(self.mas_height);
                make.left.equalTo(@-10);
            }];
        }
        if (!self.horizontalView) {
            //显示竖线
            self.horizontalView = [UIView new];
            self.horizontalView.clipsToBounds = YES;
            [self.timeLineContainerView addSubview:self.horizontalView];
            self.horizontalView.backgroundColor = LongPressLineColor;
            [self.horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.height.equalTo(@(HYStockChartLongPressVerticalViewWidth));
                make.width.equalTo(self.mas_width);
                make.top.equalTo(@-10);
            }];
        }
        //        //改变竖线的位置
        CGPoint xPosition = [self.aboveView getRightXPositionWithOriginXPosition:pressPosition.x];
        [self.horizontalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(xPosition.y));
        }];
        [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(xPosition.x + 10));
        }];
        [self.verticalView layoutIfNeeded];
        [self.horizontalView layoutIfNeeded];
        self.verticalView.hidden = NO;
        self.horizontalView.hidden = NO;
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:CanAcceptTouchNotificationName object:@"0"];
        if (self.verticalView) {
            self.verticalView.hidden = YES;
        }
        if (self.horizontalView) {
            self.horizontalView.hidden = YES;
        }
        self.timeLineLongPressProfileView.hidden = YES;
        self.brokenLineLongPressProfileView.hidden = YES;
    }
}
- (void)timeLineAboveViewLongPressDismiss{
    self.timeLineLongPressProfileView.hidden = YES;
    self.brokenLineLongPressProfileView.hidden = YES;
    self.timeLineLongPressView.hidden = YES;
    self.brokenLineLongPressView.hidden = YES;
    self.belowView.maskView.hidden = YES;
}
/*
-(void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress{
    CGPoint pressPosition = [longPress locationInView:self.aboveView];
    if (UIGestureRecognizerStateBegan == longPress.state || UIGestureRecognizerStateChanged == longPress.state) {
        if (!self.verticalView) {
            //显示竖线
            self.verticalView = [UIView new];
            self.verticalView.clipsToBounds = YES;
            [self.timeLineContainerView addSubview:self.verticalView];
            self.verticalView.backgroundColor = [UIColor longPressLineColor];
            [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.width.equalTo(@(HYStockChartLongPressVerticalViewWidth));
                make.height.equalTo(self.mas_height);
                make.left.equalTo(@-10);
            }];
        }
        if (!self.horizontalView) {
            //显示竖线
            self.horizontalView = [UIView new];
            self.horizontalView.clipsToBounds = YES;
            [self.timeLineContainerView addSubview:self.horizontalView];
            self.horizontalView.backgroundColor = [UIColor longPressLineColor];
            [self.horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.height.equalTo(@(HYStockChartLongPressVerticalViewWidth));
                make.width.equalTo(self.mas_width);
                make.top.equalTo(@-10);
            }];
        }
//        //改变竖线的位置
        CGPoint xPosition = [self.aboveView getRightXPositionWithOriginXPosition:pressPosition.x];
        [self.horizontalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(xPosition.y));
        }];
        [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(xPosition.x + 10));
        }];
        [self.verticalView layoutIfNeeded];
        [self.horizontalView layoutIfNeeded];
        self.verticalView.hidden = NO;
        self.horizontalView.hidden = NO;
    }else{
        if (self.verticalView) {
            self.verticalView.hidden = YES;
        }
        if (self.horizontalView) {
            self.horizontalView.hidden = YES;
        }

        
        self.timeLineLongPressProfileView.hidden = YES;
        self.brokenLineLongPressProfileView.hidden = YES;
    }
}*/
#pragma mark - HYTimeLineAboveViewDelegate代理方法
//绘制线面的成交量图
-(void)timeLineAboveView:(UIView *)timeLineAboveView positionModels:(NSArray *)positionModels colorModels:(NSArray *)colorModels{
    NSMutableArray *xPositionArr = [NSMutableArray array];
    for (HYTimeLineAbovePositionModel *positionModel in positionModels) {
        [xPositionArr addObject:[NSNumber numberWithFloat:positionModel.currentPoint.x]];
    }
    self.belowView.xPositionArray = xPositionArr;
    self.belowView.colorArray = colorModels;
    [self.belowView drawBelowView];
}
-(void)timeLineAboveViewLongPressTimeLineModel:(HYTimeLineModel *)timeLineModel{
    if (self.frame.size.width < 450)return;
    if (self.centerViewType == HYStockChartCenterViewTypeTimeLine ) {
        self.timeLineLongPressProfileView.timeLineModel = timeLineModel;
        self.timeLineLongPressProfileView.hidden = YES;
        self.timeLineLongPressView.timeLineModel = timeLineModel;
        self.timeLineLongPressView.hidden = NO;
    }else{
        self.brokenLineLongPressProfileView.timeLineModel = timeLineModel;
        self.brokenLineLongPressView.timeLineModel = timeLineModel;
        self.brokenLineLongPressProfileView.hidden = YES;
        self.brokenLineLongPressView.hidden = NO;
    }
}
- (void)timeLineAboveViewLongPressAboveLineModel:(HYTimeLineModel *)selectedModel selectPoint:(CGPoint)selectedPoint{
    [self.belowView timeLineAboveViewLongPressAboveLineModel:selectedModel selectPoint:selectedPoint];
    
}
@end
