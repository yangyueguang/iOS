//  TLTableViewController.m
//  Freedom
// Created by Super
#import "WXTableViewController.h"
#import <UMMobClick/MobClick.h>
@implementation WXTableViewController
- (void) viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:colorGrayBG];
    [self.tableView setTableFooterView:[UIView new]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
