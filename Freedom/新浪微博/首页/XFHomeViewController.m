
#import "XFHomeViewController.h"
#import "XFTitleMenuViewController.h"
#import "XFAccount.h"
#import "XFAccountTool.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "XFHomeViewController+Views.h"
@interface XFHomeViewController ()<XFDropdownViewDelegate,UITableViewDataSource,UITableViewDelegate>
//微博数组（里面放的都是XFStatusFrame模型，一个XFStatusFrame对象就代表一条微博）
@property (nonatomic,strong) NSMutableArray *statusFrames;
@property (nonatomic,strong) NSMutableArray *refreshArray;
@end
@implementation XFHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = gradcolor;
    self.statusFrames  = [NSMutableArray array];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:PpersonAdd  heighlightImage:PpersonAddHL];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:Pscan  heighlightImage:Pscan_y];
    // 设置图片和文字
    NSString *name = [XFAccountTool account].name;
    XFTitleButton *homePageBtn = [[XFTitleButton alloc]init];
    [homePageBtn setTitle:name?name:@"首页" forState:UIControlStateNormal];
    [homePageBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = homePageBtn;
    //设置昵称
    // https://api.weibo.com/2/users/show.json
    // access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
    // uid	false	int64	需要查询的用户ID。
    NSString *url = @"https://api.weibo.com/2/users/show.json";
    XFAccount *account = [XFAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    [Net GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        // 设置名字
        NSString *name = responseObject[@"name"];
        [titleButton setTitle:name forState:UIControlStateNormal];
        // 存储昵称到沙盒中
        account.name = name;
        [XFAccountTool saveAccount:account];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        DLog(@"请求失败");
    }];
    [self refreshData]; //刷新数据
    XFLoadMoreFooter *load = [[XFLoadMoreFooter alloc]init];
    load.hidden = YES;
    self.tableView.tableFooterView = load;//上拉刷新,获取更多数据
    NSTimer *timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];//获取未读数
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes]; // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
}
//  获得未读数
-(void)setupUnreadCount {
    // 1.请求管理者// 2.拼接请求参数
    XFAccount *account = [XFAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    // 3.发送请求
    [NetBase GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // NSNumber --> NSString
        // 设置提醒数字(微博的未读数)
        NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) { // 如果是0，得清空数字
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else { // 非0情况
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         DLog(@"请求失败-%@", error);
    }];
}
 //刷新数据
-(void)refreshData {
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self action:@selector(refreshStatus:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    //进来就开始刷新
    [refresh beginRefreshing];
    //一进来就开始加载微博
    [self refreshStatus:refresh];
}
/*将HWStatus模型转为HWStatusFrame模型*/
-(NSArray *)stausFramesWithStatuses:(NSArray *)statuses{
    NSMutableArray *frames = [NSMutableArray array];
    for (XFStatus *status in statuses) {
        XFStatusFrame *f = [[XFStatusFrame alloc] init];
        f.status = status;
        [frames addObject:f];
    }
    return frames;
}
/*UIRefreshControl进入刷新状态：加载最新的数据*/
-(void)refreshStatus:(UIRefreshControl *)control {
    NSString *url = @"https://api.weibo.com/2/statuses/friends_timeline.json";
     XFAccount *account = [XFAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    // 取出最前面的微博（最新的微博，ID最大的微博）
    XFStatusFrame *firstStatusF = [self.statusFrames firstObject];
    if (firstStatusF) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatusF.status.idstr;
    }
    [NetBase GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [XFStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        // 将 XFStatus数组 转为 XFStatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:indexSet];
        [self.tableView reloadData];
        [control endRefreshing];
        //显示微博刷新数
        [self showStatusCount:(int)newStatuses.count];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         DLog(@"请求失败-%@", error);
    }];
}
//显示微博刷新数
-(void)showStatusCount:(int)count {
    // 刷新成功(清空图标数字)
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.frameWidth = [UIScreen mainScreen].bounds.size.width;
    label.frameHeight = 35;
    label.frameY = 64 - label.frameHeight;
    if (count) {
        label.text = [NSString stringWithFormat:@"有%d条微博更新了",count];
    }else{
        label.text = @"没有新的微博";
    }
    //添加label
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    //出来的动画
    [UIView animateWithDuration:1.0 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, label.frameHeight);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}
-(void)titleClick:(UIButton *)titleButton{
    XFDropdownView *dropMenu = [XFDropdownView menu];
    dropMenu.delegate = self;
    XFTitleMenuViewController *vc = [[XFTitleMenuViewController alloc]init];
    vc.view.frameHeight = 200;
   //下拉列表的控制器
    dropMenu.contentController = vc;
    //显示
    [dropMenu showFrom:titleButton];
}
// 加载更多的微博数据
-(void)loadMoreStatus {
    // 1.请求管理者// 2.拼接请求参数
    XFAccount *account = [XFAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    // 取出最后面的微博（最新的微博，ID最大的微博）
    XFStatusFrame *lastStatusF = [self.statusFrames lastObject];
    if (lastStatusF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatusF.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    // 3.发送请求
    [NetBase GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [XFStatus mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        // 将 HWStatus数组 转为 HWStatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"请求失败-%@", error);
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
    }];
}
- (void)friendSearch{
    DLog(@"friendSearch");
}
- (void)pop{
    DLog(@"pop");
}
#pragma mark XFDropdownViewDelegate代理方法
/*下拉菜单被销毁了*/
- (void)dropdownMenuDidDismiss:(XFDropdownView *)menu{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
}
/*下拉菜单显示了*/
- (void)dropdownMenuDidShow:(XFDropdownView *)menu{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusFrames.count;
}
//数据源
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFStatusViewCell *cell = [XFStatusViewCell cellWithTableView:tableView];
    cell.statusFrame = self.statusFrames[indexPath.row];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.statusFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.frameHeight - self.tableView.tableFooterView.frameHeight;
    if (offsetY >= judgeOffsetY) {
        self.tableView.tableFooterView.hidden = NO;
        [self loadMoreStatus];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFStatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
}
@end
