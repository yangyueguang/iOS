//  WXExpressionSearchViewController.m
//  Freedom
//  Created by Super on 16/4/4.
#import "WXExpressionSearchViewController.h"
#import "WXExpressionDetailViewController.h"
#import "WXExpressionHelper.h"
#import "WXRootViewController.h"
#import "WXExpressionChosenViewController.h"
#import <XCategory/UIBarButtonItem+expanded.h>
@interface WXExpressionSearchViewController () <WXExpressionCellDelegate>
@property (nonatomic, strong) WXExpressionHelper *proxy;
@property (nonatomic, strong) NSArray *data;
@end
@implementation WXExpressionSearchViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.tableView registerClass:[WXExpressionCell class] forCellReuseIdentifier:@"TLExpressionCell"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView setFrame:CGRectMake(0, HEIGHT_NAVBAR + NavY, APPW, APPH - NavY - HEIGHT_NAVBAR)];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark -  Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXExpressionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLExpressionCell"];
    TLEmojiGroup *group = self.data[indexPath.row];
    [cell setGroup:group];
    [cell setDelegate:self];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TLEmojiGroup *group = [self.data objectAtIndex:indexPath.row];
    WXExpressionDetailViewController *detailVC = [[WXExpressionDetailViewController alloc] init];
    [detailVC setGroup:group];
    WXNavigationController *navC = [[WXNavigationController alloc] initWithRootViewController:detailVC];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain actionBlick:^{
       [navC dismissViewControllerAnimated:YES completion:^{
       }];
    }];
    [detailVC.navigationItem setLeftBarButtonItem:closeButton];
    [self presentViewController:navC animated:YES completion:^{
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
//MARK: UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *keyword = searchBar.text;
    if (keyword.length > 0) {
        [SVProgressHUD show];
        [self.proxy requestExpressionSearchByKeyword:keyword success:^(NSArray *data) {
            self.data = data;
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        } failure:^(NSString *error) {
            self.data = nil;
            [self.tableView reloadData];
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }
}
//MARK: TLExpressionCellDelegate
- (void)expressionCellDownloadButtonDown:(TLEmojiGroup *)group{
    group.status = TLEmojiGroupStatusDownloading;
    [self.proxy requestExpressionGroupDetailByGroupID:group.groupID pageIndex:1 success:^(id data) {
        group.data = data;
        [[WXExpressionHelper sharedHelper] downloadExpressionsWithGroupInfo:group progress:^(CGFloat progress) {
            
        } success:^(TLEmojiGroup *group) {
            group.status = TLEmojiGroupStatusDownloaded;
            NSInteger index = [self.data indexOfObject:group];
            if (index < self.data.count) {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            BOOL ok = [[WXExpressionHelper sharedHelper] addExpressionGroup:group];
            if (!ok) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"表情 %@ 存储失败！", group.groupName]];
            }
        } failure:^(TLEmojiGroup *group, NSString *error) {
            
        }];
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"\"%@\" 下载失败: %@", group.groupName, error]];
    }];
}
//MARK: UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}
#pragma mark - Getter
- (WXExpressionHelper *)proxy{
    if (_proxy == nil) {
        _proxy = [WXExpressionHelper sharedHelper];
    }
    return _proxy;
}
@end
