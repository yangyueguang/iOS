//  TLExpressionChosenViewController.m
//  Freedom
//  Created by Super on 16/4/4.
#import "WXExpressionChosenViewController.h"
#import "WXExpressionSearchViewController.h"
#import "WXSearchController.h"
#import "WXExpressionDetailViewController.h"
#import "WXExpressionHelper.h"
#import "WXPictureCarouselView.h"
#define         EDGE_TOP        10.0f
#define         EDGE_LEFT       15.0f
#define         ROW_SPCAE       10.0f
@interface WXExpressionCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *tagView;
@property (nonatomic, strong) UIButton *downloadButton;
@end
@implementation WXExpressionCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.tagView];
        [self.contentView addSubview:self.downloadButton];
        
        [self p_addMasonry];
    }
    return self;
}
- (void)setGroup:(TLEmojiGroup *)group{
    _group = group;
    UIImage *image = [UIImage imageNamed:group.groupIconPath];
    if (image) {
        [self.iconImageView setImage:image];
    }else{
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:group.groupIconURL]];
    }
    [self.titleLabel setText:group.groupName];
    [self.detailLabel setText:group.groupDetailInfo];
    
    if (group.status == TLEmojiGroupStatusDownloaded) {
        [self.downloadButton setTitle:@"已下载" forState:UIControlStateNormal];
        [self.downloadButton.layer setBorderColor:[UIColor grayColor].CGColor];
        [self.downloadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else if (group.status == TLEmojiGroupStatusDownloading) {
        [self.downloadButton setTitle:@"下载中" forState:UIControlStateNormal];
        [self.downloadButton.layer setBorderColor:[UIColor greenColor].CGColor];
        [self.downloadButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }else{
        [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        [self.downloadButton.layer setBorderColor:[UIColor greenColor].CGColor];
        [self.downloadButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }
}
#pragma mark - Event Response
- (void)downloadButtonDown:(UIButton *)sender{
    if (self.group.status == TLEmojiGroupStatusUnDownload) {
        self.group.status = TLEmojiGroupStatusDownloading;
        [self setGroup:self.group];
        if (_delegate && [_delegate respondsToSelector:@selector(expressionCellDownloadButtonDown:)]) {
            [_delegate expressionCellDownloadButtonDown:self.group];
        }
    }
}
#pragma mark - Private Methods
- (void)p_addMasonry{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(EDGE_LEFT);
        make.top.mas_equalTo(self.contentView).mas_offset(EDGE_TOP);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-EDGE_TOP);
        make.width.mas_equalTo(self.iconImageView.mas_height);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.iconImageView.mas_centerY).mas_offset(-2.0f);
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(13.0f);
        make.right.mas_lessThanOrEqualTo(self.downloadButton.mas_left).mas_offset(-EDGE_LEFT);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_centerY).mas_offset(5.0);
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_lessThanOrEqualTo(self.downloadButton.mas_left).mas_offset(-EDGE_LEFT);
    }];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(self.contentView);
    }];
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-EDGE_LEFT);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(60, 26));
    }];
}
#pragma mark - Getter
- (UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        [_iconImageView setBackgroundColor:[UIColor clearColor]];
        [_iconImageView.layer setMasksToBounds:YES];
        [_iconImageView.layer setCornerRadius:5.0f];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    }
    return _titleLabel;
}
- (UILabel *)detailLabel{
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        [_detailLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_detailLabel setTextColor:[UIColor grayColor]];
    }
    return _detailLabel;
}
- (UIImageView *)tagView{
    if (_tagView == nil) {
        _tagView = [[UIImageView alloc] init];
        [_tagView setImage:[UIImage imageNamed:@"icon_corner_new"]];
        [_tagView setHidden:YES];
    }
    return _tagView;
}
- (UIButton *)downloadButton{
    if (_downloadButton == nil) {
        _downloadButton = [[UIButton alloc] init];
        [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        [_downloadButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_downloadButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_downloadButton.layer setMasksToBounds:YES];
        [_downloadButton.layer setCornerRadius:3.0f];
        [_downloadButton.layer setBorderWidth:1.0f];
        [_downloadButton.layer setBorderColor:[UIColor greenColor].CGColor];
        [_downloadButton addTarget:self action:@selector(downloadButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}
@end
@interface WXExpressionBannerCell () <WXPictureCarouselDelegate>
@property (nonatomic, strong) WXPictureCarouselView *picCarouselView;
@end
@implementation WXExpressionBannerCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBottomLineStyle:TLCellLineStyleNone];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.picCarouselView];
        
        [self p_addMasonry];
    }
    return self;
}
- (void)setData:(NSArray *)data{
    _data = data;
    [self.picCarouselView setData:data];
}
#pragma mark - 
- (void)pictureCarouselView:(WXPictureCarouselView *)pictureCarouselView didSelectItem:(id<WXPictureCarouselProtocol>)model{
    if (self.delegate && [self.delegate respondsToSelector:@selector(expressionBannerCellDidSelectBanner:)]) {
        [self.delegate expressionBannerCellDidSelectBanner:model];
    }
}
#pragma mark - 
- (void)p_addMasonry{
    [self.picCarouselView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}
#pragma mark - 
- (WXPictureCarouselView *)picCarouselView{
    if (_picCarouselView == nil) {
        _picCarouselView = [[WXPictureCarouselView alloc] init];
        [_picCarouselView setDelegate:self];
    }
    return _picCarouselView;
}
@end
@interface WXExpressionChosenViewController () <UISearchBarDelegate>
@property (nonatomic, strong) WXSearchController *searchController;
@property (nonatomic, strong) WXExpressionSearchViewController *searchVC;
@end
@implementation WXExpressionChosenViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.tableView setFrame:CGRectMake(0, TopHeight + 20, APPW, APPH - 20 - TopHeight)];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    [self.tableView setMj_footer:footer];
    
    [self registerCellsForTableView:self.tableView];
    [self loadDataWithLoadingView:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}
#pragma mark - 
- (WXExpressionHelper *)proxy{
    if (_proxy == nil) {
        _proxy = [WXExpressionHelper sharedHelper];
    }
    return _proxy;
}
- (WXSearchController *)searchController{
    if (_searchController == nil) {
        _searchController = [[WXSearchController alloc] initWithSearchResultsController:self.searchVC];
        [_searchController setSearchResultsUpdater:self.searchVC];
        [_searchController.searchBar setPlaceholder:@"搜索表情"];
        [_searchController.searchBar setDelegate:self.searchVC];
    }
    return _searchController;
}
- (WXExpressionSearchViewController *)searchVC{
    if (_searchVC == nil) {
        _searchVC = [[WXExpressionSearchViewController alloc] init];
    }
    return _searchVC;
}
- (void)loadDataWithLoadingView:(BOOL)showLoadingView{
    if (showLoadingView) {
        [SVProgressHUD show];
    }
    kPageIndex = 1;
    __weak typeof(self) weakSelf = self;
    [self.proxy requestExpressionChosenListByPageIndex:kPageIndex success:^(id data) {
        [SVProgressHUD dismiss];
        kPageIndex ++;
        weakSelf.data = [[NSMutableArray alloc] init];
        for (TLEmojiGroup *group in data) {     // 优先使用本地表情
            TLEmojiGroup *localEmojiGroup = [[WXExpressionHelper sharedHelper] emojiGroupByID:group.groupID];
            if (localEmojiGroup) {
                [self.data addObject:localEmojiGroup];
            }else{
                [self.data addObject:group];
            }
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
    
    [self.proxy requestExpressionChosenBannerSuccess:^(id data) {
        self.bannerData = data;
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        
    }];
}
- (void)loadMoreData{
    __weak typeof(self) weakSelf = self;
    [self.proxy requestExpressionChosenListByPageIndex:kPageIndex success:^(NSMutableArray *data) {
        [SVProgressHUD dismiss];
        if (data.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
            kPageIndex ++;
            for (TLEmojiGroup *group in data) {     // 优先使用本地表情
                TLEmojiGroup *localEmojiGroup = [[WXExpressionHelper sharedHelper] emojiGroupByID:group.groupID];
                if (localEmojiGroup) {
                    [self.data addObject:localEmojiGroup];
                }
                else {
                    [self.data addObject:group];
                }
            }
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSString *error) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [SVProgressHUD dismiss];
    }];
}
- (void)registerCellsForTableView:(UITableView *)tableView{
    [tableView registerClass:[WXExpressionBannerCell class] forCellReuseIdentifier:@"TLExpressionBannerCell"];
    [tableView registerClass:[WXExpressionCell class] forCellReuseIdentifier:@"TLExpressionCell"];
}
#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.bannerData.count > 0 ? 2 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.bannerData.count > 0 ? 1 : self.data.count;
    }else if (section == 1) {
        return self.data.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && self.bannerData.count > 0) {
        WXExpressionBannerCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:@"TLExpressionBannerCell"];
        [bannerCell setData:self.bannerData];
        [bannerCell setDelegate:self];
        return bannerCell;
    }
    WXExpressionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLExpressionCell"];
    TLEmojiGroup *group = self.data[indexPath.row];
    [cell setGroup:group];
    [cell setDelegate:self];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0 && self.bannerData.count == 0) || indexPath.section == 1) {
        TLEmojiGroup *group = [self.data objectAtIndex:indexPath.row];
        WXExpressionDetailViewController *detailVC = [[WXExpressionDetailViewController alloc] init];
        [detailVC setGroup:group];
        [self.parentViewController setHidesBottomBarWhenPushed:YES];
        [self.parentViewController.navigationController pushViewController:detailVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.bannerData.count > 0 ? 140 : 80;
    }else if (indexPath.section == 1) {
        return 80;
    }
    return 0;
}
//MARK: TLExpressionBannerCellDelegate
- (void)expressionBannerCellDidSelectBanner:(id)item{
    WXExpressionDetailViewController *detailVC = [[WXExpressionDetailViewController alloc] init];
    [detailVC setGroup:item];
    [self.parentViewController setHidesBottomBarWhenPushed:YES];
    [self.parentViewController.navigationController pushViewController:detailVC animated:YES];
}
//MARK: TLExpressionCellDelegate
- (void)expressionCellDownloadButtonDown:(TLEmojiGroup *)group{
    group.status = TLEmojiGroupStatusDownloading;
    [self.proxy requestExpressionGroupDetailByGroupID:group.groupID pageIndex:1 success:^(id data) {
        group.data = data;
        [[WXExpressionHelper sharedHelper] downloadExpressionsWithGroupInfo:group progress:^(CGFloat progress) {
            
        } success:^(TLEmojiGroup *group) {
            group.status = TLEmojiGroupStatusDownloaded;
            NSInteger index = [self.data indexOfObject:group];
            if (index < self.data.count) {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
            BOOL ok = [[WXExpressionHelper sharedHelper] addExpressionGroup:group];
            if (!ok) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"表情 %@ 存储失败！", group.groupName]];
            }
        } failure:^(TLEmojiGroup *group, NSString *error) {
            
        }];
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"\"%@\" 下载失败: %@", group.groupName, error]];
    }];
}
@end
