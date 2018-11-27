//  TLHelpAndFeedbackViewController.m
//  Freedom
// Created by Super
#import "TLHelpAndFeedbackViewController.h"
@implementation TLHelpAndFeedbackViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    [self setUrl:@"https://github.com/tbl00c/TLChat/issues"];
}
#pragma mark - Event Response -
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
}
@end
