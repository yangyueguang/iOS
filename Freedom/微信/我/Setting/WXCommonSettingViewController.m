//  WXCommonSettingViewController.m
//  Freedom
// Created by Super
#import "WXCommonSettingViewController.h"
#import "WXMessageManager.h"
#import "WXChatViewController.h"
#import "WXBgSettingViewController.h"
#import "WXMyExpressionViewController.h"
#import "WXChatTableViewController.h"
#import "WXUserHelper.h"
#import "WXBaseViewController.h"
#import "NSFileManager+expanded.h"
#import "WXModes.h"
@interface WXChatFontSettingView : UIView
@property (nonatomic, assign) CGFloat curFontSize;
@property (nonatomic, copy) void (^fontSizeChangeTo)(CGFloat size);
@end
@interface WXChatFontSettingView ()
@property (nonatomic, strong) UILabel *miniFontLabel;
@property (nonatomic, strong) UILabel *maxFontLabel;
@property (nonatomic, strong) UILabel *standardFontLabel;
@property (nonatomic, strong) UISlider *slider;
@end
@implementation WXChatFontSettingView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.miniFontLabel];
        [self addSubview:self.maxFontLabel];
        [self addSubview:self.standardFontLabel];
        [self addSubview:self.slider];
        [self p_addMasonry];
    }
    return self;
}
- (void)setCurFontSize:(CGFloat)curFontSize{
    _curFontSize = curFontSize;
    [self.slider setValue:curFontSize];
}
#pragma mark - Event Response -
- (void)sliderValueChanged:(UISlider *)sender{
    NSInteger value = (NSInteger)sender.value;
    value = ((sender.value - value) > 0.5 ? value + 1 : value);
    if (value == (NSInteger)_curFontSize) {
        return;
    }
    _curFontSize = value;
    if (self.fontSizeChangeTo) {
        self.fontSizeChangeTo(value);
    }
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.miniFontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.slider.mas_left);
        make.bottom.mas_equalTo(self.slider.mas_top).mas_offset(-6);
    }];
    
    [self.maxFontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.slider.mas_right);
        make.bottom.mas_equalTo(self.miniFontLabel);
    }];
    
    [self.standardFontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.miniFontLabel);
        make.left.mas_equalTo(self.miniFontLabel.mas_right).mas_equalTo(40);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-35);
        make.width.mas_equalTo(self).multipliedBy(0.8);
        make.height.mas_equalTo(40);
    }];
}
#pragma mark - Getter -
- (UILabel *)miniFontLabel{
    if (_miniFontLabel == nil) {
        _miniFontLabel = [[UILabel alloc] init];
        [_miniFontLabel setFont:[UIFont systemFontOfSize:15]];
        [_miniFontLabel setText:@"A"];
    }
    return _miniFontLabel;
}
- (UILabel *)maxFontLabel{
    if (_maxFontLabel == nil) {
        _maxFontLabel = [[UILabel alloc] init];
        [_maxFontLabel setFont:[UIFont systemFontOfSize:20]];
        [_maxFontLabel setText:@"A"];
    }
    return _maxFontLabel;
}
- (UILabel *)standardFontLabel{
    if (_standardFontLabel == nil) {
        _standardFontLabel = [[UILabel alloc] init];
        [_standardFontLabel setFont:[UIFont systemFontOfSize:16]];
        [_standardFontLabel setText:@"标准"];
    }
    return _standardFontLabel;
}
- (UISlider *)slider{
    if (_slider == nil) {
        _slider = [[UISlider alloc] init];
        [_slider setMinimumValue:15];
        [_slider setMaximumValue:20];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}
@end
@interface WXChatFontViewController : WXBaseViewController
@end
@interface WXChatFontViewController ()
@property (nonatomic, strong) WXChatTableViewController *chatTVC;
@property (nonatomic, strong) WXChatFontSettingView *chatFontSettingView;
@end
@implementation WXChatFontViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"字体大小"];
    
    [self.view addSubview:self.chatTVC.view];
    [self addChildViewController:self.chatTVC];
    [self.view addSubview:self.chatFontSettingView];
    [self p_addMasonry];
    
    __weak typeof(self) weakSelf = self;
    [self.chatFontSettingView setFontSizeChangeTo:^(CGFloat size) {
        [[NSUserDefaults standardUserDefaults] setDouble:size forKey:@"CHAT_FONT_SIZE"];
        weakSelf.chatTVC.data = [weakSelf p_chatTVCData];
        [weakSelf.chatTVC.tableView reloadData];
    }];
    CGFloat size = [[NSUserDefaults standardUserDefaults] doubleForKey:@"CHAT_FONT_SIZE"];
    [self.chatFontSettingView setCurFontSize:size];
    self.chatTVC.data = [self p_chatTVCData];
    [self.chatTVC.tableView reloadData];
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.chatTVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.chatFontSettingView.mas_top);
    }];
    
    [self.chatFontSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(self.chatFontSettingView.mas_width).multipliedBy(0.4);
    }];
}
- (NSMutableArray *)p_chatTVCData{
    WXTextMessage *message = [[WXTextMessage alloc] init];
    message.fromUser = [WXUserHelper sharedHelper].user;
    message.messageType = TLMessageTypeText;
    message.ownerTyper = TLMessageOwnerTypeSelf;
    message.content[@"text"] = @"预览字体大小";
    
    WXUser *user = [[WXUser alloc] init];
    user.avatarPath = @"AppIcon";
    NSString *path = [NSFileManager pathUserAvatar:@"AppIcon"];
    if (![[NSFileManager defaultManager] isExecutableFileAtPath:path]) {
        NSString *iconPath = [[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        UIImage *image = [UIImage imageNamed:iconPath];
        NSData *data = (UIImagePNGRepresentation(image) ? UIImagePNGRepresentation(image) :UIImageJPEGRepresentation(image, 1));
        [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
    }
    
    
    WXTextMessage *message1 = [[WXTextMessage alloc] init];
    message1.fromUser = user;
    message1.messageType = TLMessageTypeText;
    message1.ownerTyper = TLMessageOwnerTypeFriend;
    message1.content[@"text"] = @"拖动下面的滑块，可设置字体大小";
    WXTextMessage *message2 = [[WXTextMessage alloc] init];
    message2.fromUser = user;
    message2.messageType = TLMessageTypeText;
    message2.ownerTyper = TLMessageOwnerTypeFriend;
    message2.content[@"text"] = @"设置后，会改变聊天页面的字体大小。后续将支持更改菜单、朋友圈的字体修改。";
    
    NSMutableArray *data = [[NSMutableArray alloc] initWithObjects:message, message1, message2, nil];
    return data;
}
#pragma mark - Getter -
- (WXChatTableViewController *)chatTVC{
    if (_chatTVC == nil) {
        _chatTVC = [[WXChatTableViewController alloc] init];
        [_chatTVC setDisablePullToRefresh:YES];
        [_chatTVC setDisableLongPressMenu:YES];
    }
    return _chatTVC;
}
- (WXChatFontSettingView *)chatFontSettingView{
    if (_chatFontSettingView == nil) {
        _chatFontSettingView = [[WXChatFontSettingView alloc] init];
    }
    return _chatFontSettingView;
}
@end
@implementation WXCommonSettingHelper
+ (NSMutableArray *)chatBackgroundSettingData{
    WXSettingItem *select = [WXSettingItem createItemWithTitle:(@"选择背景图")];
    WXSettingGroup *group1 = TLCreateSettingGroup(nil, nil, @[select]);
    
    WXSettingItem *album = [WXSettingItem createItemWithTitle:(@"从手机相册中选择")];
    WXSettingItem *camera = [WXSettingItem createItemWithTitle:(@"拍一张")];
    WXSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[album, camera]));
    
    WXSettingItem *toAll = [WXSettingItem createItemWithTitle:(@"将背景应用到所有聊天场景")];
    toAll.type = TLSettingItemTypeTitleButton;
    WXSettingGroup *group3 = TLCreateSettingGroup(nil, nil, @[toAll]);
    
    NSMutableArray *data = [[NSMutableArray alloc] initWithObjects:group1, group2, group3, nil];
    return data;
}
- (id) init{
    if (self = [super init]) {
        self.commonSettingData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}
- (void) p_initTestData{
    WXSettingItem *item1 = [WXSettingItem createItemWithTitle:(@"多语言")];
    WXSettingGroup *group1 = TLCreateSettingGroup(nil, nil, @[item1]);
    
    WXSettingItem *item2 = [WXSettingItem createItemWithTitle:(@"字体大小")];
    WXSettingItem *item3 = [WXSettingItem createItemWithTitle:(@"聊天背景")];
    WXSettingItem *item4 = [WXSettingItem createItemWithTitle:(@"我的表情")];
    WXSettingItem *item5 = [WXSettingItem createItemWithTitle:(@"朋友圈小视频")];
    WXSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[item2, item3, item4, item5]));
    
    WXSettingItem *item6 = [WXSettingItem createItemWithTitle:(@"听筒模式")];
    item6.type = TLSettingItemTypeSwitch;
    WXSettingGroup *group3 = TLCreateSettingGroup(nil, nil, @[item6]);
    
    WXSettingItem *item7 = [WXSettingItem createItemWithTitle:(@"功能")];
    WXSettingGroup *group4 = TLCreateSettingGroup(nil, nil, @[item7]);
    
    WXSettingItem *item8 = [WXSettingItem createItemWithTitle:(@"聊天记录迁移")];
    WXSettingItem *item9 = [WXSettingItem createItemWithTitle:(@"清理微信存储空间")];
    WXSettingGroup *group5 = TLCreateSettingGroup(nil, nil, (@[item8, item9]));
    
    WXSettingItem *item10 = [WXSettingItem createItemWithTitle:(@"清空聊天记录")];
    item10.type = TLSettingItemTypeTitleButton;
    WXSettingGroup *group6 = TLCreateSettingGroup(nil, nil, @[item10]);
    
    [self.commonSettingData addObjectsFromArray:@[group1, group2, group3, group4, group5, group6]];
}
@end
@interface WXCommonSettingViewController ()
@property (nonatomic, strong) WXCommonSettingHelper *helper;
@end
@implementation WXCommonSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"通用"];
    
    self.helper = [[WXCommonSettingHelper alloc] init];
    self.data = self.helper.commonSettingData;
}
#pragma mark - Delegate -
//MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"字体大小"]) {
        WXChatFontViewController *chatFontVC = [[WXChatFontViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatFontVC animated:YES];
    }else if ([item.title isEqualToString:@"聊天背景"]) {
        WXBgSettingViewController *chatBGSettingVC = [[WXBgSettingViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatBGSettingVC animated:YES];
    }else if ([item.title isEqualToString:@"我的表情"]) {
        WXMyExpressionViewController *myExpressionVC = [[WXMyExpressionViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:myExpressionVC animated:YES];
    }else if ([item.title isEqualToString:@"清空聊天记录"]) {
        [self showAlerWithtitle:@"将删除所有个人和群的聊天记录。" message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
            return [UIAlertAction actionWithTitle:@"清空聊天记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[WXMessageManager sharedInstance] deleteAllMessages];
                    [[WXChatViewController sharedChatVC] resetChatVC];
            }];
        } ac2:^UIAlertAction *{
            return [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            }];
        } ac3:nil completion:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
