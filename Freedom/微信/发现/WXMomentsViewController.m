//  TLMomentsViewController.m
//  Freedom
//  Created by Super on 16/4/5.
#import "WXMomentsViewController.h"
#import "WXModes.h"
#import "WXMomentDetailViewController.h"
#import "MWPhotoBrowser.h"
#import "WXMomentsViewController.h"
#import "UIButton+WebCache.h"
#import "WXUserHelper.h"
#import "WXRootViewController.h"
#define         WIDTH_AVATAR        65
#import "WXTableViewCell.h"
#import <XCategory/UIBarButtonItem+expanded.h>
@interface WXMomentsProxy : NSObject
- (NSArray *)testData;
@end
@implementation WXMomentsProxy
- (NSArray *)testData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Moments" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    NSArray *arr = [WXMoment mj_objectArrayWithKeyValuesArray:jsonArray];
    return arr;
}
@end
@interface WXMomentBaseCell : WXTableViewCell
@property (nonatomic, assign) id<WXMomentViewDelegate> delegate;
@property (nonatomic, strong) WXMoment *moment;
@end
@interface WXMomentImagesCell : WXMomentBaseCell
@end
@implementation WXMomentBaseCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBottomLineStyle:TLCellLineStyleFill];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}
@end
@interface WXMomentImagesCell ()
@property (nonatomic, strong) WXMomentImageView *momentView;
@end
@implementation WXMomentImagesCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.momentView];
        [self.momentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    return self;
}
- (void)setMoment:(WXMoment *)moment{
    [super setMoment:moment];
    [self.momentView setMoment:moment];
}
- (void)setDelegate:(id<WXMomentViewDelegate>)delegate{
    [super setDelegate:delegate];
    [self.momentView setDelegate:delegate];
}
#pragma mark - 
- (WXMomentImageView *)momentView{
    if (_momentView == nil) {
        _momentView = [[WXMomentImageView alloc] init];
    }
    return _momentView;
}
@end
@interface WXMomentHeaderCell : WXTableViewCell
@property (nonatomic, strong) WXUser *user;
@end
@interface WXMomentHeaderCell ()
@property (nonatomic, strong) UIButton *backgroundWall;
@property (nonatomic, strong) UIButton *avatarView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *mottoLabel;
@end
@implementation WXMomentHeaderCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBottomLineStyle:TLCellLineStyleNone];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.backgroundWall];
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.mottoLabel];
        
        [self p_addMasonry];
    }
    return self;
}
- (void)setUser:(WXUser *)user{
    _user = user;
    [self.backgroundWall sd_setImageWithURL:TLURL(user.detailInfo.momentsWallURL) forState:UIControlStateNormal];
    [self.backgroundWall sd_setImageWithURL:TLURL(user.detailInfo.momentsWallURL) forState:UIControlStateHighlighted];
    [self.avatarView sd_setImageWithURL:TLURL(user.avatarURL) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PuserLogo]];
    [self.usernameLabel setText:user.nikeName];
    [self.mottoLabel setText:user.detailInfo.motto];
}
#pragma mark - 
- (void)p_addMasonry{
    [self.backgroundWall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.mottoLabel.mas_top).mas_offset(- WIDTH_AVATAR / 3.0f - 8.0f);
        make.top.mas_lessThanOrEqualTo(self.contentView.mas_top);
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-20.0f);
        make.centerY.mas_equalTo(self.backgroundWall.mas_bottom).mas_offset(- WIDTH_AVATAR / 6.0f);
        make.size.mas_equalTo(CGSizeMake(WIDTH_AVATAR, WIDTH_AVATAR));
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.backgroundWall).mas_offset(-8.0f);
        make.right.mas_equalTo(self.avatarView.mas_left).mas_offset(-15.0f);
    }];
    
    [self.mottoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).mas_offset(-8.0f);
        make.right.mas_equalTo(self.avatarView);
        make.width.mas_lessThanOrEqualTo(APPW * 0.4);
    }];
}
#pragma mark - 
- (UIButton *)backgroundWall{
    if (_backgroundWall == nil) {
        _backgroundWall = [[UIButton alloc] init];
        [_backgroundWall setBackgroundColor:colorGrayLine];
    }
    return _backgroundWall;
}
- (UIButton *)avatarView{
    if (_avatarView == nil) {
        _avatarView = [[UIButton alloc] init];
        [_avatarView.layer setMasksToBounds:YES];
        [_avatarView.layer setBorderWidth:2.0f];
        [_avatarView.layer setBorderColor:[UIColor whiteColor].CGColor];
    }
    return _avatarView;
}
- (UILabel *)usernameLabel{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        [_usernameLabel setTextColor:[UIColor whiteColor]];
    }
    return _usernameLabel;
}
- (UILabel *)mottoLabel{
    if (_mottoLabel == nil) {
        _mottoLabel = [[UILabel alloc] init];
        [_mottoLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_mottoLabel setTextColor:[UIColor grayColor]];
        [_mottoLabel setTextAlignment:NSTextAlignmentRight];
    }
    return _mottoLabel;
}
@end
@interface WXMomentsViewController ()<WXMomentViewDelegate>
@property (nonatomic, strong) WXMomentsProxy *proxy;
- (void)loadData;
- (void)registerCellForTableView:(UITableView *)tableView;
@end
@implementation WXMomentsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"朋友圈"];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60.0f)]];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_camera"] style:UIBarButtonItemStylePlain actionBlick:^{
        
    }];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    [self registerCellForTableView:self.tableView];
    [self loadData];
}
#pragma mark - 
- (WXMomentsProxy *)proxy{
    if (_proxy == nil) {
        _proxy = [[WXMomentsProxy alloc] init];
    }
    return _proxy;
}
- (void)loadData{
    self.data = [NSMutableArray arrayWithArray:self.proxy.testData];
    [self.tableView reloadData];
}
- (void)registerCellForTableView:(UITableView *)tableView{
    [tableView registerClass:[WXMomentHeaderCell class] forCellReuseIdentifier:@"TLMomentHeaderCell"];
    [tableView registerClass:[WXMomentImagesCell class] forCellReuseIdentifier:@"TLMomentImagesCell"];
    [tableView registerClass:[WXTableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
}
#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        WXMomentHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLMomentHeaderCell"];
        [cell setUser:[WXUserHelper sharedHelper].user];
        return cell;
    }
    
    WXMoment *moment = [self.data objectAtIndex:indexPath.row - 1];
    id cell;
    if (moment.detail.text.length > 0 || moment.detail.images.count > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TLMomentImagesCell"];
    }
    
    if (cell) {
        [cell setMoment:moment];
        [cell setDelegate:self];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 260.0f;
    }
    
    WXMoment *moment = [self.data objectAtIndex:indexPath.row - 1];
    return (int)moment.momentFrame.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        WXMoment *moment = [self.data objectAtIndex:indexPath.row - 1];
        WXMomentDetailViewController *detailVC = [[WXMomentDetailViewController alloc] init];
        [detailVC setMoment:moment];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//MARK: TLMomentViewDelegate
- (void)momentViewClickImage:(NSArray *)images atIndex:(NSInteger)index{
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:images.count];
    for (NSString *imageUrl in images) {
        MWPhoto *photo = [MWPhoto photoWithURL:TLURL(imageUrl)];
        [data addObject:photo];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:data];
    [browser setDisplayNavArrows:YES];
    [browser setCurrentPhotoIndex:index];
    WXNavigationController *broserNavC = [[WXNavigationController alloc] initWithRootViewController:browser];
    [self presentViewController:broserNavC animated:NO completion:nil];
}
@end
