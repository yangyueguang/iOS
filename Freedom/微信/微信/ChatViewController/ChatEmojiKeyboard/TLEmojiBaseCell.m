//  TLEmojiBaseCell.m
//  Freedom
// Created by Super
#import "TLEmojiBaseCell.h"
#import "NSFileManager+expanded.h"
@implementation TLEmoji
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"emojiID" : @"pId",
             @"emojiURL" : @"Url",
             @"emojiName" : @"credentialName",
             @"emojiPath" : @"imageFile",
             @"size" : @"size",
             };
}
- (NSString *)emojiPath{
    if (_emojiPath == nil) {
        NSString *groupPath = [NSFileManager pathExpressionForGroupID:self.groupID];
        _emojiPath = [NSString stringWithFormat:@"%@%@", groupPath, self.emojiID];
    }
    return _emojiPath;
}
@end
@implementation TLEmojiGroup
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"groupID" : @"eId",
             @"groupIconURL" : @"coverUrl",
             @"groupName" : @"eName",
             @"groupInfo" : @"memo",
             @"groupDetailInfo" : @"memo1",
             @"count" : @"picCount",
             @"bannerID" : @"aId",
             @"bannerURL" : @"URL",
             };
}
- (id)init{
    if (self = [super init]) {
        [self setType:TLEmojiTypeImageWithTitle];
    }
    return self;
}
- (void)setType:(TLEmojiType)type{
    _type = type;
    switch (type) {
        case TLEmojiTypeOther:
            return;
        case TLEmojiTypeFace:
        case TLEmojiTypeEmoji:
            self.rowNumber = 3;
            self.colNumber = 7;
            break;
        case TLEmojiTypeImage:
        case TLEmojiTypeFavorite:
        case TLEmojiTypeImageWithTitle:
            self.rowNumber = 2;
            self.colNumber = 4;
            break;
        default:
            break;
    }
    self.pageItemCount = self.rowNumber * self.colNumber;
    self.pageNumber = self.count / self.pageItemCount + (self.count % self.pageItemCount == 0 ? 0 : 1);
}
- (void)setData:(NSMutableArray *)data{
    _data = data;
    self.count = data.count;
    self.pageItemCount = self.rowNumber * self.colNumber;
    self.pageNumber = self.count / self.pageItemCount + (self.count % self.pageItemCount == 0 ? 0 : 1);
}
- (id)objectAtIndex:(NSUInteger)index{
    return [self.data objectAtIndex:index];
}
- (NSString *)path{
    if (_path == nil && self.groupID != nil) {
        _path = [NSFileManager pathExpressionForGroupID:self.groupID];
    }
    return _path;
}
- (NSString *)groupIconPath{
    if (_groupIconPath == nil && self.path != nil) {
        _groupIconPath = [NSString stringWithFormat:@"%@icon_%@", self.path, self.groupID];
    }
    return _groupIconPath;
}
- (NSString *)pictureURL{
    return self.bannerURL;
}
@end
@interface TLEmojiFaceItemCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation TLEmojiFaceItemCell
- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self p_addMasonry];
    }
    return self;
}
- (void)setEmojiItem:(TLEmoji *)emojiItem{
    [super setEmojiItem:emojiItem];
    [self.imageView setImage:emojiItem.emojiName == nil ? nil : [UIImage imageNamed:emojiItem.emojiName]];
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
#pragma mark - Getter -
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
@end
@interface TLEmojiImageItemCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation TLEmojiImageItemCell
- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self setHighlightImage:[UIImage imageNamed:@"emoji_hl_background"]];
        [self p_addMasonry];
    }
    return self;
}
- (void)setEmojiItem:(TLEmoji *)emojiItem{
    [super setEmojiItem:emojiItem];
    [self.imageView setImage:emojiItem.emojiPath == nil ? nil : [UIImage imageNamed:emojiItem.emojiPath]];
}
- (void)p_addMasonry{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
}
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
@end
@interface TLEmojiImageTitleItemCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end
@implementation TLEmojiImageTitleItemCell
- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setHighlightImage:[UIImage imageNamed:@"emoji_hl_background"]];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.label];
        [self p_addMasonry];
    }
    return self;
}
- (void)setEmojiItem:(TLEmoji *)emojiItem{
    [super setEmojiItem:emojiItem];
    [self.imageView setImage:emojiItem.emojiPath == nil ? nil : [UIImage imageNamed:emojiItem.emojiPath]];
    [self.label setText:emojiItem.emojiName];
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.bgView.mas_width);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(self.contentView).mas_offset(3);
        make.right.mas_equalTo(self.contentView).mas_offset(-3);
        make.height.mas_equalTo(self.imageView.mas_width);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.contentView);
    }];
}
#pragma mark - Getter -
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
- (UILabel *)label{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        [_label setFont:[UIFont systemFontOfSize:12.0f]];
        [_label setTextColor:[UIColor grayColor]];
        [_label setTextAlignment:NSTextAlignmentCenter];
    }
    return _label;
}
@end
@interface TLEmojiItemCell ()
@property (nonatomic, strong) UILabel *label;
@end
@implementation TLEmojiItemCell
- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.label];
        [self p_addMasonry];
    }
    return self;
}
- (void)setEmojiItem:(TLEmoji *)emojiItem{
    [super setEmojiItem:emojiItem];
    [self.label setText:emojiItem.emojiName];
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
}
#pragma mark - Getter -
- (UILabel *)label{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        [_label setFont:[UIFont systemFontOfSize:25.0f]];
    }
    return _label;
}
@end
@implementation TLEmojiBaseCell
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    return self;
}
- (void)setShowHighlightImage:(BOOL)showHighlightImage{
    if (showHighlightImage) {
        [self.bgView setImage:self.highlightImage];
    }else{
        [self.bgView setImage:nil];
    }
}
#pragma mark - Getter -
- (UIImageView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc] init];
        [_bgView.layer setMasksToBounds:YES];
        [_bgView.layer setCornerRadius:5.0f];
    }
    return _bgView;
}
@end
@interface TLEmojiGroupCell ()
@property (nonatomic, strong) UIImageView *groupIconView;
@end
@implementation TLEmojiGroupCell
- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *selectedView = [[UIView alloc] init];
        [selectedView setBackgroundColor:RGBACOLOR(245.0, 245.0, 247.0, 1.0)];
        [self setSelectedBackgroundView:selectedView];
        
        [self.contentView addSubview:self.groupIconView];
        [self p_addMasonry];
    }
    return self;
}
- (void)setEmojiGroup:(TLEmojiGroup *)emojiGroup{
    _emojiGroup = emojiGroup;
    [self.groupIconView setImage:[UIImage imageNamed:emojiGroup.groupIconPath]];
}
#pragma mark - Private Methods -
- (void) p_addMasonry{
    [self.groupIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.width.and.height.mas_lessThanOrEqualTo(30);
    }];
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, colorGrayLine.CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.frame.size.width - 0.5, 5);
    CGContextAddLineToPoint(context, self.frame.size.width - 0.5, self.frameHeight - 5);
    CGContextStrokePath(context);
}
#pragma mark - Getter -
- (UIImageView *)groupIconView{
    if (_groupIconView == nil) {
        _groupIconView = [[UIImageView alloc] init];
    }
    return _groupIconView;
}
@end
#define     WIDTH_EMOJIGROUP_CELL       46
#define     WIDTH_SENDBUTTON            60
@interface TLEmojiGroupControl () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSIndexPath *curIndexPath;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *sendButton;
@end
@implementation TLEmojiGroupControl
- (id) init{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.addButton];
        [self addSubview:self.collectionView];
        [self addSubview:self.sendButton];
        [self p_addMasonry];
        
        [self.collectionView registerClass:[TLEmojiGroupCell class] forCellWithReuseIdentifier:@"TLEmojiGroupCell"];
    }
    return self;
}
- (void)setSendButtonStatus:(TLGroupControlSendButtonStatus)sendButtonStatus{
    if (_sendButtonStatus != sendButtonStatus) {
        if (_sendButtonStatus == TLGroupControlSendButtonStatusNone) {
            [UIView animateWithDuration:BORDER_WIDTH_1PX animations:^{
                [self.sendButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self);
                }];
                [self layoutIfNeeded];
            }];
        }
        
        _sendButtonStatus = sendButtonStatus;
        if (sendButtonStatus == TLGroupControlSendButtonStatusNone) {
            [UIView animateWithDuration:BORDER_WIDTH_1PX animations:^{
                [self.sendButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self).mas_offset(WIDTH_SENDBUTTON);
                }];
                [self layoutIfNeeded];
            }];
        }else if (sendButtonStatus == TLGroupControlSendButtonStatusBlue) {
            [_sendButton setBackgroundImage:[UIImage imageNamed:@"emojiKB_sendBtn_blue"] forState:UIControlStateNormal];
            [_sendButton setBackgroundImage:[UIImage imageNamed:@"emojiKB_sendBtn_blueHL"] forState:UIControlStateHighlighted];
            [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if (sendButtonStatus == TLGroupControlSendButtonStatusGray) {
            [_sendButton setBackgroundImage:[UIImage imageNamed:@"emojiKB_sendBtn_gray"] forState:UIControlStateNormal];
            [_sendButton setBackgroundImage:[UIImage imageNamed:@"emojiKB_sendBtn_gray"] forState:UIControlStateHighlighted];
            [_sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
}
- (void)setEmojiGroupData:(NSMutableArray *)emojiGroupData{
    if (_emojiGroupData == emojiGroupData || [_emojiGroupData isEqualToArray:emojiGroupData]) {
        return;
    }
    _emojiGroupData = emojiGroupData;
    [self.collectionView reloadData];
    if (emojiGroupData && emojiGroupData.count > 0) {
        [self setCurIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}
- (void)setCurIndexPath:(NSIndexPath *)curIndexPath{
    [self.collectionView selectItemAtIndexPath:curIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    if (_curIndexPath && _curIndexPath.section == curIndexPath.section && _curIndexPath.row == curIndexPath.row) {
        return;
    }
    _curIndexPath = curIndexPath;
    if (_delegate && [_delegate respondsToSelector:@selector(emojiGroupControl:didSelectedGroup:)]) {
        TLEmojiGroup *group = [self.emojiGroupData[curIndexPath.section] objectAtIndex:curIndexPath.row];
        [_delegate emojiGroupControl:self didSelectedGroup:group];
    }
}
#pragma mark - Delegate -
//MARK: UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.emojiGroupData.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [(NSArray*)self.emojiGroupData[section] count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TLEmojiGroupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLEmojiGroupCell" forIndexPath:indexPath];
    TLEmojiGroup *group = [self.emojiGroupData[indexPath.section] objectAtIndex:indexPath.row];
    [cell setEmojiGroup:group];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(WIDTH_EMOJIGROUP_CELL, self.frameHeight);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == self.emojiGroupData.count - 1) {
        return CGSizeMake(WIDTH_EMOJIGROUP_CELL * 2, self.frameHeight);
    }
    return CGSizeZero;
}
//MARK: UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TLEmojiGroup *group = [self.emojiGroupData[indexPath.section] objectAtIndex:indexPath.row];
    if (group.type == TLEmojiTypeOther) {
        //???: 存在冲突：用户选中cellA,再此方法中立马调用方法选中cellB时，所有cell都不会被选中
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setCurIndexPath:_curIndexPath];
        });
        [self p_eidtMyEmojiButtonDown];
    }else{
        [self setCurIndexPath:indexPath];
    }
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.mas_equalTo(self);
        make.width.mas_equalTo(WIDTH_EMOJIGROUP_CELL);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.mas_equalTo(self);
        make.width.mas_equalTo(WIDTH_SENDBUTTON);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.addButton.mas_right);
        make.right.mas_equalTo(self.sendButton.mas_left);
    }];
}
- (void)p_eidtMyEmojiButtonDown{
    if (_delegate && [_delegate respondsToSelector:@selector(emojiGroupControlEditMyEmojiButtonDown:)]) {
        [_delegate emojiGroupControlEditMyEmojiButtonDown:self];
    }
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, colorGrayLine.CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, WIDTH_EMOJIGROUP_CELL, 5);
    CGContextAddLineToPoint(context, WIDTH_EMOJIGROUP_CELL, self.frameHeight - 5);
    CGContextStrokePath(context);
}
#pragma mark - Event Response -
- (void)emojiAddButtonDown{
    if (_delegate && [_delegate respondsToSelector:@selector(emojiGroupControlEditButtonDown:)]) {
        [_delegate emojiGroupControlEditButtonDown:self];
    }
}
- (void)sendButtonDown{
    if (_delegate && [_delegate respondsToSelector:@selector(emojiGroupControlSendButtonDown:)]) {
        [_delegate emojiGroupControlSendButtonDown:self];
    }
}
#pragma mark - Getter -
- (UIButton *)addButton{
    if (_addButton == nil) {
        _addButton = [[UIButton alloc] init];
        [_addButton setImage:[UIImage imageNamed:@"emojiKB_groupControl_add"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(emojiAddButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setMinimumLineSpacing:0];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setScrollsToTop:NO];
    }
    return _collectionView;
}
- (UIButton *)sendButton{
    if (_sendButton == nil) {
        _sendButton = [[UIButton alloc] init];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_sendButton setTitle:@"  发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:[UIColor clearColor]];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"emojiKB_sendBtn_gray"] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"emojiKB_sendBtn_gray"] forState:UIControlStateHighlighted];
        [_sendButton addTarget:self action:@selector(sendButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
@end
