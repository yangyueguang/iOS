//  TLContactsViewController.h
//  Freedom
// Created by Super
#import "TLTableViewController.h"
@interface TLContactsSearchViewController : TLTableViewController <UISearchResultsUpdating>
@property (nonatomic, strong) NSArray *contactsData;
@end
@interface TLContactsViewController : TLTableViewController
/// 通讯录好友（初始数据）
@property (nonatomic, strong) NSArray *contactsData;
/// 通讯录好友（格式化的列表数据）
@property (nonatomic, strong) NSArray *data;
/// 通讯录好友索引
@property (nonatomic, strong) NSArray *headers;
@property (nonatomic, strong) TLContactsSearchViewController *searchVC;
- (void)registerCellClass;
@end
