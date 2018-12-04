//  TLMyExpressionViewController.m
//  Freedom
//  Created by Super on 16/3/10.
#import "WXMyExpressionViewController.h"
#import "WXExpressionDetailViewController.h"
#import "WXExpressionHelper.h"
#import "TLEmojiBaseCell.h"
@protocol WXMyExpressionCellDelegate <NSObject>
- (void)myExpressionCellDeleteButtonDown:(TLEmojiGroup *)group;
@end
@interface WXMyExpressionCell : UITableViewCell
@property (nonatomic, assign) id<WXMyExpressionCellDelegate>delegate;
@property (nonatomic, strong) TLEmojiGroup *group;
@end
@interface WXMyExpressionCell()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *delButton;
@end
@implementation WXMyExpressionCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titleLabel];
        [self setAccessoryView:self.delButton];
        
        [self p_addMasonry];
    }
    return self;
}
- (void)setGroup:(TLEmojiGroup *)group{
    _group = group;
    [self.iconView setImage:[UIImage imageNamed:group.groupIconPath]];
    [self.titleLabel setText:group.groupName];
}
#pragma mark - Event Response -
- (void)delButtonDown{
    if (_delegate && [_delegate respondsToSelector:@selector(myExpressionCellDeleteButtonDown:)]) {
        [_delegate myExpressionCellDeleteButtonDown:self.group];
    }
}
#pragma mark - Private Methods
- (void)p_addMasonry{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(15.0f);
        make.centerY.mas_equalTo(self.contentView);
        make.width.and.height.mas_equalTo(35);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconView);
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(10.0f);
        make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-15.0f);
    }];
}
#pragma mark - Getter -
- (UIImageView *)iconView{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}
- (UIButton *)delButton{
    if (_delButton == nil) {
        _delButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [_delButton setTitle:@"移除" forState:UIControlStateNormal];
        [_delButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_delButton setBackgroundColor:colorGrayBG];
        [_delButton setBackgroundImage:[FreedomTools imageWithColor:colorGrayLine] forState:UIControlStateHighlighted];
        [_delButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_delButton addTarget:self action:@selector(delButtonDown) forControlEvents:UIControlEventTouchUpInside];
        [_delButton.layer setMasksToBounds:YES];
        [_delButton.layer setCornerRadius:3.0f];
        [_delButton.layer setBorderWidth:BORDER_WIDTH_1PX];
        [_delButton.layer setBorderColor:colorGrayLine.CGColor];
    }
    return _delButton;
}
@end
@interface WXMyExpressionViewController () <WXMyExpressionCellDelegate>
@property (nonatomic, strong) WXExpressionHelper *helper;
@end
@implementation WXMyExpressionViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的表情"];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"排序" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    if (self.navigationController.rootViewController == self) {
        UIBarButtonItem *dismissBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain actionBlick:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [self.navigationItem setLeftBarButtonItem:dismissBarButton];
    }
    
    [self.tableView registerClass:[WXMyExpressionCell class] forCellReuseIdentifier:@"TLMyExpressionCell"];
    
    self.helper = [WXExpressionHelper sharedHelper];
    self.data = [self.helper myExpressionListData];
}
#pragma mark - Delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXSettingGroup *group = self.data[indexPath.section];
    if (group.headerTitle) {    // 有标题的就是表情组
        TLEmojiGroup *emojiGroup = [group objectAtIndex:indexPath.row];
        WXMyExpressionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLMyExpressionCell"];
        [cell setGroup:emojiGroup];
        [cell setDelegate:self];
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXSettingGroup *group = self.data[indexPath.section];
    if (group.headerTitle) {
        return 50.0f;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXSettingGroup *group = self.data[indexPath.section];
    if (group.headerTitle) {    // 有标题的就是表情组
        TLEmojiGroup *emojiGroup = [group objectAtIndex:indexPath.row];
        WXExpressionDetailViewController *detailVC = [[WXExpressionDetailViewController alloc] init];
        [detailVC setGroup:emojiGroup];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//MARK: TLMyExpressionCellDelegate
- (void)myExpressionCellDeleteButtonDown:(TLEmojiGroup *)group{
    BOOL ok = [self.helper deleteExpressionGroupByID:group.groupID];
    if (ok) {
        BOOL canDeleteFile = ![self.helper didExpressionGroupAlwaysInUsed:group.groupID];
        if (canDeleteFile) {
            NSError *error;
            ok = [[NSFileManager defaultManager] removeItemAtPath:group.path error:&error];
            if (!ok) {
                DLog(@"删除表情文件失败\n路径:%@\n原因:%@", group.path, [error description]);
            }
        }
        
        NSInteger row = [self.data[0] indexOfObject:group];
        [self.data[0] removeObject:group];
        NSArray *temp = self.data[0];
        if ([temp count] == 0) {
            [self.data removeObjectAtIndex:0];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"表情包删除失败"];
    }
}
#pragma mark - Event Response -
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
}
@end
