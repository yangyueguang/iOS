//
//  XBaseTableView.h
//  XianRenZhang
//
//  Created by Super on 2018/5/23.
//  Copyright © 2018年 Universal App. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CLLRefreshHeadController.h"
@protocol XBaseTableViewDelegate<UITableViewDelegate,UITableViewDataSource>
///网络请求结束more代表是否还有更多completion要在reloadData之前做
- (void)refresh:(BOOL)refresh loadMorePage:(NSInteger)page completion:(BOOL(^)(BOOL more))completion;
@end
@interface XBaseTableView : UITableView<CLLRefreshHeadControllerDelegate>
@property(nonatomic,assign)NSInteger page;///空视图
@property(nonatomic,strong)UIView *emptyView;
@property(nonatomic,assign)BOOL hasRefreshFooterView;
@property(nonatomic,assign)BOOL hasRefreshHeaderView;
@property(nonatomic,assign)BOOL isRefreshOnTop;
@property(nonatomic,  weak)id<XBaseTableViewDelegate> baseDelegate;
@property(nonatomic,strong)CLLRefreshHeadController *refreshController;
@end
