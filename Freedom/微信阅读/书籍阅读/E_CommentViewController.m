//  E_CommentViewController.m
//  Freedom
//  Created by Super on 15/2/27.
#import "E_CommentViewController.h"
@interface E_CommentViewController ()
@end
@implementation E_CommentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    [titleLbl setText:@"评论页"];
    titleLbl.font = [UIFont systemFontOfSize:20];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLbl];
    UIButton *backBtn = [UIButton buttonWithType:0];
    backBtn.frame = CGRectMake(10, 20, 60, 44);
    [backBtn setTitle:@" 返回" forState:0];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitleColor:[UIColor blackColor] forState:0];
    [backBtn addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    UILabel *introLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 88)];
    introLbl.text = @"初始页，点击朋友圈";
    introLbl.textAlignment = NSTextAlignmentCenter;
    introLbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:introLbl];
}
- (void)backToFront{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
