//  DetailViewController.m
//  WFCoretext
//  Created by Super on 14/10/28.
#import "DetailViewController.h"
#import "BookReaderViewController.h"
@interface DetailViewController ()
@end
@implementation DetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    [backBtn setTitle:@"我是返回" forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
    UIButton *pushBtn = [UIButton buttonWithType:0];
    pushBtn.frame = CGRectMake(40, 90, self.view.frame.size.width - 80, 100);
    [pushBtn setTitle:@"go to Reader" forState:0];
    pushBtn.backgroundColor = [UIColor cyanColor];
    [pushBtn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushBtn];
}
- (void)backToPre{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)push{
    BookReaderViewController *loginvctrl = [[BookReaderViewController alloc] init];
    [self presentViewController:loginvctrl animated:NO completion:nil];
    
}
@end
