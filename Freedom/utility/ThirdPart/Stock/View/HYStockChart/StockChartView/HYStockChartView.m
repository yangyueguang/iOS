//
//  HYStockChartView.m
//  JimuStockChartDemo
//
#import "HYStockChartView.h"
#import "KLineModel.h"
#import "HYTimeLineView.h"
#import "HYKLineView.h"
#import "TimeLineModel.h"
#import "MJExtension.h"
#import "HYStockChartProfileModel.h"
#import "HYStockChartConstant.h"
#import "StockCategory.h"
#import "HYStockChartTool.h"
@class HYStockChartProfileModel;
/************************股票概要View(在顶部的view)************************/
@interface HYStoctDefaultProfileView : UIView
@property(nonatomic,strong) HYStockChartProfileModel *profileModel;
+(HYStoctDefaultProfileView *)profileView;
@end
@interface HYStoctDefaultProfileView ()
@property (strong, nonatomic) UILabel *chineseNameLabel;
@property (strong, nonatomic) UILabel *symbolLabel;
@property (strong, nonatomic) UILabel *currentPriceLabel;
@property (strong, nonatomic) UILabel *volumeLabel;
@property (strong, nonatomic) UILabel *updateTimeLabel;
@property (strong, nonatomic) UILabel *updateDateLabel;
@property (strong, nonatomic) UILabel *appliesLabel;
@property (strong, nonatomic) UILabel *volumeNameLabel;
@end
@implementation HYStoctDefaultProfileView
+(HYStoctDefaultProfileView *)profileView{
    HYStoctDefaultProfileView *bllppView = [[HYStoctDefaultProfileView alloc]initWithFrame:CGRectMake(0, 0, APPH, HYStockChartProfileViewHeight)];
    bllppView.backgroundColor = [UIColor whiteColor];
    CGFloat width = APPH/5;
    CGFloat height = HYStockChartProfileViewHeight/2;
    bllppView.chineseNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    bllppView.symbolLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, height, width, height)];
    bllppView.currentPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, 0, width, height)];
    bllppView.appliesLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, height, width, height)];
    bllppView.volumeLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*2, 0, width, height)];
    bllppView.volumeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*2, height, width, height)];
    bllppView.updateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*3, 0, width, height)];
    bllppView.updateDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*3, height, width, height)];
    [bllppView addSubviews:bllppView.chineseNameLabel,bllppView.symbolLabel,bllppView.currentPriceLabel,bllppView.appliesLabel,bllppView.volumeLabel,bllppView.volumeNameLabel,bllppView.updateTimeLabel,bllppView.updateDateLabel,nil];
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
    self.backgroundColor = [UIColor whiteColor];
    self.chineseNameLabel.textColor = MainTextColor;
    self.currentPriceLabel.textColor = MainTextColor;
    self.volumeLabel.textColor = MainTextColor;
    self.updateTimeLabel.textColor = MainTextColor;
    self.symbolLabel.textColor = AssistTextColor;
    self.appliesLabel.textColor = AssistTextColor;
    self.volumeNameLabel.textColor = AssistTextColor;
    self.updateDateLabel.textColor = AssistTextColor;
}
-(void)setProfileModel:(HYStockChartProfileModel *)profileModel{
    _profileModel = profileModel;
    self.chineseNameLabel.text = [HYStockChartTool stockChineseName];
    self.symbolLabel.text = [HYStockChartTool stockSymbol];
    NSString *currencySymbol = [HYStockChartTool currencySymbol];
    self.currentPriceLabel.text = [NSString stringWithFormat:@"%@%.2f",currencySymbol,profileModel.CurrentPrice];
    NSString *volumeString = [NSString stringWithFormat:@"%.f",profileModel.Volume];
    if (volumeString.length >= 9 ) {
        volumeString = [NSString stringWithFormat:@"%.2f亿股",profileModel.Volume/100000000.0];
    }else{
        volumeString = [NSString stringWithFormat:@"%.2f万股",profileModel.Volume/10000.0];
    }
    self.volumeLabel.text = volumeString;
    self.appliesLabel.text = [NSString stringWithFormat:@"%.2f%%",profileModel.applies];
    UIColor *appliesTextColor = profileModel.applies > 0 ? IncreaseColor : DecreaseColor;
    self.appliesLabel.textColor = appliesTextColor;
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"HH:mm";
    self.updateTimeLabel.text = [formatter stringFromDate:[NSDate date]];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.updateDateLabel.text = [formatter stringFromDate:[NSDate date]];
}
@end
@protocol HYStockChartSegmentViewDelegate;
@interface HYStockChartSegmentView : UIView
/**
 *  通过items创建SegmentView
 */
-(instancetype)initWithItems:(NSArray *)items;
@property(nonatomic,strong) NSArray *items;
@property(nonatomic,weak) id<HYStockChartSegmentViewDelegate> delegate;
@property(nonatomic,assign) NSUInteger selectedIndex;
@end
@protocol HYStockChartSegmentViewDelegate <NSObject>
@optional
-(void)hyStockChartSegmentView:(HYStockChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index;
@end
static NSInteger const HYStockChartSegmentStartTag = 2000;
static CGFloat const HYStockChartSegmentIndicatorViewHeight = 2;
static CGFloat const HYStockChartSegmentIndicatorViewWidth = 40;
@interface HYStockChartSegmentView ()
@property(nonatomic,strong,readwrite) UIButton *selectedBtn;
@property(nonatomic,strong) UIView *indicatorView;
@end
@implementation HYStockChartSegmentView
#pragma mark - 初始化方法
#pragma mark 通过items创建SegmentView
-(instancetype)initWithItems:(NSArray *)items{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.items = items;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
#pragma mark - get方法
#pragma mark indicatorView的get方法
-(UIView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [UIView new];
        _indicatorView.backgroundColor = TimeLineLineColor;
        [self addSubview:_indicatorView];
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-HYStockChartSegmentIndicatorViewHeight);
            make.height.equalTo(@(HYStockChartSegmentIndicatorViewHeight));
            make.width.equalTo(@(HYStockChartSegmentIndicatorViewWidth));
            make.centerX.equalTo(self);
        }];
    }
    return _indicatorView;
}
#pragma mark - set方法
#pragma mark items的set方法
-(void)setItems:(NSArray *)items{
    _items = items;
    if (items.count == 0 || !items) {
        return;
    }
    NSInteger index = 0;
    NSInteger count = items.count;
    UIButton *preBtn = nil;
    for (NSString *title in items) {
        UIButton *btn = [self private_createButtonWithTitle:title tag:HYStockChartSegmentStartTag+index];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom).offset(-2);
            make.width.equalTo(self).multipliedBy(1.0f/count);
            if (preBtn) {
                make.left.equalTo(preBtn.mas_right);
            }else{
                make.left.equalTo(self);
            }
        }];
        preBtn = btn;
        index++;
    }
}
-(void)setSelectedIndex:(NSUInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    UIButton *btn = (UIButton *)[self viewWithTag:HYStockChartSegmentStartTag+selectedIndex];
    NSAssert(btn, @"Segmetn的按钮还没有初始化完毕!");
    [self event_segmentButtonClicked:btn];
}
-(void)setSelectedBtn:(UIButton *)selectedBtn{
    if (_selectedBtn == selectedBtn) {
        return;
    }
    _selectedBtn = selectedBtn;
    _selectedIndex = selectedBtn.tag - HYStockChartSegmentStartTag;
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-HYStockChartSegmentIndicatorViewHeight);
        make.height.equalTo(@(HYStockChartSegmentIndicatorViewHeight));
        make.width.equalTo(@(HYStockChartSegmentIndicatorViewWidth));
        make.centerX.equalTo(selectedBtn.mas_centerX);
    }];
    [UIView animateWithDuration:0.2f animations:^{
        [self layoutIfNeeded];
    }];
}
#pragma mark - 私有方法
#pragma mark 根据title创建一个button
-(UIButton *)private_createButtonWithTitle:(NSString *)title tag:(NSInteger)tag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor colorWithWhite:51/255.0 alpha:1] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont blackSimpleFontWithSize:13];
    btn.tag = tag;
    [btn addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}
#pragma mark - 事件执行方法
-(void)event_segmentButtonClicked:(UIButton *)btn{
    self.selectedBtn = btn;
    if (self.delegate && [self.delegate respondsToSelector:@selector(hyStockChartSegmentView:clickSegmentButtonIndex:)]) {
        [self.delegate hyStockChartSegmentView:self clickSegmentButtonIndex:btn.tag-HYStockChartSegmentStartTag];
    }
}
@end
@interface HYStockChartView ()<HYStockChartSegmentViewDelegate>
@property(nonatomic,strong) HYStoctDefaultProfileView *stockDefaultProfileView;
@property(nonatomic,strong) HYStockChartSegmentView *segmentView;
@property(nonatomic,strong) UILabel *companyNameLabel;
@property(nonatomic,strong) HYTimeLineView *timeLineView;   //分时线view
@property(nonatomic,strong) HYKLineView *kLineView;         //K线view
@property(nonatomic,strong) HYTimeLineView *brokenLineView; //折线view
@property(nonatomic,assign) HYStockChartCenterViewType currentCenterViewType;
@property(nonatomic,assign,readwrite) NSInteger currentIndex;
@end
@implementation HYStockChartView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
#pragma mark topView的get方法
-(HYStoctDefaultProfileView *)stockDefaultProfileView{
    if (!_stockDefaultProfileView) {
        _stockDefaultProfileView = [HYStoctDefaultProfileView profileView];
        [self addSubview:_stockDefaultProfileView];
        [_stockDefaultProfileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@(HYStockChartProfileViewHeight));
        }];
    }
    return _stockDefaultProfileView;
}
#pragma mark segmentView的get方法
-(HYStockChartSegmentView *)segmentView{
    if (!_segmentView) {
        _segmentView = [[HYStockChartSegmentView alloc] init];
        _segmentView.delegate = self;
        _segmentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        [self addSubview:_segmentView];
        [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.bottom.left.equalTo(self);
            make.left.equalTo(self);
            make.top.equalTo(self.stockDefaultProfileView.mas_bottom);
            make.width.equalTo(self);
            make.height.equalTo(@30);
        }];
    }
    return _segmentView;
}
#pragma mark kLineView的get方法
-(HYKLineView *)kLineView{
    if (!_kLineView) {
        _kLineView = [HYKLineView new];
        [self addSubview:_kLineView];
        [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            //make.top.equalTo(self.stockDefaultProfileView.mas_bottom);
            make.top.equalTo(self.segmentView.mas_bottom).offset(10);
            //make.bottom.equalTo(self.segmentView.mas_top);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    return _kLineView;
}
#pragma mark timeLineView的get方法
-(HYTimeLineView *)timeLineView{
    if (!_timeLineView) {
        _timeLineView = [HYTimeLineView new];
        _timeLineView.centerViewType = HYStockChartCenterViewTypeTimeLine;
        [self insertSubview:_timeLineView aboveSubview:self.stockDefaultProfileView];
        [_timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.segmentView.mas_bottom).offset(10);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    return _timeLineView;
}
#pragma mark brokenLineView的get方法
-(HYTimeLineView *)brokenLineView{
    if (!_brokenLineView) {
        _brokenLineView = [HYTimeLineView new];
        _brokenLineView.centerViewType = HYStockChartCenterViewTypeBrokenLine;
        [self insertSubview:_brokenLineView aboveSubview:self.stockDefaultProfileView];
        [_brokenLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.segmentView.mas_bottom).offset(10);
            //make.bottom.equalTo(self.segmentView.mas_top);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    return _brokenLineView;
}
#pragma mark - set方法
#pragma mark items的set方法
-(void)setItemModels:(NSArray *)itemModels{
    _itemModels = itemModels;
    if (itemModels) {
        NSMutableArray *items = [NSMutableArray array];
        for (HYStockChartViewItemModel *item in itemModels) {
            [items addObject:item.title];
        }
        self.segmentView.items = items;
        HYStockChartViewItemModel *firstModel = [itemModels firstObject];
        self.currentCenterViewType = firstModel.centerViewType;
    }
    if (self.dataSource) {
        self.segmentView.selectedIndex = 0;
    }
}
#pragma mark 设置股票简介模型
-(void)setStockChartProfileModel:(HYStockChartProfileModel *)stockChartProfileModel{
    _stockChartProfileModel = stockChartProfileModel;
    [HYStockChartTool setStockChineseName:stockChartProfileModel.ChineseName.length > 0 ? stockChartProfileModel.ChineseName : stockChartProfileModel.Name];
    [HYStockChartTool setStockSymbol:stockChartProfileModel.Symbol];
    [HYStockChartTool setStockType:stockChartProfileModel.stockType];
    //self.stockDefaultProfileView.profileModel = stockChartProfileModel;
}
#pragma mark dataSource的设置方法
-(void)setDataSource:(id<HYStockChartViewDataSource>)dataSource{
    _dataSource = dataSource;
    if (self.itemModels) {
        self.segmentView.selectedIndex = 0;
    }
}
/**
 *  重新加载数据
 */
-(void)reloadData{
    self.segmentView.selectedIndex = self.segmentView.selectedIndex;
}
#pragma mark HYStockChartSegmentViewDelegate代理方法
-(void)hyStockChartSegmentView:(HYStockChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index{
    self.currentIndex = index;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(stockDatasWithIndex:)]) {
        id stockData = [self.dataSource stockDatasWithIndex:index];
        if (!stockData) {
            return;
        }
        HYStockChartViewItemModel *itemModel = self.itemModels[index];
        HYStockChartCenterViewType type = itemModel.centerViewType;
        if (type != self.currentCenterViewType) {
            //移除原来的view，设置新的view
            self.currentCenterViewType = type;
            if (type == HYStockChartCenterViewTypeKLine) {
                self.kLineView.hidden = NO;
                self.brokenLineView.hidden = YES;
                self.timeLineView.hidden = YES;
                [self bringSubviewToFront:self.kLineView];
            }else if(HYStockChartCenterViewTypeTimeLine == type){
                self.timeLineView.hidden = NO;
                self.kLineView.hidden = YES;
                self.brokenLineView.hidden = YES;
            }else{
                self.brokenLineView.hidden = NO;
                self.kLineView.hidden = YES;
                self.timeLineView.hidden = YES;
            }
        }
        if (type == HYStockChartCenterViewTypeTimeLine) {
            NSAssert([stockData isKindOfClass:[HYTimeLineGroupModel class]], @"数据必须是HYTimeLineGroupModel类型!!!");
            HYTimeLineGroupModel *groupTimeLineModel = (HYTimeLineGroupModel *)stockData;
            self.timeLineView.timeLineGroupModel = groupTimeLineModel;
            [self.timeLineView reDraw];
        }else if(HYStockChartCenterViewTypeBrokenLine == type){
            NSAssert([stockData isKindOfClass:[HYTimeLineGroupModel class]], @"数据必须是HYTimeLineGroupModel类型!!!");
            HYTimeLineGroupModel *groupTimeLineModel = (HYTimeLineGroupModel *)stockData;
            self.brokenLineView.timeLineGroupModel = groupTimeLineModel;
            [self.brokenLineView reDraw];
        }else{
            NSArray *stockDataArray = (NSArray *)stockData;
            self.kLineView.kLineModels = stockDataArray;
            [self.kLineView reDraw];
        }
    }
}
@end
/************************ItemModel类************************/
@implementation HYStockChartViewItemModel
+(instancetype)itemModelWithTitle:(NSString *)title type:(HYStockChartCenterViewType)type{
    HYStockChartViewItemModel *itemModel = [[HYStockChartViewItemModel alloc] init];
    itemModel.title = title;
    itemModel.centerViewType = type;
    return itemModel;
}
@end
