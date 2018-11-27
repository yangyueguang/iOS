//  LookViewController.m
//  CLKuGou
//  Created by Darren on 16/7/29.
#define headerH 280
#import "LookViewController.h"
#import "CoustomButtom.h"
#import <MediaPlayer/MediaPlayer.h>
@interface LookViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *titlesArr;
@property (nonatomic,strong) UIView *headerView;
@end
@implementation LookViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titlesArr = @[@"繁星MV",@"明星在线",@"线下演出"];
    [self setupTableView];
}
- (UIView*)headerView{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, APPW, headerH)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];
    UIImageView *banner  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APPW, 150)];
    banner.image = [UIImage imageNamed:@"bj"];
    [_headerView addSubview:banner];
    
    CGFloat btnW = 80;
    CGFloat btnH = 100;
    CGFloat magin = (APPW-3*btnW)/4.0;
    NSArray *titleArr = @[@"MV",@"繁星直播",@"酷狗LIVE"];
    for (int i = 0; i < 3; i ++) {
        CGFloat btnX = magin + (magin + btnW)*i;
        CoustomButtom *btn = [[CoustomButtom alloc] initWithFrame:CGRectMake(btnX, banner.frameHeight+15, btnW, btnH)];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"n%d",i+1]] forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_headerView addSubview:btn];
    }
    return _headerView;
}
#pragma mark - 创建tableView
- (void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH-TabBarH+2) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = [self headerView];
    self.tableView = tableView;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.view addSubview:tableView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titlesArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *mainCellID = @"mainID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainCellID];
    }
    cell.imageView.image = [UIImage imageNamed:@"music"];
    cell.textLabel.text = self.titlesArr[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
@end
