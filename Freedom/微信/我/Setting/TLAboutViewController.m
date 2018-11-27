//  TLAboutViewController.m
//  Freedom
// Created by Super
#import "TLAboutViewController.h"
#define     HEIGHT_TOPVIEW      100.0f
#import "WechartModes.h"
@interface TLAboutHelper : NSObject
@property (nonatomic, strong) NSMutableArray *abouSettingtData;
@end
@implementation TLAboutHelper
- (id) init{
    if (self = [super init]) {
        self.abouSettingtData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}
- (void) p_initTestData{
    TLSettingItem *item1 = TLCreateSettingItem(@"去评分");
    TLSettingItem *item2 = TLCreateSettingItem(@"欢迎页");
    TLSettingItem *item3 = TLCreateSettingItem(@"功能介绍");
    TLSettingItem *item4 = TLCreateSettingItem(@"系统通知");
    TLSettingItem *item5 = TLCreateSettingItem(@"举报与投诉");
    TLSettingGroup *group1 = TLCreateSettingGroup(nil, nil, (@[item1, item2, item3, item4, item5]));
    [self.abouSettingtData addObjectsFromArray:@[group1]];
}
@end
@interface TLAboutHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imagePath;
@end
@interface TLAboutHeaderView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation TLAboutHeaderView
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
        [self p_addMasonry];
    }
    return self;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    [self.titleLabel setText:title];
}
- (void)setImagePath:(NSString *)imagePath{
    _imagePath = imagePath;
    [self.imageView setImage:[UIImage imageNamed:imagePath]];
}
- (void)p_addMasonry{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(4);
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.titleLabel.mas_top).mas_equalTo(1);
        make.width.mas_equalTo(self.imageView.mas_height).multipliedBy(1.13);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).mas_offset(-10);
        make.left.and.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(25);
    }];
}
#pragma mark - Getter -
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_titleLabel setTextColor:[UIColor grayColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}
@end
@interface TLAboutViewController ()
@property (nonatomic, strong) TLAboutHelper *helper;
@property (nonatomic, strong) UILabel *cmpLabel;
@end
@implementation TLAboutViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"关于微信"];
    
    self.helper = [[TLAboutHelper alloc] init];
    self.data = self.helper.abouSettingtData;
    
    [self.tableView registerClass:[TLAboutHeaderView class] forHeaderFooterViewReuseIdentifier:@"TLAboutHeaderView"];
    [self.tableView.tableFooterView addSubview:self.cmpLabel];
    [self p_addMasonry];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    float footerHeight = HEIGHT_SCREEN - self.tableView.contentSize.height - HEIGHT_NAVBAR - 15;
    [self.tableView.tableFooterView setFrameHeight:footerHeight];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        TLAboutHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TLAboutHeaderView"];
        [headerView setImagePath:@"AppLogo"];
        [headerView setTitle:[NSString stringWithFormat:@"微信 TLChat %@", [FreedomTools sharedManager].version]];
        return headerView;
    }
    return nil;
}
//MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return HEIGHT_TOPVIEW;
    }
    return 0;
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.cmpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.tableView.tableFooterView);
        make.bottom.mas_equalTo(self.tableView.tableFooterView).mas_offset(-1);
    }];
}
#pragma mark - Getter -
- (UILabel *)cmpLabel{
    if (_cmpLabel == nil) {
        _cmpLabel = [[UILabel alloc] init];
        [_cmpLabel setText:@"高仿微信 仅供学习\nhttps://github.com/tbl00c/TLChat"];
        [_cmpLabel setTextAlignment:NSTextAlignmentCenter];
        [_cmpLabel setTextColor:[UIColor grayColor]];
        [_cmpLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_cmpLabel setNumberOfLines:2];
    }
    return _cmpLabel;
}
@end
