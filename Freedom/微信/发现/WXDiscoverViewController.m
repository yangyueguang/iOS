//  WXDiscoverViewController.m
//  Freedom
// Created by Super
#import "WXDiscoverViewController.h"
#import "WXMomentsViewController.h"
#import "WXScanningViewController.h"
#import "WXShakeViewController.h"
#import "WXBottleViewController.h"
#import "WXShoppingViewController.h"
#import "WXGameViewController.h"
#import "WXModes.h"
@interface WXDiscoverHelper : NSObject
@property (nonatomic, strong) NSMutableArray *discoverMenuData;
@end
@implementation WXDiscoverHelper
- (id) init{
    if (self = [super init]) {
        self.discoverMenuData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}
- (void) p_initTestData{
    WXMenuItem *item1 = TLCreateMenuItem(@"u_frendsCircle", @"朋友圈");
    item1.rightIconURL = @"http://img4.duitang.com/uploads/item/201510/16/20151016113134_TZye4.thumb.224_0.jpeg";
    item1.showRightRedPoint = YES;
    WXMenuItem *item2 = TLCreateMenuItem(@"u_scan_b", @"扫一扫");
    WXMenuItem *item3 = TLCreateMenuItem(@"u_shake", @"摇一摇");
    WXMenuItem *item4 = TLCreateMenuItem(@"ff_IconLocationService", @"附近的人");
    WXMenuItem *item5 = TLCreateMenuItem(@"ff_IconBottle", @"漂流瓶");
    WXMenuItem *item6 = TLCreateMenuItem(@"CreditCard_ShoppingBag", @"购物");
    WXMenuItem *item7 = TLCreateMenuItem(@"MoreGame", @"游戏");
    item7.rightIconURL = @"http://qq1234.org/uploads/allimg/140404/3_140404151205_8.jpg";
    item7.subTitle = @"英雄联盟计算器版";
    item7.showRightRedPoint = YES;
    [self.discoverMenuData addObjectsFromArray:@[@[item1], @[item2, item3], @[item4, item5], @[item6, item7]]];
}
@end
@interface WXDiscoverViewController ()
@property (nonatomic, strong) WXMomentsViewController *momentsVC;
@property (nonatomic, strong) WXDiscoverHelper *discoverHelper;
@end
@implementation WXDiscoverViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"发现"];
    
    self.discoverHelper = [[WXDiscoverHelper alloc] init];
    self.data = self.discoverHelper.discoverMenuData;
}
#pragma mark - Delegate -
//MARK: UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXMenuItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"朋友圈"]) {
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:self.momentsVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }
    if ([item.title isEqualToString:@"扫一扫"]) {
        WXScanningViewController *scannerVC = [[WXScanningViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:scannerVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }else if ([item.title isEqualToString:@"摇一摇"]) {
        WXShakeViewController *shakeVC = [[WXShakeViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:shakeVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }else if ([item.title isEqualToString:@"漂流瓶"]) {
        WXBottleViewController *bottleVC = [[WXBottleViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:bottleVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }else if ([item.title isEqualToString:@"购物"]) {
        WXShoppingViewController *shoppingVC = [[WXShoppingViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:shoppingVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }else if ([item.title isEqualToString:@"游戏"]) {
        WXGameViewController *gameVC = [[WXGameViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:gameVC animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}
#pragma mark - Getter
- (WXMomentsViewController *)momentsVC{
    if (_momentsVC == nil) {
        _momentsVC = [[WXMomentsViewController alloc] init];
    }
    return _momentsVC;
}
@end
