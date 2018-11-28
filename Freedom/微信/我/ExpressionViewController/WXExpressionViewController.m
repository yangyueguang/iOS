//  TLExpressionViewController.m
//  Freedom
// Created by Super
#import "WXExpressionViewController.h"
#import "WXExpressionChosenViewController.h"
#import "WXExpressionPublicViewController.h"
#import "WXMyExpressionViewController.h"
#define     WIDTH_EXPRESSION_SEGMENT    APPW * 0.55
@interface WXExpressionViewController ()
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) WXExpressionChosenViewController *expChosenVC;
@property (nonatomic, strong) WXExpressionPublicViewController *expPublicVC;
@end
@implementation WXExpressionViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.navigationItem setTitleView:self.segmentedControl];
    [self.view addSubview:self.expChosenVC.view];
    [self addChildViewController:self.expChosenVC];
    [self addChildViewController:self.expPublicVC];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_setting"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    if (self.navigationController.topViewController == self) {
        UIBarButtonItem *dismissBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain actionBlick:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [self.navigationItem setLeftBarButtonItem:dismissBarButton];
    }
}
#pragma mark - Event Response
- (void)rightBarButtonDown{
    WXMyExpressionViewController *myExpressionVC = [[WXMyExpressionViewController alloc] init];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:myExpressionVC animated:YES];
}
- (void)segmentedControlChanged:(UISegmentedControl *)segmentedControl{
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self transitionFromViewController:self.expPublicVC toViewController:self.expChosenVC duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [self transitionFromViewController:self.expChosenVC toViewController:self.expPublicVC duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
    }
}
#pragma mark -  Getter
- (UISegmentedControl *)segmentedControl{
    if (_segmentedControl == nil) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"精选表情", @"网络表情"]];
        [_segmentedControl setSelectedSegmentIndex:0];
        [_segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}
- (WXExpressionChosenViewController *)expChosenVC{
    if (_expChosenVC == nil) {
        _expChosenVC = [[WXExpressionChosenViewController alloc] init];
    }
    return _expChosenVC;
}
- (WXExpressionPublicViewController *)expPublicVC{
    if (_expPublicVC == nil) {
        _expPublicVC = [[WXExpressionPublicViewController alloc] init];
    }
    return _expPublicVC;
}
@end
