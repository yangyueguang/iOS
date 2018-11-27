//  SWSettingViewController.m
//  Freedom
//  Created by apple on 15-3-15.
#import "SWSettingViewController.h"
#import "SWGeneralSettingViewController.h"
@interface SWSettingViewController ()
@end
@implementation SWSettingViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"设置";
    
    [self setupGroups];
    
    [self setupFooter];
}
- (void)setupFooter{
    // 1.创建按钮
    UIButton *logout = [[UIButton alloc] init];
    
    // 2.设置属性
    logout.titleLabel.font = [UIFont systemFontOfSize:14];
    [logout setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [logout setTitleColor:RGBCOLOR(255, 10, 10) forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizableImageWithName:@"common_card_background"] forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizableImageWithName:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    
    // 3.设置尺寸(tableFooterView和tableHeaderView的宽度跟tableView的宽度一样)
    logout.frameHeight = 35;
    
    self.tableView.tableFooterView = logout;
}
/*初始化模型数据*/
- (void)setupGroups{
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
}
- (void)setupGroup0{
    // 1.创建组
    SWCommonGroup *group = [SWCommonGroup group];
    group.footer = @"tile部";
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    SWCommonArrowItem *newFriend = [SWCommonArrowItem itemWithTitle:@"帐号管理"];
    SWCommonArrowItem *newFriend1 = [SWCommonArrowItem itemWithTitle:@"帐号安全"];
    
    group.items = @[newFriend,newFriend1];
}
- (void)setupGroup1{
    // 1.创建组
    SWCommonGroup *group = [SWCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    SWCommonArrowItem *newFriend1 = [SWCommonArrowItem itemWithTitle:@"通知"];
    SWCommonArrowItem *newFriend2 = [SWCommonArrowItem itemWithTitle:@"隐私"];
    SWCommonArrowItem *newFriend3 = [SWCommonArrowItem itemWithTitle:@"通用设置"];
    newFriend3.destVcClass = [SWGeneralSettingViewController class];
    group.items = @[newFriend1,newFriend2,newFriend3];
}
- (void)setupGroup2{
    // 1.创建组
    SWCommonGroup *group = [SWCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    SWCommonArrowItem *newFriend1 = [SWCommonArrowItem itemWithTitle:@"清理缓存"];
    SWCommonArrowItem *newFriend2 = [SWCommonArrowItem itemWithTitle:@"意见反馈"];
    SWCommonArrowItem *newFriend3 = [SWCommonArrowItem itemWithTitle:@"关于微博"];
    
    group.items = @[newFriend1,newFriend2,newFriend3];
}
@end
