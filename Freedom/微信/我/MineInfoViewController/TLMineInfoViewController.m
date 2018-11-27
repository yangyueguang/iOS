//  TLMineInfoViewController.m
//  Freedom
// Created by Super
#import "TLMineInfoViewController.h"
#import "TLMyQRCodeViewController.h"
#import "TLUserHelper.h"
#import "TLMineViewController.h"
#import "WechartModes.h"
@interface TLMineInfoAvatarCell : UITableViewCell
@property (nonatomic, strong) TLSettingItem *item;
@end
@interface TLMineInfoAvatarCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@end
@implementation TLMineInfoAvatarCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.avatarImageView];
        [self p_addMasonry];
    }
    return self;
}
- (void)setItem:(TLSettingItem *)item{
    _item = item;
    [self.titleLabel setText:item.title];
    if (item.rightImagePath) {
        [self.avatarImageView setImage: [UIImage imageNamed:item.rightImagePath]];
    }else if (item.rightImageURL){
        [self.avatarImageView sd_setImageWithURL:TLURL(item.rightImageURL) placeholderImage:[UIImage imageNamed:PuserLogo]];
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
@interface TLMineInfoViewController ()
@property (nonatomic, strong) TLMineInfoHelper *helper;
@end
@implementation TLMineInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"个人信息"];
    
    [self.tableView registerClass:[TLMineInfoAvatarCell class] forCellReuseIdentifier:@"TLMineInfoAvatarCell"];
    
    self.helper = [[TLMineInfoHelper alloc] init];
    self.data = [self.helper mineInfoDataByUserInfo:[TLUserHelper sharedHelper].user];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TLSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"头像"]) {
        TLMineInfoAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLMineInfoAvatarCell"];
        [cell setItem:item];
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
//MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TLSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"我的二维码"]) {
        TLMyQRCodeViewController *myQRCodeVC = [[TLMyQRCodeViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:myQRCodeVC animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TLSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"头像"]) {
        return 85.0f;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
@end
