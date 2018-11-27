//  SWGeneralSettingViewController.m
//  Freedom
//  Created by apple on 15-3-15.
#import "SWGeneralSettingViewController.h"
@interface SWGeneralSettingViewController ()
@end
@implementation SWGeneralSettingViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupGroups];
}
/*初始化模型数据*/
- (void)setupGroups{
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
}
- (void)setupGroup0{
    // 1.创建组
    SWCommonGroup *group = [SWCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    SWCommonLabelItem *readMdoe = [SWCommonLabelItem itemWithTitle:@"阅读模式"];
    readMdoe.text = @"有图模式";
    SWCommonLabelItem *readMdoe1 = [SWCommonLabelItem itemWithTitle:@"字号大小"];
    readMdoe1.text = @"中";
    SWCommonLabelItem *readMdoe2 = [SWCommonLabelItem itemWithTitle:@"显示备注"];
    readMdoe2.text = @"是";
    
    group.items = @[readMdoe,readMdoe1,readMdoe2];
}
- (void)setupGroup1{
    SWCommonGroup *group = [SWCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    SWCommonLabelItem *readMdoe = [SWCommonLabelItem itemWithTitle:@"图片浏览设置"];
    readMdoe.text = @"自适应";
    SWCommonLabelItem *readMdoe1 = [SWCommonLabelItem itemWithTitle:@"视频自动播放"];
    readMdoe1.text = @"仅WiFi";
    
    group.items = @[readMdoe,readMdoe1];
}
- (void)setupGroup2{
    SWCommonGroup *group = [SWCommonGroup group];
    [self.groups addObject:group];
    SWCommonLabelItem *readMdoe1 = [SWCommonLabelItem itemWithTitle:@"声音"];
    readMdoe1.text = @"开";
    group.items = @[readMdoe1];
}
- (void)setupGroup3{
    SWCommonGroup *group = [SWCommonGroup group];
    [self.groups addObject:group];
    SWCommonLabelItem *readMdoe1 = [SWCommonLabelItem itemWithTitle:@"多语言环境"];
    readMdoe1.text = @"跟随系统";
    group.items = @[readMdoe1];
}
@end
