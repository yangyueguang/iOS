//  TLInfoViewController.m
//  Freedom
// Created by Super
#import "WXInfoViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>
@interface WXInfoCell ()
@property (nonatomic, strong) UILabel *subTitleLabel;
@end
@implementation WXInfoCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [self.contentView addSubview:self.subTitleLabel];
        [self p_addMasonry];
    }
    return self;
}
- (void)setInfo:(WXInfo *)info{
    _info = info;
    [self.textLabel setText:info.title];
    [self.subTitleLabel setText:info.subTitle];
    [self setAccessoryType:info.showDisclosureIndicator ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone];
    [self setSelectionStyle:info.disableHighlight ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault];
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).mas_offset(APPW * 0.28);
        make.right.mas_lessThanOrEqualTo(self.contentView);
    }];
}
#pragma mark - Getter -
- (UILabel *)subTitleLabel{
    if (_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc] init];
        [_subTitleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    return _subTitleLabel;
}
@end
@interface WXInfoButtonCell ()
@property (nonatomic, strong) UIButton *button;
@end
@implementation WXInfoButtonCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setSeparatorInset:UIEdgeInsetsMake(0, APPW / 2, 0, APPW / 2)];
        [self setLayoutMargins:UIEdgeInsetsMake(0, APPW / 2, 0, APPW / 2)];
        [self.contentView addSubview:self.button];
        [self p_addMasonry];
    }
    return self;
}
- (void)setInfo:(WXInfo *)info{
    _info = info;
    [self.button setTitle:info.title forState:UIControlStateNormal];
    [self.button setBackgroundColor:info.buttonColor];
    [self.button setBackgroundImage:[FreedomTools imageWithColor:info.buttonHLColor] forState:UIControlStateHighlighted];
    [self.button setTitleColor:info.titleColor forState:UIControlStateNormal];
    [self.button.layer setBorderColor:info.buttonBorderColor.CGColor];
}
#pragma mark - Event Response -
- (void)cellButtonDown:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(infoButtonCellClicked:)]) {
        [_delegate infoButtonCellClicked:self.info];
    }
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.top.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView).multipliedBy(0.92);
        make.height.mas_equalTo(self.contentView).multipliedBy(0.78);
    }];
}
#pragma mark - Getter -
- (UIButton *)button{
    if (_button == nil) {
        _button = [[UIButton alloc] init];
        [_button.layer setMasksToBounds:YES];
        [_button.layer setCornerRadius:4.0f];
        [_button.layer setBorderWidth:1];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_button addTarget:self action:@selector(cellButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
@end
@implementation WXInfoHeaderFooterView
- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:[UIColor lightGrayColor]];
    }
    return self;
}
@end
@implementation WXInfoViewController
- (void) loadView{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH)];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, 15.0f)]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, 12.0f)]];
    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, 10.0f)]];
    [self.tableView registerClass:[WXInfoHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"TLInfoHeaderFooterView"];
    [self.tableView registerClass:[WXInfoCell class] forCellReuseIdentifier:@"TLInfoCell"];
    [self.tableView registerClass:[WXInfoButtonCell class] forCellReuseIdentifier:@"TLInfoButtonCell"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    NSArray *temp = self.data[section];
    return [temp count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *group = self.data[indexPath.section];
    WXInfo *info = [group objectAtIndex:indexPath.row];
    id cell;
    if (info.type == TLInfoTypeButton) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TLInfoButtonCell"];
        [cell setDelegate:self];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"TLInfoCell"];
    }
    [cell setInfo:info];
    
    if (indexPath.row == 0 && info.type != TLInfoTypeButton) {
        [cell setTopLineStyle:TLCellLineStyleFill];
    }else{
        [cell setTopLineStyle:TLCellLineStyleNone];
    }
    if (info.type == TLInfoTypeButton) {
        [cell setBottomLineStyle:TLCellLineStyleNone];
    }else if (indexPath.row == group.count - 1) {
        [cell setBottomLineStyle:TLCellLineStyleFill];
    }else{
        [cell setBottomLineStyle:TLCellLineStyleDefault];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TLInfoHeaderFooterView"];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TLInfoHeaderFooterView"];
}
//MARK: TLTableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXInfo *info = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if (info.type == TLInfoTypeButton) {
        return 50.0f;
    }
    return 44.0f;
}
//MARK: TLInfoButtonCellDelegate
- (void)infoButtonCellClicked:(WXInfo *)info{
    [self showAlerWithtitle:@"子类未处理按钮点击事件" message:[NSString stringWithFormat:@"Title: %@", info.title] style:UIAlertControllerStyleAlert ac1:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    } ac2:nil ac3:nil completion:nil];
}
@end
