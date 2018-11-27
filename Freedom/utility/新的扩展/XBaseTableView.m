//
//  XBaseTableView.m
//  XianRenZhang
//
//  Created by Super on 2018/5/23.
//  Copyright © 2018年 Universal App. All rights reserved.
//
#import "XBaseTableView.h"
@implementation XBaseTableView{
   BOOL _secondReload;
}
-(instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame style:UITableViewStylePlain];
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if(self = [super initWithFrame:frame style:style]){
        self.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.01)];
        self.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        self.page = 0;
        self.hasRefreshHeaderView = YES;
        self.hasRefreshFooterView = NO;
    //    self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.emptyView = [[UIView alloc]initWithFrame:self.bounds];
        [self.emptyView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startRefresh)]];
        self.emptyView.hidden = YES;
        [self addSubview:self.emptyView];
//        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
//        }];
    }
    return self;
}
-(void)startRefresh{
    [self.refreshController startPullDownRefreshing];
}
-(void)reloadData{
    NSInteger num = [self.dataSource tableView:self numberOfRowsInSection:0];
    if(num>14){
        self.hasRefreshFooterView = YES;
    }
    if(self.dataSource && (num > 0 || ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] && [self.dataSource numberOfSectionsInTableView:self] > 1))){
        self.emptyView.hidden = YES;
    }else if(NO){//![UNUtilHelper isNetWorkReachable]
        self.emptyView.hidden = NO;
        [self bringSubviewToFront:self.emptyView];
    }else if(self.page > 0 && _secondReload){
//        self.emptyView.titilLabel.text = @"暂无数据哦~";
        self.emptyView.hidden = NO;
        [self bringSubviewToFront:self.emptyView];
        [self bringSubviewToFront:self.tableHeaderView];
    }
    _secondReload = YES;
    [super reloadData];
}
-(void)setBaseDelegate:(id<XBaseTableViewDelegate>)baseDelegate{
    _baseDelegate = baseDelegate;
    self.delegate = baseDelegate;
    self.dataSource = baseDelegate;
}
- (CLLRefreshHeadController *)refreshController {
    if (!_refreshController) {
        _refreshController = [[CLLRefreshHeadController alloc] initWithScrollView:self viewDelegate:self];
    }
    return _refreshController;
}
- (void)beginPullDownRefreshing{
    self.page = 0;
    [self loadMoreWithRefresh:YES];
}
- (void)beginPullUpLoading{
    [self loadMoreWithRefresh:NO];
}
-(void)loadMoreWithRefresh:(BOOL)refresh{
    if(NO){//![UNUtilHelper isNetWorkReachable]
        NSLog(@"网络异常!");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshController endPullDownRefreshing];
            [self.refreshController endPullUpLoading];
        });
    }else if(self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(refresh:loadMorePage:completion:)]){
        [self.baseDelegate refresh:refresh loadMorePage:++self.page completion:^BOOL(BOOL more) {
            [self.refreshController endPullDownRefreshing];
            [self.refreshController endPullUpLoading];
            NSInteger num = [self.dataSource tableView:self numberOfRowsInSection:0];
            if(!more && num > 0 && self.hasRefreshFooterView){//&& !refresh
                [self.refreshController notMoreHaveContent];
            }
            return YES;//停止成功
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshController endPullDownRefreshing];
            [self.refreshController endPullUpLoading];
        });
    }
}
- (CLLRefreshViewLayerType)refreshViewLayerType{
    if(_isRefreshOnTop){
        return CLLRefreshViewLayerTypeOnScrollViews;
    }else{
        return CLLRefreshViewLayerTypeOnSuperView;
    }
}
- (BOOL)keepiOS7NewApiCharacter{
    return YES;
}
- (BOOL)hasRefreshHeaderView{
    return _hasRefreshHeaderView;
}
- (BOOL)hasRefreshFooterView{
    return _hasRefreshFooterView;
}
-(void)removeFromSuperview{
    [super removeFromSuperview];
    if ([[UIDevice currentDevice] systemVersion].floatValue < 11.0) {
        [self.refreshController removeAllObserver];
    }
}
-(void)dealloc{

}

@end
