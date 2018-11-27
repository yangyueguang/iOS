//  SingViewController.m
//  CLKuGou
//  Created by Darren on 16/7/29.
#import "SingViewController.h"
#import "RESideMenu.h"
#import "KugouRightSettingViewController.h"
@interface SingViewController ()
@end
@implementation SingViewController
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRightGesture];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}
- (void)setupRightGesture{
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipe.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:leftSwipe];
}
-(void)swipe:(UISwipeGestureRecognizer*)sender{
    [self.sideMenuViewController presentRightMenuViewController];
}
-(void)initUI{
    UIImageView *banner = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, APPW, 150)];
    banner.image = [UIImage imageNamed:@"bj"];
    
    UIButton *fujin = [[UIButton alloc]initWithFrame:CGRectMake(0, banner.frameY+banner.frameHeight+ 20, APPW/2, 80)];
    [fujin addTarget:self action:@selector(fujin) forControlEvents:UIControlEventTouchUpInside];
    [fujin setTitle:@"附近" forState:UIControlStateNormal];
    UIButton *paihang = [[UIButton alloc]initWithFrame:CGRectMake(fujin.frameWidth, fujin.frameY, fujin.frameWidth, fujin.frameHeight)];
    [paihang addTarget:self action:@selector(paihang) forControlEvents:UIControlEventTouchUpInside];
    [paihang setTitle:@"排行" forState:UIControlStateNormal];
    UIButton *guanzhu = [[UIButton alloc]initWithFrame:CGRectMake(fujin.frameX, fujin.frameY+fujin.frameHeight, fujin.frameWidth, fujin.frameHeight)];
    [guanzhu addTarget:self action:@selector(guanzhu) forControlEvents:UIControlEventTouchUpInside];
    [guanzhu setTitle:@"关注" forState:UIControlStateNormal];
    UIButton *wode = [[UIButton alloc]initWithFrame:CGRectMake(guanzhu.frameWidth, guanzhu.frameY, fujin.frameWidth, fujin.frameHeight)];
    [wode addTarget:self action:@selector(wode) forControlEvents:UIControlEventTouchUpInside];
    [wode setTitle:@"我的" forState:UIControlStateNormal];
    
    UIButton *woyaochang = [[UIButton alloc]initWithFrame:CGRectMake((APPW-100)/2,guanzhu.frameY-50, 100, 100)];
    woyaochang.layer.cornerRadius = 50;
    woyaochang.backgroundColor = [UIColor redColor];
    [woyaochang setTitle:@"我要唱" forState:UIControlStateNormal];
    [woyaochang addTarget:self action:@selector(woyaochang) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *cell = [[UIView alloc]initWithFrame:CGRectMake(0, guanzhu.frameY+guanzhu.frameHeight, APPW, 60)];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 40, 40)];
    icon.image = [UIImage imageNamed:@""];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(icon.frameX+icon.frameWidth,icon.frameY, 100, 40)];
    textLabel.text = @"大赛";
    UILabel *accessoryText = [[UILabel alloc]initWithFrame:CGRectMake(APPW-200, icon.frameY, 200, 40)];
    accessoryText.text = @"参与K歌大赛，赢取丰厚好礼";
    UIButton *cellBtn = [[UIButton alloc]initWithFrame:cell.frame];
    [cellBtn addTarget:self action:@selector(cell) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:icon];
    [cell addSubview:textLabel];
    [cell addSubview:accessoryText];
    [cell addSubview:cellBtn];
    
    [self.view addSubview:banner];
    [self.view addSubview:fujin];
    [self.view addSubview:guanzhu];
    [self.view addSubview:paihang];
    [self.view addSubview:wode];
    [self.view addSubview:woyaochang];
    [self.view addSubview:cell];
    self.view.backgroundColor = [UIColor grayColor];
    
}
-(void)fujin{
    
}
-(void)paihang{
    
}
-(void)guanzhu{
    
}
-(void)wode{
    
}
-(void)woyaochang{
    
}
-(void)cell{
    
}
@end
