//  EnergyDetailViewController.m
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "EnergyDetailViewController.h"
@implementation EnergyDetailViewController{
    UIWebView *web;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"http://weibo.com/tv/v/ErlcFmAdZ?from=vhot"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    web = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [web loadRequest:request];
    [self.view addSubview:web];
}
@end
