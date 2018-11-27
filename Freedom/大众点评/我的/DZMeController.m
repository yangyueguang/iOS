//  DZMeViewController.m
//  Freedom
//  Created by Super on 15/11/28.
#import "DZMeController.h"
@interface DZMeController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_data;
}
@end
@implementation DZMeController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1.搭建UI界面
    [self buildUI];
    
    //2.读取plist文件内容
    [self loadPlist];
    
    //3.设置tableview属性
    [self buildTableView];
}
#pragma mark 设置tableview属性
-(void)buildTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //增加底部额外的滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    //去掉cell分割线
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //24bit颜色 RGB（红绿蓝）
    //32bit颜色 ARGB
}
#pragma mark 读取plist文件内容
-(void)loadPlist{
    //1.获取路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"DianpingWo" withExtension:@"plist"];
    
    //2.读取数据
    _data = [NSArray arrayWithContentsOfURL:url];
}
#pragma mark 搭建UI界面
-(void)buildUI{
    self.title = @"我的";
    
    //设置右上角按钮
    UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithRenderingOriginalName:@"personal_icon_send@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage)];
    self.navigationItem.rightBarButtonItem = send;
    //设置左上角按钮
    UIBarButtonItem *service = [[UIBarButtonItem alloc]initWithTitle:@"联系客服" style:UIBarButtonItemStylePlain target:self action:@selector(serviceAction)];
    self.navigationItem.leftBarButtonItem = service;
}
#pragma mark 弹出消息窗口
-(void)sendMessage{
    DLog(@"消息");
}
#pragma mark 联系客服
-(void)serviceAction{
    DLog(@"联系客服");
}
#pragma mark - Table View data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _data.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_data[section] count];
}
//设置tableView每组头部的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 75;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, 5)];
        //        headerView.backgroundColor = [UIColor greenColor];
        headerView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg_login"]];
        //头像
        UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 55, 55)];
        userImage.layer.masksToBounds = YES;
        userImage.layer.cornerRadius = 27;
        [userImage setImage:[UIImage imageNamed:PuserLogo]];
        [headerView addSubview:userImage];
        //用户名
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+55+5, 15, 200, 30)];
        userNameLabel.font = [UIFont systemFontOfSize:13];
        userNameLabel.text = @"风乔伊唐纳";
        [headerView addSubview:userNameLabel];
        //账户余额
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+55+5, 40, 200, 30)];
        moneyLabel.font = [UIFont systemFontOfSize:13];
        moneyLabel.text = @"余额：0.00元";
        [headerView addSubview:moneyLabel];
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(APPW-10-24, 30, 12, 24)];
        [arrowImg setImage:[UIImage imageNamed:@"icon_mine_accountViewRightArrow"]];
        [headerView addSubview: arrowImg];
        
        return headerView;
    }else{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, 5)];
        headerView.backgroundColor = RGBCOLOR(239, 239, 244);
        return headerView;
    }
    
}
#pragma mark 每当有一个新的cell进入屏幕视野范围内就会调用
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    //forIndexPath:indexPath 跟 storyboard 配套使用
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Configure the cell ...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //取出这一行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    cell.textLabel.text = dict[@"name"];
    cell.imageView.image = [UIImage imageNamed:dict[@"icon"]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
