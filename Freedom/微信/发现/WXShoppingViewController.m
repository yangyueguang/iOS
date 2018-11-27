//  TLShoppingViewController.m
//  Freedom
// Created by Super
#import "WXShoppingViewController.h"
@implementation WXShoppingViewController
- (void) viewDidLoad{
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_shopping_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
//    [self setUrl:@"http://wq.jd.com/"];
    [self setUrl:@"http://m.zhuanzhuan.com"];
}
#pragma mark - Event Response
- (void) rightBarButtonDown:(UIBarButtonItem *)sender{
}
@end
