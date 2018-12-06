//  TLSettingViewController.m
//  Freedom
// Created by Super
#import "WXSettingViewController.h"
#import <UMMobClick/MobClick.h>
#import "WXModes.h"
@interface WechatSettingSwitchCell : UITableViewCell
@property (nonatomic, assign) id<WXSettingSwitchCellDelegate>delegate;
@property (nonatomic, strong) WXSettingItem *item;
@end
@interface WechatSettingButtonCell : UITableViewCell
@property (nonatomic, strong) WXSettingItem *item;
@end
@interface WXSettingCell : UITableViewCell
@property (nonatomic, strong) WXSettingItem *item;
@end
@interface WXSettingHeaderTitleView : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *text;
@end
@interface WechatSettingFooterTitleView : WXSettingHeaderTitleView
@end
@interface WechatSettingSwitchCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *cellSwitch;
@end
@implementation WechatSettingSwitchCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryView:self.cellSwitch];
        [self.contentView addSubview:self.titleLabel];
        [self p_addMasonry];
    }
    return self;
}
- (void)setItem:(WXSettingItem *)item{
    _item = item;
    [self.titleLabel setText:item.title];
}
#pragma mark - Event Response -
- (void)switchChangeStatus:(UISwitch *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(settingSwitchCellForItem:didChangeStatus:)]) {
        [_delegate settingSwitchCellForItem:self.item didChangeStatus:sender.on];
    }
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-15);
    }];
}
#pragma mark - Getter -
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}
- (UISwitch *)cellSwitch{
    if (_cellSwitch == nil) {
        _cellSwitch = [[UISwitch alloc] init];
        [_cellSwitch addTarget:self action:@selector(switchChangeStatus:) forControlEvents:UIControlEventValueChanged];
    }
    return _cellSwitch;
}
@end
@interface WXSettingCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@end
@implementation WXSettingCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.rightLabel];
        [self.contentView addSubview:self.rightImageView];
        [self p_addMasonry];
    }
    return self;
}
- (void) setItem:(WXSettingItem *)item{
    _item = item;
    [self.titleLabel setText:item.title];
    [self.rightLabel setText:item.subTitle];
    if (item.rightImagePath) {
        [self.rightImageView setImage: [UIImage imageNamed:item.rightImagePath]];
    }else if (item.rightImageURL){
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:item.rightImageURL] placeholderImage:[UIImage imageNamed:PuserLogo]];
    }else{
        [self.rightImageView setImage:nil];
    }
    
    if (item.showDisclosureIndicator == NO) {
        [self setAccessoryType: UITableViewCellAccessoryNone];
        [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).mas_offset(-15.0f);
        }];
    }else{
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView);
        }];
    }
    
    if (item.disableHighlight) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else{
        [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
}
#pragma mark - Private Methods
- (void)p_addMasonry{
    [self.titleLabel setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).mas_offset(15);
    }];
    
    [self.rightLabel setContentCompressionResistancePriority:200 forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.titleLabel);
        make.left.mas_greaterThanOrEqualTo(self.titleLabel.mas_right).mas_offset(20);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightLabel.mas_left).mas_offset(-2);
        make.centerY.mas_equalTo(self.contentView);
    }];
}
#pragma mark - Getter
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}
- (UILabel *)rightLabel{
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        [_rightLabel setTextColor:[UIColor grayColor]];
        [_rightLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    return _rightLabel;
}
- (UIImageView *)rightImageView{
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}
@end
@implementation WechatSettingButtonCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}
- (void) setItem:(WXSettingItem *)item{
    _item = item;
    [self.textLabel setText:item.title];
}
@end
@implementation WechatSettingFooterTitleView
- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(15);
            make.right.mas_equalTo(self.contentView).mas_offset(-15);
            make.top.mas_equalTo(self.contentView).mas_offset(5.0f);
        }];
    }
    return self;
}
@end
@implementation WXSettingHeaderTitleView
- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(15);
            make.right.mas_equalTo(self.contentView).mas_offset(-15);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-5.0f);
        }];
    }
    return self;
}
- (void) setText:(NSString *)text{
    _text = text;
    [self.titleLabel setText:text];
}
#pragma mark - Getter
- (UILabel *) titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor grayColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_titleLabel setNumberOfLines:0];
    }
    return _titleLabel;
}
@end
@implementation WXSettingViewController
- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH)];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, 15.0f)]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, 12.0f)]];
    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    [self.tableView setSeparatorColor:[UIColor grayColor]];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.tableView registerClass:[WXSettingHeaderTitleView class] forHeaderFooterViewReuseIdentifier:@"TLSettingHeaderTitleView"];
    [self.tableView registerClass:[WechatSettingFooterTitleView class] forHeaderFooterViewReuseIdentifier:@"TLSettingFooterTitleView"];
    [self.tableView registerClass:[WXSettingCell class] forCellReuseIdentifier:@"TLSettingCell"];
    [self.tableView registerClass:[WechatSettingButtonCell class] forCellReuseIdentifier:@"TLSettingButtonCell"];
    [self.tableView registerClass:[WechatSettingSwitchCell class] forCellReuseIdentifier:@"TLSettingSwitchCell"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.analyzeTitle];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.analyzeTitle];
}
- (void)dealloc{
#ifdef DEBUG_MEMERY
    DLog(@"dealloc %@", self.navigationItem.title);
#endif
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray*)(self.data[section]) count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    id cell = [tableView dequeueReusableCellWithIdentifier:item.cellClassName];
    [cell setItem:item];
    if (item.type == TLSettingItemTypeSwitch) {
        [cell setDelegate:self];
    }
    return cell;
}
//MARK: UITableViewDelegate
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WXSettingGroup *group = self.data[section];
    if (group.headerTitle == nil) {
        return nil;
    }
    WXSettingHeaderTitleView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TLSettingHeaderTitleView"];
    [view setText:group.headerTitle];
    return view;
}
- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    WXSettingGroup *group = self.data[section];
    if (group.footerTitle == nil) {
        return nil;
    }
    WechatSettingFooterTitleView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TLSettingFooterTitleView"];
    [view setText:group.footerTitle];
    return view;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    WXSettingGroup *group = self.data[section];
    return 0.5 + (group.headerTitle == nil ? 0 : 5.0f + group.headerHeight);
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    WXSettingGroup *group = self.data[section];
    return 20.0f + (group.footerTitle == nil ? 0 : 5.0f + group.footerHeight);
}
//MARK: TLSettingSwitchCellDelegate
- (void)settingSwitchCellForItem:(WXSettingItem *)settingItem didChangeStatus:(BOOL)on{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Switch事件未被子类处理Title: %@\nStatus: %@", settingItem.title, (on ? @"on" : @"off")]];
}
#pragma mark - Getter -
- (NSString *)analyzeTitle{
    if (_analyzeTitle == nil) {
        return self.navigationItem.title;
    }
    return _analyzeTitle;
}
@end
