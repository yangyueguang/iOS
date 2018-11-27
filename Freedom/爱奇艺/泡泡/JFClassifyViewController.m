//  JFClassifyViewController.m
//  Freedom
//  Created by Freedom on 15/10/9.
#import "JFClassifyViewController.h"
#import "JFWebViewController.h"
@interface JFClassifyModel : NSObject
@property(nonatomic, strong) NSString *normal_icon_for_ipad_v_4;
@property(nonatomic, strong) NSNumber *top_state;
@property(nonatomic, strong) NSString *selected_icon_for_v_4;
@property(nonatomic, strong) NSMutableArray *tabs;
@property(nonatomic, strong) NSString *image_at_bottom;
@property(nonatomic, strong) NSNumber *the_whole_state;
@property(nonatomic, strong) NSNumber *display_flag;
@property(nonatomic, strong) NSString *selected_icon;
@property(nonatomic, strong) NSNumber *label_top_state;
@property(nonatomic, strong) NSString *selected_icon_for_apad_v_4;
@property(nonatomic, strong) NSString *normal_icon_for_apad_v_4;
@property(nonatomic, strong) NSNumber *choiceness_state;
@property(nonatomic, strong) NSNumber *is_listing;
@property(nonatomic, strong) NSString *redirect_type;
@property(nonatomic, strong) NSNumber *channel_order_for_pad;
@property(nonatomic, strong) NSString *icon;
@property(nonatomic, strong) NSString *image_at_top;
@property(nonatomic, strong) NSNumber *show_operation;
@property(nonatomic, strong) NSNumber *display_flag_bak;
@property(nonatomic, strong) NSString *selected_icon_for_ipad_v_4_1_plus;
@property(nonatomic, strong) NSNumber *tagType;
@property(nonatomic, strong) NSMutableArray *label_tops;
@property(nonatomic, strong) NSNumber *tabs_state;
@property(nonatomic, strong) NSString *young_app_launcher;
@property(nonatomic, strong) NSString *normal_icon_for_v_4;
@property(nonatomic, strong) NSString *head_icon_for_ipad_in_channel;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *cid;
@property(nonatomic, strong) NSString *selected_icon_for_ipad_v_4;
@property(nonatomic, strong) NSString *default_order_by;
@property(nonatomic, strong) NSNumber *firstTagId;
@property(nonatomic, strong) NSString *url_for_more_link;
@end
@implementation JFClassifyModel
@end
@interface JFClassifyCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic, strong)JFClassifyModel *classifyModel;
@end
@implementation JFClassifyCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"JFClassifyCell";
    JFClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[JFClassifyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setClassifyModel:(JFClassifyModel *)classifyModel{
    _classifyModel = classifyModel;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:classifyModel.image_at_bottom] placeholderImage:[UIImage imageNamed:@"home_GaoXiao"]];
    self.textLabel.text = classifyModel.name;
    
}
@end
@interface JFClassifyViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *_dataSource;
      NSString *urlStr;
}
@property (nonatomic, strong)UITableView *classifyTableView;
@end
@implementation JFClassifyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    urlStr = [[FreedomTools sharedManager]urlWithclassifyData];
     _dataSource = [[NSMutableArray alloc] init];
    [self initView];
    [self setUpRefresh];
}
#pragma mark - 设置普通模式下啦刷新
-(void)setUpRefresh{
    self.classifyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    [self.classifyTableView.mj_header beginRefreshing];
}
-(void)initData{
   
  
    [NetBase GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.classifyTableView.mj_header endRefreshing];
        [_dataSource removeAllObjects];
        NSMutableArray *array = [responseObject objectForKey:@"results"];
        for (int i = 0; i < array.count; i++) {
            JFClassifyModel *classM = [JFClassifyModel mj_objectWithKeyValues:array[i]];
            [_dataSource addObject:classM];
        }
        [self.classifyTableView reloadData];
    } failure:nil];
    
}
-(void)initView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH  -64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    //将系统的Separator左边不留间隙
    tableView.separatorInset = UIEdgeInsetsZero;
    self.classifyTableView =  tableView;
    [self.view addSubview:self.classifyTableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataSource) {
        return _dataSource.count;
    }else{
        return 0;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JFClassifyCell *cell = [JFClassifyCell cellWithTableView:tableView];
    if (_dataSource) {
        cell.classifyModel = [_dataSource objectAtIndex:indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JFWebViewController *webVC = [[JFWebViewController alloc]init];
    webVC.urlStr = [[FreedomTools sharedManager]urlWithJianShuData];
    [self.navigationController pushViewController:webVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
