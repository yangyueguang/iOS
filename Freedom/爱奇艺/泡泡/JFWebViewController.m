//  JFWebViewController.m
//  Freedom
//  Created by Freedom on 15/9/15.
#import "JFWebViewController.h"
@interface JFWebViewController ()<UIWebViewDelegate>{
    UILabel *_titleLabel;
    int _isFirstIn;
    UIActivityIndicatorView *_activityView;
}
@end
@implementation JFWebViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _isFirstIn = 0;
    //返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 23, 23);
    [backBtn setImage:[UIImage imageNamed:PcellLeft] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH-64)];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
    DLog(@"webview URL:%@",self.urlStr);
    NSString *urlStr = [self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(APPW/2-15, APPH/2-15, 30, 30)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityView.hidesWhenStopped = YES;
    [self.view addSubview:_activityView];
    [self.view bringSubviewToFront:_activityView];
}
-(void)OnBackBtn:(UIButton *)sender{
    DLog(@"_isFirstIn:%d",_isFirstIn);
    if (_isFirstIn <= 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        _isFirstIn = _isFirstIn - 2;
        [self.webView goBack];
    }
    
}
#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    DLog(@"开始加载webview");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    DLog(@"加载webview完成");
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = theTitle;
    [_activityView stopAnimating];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    DLog(@"加载webview失败");
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [_activityView startAnimating];
    _isFirstIn++;
    DLog(@"第几次加载:%d",_isFirstIn);
    return YES;
}
@end
