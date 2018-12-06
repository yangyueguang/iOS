//  TLUserGroupCell.m
//  Freedom
// Created by Super
#import "WXUserGroupCell.h"
#define     USER_CELL_WIDTH         57
#define     USER_CELL_HEIGHT        75
#define     USER_CELL_ROWSPACE     15
#define     USER_CELL_COLSPACE      ((APPW - USER_CELL_WIDTH * 4) / 5)
#import "UIButton+WebCache.h"
#import "WXUserHelper.h"
@interface WXUserGroupItemCell : UICollectionViewCell
@property (nonatomic, strong) WXUser *user;
@property (nonatomic, strong) void (^clickBlock)(WXUser *user);
@end
@interface WXUserGroupItemCell()
@property (nonatomic, strong) UIButton *avatarView;
@property (nonatomic, strong) UILabel *usernameLabel;
@end
@implementation WXUserGroupItemCell
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.usernameLabel];
        
        [self p_addMasonry];
    }
    return self;
}
- (void)setUser:(WXUser *)user{
    _user = user;
    if (user != nil) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:user.avatarURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PuserLogo]];
        [self.usernameLabel setText:user.showName];
    }else{
        [self.avatarView setImage:[UIImage imageNamed:@"chatdetail_add_member"] forState:UIControlStateNormal];
        [self.avatarView setImage:[UIImage imageNamed:@"chatdetail_add_memberHL"] forState:UIControlStateHighlighted];
        [self.usernameLabel setText:nil];
    }
}
#pragma mark - EventResponse -
- (void)avatarButtonDown{
    self.clickBlock(self.user);
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.avatarView.mas_width);
    }];
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.bottom.mas_equalTo(self.contentView);
        make.left.and.right.mas_lessThanOrEqualTo(self.contentView);
    }];
}
#pragma mark - Getter -
- (UIButton *)avatarView{
    if (_avatarView == nil) {
        _avatarView = [[UIButton alloc] init];
        [_avatarView.layer setMasksToBounds:YES];
        [_avatarView.layer setCornerRadius:5.0f];
        [_avatarView addTarget:self action:@selector(avatarButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarView;
}
- (UILabel *)usernameLabel{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        [_usernameLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_usernameLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _usernameLabel;
}
@end
@interface WXUserGroupCell () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end
@implementation WXUserGroupCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.collectionView];
        [self.collectionView registerClass:[WXUserGroupItemCell class] forCellWithReuseIdentifier:@"TLUserGroupItemCell"];
        
        [self p_addMasonry];
    }
    return self;
}
#pragma mark - Delegate -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.users.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WXUserGroupItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLUserGroupItemCell" forIndexPath:indexPath];
    if (indexPath.row < self.users.count) {
        [cell setUser:self.users[indexPath.row]];
    }else{
        [cell setUser:nil];
    }
    [cell setClickBlock:^(WXUser *user) {
        if (user && _delegate && [_delegate respondsToSelector:@selector(userGroupCellDidSelectUser:)]) {
            [_delegate userGroupCellDidSelectUser:user];
        }else{
            [_delegate userGroupCellAddUserButtonDown];
        }
    }];
    return cell;
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}
#pragma mark - Getter -
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(USER_CELL_WIDTH, USER_CELL_HEIGHT)];
        [layout setMinimumInteritemSpacing:USER_CELL_COLSPACE];
        [layout setSectionInset:UIEdgeInsetsMake(USER_CELL_ROWSPACE, USER_CELL_COLSPACE * 0.9, USER_CELL_ROWSPACE, USER_CELL_ROWSPACE * 0.9)];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView setScrollEnabled:NO];
        [_collectionView setPagingEnabled:YES];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setScrollsToTop:NO];
    }
    return _collectionView;
}
@end
