//  TLMineInfoViewController.m
//  Freedom
// Created by Super
#import "WXMineInfoViewController.h"
#import "WXMyQRCodeViewController.h"
#import "WXUserHelper.h"
#import "WXMineViewController.h"
#import "WXModes.h"
@interface WXMineInfoAvatarCell : UITableViewCell
@property (nonatomic, strong) WXSettingItem *item;
@end
@interface WXMineInfoAvatarCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@end
@implementation WXMineInfoAvatarCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.avatarImageView];
        [self p_addMasonry];
    }
    return self;
}
- (void)setItem:(WXSettingItem *)item{
    _item = item;
    [self.titleLabel setText:item.title];
    if (item.rightImagePath) {
        [self.avatarImageView setImage: [UIImage imageNamed:item.rightImagePath]];
    }else if (item.rightImageURL){
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:item.rightImageURL] placeholderImage:[UIImage imageNamed:PuserLogo]];
    }else{
        [self.avatarImageView setImage:nil];
    }
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.right.mas_lessThanOrEqualTo(self.avatarImageView.mas_left).mas_offset(-15);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).mas_offset(9);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-9);
        make.width.mas_equalTo(self.avatarImageView.mas_height);
    }];
}
#pragma mark - Getter -
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}
- (UIImageView *)avatarImageView{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView.layer setMasksToBounds:YES];
        [_avatarImageView.layer setCornerRadius:4.0f];
    }
    return _avatarImageView;
}
@end
@interface WXMineInfoViewController ()
@property (nonatomic, strong) WXMineInfoHelper *helper;
@end
@implementation WXMineInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"个人信息"];
    
    [self.tableView registerClass:[WXMineInfoAvatarCell class] forCellReuseIdentifier:@"TLMineInfoAvatarCell"];
    
    self.helper = [[WXMineInfoHelper alloc] init];
    self.data = [self.helper mineInfoDataByUserInfo:[WXUserHelper sharedHelper].user];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"头像"]) {
        WXMineInfoAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLMineInfoAvatarCell"];
        [cell setItem:item];
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
//MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"我的二维码"]) {
        WXMyQRCodeViewController *myQRCodeVC = [[WXMyQRCodeViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:myQRCodeVC animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"头像"]) {
        return 85.0f;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
@end
