//  TaobaoMiniArticleViewController.m
//  Created by Super on 17/1/11.
//  Copyright © 2017年 Super. All rights reserved.
//
#import "TaobaoMiniArticleViewController.h"
@implementation TaobaoMiniArticleViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0,0, APPW, self.view.frameHeight-20) style:UITableViewStylePlain];
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:280 sectionN:1 rowN:11 cellName:@"TaobaoMiniDynamicViewCell"];
    self.tableView.dataArray = [NSMutableArray arrayWithObjects:@"b",@"a",@"v",@"f",@"d",@"a",@"w",@"u",@"n",@"o",@"2", nil];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
-(void)viewWillLayoutSubviews{
    self.tableView.frameHeight = self.view.frameHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
