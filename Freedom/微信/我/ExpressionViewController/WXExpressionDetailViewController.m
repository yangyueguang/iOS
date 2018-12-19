//  WXExpressionDetailViewController.m
//  Freedom
// Created by Super
#import "WXExpressionDetailViewController.h"
#import "WXExpressionHelper.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "UIImage+GIF.h"
#import "TLEmojiBaseCell.h"
@protocol WXExpressionDetailCellDelegate <NSObject>
- (void)expressionDetailCellDownloadButtonDown:(TLEmojiGroup *)group;
@end
@interface WXExpressionDetailCell : UICollectionViewCell
@property (nonatomic, assign) id <WXExpressionDetailCellDelegate> delegate;
@property (nonatomic, strong) TLEmojiGroup *group;
+ (CGFloat)cellHeightForModel:(TLEmojiGroup *)group;
@end
@interface WXExpressionDetailCell ()
@property (nonatomic, strong) UIImageView *bannerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UILabel *detailLabel;
@end
@implementation WXExpressionDetailCell
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bannerView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.downloadButton];
        [self.contentView addSubview:self.detailLabel];
        
        [self p_addMasonry];
    }
    return self;
}
- (void)setGroup:(TLEmojiGroup *)group{
    _group = group;
    if (group.bannerURL.length > 0) {
        [self.bannerView sd_setImageWithURL:[NSURL URLWithString:group.bannerURL]];
        [self.bannerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo((APPW * 0.45));
        }];
    }else{
        [self.bannerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    [self.titleLabel setText:group.groupName];
    [self.detailLabel setText:group.groupDetailInfo];
    if (group.status == TLEmojiGroupStatusDownloaded) {
        [self.downloadButton setTitle:@"已下载" forState:UIControlStateNormal];
        [self.downloadButton setBackgroundColor:[UIColor grayColor]];
    }else if (group.status == TLEmojiGroupStatusDownloading) {
        [self.downloadButton setTitle:@"下载中" forState:UIControlStateNormal];
        [self.downloadButton setBackgroundColor: [UIColor greenColor]];
    }else{
        [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        [self.downloadButton setBackgroundColor: [UIColor greenColor]];
    }
}
#pragma mark - Private Methods
- (void)p_addMasonry{
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom).mas_offset(25.0f);
        make.left.mas_equalTo(15.0f);
        make.right.mas_lessThanOrEqualTo(self.downloadButton.mas_right).mas_offset(-15);
    }];
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel).mas_offset(-2);
        make.right.mas_equalTo(self.contentView).mas_offset(-15.0f);
        make.size.mas_equalTo(CGSizeMake(75, 26));
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.contentView).mas_offset(-15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    [line1 setBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:line1];
    UIView *line2 = [[UIView alloc] init];
    [line2 setBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:line2];
    UILabel *label = [[UILabel alloc] init];
    [label setTextColor:[UIColor grayColor]];
    [label setFont:[UIFont systemFontOfSize:12.0f]];
    [label setText:@"长按表情可预览"];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5.0f);
        make.left.mas_equalTo(line1.mas_right).mas_offset(5.0f);
        make.right.mas_equalTo(line2.mas_left).mas_offset(-5.0f);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(15.0f);
        make.centerY.mas_equalTo(label);
        make.width.mas_equalTo(line2);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(-15.0f);
        make.centerY.mas_equalTo(label);
    }];
}
#pragma mark - Event Response
- (void)downloadButtonDown:(UIButton *)sender{
    [sender setTitle:@"下载中" forState:UIControlStateNormal];
    if (_delegate && [_delegate respondsToSelector:@selector(expressionDetailCellDownloadButtonDown:)]) {
        [_delegate expressionDetailCellDownloadButtonDown:self.group];
    }
}
#pragma mark - Getter
- (UIImageView *)bannerView{
    if (_bannerView == nil) {
        _bannerView = [[UIImageView alloc] init];
    }
    return _bannerView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}
- (UIButton *)downloadButton{
    if (_downloadButton == nil) {
        _downloadButton = [[UIButton alloc] init];
        [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        [_downloadButton setBackgroundColor:[UIColor greenColor]];
        [_downloadButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_downloadButton.layer setMasksToBounds:YES];
        [_downloadButton.layer setCornerRadius:3.0f];
        [_downloadButton.layer setBorderWidth:1];
        [_downloadButton.layer setBorderColor:[UIColor grayColor].CGColor];
        [_downloadButton addTarget:self action:@selector(downloadButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}
- (UILabel *)detailLabel{
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        [_detailLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_detailLabel setTextColor:[UIColor grayColor]];
        [_detailLabel setNumberOfLines:0];
    }
    return _detailLabel;
}
#pragma mark - Class Methods
+ (CGFloat)cellHeightForModel:(TLEmojiGroup *)group{
    CGFloat detailHeight = [group.groupDetailInfo boundingRectWithSize:CGSizeMake(APPW - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:13.0f]} context:nil].size.height;
    CGFloat bannerHeight = group.bannerURL.length > 0 ? (APPW * 0.45) : 0;
    CGFloat height = 105.0 + detailHeight + bannerHeight;
    return height;
}
@end
@interface WXExpressionItemCell : UICollectionViewCell
@property (nonatomic, strong) TLEmoji *emoji;
@end
@interface WXExpressionItemCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation WXExpressionItemCell
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        
        [self p_addMasonry];
    }
    return self;
}
- (void)setEmoji:(TLEmoji *)emoji{
    _emoji = emoji;
    UIImage *image = [UIImage imageNamed:emoji.emojiPath];
    if (image) {
        [self.imageView setImage:image];
    }else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:emoji.emojiURL]];
    }
}
#pragma mark - Private Methods
- (void)p_addMasonry{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}
#pragma mark - Getter
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [_imageView.layer setMasksToBounds:YES];
        [_imageView.layer setCornerRadius:3.0f];
    }
    return _imageView;
}
@end
@interface WXExpressionDetailViewController ()<WXExpressionDetailCellDelegate>{
    NSInteger kPageIndex;
}
@property (nonatomic, strong) WXExpressionHelper *proxy;
@property (nonatomic,strong) UICollectionView *collectionView;
@end
@implementation WXExpressionDetailViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setAlwaysBounceVertical:YES];
    
    [self.view addSubview:self.collectionView];
    
    [self registerCellForCollectionView:self.collectionView];
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] init];
    [longPressGR setMinimumPressDuration:1.0f];
    [longPressGR addTarget:self action:@selector(didLongPressScreen:)];
    [self.collectionView addGestureRecognizer:longPressGR];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    [tapGR setNumberOfTapsRequired:5];
    [tapGR setNumberOfTouchesRequired:1];
    [tapGR addTarget:self action:@selector(didTap5TimesScreen:)];
    [self.collectionView addGestureRecognizer:tapGR];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.group.data == nil) {
        [SVProgressHUD show];
        [self p_loadData];
    }
}
- (void)setGroup:(TLEmojiGroup *)group{
    _group = group;
    [self.navigationItem setTitle:group.groupName];
//    [self.collectionView reloadData];
}
#pragma mark - Private Methods
- (void)p_loadData{
    kPageIndex = 1;
    __weak typeof(self) weakSelf = self;
    [self.proxy requestExpressionGroupDetailByGroupID:self.group.groupID pageIndex:kPageIndex success:^(id data) {
        [SVProgressHUD dismiss];
        weakSelf.group.data = data;
        [weakSelf.collectionView reloadData];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - Getter
- (WXExpressionHelper *)proxy{
    if (_proxy == nil) {
        _proxy = [WXExpressionHelper sharedHelper];
    }
    return _proxy;
}
- (WXImageExpressionDisplayView *)emojiDisplayView{
    if (_emojiDisplayView == nil) {
        _emojiDisplayView = [[WXImageExpressionDisplayView alloc] init];
    }
    return _emojiDisplayView;
}
- (void)registerCellForCollectionView:(UICollectionView *)collectionView{
    [collectionView registerClass:[WXExpressionItemCell class] forCellWithReuseIdentifier:@"TLExpressionItemCell"];
    [collectionView registerClass:[WXExpressionDetailCell class] forCellWithReuseIdentifier:@"TLExpressionDetailCell"];
}
- (void)didLongPressScreen:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {        // 长按停止
        [self.emojiDisplayView removeFromSuperview];
    }else{
        CGPoint point = [sender locationInView:self.collectionView];
        for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
            if (cell.frame.origin.x <= point.x && cell.frame.origin.y <= point.y && cell.frame.origin.x + cell.frame.size.width >= point.x && cell.frame.origin.y + cell.frame.size.height >= point.y) {
                NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
                TLEmoji *emoji = [self.group objectAtIndex:indexPath.row];
                CGRect rect = cell.frame;
                rect.origin.y -= (self.collectionView.contentOffset.y + 13);
                [self.emojiDisplayView removeFromSuperview];
                [self.emojiDisplayView displayEmoji:emoji atRect:rect];
                [self.view addSubview:self.emojiDisplayView];
                break;
            }
        }
    }
}
- (void)didTap5TimesScreen:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.collectionView];
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        if (cell.frame.origin.x <= point.x && cell.frame.origin.y <= point.y && cell.frame.origin.x + cell.frame.size.width >= point.x && cell.frame.origin.y + cell.frame.size.height >= point.y) {
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            TLEmoji *emoji = [self.group objectAtIndex:indexPath.row];
            [SVProgressHUD showWithStatus:@"正在将表情保存到系统相册"];
            NSString *urlString = [NSString stringWithFormat:@"http://123.57.155.230:8080/ibiaoqing/admin/expre/download.do?pId=%@",emoji.emojiID];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            if (!data) {
                data = [NSData dataWithContentsOfFile:emoji.emojiPath];
            }
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }
            break;
        }
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"保存图片到系统相册失败\n%@", [error description]]];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"已保存到系统相册"];
    }
}
#pragma mark - Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.group.data.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WXExpressionDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLExpressionDetailCell" forIndexPath:indexPath];
        [cell setGroup:self.group];
        [cell setDelegate:self];
        return cell;
    }
    WXExpressionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLExpressionItemCell" forIndexPath:indexPath];
    TLEmoji *emoji = [self.group objectAtIndex:indexPath.row];
    [cell setEmoji:emoji];
    return cell;
}
//MARK: UICollectionDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat height = [WXExpressionDetailCell cellHeightForModel:self.group];
        return CGSizeMake(collectionView.frame.size.width, height);
    }else{
        return CGSizeMake(((APPW - 20 * 2 - 15 * 3.0) / 4.0),((APPW - 20 * 2 - 15 * 3.0) / 4.0));
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return section == 0 ? 0 : 15;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return section == 0 ? 0 : 15;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return section == 0 ? UIEdgeInsetsZero : UIEdgeInsetsMake(20,20,20,20);
}
//MAKR: TLExpressionDetailCellDelegate
- (void)expressionDetailCellDownloadButtonDown:(TLEmojiGroup *)group{
    [[WXExpressionHelper sharedHelper] downloadExpressionsWithGroupInfo:group progress:^(CGFloat progress) {
        
    } success:^(TLEmojiGroup *group) {
        group.status = TLEmojiGroupStatusDownloaded;
        [self.collectionView reloadData];
        BOOL ok = [[WXExpressionHelper sharedHelper] addExpressionGroup:group];
        if (!ok) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"表情 %@ 存储失败！", group.groupName]];
        }
    } failure:^(TLEmojiGroup *group, NSString *error) {
        group.status = TLEmojiGroupStatusUnDownload;
        [self.collectionView reloadData];
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"\"%@\" 下载失败: %@", group.groupName, error]];
    }];
}
@end
