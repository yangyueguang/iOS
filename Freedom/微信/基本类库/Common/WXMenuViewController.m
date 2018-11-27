//  TLMenuViewController.m
//  Freedom
// Created by Super
#import "WXMenuViewController.h"
#import <UMMobClick/MobClick.h>
#define     REDPOINT_WIDTH      8.0f
@interface WXMenuCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *midLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIView *redPointView;
@end
@implementation WXMenuCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.midLabel];
        [self.contentView addSubview:self.rightImageView];
        [self.contentView addSubview:self.redPointView];
        
        [self p_addMasonry];
    }
    return self;
}
- (void)setMenuItem:(WXMenuItem *)menuItem{
    _menuItem = menuItem;
    [self.iconImageView setImage:[UIImage imageNamed:menuItem.iconPath]];
    [self.titleLabel setText:menuItem.title];
    [self.midLabel setText:menuItem.subTitle];
    if (menuItem.rightIconURL == nil) {
        [self.rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }else{
        [self.rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.rightImageView.mas_height);
        }];
        [self.rightImageView sd_setImageWithURL:TLURL(menuItem.rightIconURL) placeholderImage:[UIImage imageNamed:PuserLogo]];
    }
    [self.redPointView setHidden:!menuItem.showRightRedPoint];
}
#pragma mark - Private Methods
- (void)p_addMasonry{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(15.0f);
        make.centerY.mas_equalTo(self.contentView);
        make.width.and.height.mas_equalTo(25.0f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImageView);
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(15.0f);
        make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(15.0f);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.iconImageView);
        make.width.and.height.mas_equalTo(31);
    }];
    [self.midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(self.titleLabel.mas_right).mas_offset(15);
        make.right.mas_equalTo(self.rightImageView.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(self.iconImageView);
    }];
    [self.redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rightImageView.mas_right).mas_offset(1);
        make.centerY.mas_equalTo(self.rightImageView.mas_top).mas_offset(1);
        make.width.and.height.mas_equalTo(REDPOINT_WIDTH);
    }];
}
#pragma mark - Getter
- (UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}
- (UILabel *)midLabel{
    if (_midLabel == nil) {
        _midLabel = [[UILabel alloc] init];
        [_midLabel setTextColor:[UIColor grayColor]];
        [_midLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    return _midLabel;
}
- (UIImageView *)rightImageView{
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}
- (UIView *)redPointView{
    if (_redPointView == nil) {
        _redPointView = [[UIView alloc] init];
        [_redPointView setBackgroundColor:[UIColor redColor]];
        
        [_redPointView.layer setMasksToBounds:YES];
        [_redPointView.layer setCornerRadius:REDPOINT_WIDTH / 2.0];
        [_redPointView setHidden:YES];
    }
    return _redPointView;
}
@end
@interface WXMenuViewController ()
@end
@implementation WXMenuViewController
- (void) loadView{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH)];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView setBackgroundColor:colorGrayBG];
    [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    [self.tableView setSeparatorColor:colorGrayLine];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, 20)]];
}
- (void) viewDidLoad{
    [super viewDidLoad];
    [self.tableView registerClass:[WXMenuCell class] forCellReuseIdentifier:@"TLMenuCell"];
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
#pragma mark - 
#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *temp = self.data[section];
    return [temp count];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLMenuCell"];
    WXMenuItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    [cell setMenuItem:item];
    return cell;
}
#pragma mark UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXMenuItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if (item.rightIconURL != nil || item.subTitle != nil) {
        item.rightIconURL = nil;
        item.subTitle = nil;
        item.showRightRedPoint = NO;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}
#pragma mark - Getter -
#pragma mark - Getter -
- (NSString *)analyzeTitle{
    if (_analyzeTitle == nil) {
        return self.navigationItem.title;
    }
    return _analyzeTitle;
}
@end
