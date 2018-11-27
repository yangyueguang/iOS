//  SettingsViewController.m
//  Freedom
//  Created by Super on 16/6/24.
//  Copyright © 2016年 Super. All rights reserved.
#import "SettingsViewController.h"
@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableView1;
}
@end
@implementation SettingsViewController
@synthesize contentLength, dismissByBackgroundDrag, dismissByBackgroundTouch, dismissByForegroundDrag;
- (void)viewDidLoad {
    [super viewDidLoad];
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH)];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.backgroundColor = [UIColor clearColor];
    tableView1.tableHeaderView = [self getheadView];
    tableView1.showsVerticalScrollIndicator = NO;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView1];
    ElasticTransition *ET = (ElasticTransition*)self.transitioningDelegate;
    DLog(@"\ntransition.edge = %@\ntransition.transformType = %@\ntransition.sticky = %@\ntransition.showShadow = %@", [HelperFunctions typeToStringOfEdge:ET.edge], [ET transformTypeToString], ET.sticky ? @"YES" : @"NO", ET.showShadow ? @"YES" : @"NO");
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contentLength = APPW*0.8;
        self.dismissByBackgroundTouch   = YES;
        self.dismissByBackgroundDrag    = YES;
        self.dismissByForegroundDrag    = YES;
    }return self;
}
-(UIView *)getheadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW*0.8, 200)];
    return headView;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
