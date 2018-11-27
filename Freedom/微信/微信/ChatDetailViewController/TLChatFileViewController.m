//  FreedomFileViewController.m
//  Freedom
//  Created by Super on 16/3/18.
#import "TLChatFileViewController.h"
#import <XCategory/NSDate+expanded.h>
#import "MWPhotoBrowser.h"
#import "TLMessageManager.h"
#define     HEIGHT_COLLECTIONVIEW_HEADER    28
#define     WIDTH_COLLECTIONVIEW_CELL       WIDTH_SCREEN / 4 * 0.98
#define     SPACE_COLLECTIONVIEW_CELL       (WIDTH_SCREEN - WIDTH_COLLECTIONVIEW_CELL * 4) / 3
@interface TLChatFileCell : UICollectionViewCell
@property (nonatomic, strong) TLMessage * message;
@end
@interface TLChatFileCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation TLChatFileCell
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self p_addMasonry];
    }
    return self;
}
- (void)setMessage:(TLMessage *)message{
    _message = message;
    if (message.messageType == TLMessageTypeImage) {
        if ([(TLImageMessage *)message imagePath].length > 0) {
            NSString *imagePath = [NSFileManager pathUserChatImage:[(TLImageMessage *)message imagePath]];
            [self.imageView setImage:[UIImage imageNamed:imagePath]];
        }else if ([(TLImageMessage *)message imageURL].length > 0) {
            [self.imageView sd_setImageWithURL:TLURL([(TLImageMessage *)message imageURL]) placeholderImage:[UIImage imageNamed:PuserLogo]];
        }else{
            [self.imageView setImage:nil];
        }
    }
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
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
@interface TLChatFileHeaderView : UICollectionReusableView
@property (nonatomic, strong) NSString *title;
@end
@interface TLChatFileHeaderView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation TLChatFileHeaderView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.bgView];
        [self addSubview:self.titleLabel];
        [self p_addMasonry];
    }
    return self;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    [self.titleLabel setText:title];
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).mas_offset(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
}
#pragma mark - Getter -
- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        [_bgView setBackgroundColor:RGBACOLOR(46.0, 49.0, 50.0, 1.0)];
        [_bgView setAlpha:0.8f];
    }
    return _bgView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    return _titleLabel;
}
@end
@interface TLChatFileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *mediaData;
@property (nonatomic, strong) NSMutableArray *browserData;
@end
@implementation TLChatFileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"聊天文件"];
    [self.view setBackgroundColor:RGBACOLOR(46.0, 49.0, 50.0, 1.0)];
    
    [self.view addSubview:self.collectionView];
    [self p_addMasonry];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain actionBlick:^{
        
    }];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    [self.collectionView registerClass:[TLChatFileHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TLChatFileHeaderView"];
    [self.collectionView registerClass:[TLChatFileCell class] forCellWithReuseIdentifier:@"TLChatFileCell"];
}
- (void)setPartnerID:(NSString *)partnerID{
    _partnerID = partnerID;
    __weak typeof(self) weakSelf = self;
    [[TLMessageManager sharedInstance] chatFilesForPartnerID:partnerID completed:^(NSArray *data) {
        [weakSelf.data removeAllObjects];
        weakSelf.mediaData = nil;
        [weakSelf.data addObjectsFromArray:data];
        [weakSelf.collectionView reloadData];
    }];
}
#pragma mark - Delegate -
//MARK: UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.data.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.data[section] count];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    TLMessage *message = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    TLChatFileHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TLChatFileHeaderView" forIndexPath:indexPath];
    [headerView setTitle:[message.date chatFileTimeInfo]];
    return headerView;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TLMessage * message = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    TLChatFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLChatFileCell" forIndexPath:indexPath];
    [cell setMessage:message];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TLMessage *message = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if (message.messageType == TLMessageTypeImage) {
        NSInteger index = -1;
        for (int i = 0; i < self.mediaData.count; i++) {
            if ([message.messageID isEqualToString:[self.mediaData[i] messageID]]) {
                index = i;
                break;
            }
        }
        if (index >= 0) {
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:self.browserData];
            [browser setDisplayNavArrows:YES];
            [browser setCurrentPhotoIndex:index];
            TLNavigationController *broserNavC = [[TLNavigationController alloc] initWithRootViewController:browser];
            [self presentViewController:broserNavC animated:NO completion:nil];
        }
    }
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
}
#pragma mark - Getter -
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
            [layout setSectionHeadersPinToVisibleBounds:YES];
        }
        [layout setItemSize:CGSizeMake(WIDTH_COLLECTIONVIEW_CELL, WIDTH_COLLECTIONVIEW_CELL)];
        [layout setMinimumInteritemSpacing:SPACE_COLLECTIONVIEW_CELL];
        [layout setMinimumLineSpacing:SPACE_COLLECTIONVIEW_CELL];
        [layout setHeaderReferenceSize:CGSizeMake(WIDTH_SCREEN, HEIGHT_COLLECTIONVIEW_HEADER)];
        [layout setFooterReferenceSize:CGSizeMake(WIDTH_SCREEN, 0)];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setAlwaysBounceVertical:YES];
    }
    return _collectionView;
}
- (NSMutableArray *)data{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}
- (NSMutableArray *)mediaData{
    if (_mediaData == nil) {
        _mediaData = [[NSMutableArray alloc] init];
        for (NSArray *array in self.data) {
            for (TLMessage *message in array) {
                if (message.messageType == TLMessageTypeImage) {
                    [_mediaData addObject:message];
                    NSURL *url;
                    if ([(TLImageMessage *)message imagePath]) {
                        NSString *imagePath = [NSFileManager pathUserChatImage:[(TLImageMessage *)message imagePath]];
                        url = [NSURL fileURLWithPath:imagePath];
                    }
                    else {
                        url = TLURL([(TLImageMessage *)message imageURL]);
                    }
                    MWPhoto *photo = [MWPhoto photoWithURL:url];
                    [_browserData addObject:photo];
                }
            }
        }
    }
    return _mediaData;
}
- (NSMutableArray *)browserData{
    if (_browserData == nil) {
        _browserData = [[NSMutableArray alloc] init];
        for (TLMessage *message in self.mediaData) {
            if (message.messageType == TLMessageTypeImage) {
                NSURL *url;
                if ([(TLImageMessage *)message imagePath]) {
                    NSString *imagePath = [NSFileManager pathUserChatImage:[(TLImageMessage *)message imagePath]];
                    url = [NSURL fileURLWithPath:imagePath];
                }
                else {
                    url = TLURL([(TLImageMessage *)message imageURL]);
                }
                MWPhoto *photo = [MWPhoto photoWithURL:url];
                [_browserData addObject:photo];
            }
        }
    }
    return _browserData;
}
@end
