//  TLGameViewController.m
//  Freedom
//  Created by Super on 16/3/4.
#import "WXGameViewController.h"
@implementation WXGameViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUseMPageTitleAsNavTitle:NO];
    [self setShowLoadingProgress:NO];
    [self setDisableBackButton:YES];
    
    [self.navigationItem setTitle:@"游戏"];
    [self setUrl:@"http://m.le890.com"];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_setting"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    [SVProgressHUD showWithStatus:@"加载中"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}
#pragma mark - Delegate -
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    [super webView:webView didFinishNavigation:navigation];
}
#pragma mark - Event Response
- (void) rightBarButtonDown:(UIBarButtonItem *)sender{
    
}
@end
