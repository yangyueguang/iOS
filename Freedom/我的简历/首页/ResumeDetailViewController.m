//  ResumeDetailViewController.m
//  Freedom
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "ResumeDetailViewController.h"
@interface ResumeDetailViewController ()<UIWebViewDelegate>{
    UIWebView *webView;
}
@end
@implementation ResumeDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-TopHeight)];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.userInfo[@"url"]]]];
    [self.view addSubview:webView];
}
@end
