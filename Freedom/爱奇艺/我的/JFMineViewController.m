//  JFMineViewController.m
//  Freedom
//  Created by Freedom on 15/10/9.//  项目详解：
//  github:https://github.com/tubie/JFTudou
//  简书：http://www.jianshu.com/p/2156ec56c55b
#import "JFMineViewController.h"
#import "JFWatchRecordViewController.h"
#import "JFLoginViewController.h"
@interface JFMineViewController ()
@end
@implementation JFMineViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"我的";
    
    
    [self setNav];
    [self initViews];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    
}
-(void)setNav{
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPW, 147)];
    [backImage setImage:[UIImage imageNamed:@"morentu"]];
    [self.view addSubview:backImage];
    //
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 107, APPW, 40)];
    backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"titlebar"]];
    [self.view addSubview:backView];
    //
    //设置
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(APPW-30, 30, 22, 22)];
    [settingBtn setImage:[UIImage imageNamed:Pwsetting] forState:UIControlStateNormal];
    [self.view addSubview:settingBtn];
    //消息
    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    msgBtn.frame = CGRectMake(APPW-60, 30, 22, 22);
    [msgBtn setImage:[UIImage imageNamed:Pwbell] forState:UIControlStateNormal];
    //    [msgBtn addTarget:self action:@selector(OnHisBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:msgBtn];
    //头像
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 50, 50)];
    userImage.userInteractionEnabled = YES;
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = 25;
    userImage.image = [UIImage imageNamed:PuserLogo];
    [self.view addSubview:userImage];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGROnIconClick)];
    [userImage addGestureRecognizer:tapGR];
    
    //登陆
    UILabel *loginLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImage.frame)+10, 30, 100, 30)];
    loginLable.textColor = [UIColor whiteColor];
    loginLable.font = [UIFont systemFontOfSize:14];
    loginLable.text = @"马上登陆";
    [self.view addSubview:loginLable];
    //
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImage.frame)+10, 60, 100, 20)];
    msgLabel.text = @"登陆后更精彩";
    msgLabel.textColor = [UIColor whiteColor];
    msgLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:msgLabel];
}
-(void)initViews{
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 150, APPW, APPH-150-49)];
    [backImage setImage:[UIImage imageNamed:@"cache_no_data"]];
    backImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:backImage];
    //
    NSArray *titleArrar = @[@"历史",@"收藏",@"上传",@"特权"];
    NSArray *picArray = @[Pwhistory,Pwfavourite,Pwcamera,Pwvip];
    for (int i = 0; i < 4; i++) {
        UIButton *segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        segmentBtn.tag = i;
        segmentBtn.frame = CGRectMake(APPW/4*i, 107, APPW/4, 40);
        [segmentBtn setImage:[UIImage imageNamed:picArray[i]] forState:UIControlStateNormal];
        [segmentBtn setTitle:titleArrar[i] forState:UIControlStateNormal];
        [segmentBtn addTarget:self action:@selector(segmentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:segmentBtn];
    }
}
-(void)segmentBtn:(UIButton *)sender{
    if (sender.tag == 0) {
        JFWatchRecordViewController *watchRecordVC = [[JFWatchRecordViewController alloc]initWithNibName:@"JFWatchRecordViewController" bundle:nil];
        [self.navigationController pushViewController:watchRecordVC animated:YES];
    }
}
-(void)tapGROnIconClick{
    JFLoginViewController *loginVC = [[JFLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
