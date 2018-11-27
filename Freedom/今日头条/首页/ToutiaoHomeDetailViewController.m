//  ToutiaoHomeDetailViewController.m
//  Created by Super on 17/2/7.
//  Copyright © 2017年 Super. All rights reserved.
//
#import "ToutiaoHomeDetailViewController.h"
@interface ToutiaoHomeDetailViewController ()<UIWebViewDelegate>{
    UIWebView *webView;
    NSString *dataurl;
    NSString *title;
}
@end
@implementation ToutiaoHomeDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-TopHeight)];
    webView.delegate = self;
    DLog(@"%@",self.userInfo);
    webView.backgroundColor = [UIColor whiteColor];
    dataurl = [self.userInfo valueForJSONKey:@"rawUrl"];
    title = [self.userInfo valueForJSONStrKey:@"title"];
    NSString *s = [NSString stringWithContentsOfURL:[NSURL URLWithString:dataurl] encoding:NSUTF8StringEncoding error:nil];
    NSString *pattern = [NSString stringWithFormat:@"<body>(.*?)<div class=\"container\">"];
    NSString *content = [s firstMatchWithPattern:pattern];
    pattern = [NSString stringWithFormat:@"<div id=\"SOHUCS\"(.*?)<script"];
    NSString *content1 = [NSString stringWithFormat:@"<div id=\"SOHUCS\"%@",[s firstMatchWithPattern:pattern]];
    NSRange range1 = [s rangeOfString:content];
    s=[s stringByReplacingCharactersInRange:range1 withString:@""];
    NSRange range2 = [s rangeOfString:content1];
    s=[s stringByReplacingCharactersInRange:range2 withString:@""];
    [webView loadHTMLString:s baseURL:[NSURL URLWithString:dataurl]];
    [self.view addSubview:webView];
}
@end
