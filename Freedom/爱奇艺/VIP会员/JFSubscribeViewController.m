//  JFSubscribeViewController.m
//  Freedom
//  Created by Freedom on 15/10/9.//  项目详解：
//  github:https://github.com/tubie/JFTudou
//  简书：http://www.jianshu.com/p/2156ec56c55
#import "JFSubscribeViewController.h"
#import "JFVideoDetailViewController.h"
#import "JFSubscribeCell.h"
@interface JFSubscribeViewController ()<UITableViewDataSource,UITableViewDelegate,JFSubscribeCellDelagate>{
    NSMutableArray *_dataSource;
}
@property (nonatomic, strong) UITableView *subscribeTableView;
@end
@implementation JFSubscribeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initView];
    [self setUpRefresh];
    
}
#pragma mark - 设置普通模式下啦刷新
-(void)setUpRefresh{
    self.subscribeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    [self.subscribeTableView.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
-(void)initNav{
    self.title = @"订阅推荐";
    _dataSource = [[NSMutableArray alloc] init];
}
-(void)initData{
    NSString *urlStr = [[FreedomTools sharedManager]urlWithSubscribeData];
    
    [NetBase GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.subscribeTableView.mj_header endRefreshing];
        NSMutableArray *array = [responseObject objectForKey:@"results"];
        for (int i = 0; i < array.count; i++) {
            JFSubscribeModel *subM = [JFSubscribeModel mj_objectWithKeyValues:array[i]];
            [_dataSource addObject:subM];
            
        }
        [self.subscribeTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
-(void)initView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH  -64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    //将系统的Separator左边不留间隙
    tableView.separatorInset = UIEdgeInsetsZero;
    self.subscribeTableView =  tableView;
    [self.view addSubview:self.subscribeTableView];
    
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 215;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"JFSubscribeCell";
    JFSubscribeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[JFSubscribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.delegate = self;
    
    JFSubscribeModel *subM = [_dataSource objectAtIndex:indexPath.row];    
    [cell setSubscribeM:subM];
    
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didSelectSubscribeCell:(JFSubscribeCell *)subCell subItem:(JFSubItemModel *)subItem{
    JFVideoDetailViewController *videoDetailVC = [[JFVideoDetailViewController alloc]init];
    videoDetailVC.iid = subItem.code;
    [self.navigationController pushViewController:videoDetailVC animated:YES];
    
}
/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
