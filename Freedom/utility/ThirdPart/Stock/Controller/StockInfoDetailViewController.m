//
//  StockInfoDetailViewController.m
//  RRCP
#import "StockInfoDetailViewController.h"
#import "StockNewsController.h"
#import "StockDetailHeaderView.h"
#import "HYStockChartViewController.h"
#import "HYStockChartConstant.h"
#import "StockChartTitleView.h"
@interface RecognizeSimultaneousTableView : UITableView
@end
@implementation RecognizeSimultaneousTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end
@interface StockContentView : UIView<UIScrollViewDelegate>
-(instancetype)initWithTabTitleArray:(NSArray*)titles ConfigArray:(NSArray *)tabConfigArray;//tab页配置数组
@property (nonatomic, strong) StockChartTitleView *tabTitleView;
@property (nonatomic, strong) UIScrollView *tabContentView;
@end
@implementation StockContentView
-(instancetype)initWithTabTitleArray:(NSArray*)titles ConfigArray:(NSArray *)tabConfigArray{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.frame = CGRectMake(0, 0, APPW, APPH);
        _tabTitleView = [[StockChartTitleView alloc] initWithTitleArray:titles];
        WS(weakSelf);
        _tabTitleView.titleClickBlock = ^(NSInteger row){
            if (weakSelf.tabContentView) {
                weakSelf.tabContentView.contentOffset = CGPointMake(APPW*row, 0);
            }
        };
        [self addSubview:_tabTitleView];
        _tabContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, APPW, CGRectGetHeight(self.frame)- 45)];
        _tabContentView.contentSize = CGSizeMake(CGRectGetWidth(_tabContentView.frame)* titles.count, CGRectGetHeight(_tabContentView.frame));
        _tabContentView.pagingEnabled = YES;
        _tabContentView.bounces = NO;
        _tabContentView.showsHorizontalScrollIndicator = NO;
        _tabContentView.delegate = self;
        _tabContentView.scrollEnabled = NO;
        [self addSubview:_tabContentView];
        for (int i=0; i<tabConfigArray.count; i++){
            UIView *currentView = tabConfigArray[i];
            currentView.frame = CGRectMake(i * APPW, 0, APPW, APPH - 45-TopHeight);
            [_tabContentView addSubview:currentView];
        }
    }
    return self;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger pageNum = offsetX/APPW + 0.5;
    [_tabTitleView setItemSelected:pageNum];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat page = scrollView.contentOffset.x / APPW;
    [_tabTitleView setScrollDistance:page];
}
@end
@interface StockInfoDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL _isTopIsCanNotMoveTabViewPre;
    BOOL _isTopIsCanNotMoveTabView;
    BOOL _canScroll;
    BOOL _canEnter;
}
@property (nonatomic,strong)NSMutableArray *contentViewList;
@property (nonatomic,weak)RecognizeSimultaneousTableView *tableView;
@property (nonatomic,weak)StockDetailHeaderView *stockProductHeaderView;
@end
@implementation StockInfoDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentViewList = [NSMutableArray array];
    StockNewsController *opinionVC = [StockNewsController new];//观点
    StockNewsController *newsVC = [StockNewsController new];//新闻
    StockNewsController *noticeVC = [StockNewsController new];//公告
    StockNewsController *dataVC = [StockNewsController new];//资料
    StockNewsController *tradeVC = [StockNewsController new];//交易
    NSArray *controllers = @[opinionVC,newsVC,noticeVC,dataVC,tradeVC];
    self.navigationItem.title = @"产品详情";
    self.view.backgroundColor = [UIColor whiteColor];
    RecognizeSimultaneousTableView *tableView = [[RecognizeSimultaneousTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorWithWhite:242/255.0 alpha:1];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.sectionFooterHeight = 0.0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    StockDetailHeaderView *headerView = [[StockDetailHeaderView alloc] init];
    headerView.frame = CGRectMake(0, 0, APPW, 500);
    WS(weakSelf);
    headerView.headerBlock = ^(){
        if(_canEnter == 1){
            return ;
        }
        HYStockChartViewController *stockChartVC = [HYStockChartViewController new];
        stockChartVC.isFullScreen = YES;
        [weakSelf presentViewController:stockChartVC animated:NO completion:nil];
    };
    _tableView.tableHeaderView = headerView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kLeaveTopNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canEnterDetail:) name:CanAcceptTouchNotificationName object:nil];
}
- (void)canEnterDetail:(NSNotification *)notification{
    if ([notification.object integerValue] == 1) {
        _canEnter = 1;
        self.tableView.scrollEnabled = NO;
    }else{
        _canEnter = 0;
        self.tableView.scrollEnabled = YES;
    }
}
-(void)acceptMsg : (NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return APPH-TopHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *titles = @[@"基本信息",@"当前业绩",@"股票",@"债券",@"可转债"];
    StockContentView *tabView = [[StockContentView alloc] initWithTabTitleArray:titles ConfigArray:self.contentViewList];
    [cell.contentView addSubview:tabView];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat tabOffsetY = [_tableView rectForSection:0].origin.y-TopHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
}
@end
