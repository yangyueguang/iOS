//  JFSearchHistoryViewController.m
//  Freedom
//  Created by Freedom on 15/9/21.//  项目详解：
//  github:https://github.com/tubie/JFTudou
//  简书：http://www.jianshu.com/p/2156ec56c55b
#import "JFSearchHistoryViewController.h"
@interface JFSearchTextField : UITextField
@end
@implementation JFSearchTextField
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholder = @"大家都在搜琅琊榜";
        self.font = [UIFont systemFontOfSize:16];
        
        UIImage *image = [UIImage imageNamed:@"GroupCell"];
        self.background = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        
        //设置文边框左边专属View
        UIImageView *leftView = [[UIImageView alloc] init];
        leftView.bounds = CGRectMake(0, 0, 35  , 35);
        //        leftView.contentMode = UIViewContentModeCenter;
        
        leftView.image = [UIImage imageNamed:Psearch_small];
        
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return self;
}
@end
@interface JFSearchHotCell : UITableViewCell
@property(nonatomic, strong)NSArray *array;
+ (instancetype)cellWithTableView:(UITableView *)tableView ;
@end
@interface JFSearchHotCell ()
@property(nonatomic, strong)UIButton *button;
@property (nonatomic , strong)NSArray *hotDatas;
@property(nonatomic, strong) NSIndexPath *indexPath;
@end
@implementation JFSearchHotCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"JFSearchHotCell";
    JFSearchHotCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[JFSearchHotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setArray:(NSArray *)array{
    _array = array;
    NSInteger buttons = array.count;
    CGFloat margin = 10;
    CGFloat buttonW = (APPW - (buttons +1 ) * margin)/buttons;
    for (int i = 0 ; i < array.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button = button;
        button.frame = CGRectMake( margin + i * (buttonW +margin) , 5, buttonW   , 40);
        NSString *buttontitle = array[i];
        
        [button setTitle:buttontitle forState:UIControlStateNormal];
        [self addSubview:button];
    }
    
}
@end
@interface JFSearchHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *searchHistoryLabel;
- (IBAction)cancelSearchBtnClick:(id)sender;
+ (instancetype)cellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath atNSMutableArr:(NSMutableArray *)datas;
/** 底部的线 */
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
/** 记录自己是哪个数据 */
@property (nonatomic, weak) NSIndexPath *indexPath;
/** 记录模型数据 */
@property (nonatomic, weak) NSMutableArray *hisDatas;
/** 记录tableView */
@property (nonatomic, weak) UITableView *tableView;
@end
@implementation JFSearchHistoryCell
+ (instancetype)cellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath atNSMutableArr:(NSMutableArray *)datas{
    static NSString *identifier = @"historyCell";
    JFSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[JFSearchHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.searchHistoryLabel = cell.textLabel;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [cell.accessoryView addSubview:button];
        [button addTarget:self action:@selector(cancelSearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.tableView = tableView;
    cell.hisDatas = datas;
    cell.indexPath = indexPath;
    return cell;
}
- (IBAction)cancelSearchBtnClick:(id)sender {
    [self.hisDatas removeObjectAtIndex:self.indexPath.row];
    [self.hisDatas writeToFile:JFSearchHistoryPath  atomically:YES];
    [self.tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
@end
@interface JFsearchHeaderView : UIView
+ (instancetype)headViewWithTableView:(UITableView *)tableView ;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@end
@implementation JFsearchHeaderView
+ (instancetype)headViewWithTableView:(UITableView *)tableView {
    static NSString *ID = @"JFsearchHeaderView";
    JFsearchHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (headView == nil) {
        // 从xib中加载cell
        headView = [[JFsearchHeaderView alloc]initWithFrame:CGRectMake(0, 0, APPW, 40)];
        headView.TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 20)];
        headView.TitleLabel.text = @"label";
        [headView addSubview:headView.TitleLabel];
        //        headView = [[[NSBundle mainBundle] loadNibNamed:@"JFsearchHeaderView" owner:nil options:nil] lastObject];
    }
    headView.backgroundColor = RGBCOLOR(200, 199, 204);
    return headView;
}
@end
@interface JFSearchHistoryViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property(nonatomic ,strong)UITableView *searchTableView;
/** 搜索文本框 */
@property (nonatomic, weak) JFSearchTextField *searchTF;
/** 搜索的tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 搜索的数据 */
@property (nonatomic, strong) NSMutableArray *datas;
/** 历史搜索数据 */
@property (nonatomic, strong) NSMutableArray *hisDatas;
/** 热门数据模型 */
@property (nonatomic, strong) NSArray *hotDatas;
@end
@implementation JFSearchHistoryViewController
- (NSMutableArray *)hisDatas{
    if (_hisDatas == nil) {
        _hisDatas = [NSMutableArray arrayWithContentsOfFile:JFSearchHistoryPath];
        if (_hisDatas == nil) {
            _hisDatas = [NSMutableArray arrayWithObjects:@"优衣库", nil];
        }
    }
    return _hisDatas;
}
- (NSArray *)hotDatas{
    if (_hotDatas == nil) {
        _hotDatas = @[@"琅琊榜" , @"奔跑吧兄弟"];
    }
    return _hotDatas;
}
/** 模拟数据,懒加载方法 */
- (NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
        if (self.hisDatas.count) {
            [_datas addObject:self.hisDatas];
        }
        //热点搜索，估计服务器每次返回四个字符串
        [_datas addObject:self.hotDatas];
        
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;//用push方法推出时，Tabbar隐藏
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH  -64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    //将系统的Separator左边不留间隙
    tableView.separatorInset = UIEdgeInsetsZero;
    self.searchTableView = tableView;
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.searchTableView];
    JFSearchTextField *search = [[JFSearchTextField alloc] init];
    CGFloat w = APPW * 0.7;
    search.frame = CGRectMake(0, 0, w, 30);
    search.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:search];
    self.searchTF = search;
    //取消按钮
    UIBarButtonItem *rightItem = [UIBarButtonItem initWithTitle:@"取消" titleColor:[UIColor whiteColor] target:self action:@selector(backClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)viewDidAppear:(BOOL)animated{
    //文本框获取焦点
    [super viewDidAppear:animated];
    [self.searchTF becomeFirstResponder];
    
}
-(void)backClick{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
//监听手机键盘点击搜索的事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //判断是否有输入,有值的话将新的字符串添加到datas[0]中并且重新写入文件，发送网络请求
    /* 发送请求 */
    if (textField.text.length) {
        for (NSString *text in self.hisDatas) {
            if ([text isEqualToString:textField.text]) {
                return YES;
            }
        }
        [self.hisDatas insertObject:textField.text atIndex:0];
        [self.hisDatas writeToFile:JFSearchHistoryPath atomically:YES];
        [self.tableView reloadData];
        textField.text = @"";
    }
    return YES;
}
#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.datas.count == 2) {
        if (section == 0) {return [self.datas[0] count];
        } else {return 1;}
    } else {
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.datas.count == 2 && indexPath.section == 0 && self.hisDatas.count) {
        JFSearchHistoryCell *cell = [JFSearchHistoryCell cellWithTableView:tableView IndexPath:indexPath atNSMutableArr:self.hisDatas];
        cell.searchHistoryLabel.text = self.datas[0][indexPath.row];
        return cell;
    } else {
        //这里就一个cell 不用注册了
        JFSearchHotCell *cell = [JFSearchHotCell cellWithTableView:tableView ];
        cell.array = self.hotDatas;
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JFsearchHeaderView *headerView = [JFsearchHeaderView headViewWithTableView:tableView];
    if (self.hisDatas.count) {
        if (section == 0) {
            headerView.TitleLabel.text = @"历史";
        } else {
            headerView.TitleLabel.text = @"热门";
        }
    } else {
        headerView.TitleLabel.text = @"热门";
    }
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
@end
