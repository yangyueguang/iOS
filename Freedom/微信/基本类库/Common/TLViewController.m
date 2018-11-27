//  TLViewController.m
//  Freedom
// Created by Super
#import "TLViewController.h"
#import <MobClick.h>
@implementation TLViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:colorGrayBG];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.analyzeTitle];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.analyzeTitle];
}
- (void)dealloc{
    DLog(@"dealloc %@", self.navigationItem.title);
}
#pragma mark - Getter -
- (NSString *)analyzeTitle{
    if (_analyzeTitle == nil) {
        return self.navigationItem.title;
    }
    return _analyzeTitle;
}
@end
