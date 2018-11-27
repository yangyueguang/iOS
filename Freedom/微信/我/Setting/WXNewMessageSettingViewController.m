//  TLNewMessageSettingViewController.m
//  Freedom
//  Created by Super on 16/2/8.
#import "WXNewMessageSettingViewController.h"
#import "WXModes.h"
@interface WXNewMessageSettingHelper : NSObject
@property (nonatomic, strong) NSMutableArray *mineNewMessageSettingData;
@end
@implementation WXNewMessageSettingHelper
- (id) init{
    if (self = [super init]) {
        self.mineNewMessageSettingData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}
- (void) p_initTestData{
    WXSettingItem *item1 = TLCreateSettingItem(@"接受新消息通知");
    item1.subTitle = @"已开启";
    item1.showDisclosureIndicator = NO;
    WXSettingGroup *group1 = TLCreateSettingGroup(nil, @"如果你要关闭或开启微信的新消息通知，请在iPhone的“设置” - “通知”功能中，找到应用程序“微信”更改。", @[item1]);
    
    WXSettingItem *item2 = TLCreateSettingItem(@"通知显示消息详情");
    item2.type = TLSettingItemTypeSwitch;
    WXSettingGroup *group2 = TLCreateSettingGroup(nil, @"关闭后，当收到微信消息时，通知提示将不显示发信人和内容摘要。", @[item2]);
    
    WXSettingItem *item3 = TLCreateSettingItem(@"功能消息免打扰");
    WXSettingGroup *group3 = TLCreateSettingGroup(nil, @"设置系统功能消息提示声音和振动时段。", @[item3]);
    
    WXSettingItem *item4 = TLCreateSettingItem(@"声音");
    item4.type = TLSettingItemTypeSwitch;
    WXSettingItem *item5 = TLCreateSettingItem(@"震动");
    item5.type = TLSettingItemTypeSwitch;
    WXSettingGroup *group4 = TLCreateSettingGroup(nil, @"当微信在运行时，你可以设置是否需要声音或者振动。", (@[item4, item5]));
    
    WXSettingItem *item6 = TLCreateSettingItem(@"朋友圈照片更新");
    item6.type = TLSettingItemTypeSwitch;
    WXSettingGroup *group5 = TLCreateSettingGroup(nil, @"关闭后，有朋友更新照片时，界面下面的“发现”切换按钮上不再出现红点提示。", @[item6]);
    
    [self.mineNewMessageSettingData addObjectsFromArray:@[group1, group2, group3, group4, group5]];
}
@end
@interface WXNewMessageSettingViewController ()
@property (nonatomic, strong) WXNewMessageSettingHelper *helper;
@end
@implementation WXNewMessageSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"新消息通知"];
    
    self.helper = [[WXNewMessageSettingHelper alloc] init];
    self.data = self.helper.mineNewMessageSettingData;
}
@end
