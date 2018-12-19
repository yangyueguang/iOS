//  FreedomFileViewController.m
//  Freedom
//  Created by Super on 16/3/18.
#import "WXChatFileViewController.h"
#import "MWPhotoBrowser.h"
#import "WXTabBarController.h"
#import "WXMessageManager.h"
#import "NSFileManager+expanded.h"
@interface WXChatFileCell : UICollectionViewCell
@property (nonatomic, strong) WXMessage * message;
@end
@interface WXChatFileCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation WXChatFileCell
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self p_addMasonry];
    }
    return self;
}
- (void)setMessage:(WXMessage *)message{
    _message = message;
    if (message.messageType == TLMessageTypeImage) {
        WXImageMessage *me = (WXImageMessage*)message;
        NSString *imagePath = me.content[@"path"];
        NSString *imageURL = me.content[@"url"];
        if (imagePath.length > 0) {
            NSString *imagePatha = [NSFileManager pathUserChatImage:imagePath];
            [self.imageView setImage:[UIImage imageNamed:imagePatha]];
        }else if (imageURL.length > 0) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"userLogo"]];
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
@interface WXChatFileHeaderView : UICollectionReusableView
@property (nonatomic, strong) NSString *title;
@end
@interface WXChatFileHeaderView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation WXChatFileHeaderView
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
        [_bgView setBackgroundColor:UIColor(46.0, 49.0, 50.0, 1.0)];
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
@interface WXChatFileViewController ()
@property (nonatomic, strong) NSMutableArray *mediaData;
@property (nonatomic, strong) NSMutableArray *browserData;
@property (nonatomic,strong) UICollectionView *collectionView;
@end
@implementation WXChatFileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"聊天文件"];
    [self.view setBackgroundColor:UIColor(46.0, 49.0, 50.0, 1.0)];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        [layout setSectionHeadersPinToVisibleBounds:YES];
    }
    [layout setItemSize:CGSizeMake(APPW / 4 * 0.98, APPW / 4 * 0.98)];
    [layout setMinimumInteritemSpacing:(APPW - APPW / 4 * 0.98 * 4) / 3];
    [layout setMinimumLineSpacing:(APPW - APPW / 4 * 0.98 * 4) / 3];
    [layout setHeaderReferenceSize:CGSizeMake(APPW, 28)];
    [layout setFooterReferenceSize:CGSizeMake(APPW, 0)];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setAlwaysBounceVertical:YES];
    
    [self.view addSubview:self.collectionView];
    [self p_addMasonry];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain actionBlick:^{
        
    }];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    [self.collectionView registerClass:[WXChatFileHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TLChatFileHeaderView"];
    [self.collectionView registerClass:[WXChatFileCell class] forCellWithReuseIdentifier:@"TLChatFileCell"];
}
- (void)setPartnerID:(NSString *)partnerID{
    _partnerID = partnerID;
    __weak typeof(self) weakSelf = self;
    [[WXMessageManager sharedInstance] chatFilesForPartnerID:partnerID completed:^(NSArray *data) {
        [weakSelf.data removeAllObjects];
        weakSelf.mediaData = nil;
        [weakSelf.data addObjectsFromArray:data];
        [weakSelf.collectionView reloadData];
    }];
}
#pragma mark - Delegate -
//MARK: UIcollectionViewDataSource
- (NSInteger)numberOfSectionsIncollectionView:(UICollectionView *)collectionView{
    return self.data.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *temp = self.data[section];
    return [temp count];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    WXMessage *message = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    WXChatFileHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TLChatFileHeaderView" forIndexPath:indexPath];
    [headerView setTitle:[message.date timeToNow]];
    return headerView;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WXMessage * message = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    WXChatFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLChatFileCell" forIndexPath:indexPath];
    [cell setMessage:message];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WXMessage *message = [self.data[indexPath.section] objectAtIndex:indexPath.row];
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
            WXNavigationController *broserNavC = [[WXNavigationController alloc] initWithRootViewController:browser];
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
            for (WXMessage *message in array) {
                if (message.messageType == TLMessageTypeImage) {
                    [_mediaData addObject:message];
                    NSURL *url;
                    WXImageMessage *me = (WXImageMessage *)message;
                    if (me.content[@"path"]) {
                        NSString *imagePath = [NSFileManager pathUserChatImage:me.content[@"path"]];
                        url = [NSURL fileURLWithPath:imagePath];
                    }
                    else {
                        url = [NSURL URLWithString:me.content[@"url"]];
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
        for (WXMessage *message in self.mediaData) {
            if (message.messageType == TLMessageTypeImage) {
                NSURL *url;
                NSString *imagePath = message.content[@"path"];
                if (imagePath) {
                    NSString *imagePatha = [NSFileManager pathUserChatImage:imagePath];
                    url = [NSURL fileURLWithPath:imagePatha];
                }
                else {
                    url = [NSURL URLWithString:message.content[@"url"]];
                }
                MWPhoto *photo = [MWPhoto photoWithURL:url];
                [_browserData addObject:photo];
            }
        }
    }
    return _browserData;
}
@end
