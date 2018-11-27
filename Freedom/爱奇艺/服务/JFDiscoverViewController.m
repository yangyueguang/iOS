//  JFDiscoverViewController.m
//  Freedom
//  Created by Freedom on 15/10/9.//  项目详解：
//  github:https://github.com/tubie/JFTudou
//  简书：http://www.jianshu.com/p/2156ec56c55b
#import "JFDiscoverViewController.h"
#import "JFImageScrollCell.h"
#import "JFSearchHistoryViewController.h"
#import "JFVideoDetailViewController.h"
#import "JFWebViewController.h"
@interface JFDiscoverModel : NSObject
@property(nonatomic, strong) NSNumber *group_number;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) NSString *skip_url;
@property(nonatomic, strong) NSString *sub_title;
@property(nonatomic, strong) NSString *module_icon;
@property(nonatomic, strong) NSString *sub_type;
@property(nonatomic, strong) NSNumber *group_location;
@end
@implementation JFDiscoverModel
@end
@class JFDiscoverModel;
@interface JFDiscoverCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic, strong)JFDiscoverModel *discoverModel;
@end
@implementation JFDiscoverCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"JFDiscoverCell";
    JFDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[JFDiscoverCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setDiscoverModel:(JFDiscoverModel *)discoverModel{
    _discoverModel = discoverModel;
    self.textLabel.text = discoverModel.title;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:discoverModel.module_icon]  placeholderImage:[UIImage imageNamed:PcustomService_y]];
}
@end
@interface JFDiscoverViewController ()<UITableViewDataSource, UITableViewDelegate,JFImageScrollViewDelegate>{
    NSMutableArray *_dataSource;
    NSMutableArray *_imageArray;
    UILabel *_searchLabel;
}
@property(nonatomic, strong)UITableView *discoverTableView;
@end
@implementation JFDiscoverViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat w = APPW * 0.8;
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.imageView.contentMode = UIViewContentModeCenter;
    searchButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    searchButton.frame = CGRectMake(0, 0, w, 30);
    [searchButton setBackgroundImage:[UIImage imageNamed:@"GroupCell"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:Psearch_small] forState:UIControlStateNormal];
    [searchButton setTitle:@"请输入：港囧，夏洛特烦恼，徐峥等" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    //取消按钮
    UIBarButtonItem *rightItem = [UIBarButtonItem initWithNormalImage:Pwnavi target:self action:nil width:25 height:25];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH  -64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    //将系统的Separator左边不留间隙
    tableView.separatorInset = UIEdgeInsetsZero;
    self.discoverTableView = tableView;
    [self.view addSubview:self.discoverTableView];
    
    self.discoverTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _dataSource = [[NSMutableArray alloc] init];
        _imageArray = [[NSMutableArray alloc] init];
        NSString *urlStr =[[FreedomTools sharedManager]urlWithDiscoverData];
        [NetBase GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.discoverTableView.mj_header endRefreshing];
            NSString *hotWord = [responseObject objectForKey:@"search_hot_word"];
            NSString *WordAd = [responseObject objectForKey:@"search_word_ad"];
            _searchLabel.text = [NSString stringWithFormat:@"%@:%@",WordAd,hotWord];
            [_dataSource removeAllObjects];
            NSMutableArray *resultArray = [responseObject objectForKey:@"results"];
            for (int i = 0; i < resultArray.count; i++) {
                JFDiscoverModel *disM = [JFDiscoverModel mj_objectWithKeyValues:resultArray[i]];
                [_dataSource addObject:disM];
                if (i == 0) {
                    [_imageArray removeAllObjects];
                    NSMutableArray *imgArr = disM.items;
                    for (int j = 0; j < imgArr.count; j++) {
                        NSString *picStr = [imgArr[j] objectForKey:@"image_350_1408"];
                        [_imageArray addObject:picStr];
                    }
                }
            }
            [self.discoverTableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
      
    }];
    [self.discoverTableView.mj_header beginRefreshing];
}
-(void)searchButtonClick{
    JFSearchHistoryViewController *searchVC = [[JFSearchHistoryViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 280;
    }else{
        return 40;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        JFImageScrollCell *cell = [JFImageScrollCell cellWithTableView:tableView frame:CGRectMake(0, 0, APPW,280)];
        [cell setImageArray:_imageArray];
        cell.imageScrollView.delegate = self;
        return cell;
    }else{
        JFDiscoverCell *cell = [JFDiscoverCell cellWithTableView:tableView];
        cell.discoverModel = _dataSource[indexPath.row];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0 ) {
        JFWebViewController *webVC = [[JFWebViewController alloc]init];
        webVC.urlStr = [[FreedomTools sharedManager]urlWithJianShuData];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}
#pragma mark - JFImageScrollViewDelegate
-(void)didSelectImageAtIndex:(NSInteger)index{
    JFDiscoverModel *disM = _dataSource[0];
    NSString *code = [disM.items[index] objectForKey:@"video_id"];
    JFVideoDetailViewController  *videoVC = [[JFVideoDetailViewController alloc] init];
    videoVC.iid = code;
    [self.navigationController pushViewController:videoVC animated:YES];
}
@end
