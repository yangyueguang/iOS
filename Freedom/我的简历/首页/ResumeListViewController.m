//  ResumeListViewController.m
//  Freedom
//  Created by Super on 17/2/8.
//  Copyright © 2017年 Super. All rights reserved.
//
#import "ResumeListViewController.h"
#import "ResumeDetailViewController.h"
@interface ResumeListViewCell:BaseTableViewCell
@end
@implementation ResumeListViewCell
-(void)initUI{
    [super initUI];
    self.icon.frame = CGRectMake(10, 10, 40, 40);
    self.title.frame = CGRectMake(XW(self.icon)+10, 10, APPW-XW(self.icon)-20, 20);
    self.script.frame = CGRectMake(X(self.title), YH(self.title), W(self.title), H(self.title));
    self.script.textColor = [UIColor grayColor];
}
-(void)setDataWithDict:(NSDictionary *)dict{
    self.icon.image = [UIImage imageNamed:dict[@"pic"]];
    self.title.text = dict[@"name"];
    self.script.text = dict[@"url"];
}
@end
@implementation ResumeListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0,0, APPW, APPH) style:UITableViewStylePlain];
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:60 sectionN:1 rowN:11 cellName:@"ResumeListViewCell"];
    self.tableView.dataArray = [NSMutableArray arrayWithArray:self.listArray];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.tableView.dataArray[indexPath.row];
    [self pushController:[ResumeDetailViewController class] withInfo:dict withTitle:dict[@"name"] withOther:dict];
}
-(NSArray *)listArray{
    if(!_listArray){
        _listArray = [NSArray arrayWithObjects:@{@"pic":PuserLogo,@"name":@"我的简历",@"url":ResumeURL},@{@"pic":PuserLogo,@"name":@"微信小程序1",@"url":WeChatApplet1},@{@"pic":PuserLogo,@"name":@"微信小程序2",@"url":WeChatApplet2},
                      @{@"pic":PuserLogo,@"name":@"微页1",@"url":MicroPage1},@{@"pic":PuserLogo,@"name":@"微页2",@"url":MicroPage2},@{@"pic":PuserLogo,@"name":@"微页3",@"url":MicroPage3}, nil];
    }return _listArray;
}
@end
