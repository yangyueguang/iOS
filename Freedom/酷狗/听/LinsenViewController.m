//  LinsenViewController.m
//  CLKuGou
//  Created by Darren on 16/7/29.
#define headerH 300
#import "LinsenViewController.h"
#import "LocalMusicViewController.h"
#import "CoustomButtom.h"
#import "RESideMenu.h"//自定义转场
#import <MediaPlayer/MediaPlayer.h>
typedef void(^clickLocalMusicBlock)();
@interface mainHeaderView : UIView
@property (nonatomic,copy) clickLocalMusicBlock localMusic;
@end
@interface mainHeaderView()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *bottomView;
@end
@implementation mainHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 最底层
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPW, 170)];
        self.imageView.userInteractionEnabled = YES;
        [self addSubview:self.imageView];
        //最上面
        [self setupTopButtoms];
    }
    return self;
}
- (void)setupTopButtoms{
    CGFloat btnW = 60;
    CGFloat btnH = 60;
    CGFloat magin = (APPW-4*btnW)/5.0;
    NSArray *titleArr = @[@"我喜欢",@"歌单",@"下载",@"最近"];
    for (int i = 0; i < 4; i ++) {
        CGFloat btnX = magin + (magin + btnW)*i;
        CoustomButtom *btn = [[CoustomButtom alloc] initWithFrame:CGRectMake(btnX, 30, btnW, btnH)];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setImage:[UIImage imageNamed:@"main_clock"] forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [self addSubview:btn];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, btnH + 30 + 30, APPW-20, 0.5)];
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.alpha = 0.3;
    [self addSubview:lineView];
    UIImageView *phoneimage = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lineView.frame)+15, 20, 20)];
    phoneimage.image = [UIImage imageNamed:@"main_phone"];
    [self addSubview:phoneimage];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneimage.frame)+8, phoneimage.frameY, 100, 25)];
    lable.text = @"本地音乐";
    lable.font = [UIFont systemFontOfSize:14];
    lable.textColor = [UIColor whiteColor];
    [self addSubview:lable];
    
    MPMediaQuery *everyMusic = [[MPMediaQuery alloc] init];
    NSArray *musicArr = [everyMusic items];
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(APPW-130, phoneimage.frameY, 100, 25)];
    lable2.text = [NSString stringWithFormat:@"%ld首",musicArr.count];
    lable2.font = [UIFont systemFontOfSize:12];
    lable2.textColor = [UIColor whiteColor];
    lable2.textAlignment = NSTextAlignmentRight;
    [self addSubview:lable2];
    lable2.userInteractionEnabled = YES;
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(0, lable2.frameY, APPW, lable2.frameHeight)];
    [self addSubview:lable3];
    lable3.userInteractionEnabled = YES;
    [lable3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLable2)]];
    
    UIImageView *imageArrow = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lable2.frame), lable2.frameY, 25, 25)];
    imageArrow.image = [UIImage imageNamed:@"arrow"];
    [self addSubview:imageArrow];
    // 底部
    [self setupBottonButtons];
}
- (void)setupBottonButtons{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame), APPW, 130)];
    bView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bView];
    CGFloat btnW = 80;
    CGFloat btnH = 100;
    CGFloat magin = (APPW-3*btnW)/4.0;
    NSArray *titleArr = @[@"乐库",@"电台",@"库群"];
    for (int i = 0; i < 3; i ++) {
        CGFloat btnX = magin + (magin + btnW)*i;
        CoustomButtom *btn = [[CoustomButtom alloc] initWithFrame:CGRectMake(btnX, 15, btnW, btnH)];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"n%d",i+1]] forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bView addSubview:btn];
    }
}
- (void)clickLable2{
    self.localMusic();
}
@end
@interface LinsenViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *titlesArr;
@property (nonatomic,strong) mainHeaderView *headerView;
@end
@implementation LinsenViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titlesArr = @[@"工具",@"游戏",@"推广"];
    [self setupTableView];
    [self setupRightGesture];
}
- (void)setupRightGesture{
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    leftSwipe.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:leftSwipe];
}
-(void)swipe:(UISwipeGestureRecognizer*)sender{
    [self.sideMenuViewController presentLeftMenuViewController];
}
- (mainHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[mainHeaderView alloc] initWithFrame:CGRectMake(0, 0, APPW, headerH)];
    }return _headerView;
}
#pragma mark - 创建tableView
- (void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH-TabBarH+2) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    tableView.tableFooterView = [UIView new];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bj"]];
    tableView.backgroundView.contentMode = UIViewContentModeRedraw;
    tableView.tableHeaderView = self.headerView;
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.view addSubview:tableView];
    
    UIView *viewtab = [[UIView alloc] initWithFrame:CGRectMake(0, headerH+44*self.titlesArr.count, APPW, 500)];
    viewtab.backgroundColor = [UIColor whiteColor];
    [tableView addSubview:viewtab];
    
    // 访问系统本地音乐
    WS(weakSelf);
    self.headerView.localMusic = ^{
        LocalMusicViewController *localVC = [[LocalMusicViewController alloc] init];
        [weakSelf.navigationController pushViewController:localVC animated:NO];
    };
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
