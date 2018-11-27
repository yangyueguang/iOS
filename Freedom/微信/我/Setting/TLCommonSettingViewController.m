//  TLCommonSettingViewController.m
//  Freedom
// Created by Super
#import "TLCommonSettingViewController.h"
#import "TLMessageManager.h"
#import "TLChatViewController.h"
#import "TLChatBackgroundSettingViewController.h"
#import "TLMyExpressionViewController.h"
#import "TLActionSheet.h"
#define     TAG_ACTIONSHEET_EMPTY_REC       1001
#import "TLChatTableViewController.h"
#import "TLUserHelper.h"
#import "TLViewController.h"
#define     MIN_FONT_SIZE           15.0f
#define     STANDARD_FONT_SZIE      16.0f
#define     MAX_FONT_SZIE           20.0f
#import "WechartModes.h"
@interface TLChatFontSettingView : UIView
@property (nonatomic, assign) CGFloat curFontSize;
@property (nonatomic, copy) void (^fontSizeChangeTo)(CGFloat size);
@end
@interface TLChatFontSettingView ()
@property (nonatomic, strong) UILabel *miniFontLabel;
@property (nonatomic, strong) UILabel *maxFontLabel;
@property (nonatomic, strong) UILabel *standardFontLabel;
@property (nonatomic, strong) UISlider *slider;
@end
@implementation TLChatFontSettingView
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
        [_miniFontLabel setFont:[UIFont systemFontOfSize:MIN_FONT_SIZE]];
        [_miniFontLabel setText:@"A"];
    }
    return _miniFontLabel;
}
- (UILabel *)maxFontLabel{
    if (_maxFontLabel == nil) {
        _maxFontLabel = [[UILabel alloc] init];
        [_maxFontLabel setFont:[UIFont systemFontOfSize:MAX_FONT_SZIE]];
        [_maxFontLabel setText:@"A"];
    }
    return _maxFontLabel;
}
- (UILabel *)standardFontLabel{
    if (_standardFontLabel == nil) {
        _standardFontLabel = [[UILabel alloc] init];
        [_standardFontLabel setFont:[UIFont systemFontOfSize:STANDARD_FONT_SZIE]];
        [_standardFontLabel setText:@"标准"];
    }
    return _standardFontLabel;
}
- (UISlider *)slider{
    if (_slider == nil) {
        _slider = [[UISlider alloc] init];
        [_slider setMinimumValue:MIN_FONT_SIZE];
        [_slider setMaximumValue:MAX_FONT_SZIE];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}
@end
@interface TLChatFontViewController : TLViewController
@end
@interface TLChatFontViewController ()
@property (nonatomic, strong) TLChatTableViewController *chatTVC;
@property (nonatomic, strong) TLChatFontSettingView *chatFontSettingView;
@end
@implementation TLChatFontViewController
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
    TLTextMessage *message = [[TLTextMessage alloc] init];
    message.fromUser = [TLUserHelper sharedHelper].user;
    message.messageType = TLMessageTypeText;
    message.ownerTyper = TLMessageOwnerTypeSelf;
    message.text = @"预览字体大小";
    
    TLUser *user = [[TLUser alloc] init];
    user.avatarPath = @"AppIcon";
    NSString *path = [NSFileManager pathUserAvatar:@"AppIcon"];
    if (![[NSFileManager defaultManager] isExecutableFileAtPath:path]) {
        NSString *iconPath = [[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        UIImage *image = [UIImage imageNamed:iconPath];
        NSData *data = (UIImagePNGRepresentation(image) ? UIImagePNGRepresentation(image) :UIImageJPEGRepresentation(image, 1));
        [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
    }
    
    
    TLTextMessage *message1 = [[TLTextMessage alloc] init];
    message1.fromUser = user;
    message1.messageType = TLMessageTypeText;
    message1.ownerTyper = TLMessageOwnerTypeFriend;
    message1.text = @"拖动下面的滑块，可设置字体大小";
    TLTextMessage *message2 = [[TLTextMessage alloc] init];
    message2.fromUser = user;
    message2.messageType = TLMessageTypeText;
    message2.ownerTyper = TLMessageOwnerTypeFriend;
    message2.text = @"设置后，会改变聊天页面的字体大小。后续将支持更改菜单、朋友圈的字体修改。";
    
    NSMutableArray *data = [[NSMutableArray alloc] initWithObjects:message, message1, message2, nil];
    return data;
}
#pragma mark - Getter -
- (TLChatTableViewController *)chatTVC{
    if (_chatTVC == nil) {
        _chatTVC = [[TLChatTableViewController alloc] init];
        [_chatTVC setDisablePullToRefresh:YES];
        [_chatTVC setDisableLongPressMenu:YES];
    }
    return _chatTVC;
}
- (TLChatFontSettingView *)chatFontSettingView{
    if (_chatFontSettingView == nil) {
        _chatFontSettingView = [[TLChatFontSettingView alloc] init];
    }
    return _chatFontSettingView;
}
@end
@implementation TLCommonSettingHelper
+ (NSMutableArray *)chatBackgroundSettingData{
    TLSettingItem *select = TLCreateSettingItem(@"选择背景图");
    TLSettingGroup *group1 = TLCreateSettingGroup(nil, nil, @[select]);
    
    TLSettingItem *album = TLCreateSettingItem(@"从手机相册中选择");
    TLSettingItem *camera = TLCreateSettingItem(@"拍一张");
    TLSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[album, camera]));
    
    TLSettingItem *toAll = TLCreateSettingItem(@"将背景应用到所有聊天场景");
    toAll.type = TLSettingItemTypeTitleButton;
    TLSettingGroup *group3 = TLCreateSettingGroup(nil, nil, @[toAll]);
    
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
    TLSettingItem *item1 = TLCreateSettingItem(@"多语言");
    TLSettingGroup *group1 = TLCreateSettingGroup(nil, nil, @[item1]);
    
    TLSettingItem *item2 = TLCreateSettingItem(@"字体大小");
    TLSettingItem *item3 = TLCreateSettingItem(@"聊天背景");
    TLSettingItem *item4 = TLCreateSettingItem(@"我的表情");
    TLSettingItem *item5 = TLCreateSettingItem(@"朋友圈小视频");
    TLSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[item2, item3, item4, item5]));
    
    TLSettingItem *item6 = TLCreateSettingItem(@"听筒模式");
    item6.type = TLSettingItemTypeSwitch;
    TLSettingGroup *group3 = TLCreateSettingGroup(nil, nil, @[item6]);
    
    TLSettingItem *item7 = TLCreateSettingItem(@"功能");
    TLSettingGroup *group4 = TLCreateSettingGroup(nil, nil, @[item7]);
    
    TLSettingItem *item8 = TLCreateSettingItem(@"聊天记录迁移");
    TLSettingItem *item9 = TLCreateSettingItem(@"清理微信存储空间");
    TLSettingGroup *group5 = TLCreateSettingGroup(nil, nil, (@[item8, item9]));
    
    TLSettingItem *item10 = TLCreateSettingItem(@"清空聊天记录");
    item10.type = TLSettingItemTypeTitleButton;
    TLSettingGroup *group6 = TLCreateSettingGroup(nil, nil, @[item10]);
    
    [self.commonSettingData addObjectsFromArray:@[group1, group2, group3, group4, group5, group6]];
}
@end
@interface TLCommonSettingViewController () <TLActionSheetDelegate>
@property (nonatomic, strong) TLCommonSettingHelper *helper;
@end
@implementation TLCommonSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"通用"];
    
    self.helper = [[TLCommonSettingHelper alloc] init];
    self.data = self.helper.commonSettingData;
}
#pragma mark - Delegate -
//MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TLSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"字体大小"]) {
        TLChatFontViewController *chatFontVC = [[TLChatFontViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatFontVC animated:YES];
    }else if ([item.title isEqualToString:@"聊天背景"]) {
        TLChatBackgroundSettingViewController *chatBGSettingVC = [[TLChatBackgroundSettingViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatBGSettingVC animated:YES];
    }else if ([item.title isEqualToString:@"我的表情"]) {
        TLMyExpressionViewController *myExpressionVC = [[TLMyExpressionViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:myExpressionVC animated:YES];
    }else if ([item.title isEqualToString:@"清空聊天记录"]) {
        TLActionSheet *actionSheet = [[TLActionSheet alloc] initWithTitle:@"将删除所有个人和群的聊天记录。" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清空聊天记录" otherButtonTitles:nil];
        [actionSheet setTag:TAG_ACTIONSHEET_EMPTY_REC];
        [actionSheet show];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//MARK: TLActionSheetDelegate
- (void)actionSheet:(TLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == TAG_ACTIONSHEET_EMPTY_REC) {
        if (buttonIndex == 0) {
            [[TLMessageManager sharedInstance] deleteAllMessages];
            [[TLChatViewController sharedChatVC] resetChatVC];
        }
    }
}
@end
