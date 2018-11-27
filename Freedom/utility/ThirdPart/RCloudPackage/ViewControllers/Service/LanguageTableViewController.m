//
//  LanguageTableViewController.m
//  RCloudTest
//
//  Created by Super on 2017/5/27.
//  Copyright © 2017年 Super. All rights reserved.
//
#import "LanguageTableViewController.h"
@interface LanguageTableViewController ()
@end
@implementation LanguageTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *downItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    //(title:"完成", style:.plain, target: self, action: #selector(dismissVC))
    self.navigationItem.rightBarButtonItem = downItem;
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:33 green:201 blue:120 alpha:1];
    
    self.dataArray = @[@{@"L":@"ar",@"name":@"阿拉伯语"},@{@"L":@"zh-CN",@"name":@"中文 - 中国"},@{@"L":@"zh-CHS",@"name":@"中文（简体）"},@{@"L":@"zh-CHT",@"name":@"中文（繁体）"},@{@"L":@"cs",@"name":@"捷克语"},@{@"L":@"da",@"name":@"丹麦语"},@{@"L":@"div",@"name":@"马尔代夫语"},@{@"L":@"nl",@"name":@"荷兰语"},@{@"L":@"en",@"name":@"英语"},@{@"L":@"fo",@"name":@"法罗语"},@{@"L":@"fa",@"name":@"波斯语"},@{@"L":@"fi",@"name":@"芬兰语"},@{@"L":@"fr",@"name":@"法语"},@{@"L":@"de",@"name":@"德语"},@{@"L":@"el",@"name":@"希腊语"},@{@"L":@"he",@"name":@"希伯来语"},@{@"L":@"hi",@"name":@"印地语"},@{@"L":@"hu",@"name":@"匈牙利语"},@{@"L":@"it",@"name":@"意大利语"},@{@"L":@"ja",@"name":@"日语"},@{@"L":@"ko",@"name":@"朝鲜语"},@{@"L":@"mn",@"name":@"蒙古语"},@{@"L":@"no",@"name":@"挪威语"},@{@"L":@"pl",@"name":@"波兰语"},@{@"L":@"pt",@"name":@"葡萄牙语"},@{@"L":@"ru",@"name":@"俄语"},@{@"L":@"sa",@"name":@"梵语"},@{@"L":@"es",@"name":@"西班牙语"},@{@"L":@"sv",@"name":@"瑞典语"},@{@"L":@"syr",@"name":@"叙利亚语"},@{@"L":@"th",@"name":@"泰语"},@{@"L":@"tr",@"name":@"土耳其语"},@{@"L":@"uk",@"name":@"乌克兰语"},@{@"L":@"vi",@"name":@"越南语"}];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LanguageCell"];
    if (cell == nil ){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LanguageCell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row][@"name"];
    cell.detailTextLabel.text = self.dataArray[indexPath.row][@"L"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.row];
    if(self.theLanguage != nil){
        self.theLanguage(indexPath,dic[@"name"],dic[@"L"]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
