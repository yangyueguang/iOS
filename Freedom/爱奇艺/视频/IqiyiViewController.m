//  IqiyiViewController.m
//  Created by Super on 16/8/18.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "IqiyiViewController.h"
#import "JFImageScrollCell.h"
#import "JFVideoDetailViewController.h"
#import "JFSearchHistoryViewController.h"
#import "JFWatchRecordViewController.h"
#define JFTabBarButtonImageRatio 0.6
@interface JFHomeModel : NSObject
@property(nonatomic, strong) NSString *search_default_word_for_ipad;
@property(nonatomic, strong) NSMutableArray *boxes;
@property(nonatomic, strong) NSMutableArray *banner;
@property(nonatomic, strong) NSString *index_channel_content_version;
@end
@implementation JFHomeModel
@end
@interface JFBoxesModel : NSObject
@property(nonatomic, strong) NSMutableArray *videos;
@property(nonatomic, strong) NSNumber *ipad_display_type;
@property(nonatomic, strong) NSString *index_page_channel_icon;
@property(nonatomic, strong) NSNumber *display_type;
@property(nonatomic, strong) NSString *index_page_channel_icon_for_ipad;
@property(nonatomic, strong) NSNumber *video_count_for_ipad_index_page;
@property(nonatomic, strong) NSString *cid;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *sub_title;
@property(nonatomic, strong) NSString *redirect_type;
@property(nonatomic, strong) NSString *url_for_more_link;
@property(nonatomic, strong) NSString *is_podcast;
@property(nonatomic, assign) float height;
@end
@implementation JFBoxesModel
@end
@interface JFBannerModel : NSObject
@property(nonatomic, strong) NSNumber *is_albumcover;
@property(nonatomic, strong) NSString *image_1452_578;
@property(nonatomic, strong) NSString *image_800_450;
@property(nonatomic, strong) NSString *platform_for_url_type;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSNumber *url_include_ids_count;
@property(nonatomic, strong) NSObject *vip_information;
@property(nonatomic, strong) NSString *plid;
@property(nonatomic, strong) NSString *short_desc;
@property(nonatomic, strong) NSString *image_726_289;
@property(nonatomic, strong) NSString *iid;
@property(nonatomic, strong) NSString *small_img;
@property(nonatomic, strong) NSObject *game_information;
@property(nonatomic, strong) NSString *aid;
@property(nonatomic, strong) NSString *image_640_310;
@property(nonatomic, strong) NSString *big_img;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSNumber *browser_for_url_type;
@end
@implementation JFBannerModel
@end
@interface JFVideosModel : NSObject
@property(nonatomic, strong) NSString *yaofeng;
@property(nonatomic, strong) NSNumber *is_albumcover;
@property(nonatomic, strong) NSString *pv;
@property(nonatomic, strong) NSString *corner_image;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSNumber *url_include_ids_count;
@property(nonatomic, strong) NSString *owner_nick;
@property(nonatomic, strong) NSString *short_desc;
@property(nonatomic, strong) NSObject *game_information;
@property(nonatomic, strong) NSString *iid;
@property(nonatomic, strong) NSString *small_img;
@property(nonatomic, strong) NSString *stripe_b_r;
@property(nonatomic, strong) NSString *plid;
@property(nonatomic, strong) NSString *aid;
@property(nonatomic, strong) NSString *owner_id;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *image_800x450;
@property(nonatomic, strong) NSString *big_img;
@end
@implementation JFVideosModel
@end
@class JFBoxesModel,JFVideosModel;
@protocol JFHomeBoxCellDelegate <NSObject>
@optional
-(void)didSelectHomeBox:(JFVideosModel *)video;
@end
@interface JFHomeBoxCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView ;
@property(nonatomic, strong) JFBoxesModel *boxes;
@property(nonatomic, weak) id <JFHomeBoxCellDelegate>delegate;
@end
@class JFImageCardView;
@protocol JFImageCardViewDelegate <NSObject>
@optional
-(void)didSelectImageCard:(JFImageCardView *)imageCard video:(JFVideosModel *)video;
@end
@interface JFImageCardView : UIView
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *pvLabel;
@property(nonatomic, strong) UILabel *yaofengLabel;
-(id)initWithFrame:(CGRect)frame video:(JFVideosModel *)video;
@property(nonatomic, strong) JFVideosModel *video;
@property(nonatomic, weak) id <JFImageCardViewDelegate>delegate;
@end
@implementation JFImageCardView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-5, frame.size.height-45)];
        //        [self.imageView sd_setImageWithURL:[NSURL URLWithString:video.small_img] placeholderImage:[UIImage imageNamed:@"tudoulogo"]];
        [self addSubview:self.imageView];
        //
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, frame.size.height-40, frame.size.width-5, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //        self.titleLabel.text = video.title;
        [self addSubview:self.titleLabel];
        //
        self.pvLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, frame.size.height-20, frame.size.width-5, 20)];
        self.pvLabel.font = [UIFont systemFontOfSize:11];
        self.pvLabel.textColor = [UIColor lightGrayColor];
        //        self.pvLabel.text = video.pv;
        [self addSubview:self.pvLabel];
        //
        self.yaofengLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height-60, frame.size.width-10, 20)];
        self.yaofengLabel.font = [UIFont systemFontOfSize:11];
        self.yaofengLabel.textColor = [UIColor whiteColor];
        //        self.yaofengLabel.text = video.yaofeng;
        [self addSubview:self.yaofengLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImageCard:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame video:(JFVideosModel *)video{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-5, frame.size.height-45)];
        //        [self.imageView sd_setImageWithURL:[NSURL URLWithString:video.small_img] placeholderImage:[UIImage imageNamed:@"tudoulogo"]];
        [self addSubview:self.imageView];
        //
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, frame.size.height-40, frame.size.width-5, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //        self.titleLabel.text = video.title;
        [self addSubview:self.titleLabel];
        //
        self.pvLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, frame.size.height-20, frame.size.width-5, 20)];
        self.pvLabel.font = [UIFont systemFontOfSize:11];
        self.pvLabel.textColor = [UIColor lightGrayColor];
        //        self.pvLabel.text = video.pv;
        [self addSubview:self.pvLabel];
        //
        self.yaofengLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height-60, frame.size.width-10, 20)];
        self.yaofengLabel.font = [UIFont systemFontOfSize:11];
        self.yaofengLabel.textColor = [UIColor whiteColor];
        //        self.yaofengLabel.text = video.yaofeng;
        [self addSubview:self.yaofengLabel];
    }
    return self;
}
-(void)setVideo:(JFVideosModel *)video{
    _video = video;//这里不能用self.video,只能用_video
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:video.small_img] placeholderImage:[UIImage imageNamed:@"rec_holder"]];
    self.titleLabel.text = video.title;
    if([video.type isEqualToString:@"playlist"]){
        self.pvLabel.text = video.pv;
        if ([video.yaofeng isEqualToString:@""]) {
            self.yaofengLabel.text = video.stripe_b_r;
        }else{
            self.yaofengLabel.text = video.yaofeng;
        }
    }else{
        if ([video.short_desc isEqualToString:@""]) {
            self.pvLabel.text = video.pv;
        }else{
            self.pvLabel.text = video.short_desc;
        }
        self.yaofengLabel.text = video.stripe_b_r;
    }
    
}
-(void)OnTapImageCard:(UITapGestureRecognizer *)sender{
    DLog(@"video==%@",self.video);
    if ([self.delegate respondsToSelector:@selector(didSelectImageCard:video:)]) {
        [self.delegate didSelectImageCard:self video:self.video];
        
    }
}
@end
@interface JFHomeBoxCell ()<JFImageCardViewDelegate>{
    UILabel *_titleLabel;
    UIImageView *_imageView;
    JFImageCardView *_cardView1;
    JFImageCardView *_cardView2;
    JFImageCardView *_cardView3;
    JFImageCardView *_cardView4;
    
}
@end
@implementation JFHomeBoxCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *menuID = @"JFHomeBoxCell";
    JFHomeBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:menuID];
    if (cell == nil) {
        cell = [[JFHomeBoxCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:menuID  ];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)initViews{
    //背景
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, APPW, 40+300)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    //头
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, 40)];
    [backView addSubview:headView];
    //
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    [backView addSubview:_imageView];
    //
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 40)];
    _titleLabel.textColor = blacktextcolor;
    [headView addSubview:_titleLabel];
    //
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 38, APPW-10, 1)];
    lineView.backgroundColor = gradcolor;
    [backView addSubview:lineView];
    //图
    _cardView1 = [[JFImageCardView alloc] initWithFrame:CGRectMake(0, 40, (APPW-5)/2, 150)];
    _cardView2 = [[JFImageCardView alloc] initWithFrame:CGRectMake((APPW-5)/2, 40, (APPW-5)/2, 150)];
    _cardView3 = [[JFImageCardView alloc] initWithFrame:CGRectMake(0, 40+150, (APPW-5)/2, 150)];
    _cardView4 = [[JFImageCardView alloc] initWithFrame:CGRectMake((APPW-5)/2, 40+150, (APPW-5)/2, 150)];
    _cardView1.tag = 100;
    _cardView2.tag = 101;
    _cardView3.tag = 102;
    _cardView4.tag = 103;
    _cardView1.delegate = self;
    _cardView2.delegate = self;
    _cardView3.delegate = self;
    _cardView4.delegate = self;
    [backView addSubview:_cardView1];
    [backView addSubview:_cardView2];
    [backView addSubview:_cardView3];
    [backView addSubview:_cardView4];
}
-(void)setBoxes:(JFBoxesModel *)boxes{
    _titleLabel.text = boxes.title;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:boxes.index_page_channel_icon] placeholderImage:nil];
    JFVideosModel *video1 = [JFVideosModel mj_objectWithKeyValues:boxes.videos[0]];
    JFVideosModel *video2 = [JFVideosModel mj_objectWithKeyValues:boxes.videos[1]];
    JFVideosModel *video3 = [JFVideosModel mj_objectWithKeyValues:boxes.videos[2]];
    JFVideosModel *video4 = [JFVideosModel mj_objectWithKeyValues:boxes.videos[3]];
    //    [_cardView1 setVideo:video1];
    _cardView1.video = video1;
    [_cardView2 setVideo:video2];
    [_cardView3 setVideo:video3];
    [_cardView4 setVideo:video4];
}
#pragma mark - JFImageCardViewDelegate
-(void)didSelectImageCard:(JFImageCardView *)imageCard video:(JFVideosModel *)video{
    if ([self.delegate respondsToSelector:@selector(didSelectHomeBox:)]) {
        [self.delegate didSelectHomeBox:video];
    }
    
}
@end
@interface JFHomeVideoBoxCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView ;
@property(nonatomic, strong) JFBoxesModel *boxes;
@end
@interface JFHomeVideoBoxCell (){
    UILabel *_titleLabel;
    UIImageView *_imageView;
    JFImageCardView *_cardView1;
    JFImageCardView *_cardView2;
    JFImageCardView *_cardView3;
    JFImageCardView *_cardView4;
    JFImageCardView *_cardView5;
    JFImageCardView *_cardView6;
}
@end
@implementation JFHomeVideoBoxCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *JFHomeVideoBoxCellID = @"JFHomeVideoBoxCell";
    JFHomeVideoBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:JFHomeVideoBoxCellID];
    if (cell == nil) {
        cell = [[JFHomeVideoBoxCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JFHomeVideoBoxCellID  ];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)initViews{
    //背景
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, APPW, 40+230+230)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    //头
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, 40)];
    [backView addSubview:headView];
    //
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    [backView addSubview:_imageView];
    //
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 40)];
    _titleLabel.textColor = gradtextcolor;
    [headView addSubview:_titleLabel];
    //
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 38, APPW-10, 1)];
    lineView.backgroundColor = gradcolor;
    [backView addSubview:lineView];
    //图
    _cardView1 = [[JFImageCardView alloc] initWithFrame:CGRectMake(0, 40, (APPW-5)/3, 230)];
    _cardView2 = [[JFImageCardView alloc] initWithFrame:CGRectMake((APPW-5)/3, 40, (APPW-5)/3, 230)];
    _cardView3 = [[JFImageCardView alloc] initWithFrame:CGRectMake((APPW-5)*2/3, 40, (APPW-5)/3, 230)];
    
    _cardView4 = [[JFImageCardView alloc] initWithFrame:CGRectMake(0, 40+230, (APPW-5)/3, 230)];
    _cardView5 = [[JFImageCardView alloc] initWithFrame:CGRectMake((APPW-5)/3, 40+230, (APPW-5)/3, 230)];
    _cardView6 = [[JFImageCardView alloc] initWithFrame:CGRectMake((APPW-5)*2/3, 40+230, (APPW-5)/3, 230)];
    
    [backView addSubview:_cardView1];
    [backView addSubview:_cardView2];
    [backView addSubview:_cardView3];
    [backView addSubview:_cardView4];
    [backView addSubview:_cardView5];
    [backView addSubview:_cardView6];
}
-(void)setBoxes:(JFBoxesModel *)boxes{
    _titleLabel.text = boxes.title;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:boxes.index_page_channel_icon] placeholderImage:nil];
    JFVideosModel *video1 = [JFVideosModel mj_objectWithKeyValues:boxes.videos[0]];
    JFVideosModel *video2 = [JFVideosModel mj_objectWithKeyValues:boxes.videos[1]];
    JFVideosModel *video3 = [JFVideosModel mj_objectWithKeyValues:boxes.videos[2]];
    JFVideosModel *video4 = [JFVideosModel mj_objectWithKeyValues:boxes.videos[3]];
    JFVideosModel *video5 = [JFVideosModel mj_objectWithKeyValues:boxes.videos[4]];
    JFVideosModel *video6 = [JFVideosModel mj_objectWithKeyValues:boxes.videos[5]];
    [_cardView1 setVideo:video1];
    [_cardView2 setVideo:video2];
    [_cardView3 setVideo:video3];
    [_cardView4 setVideo:video4];
    [_cardView5 setVideo:video5];
    [_cardView6 setVideo:video6];
    
}
@end
@interface IqiyiViewController ()<UITableViewDataSource, UITableViewDelegate,JFHomeBoxCellDelegate>{
    NSMutableArray *_dataSource;
    NSMutableArray *_boxesSource;
    NSMutableArray *_bannerSource;
    NSMutableArray *_headImageArray;
}
@property (nonatomic, strong)UITableView *homeTableView;
@end
@implementation IqiyiViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNav];
    [self initView];
    [self setUpRefresh];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
-(void)setUpRefresh{
    self.homeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    [self.homeTableView.mj_header beginRefreshing];
}
#pragma mark - 初始化导航栏
-(void)initNav{
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"qylogo_p@3x" target:nil action:nil width:65 height:24];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    UIBarButtonItem *rightUploadBarButtonItem = [UIBarButtonItem initWithNormalImage:Pwcamera target:nil action:nil width:22 height:22];
    UIBarButtonItem *rightHistoryBarButtonItem = [UIBarButtonItem initWithNormalImage:Pwhistory target:self action:@selector(rightHistoryBarButtonItemClick) width:22 height:22];
    
    UIBarButtonItem *rightSearchBarButtonItem = [UIBarButtonItem initWithNormalImage:Pwsearch target:self action:@selector(rightSearchBarButtonItemClick) width:22 height:22];
    
    
    self.navigationItem.rightBarButtonItems = @[rightSearchBarButtonItem,rightUploadBarButtonItem, rightHistoryBarButtonItem];
    
    
}
/*搜索*/
-(void)rightSearchBarButtonItemClick{
    JFSearchHistoryViewController *searchHistoryVC = [[JFSearchHistoryViewController alloc]init];
    [self.navigationController pushViewController:searchHistoryVC animated:YES];
    
}
-(void)rightHistoryBarButtonItemClick{
    JFWatchRecordViewController *watchRecordVC = [[JFWatchRecordViewController alloc]init];
    [self.navigationController pushViewController:watchRecordVC animated:YES];
    
}
#pragma mark - 初始化数据
-(void)initData{
    _dataSource = [[NSMutableArray alloc] init];
    _boxesSource = [[NSMutableArray alloc] init];
    _bannerSource = [[NSMutableArray alloc] init];
    _headImageArray = [[NSMutableArray alloc] init];
    
    NSString *urlStr =  [[FreedomTools sharedManager]urlWithHomeData];
    [NetBase GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.homeTableView.mj_header endRefreshing];
        [_headImageArray removeAllObjects];
        JFHomeModel *homeModel = [JFHomeModel mj_objectWithKeyValues:responseObject];
        NSMutableArray *boxesArray = [[NSMutableArray alloc] init];
        NSMutableArray *bannerArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < homeModel.boxes.count; i ++) {
            JFBoxesModel *boxesModel = [JFBoxesModel mj_objectWithKeyValues:homeModel.boxes[i]];
            boxesModel.height = [self getHeight:boxesModel];
            [boxesArray addObject:boxesModel];
        }
        for (int j = 0; j < homeModel.banner.count; j++) {
            JFBannerModel *bannerModel =[JFBannerModel mj_objectWithKeyValues:homeModel.banner[j]];
            [bannerArray addObject:bannerModel];
            [_headImageArray addObject:bannerModel.small_img];
        }
        
        _boxesSource = boxesArray;
        _bannerSource = bannerArray;
        [self.homeTableView reloadData];
    } failure:nil];
}
#pragma amrk - 初始化视图
-(void)initView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH  -64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    //将系统的Separator左边不留间隙
    tableView.separatorInset = UIEdgeInsetsZero;
    self.homeTableView =  tableView;
    [self.view addSubview:self.homeTableView];
    
}
-(float)getHeight:(JFBoxesModel *)boxes{
    float height = 0;
    height = height + 40;
    if ([boxes.display_type intValue] == 1) {
        height = height + 2*150;
        return height+5;
    }else if([boxes.display_type intValue] == 2){
        height = height + 2*230;
        return height+5;
    }else{
        return height+5;
    }
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 180;
    }else{
        CGFloat height = ((JFBoxesModel *)_boxesSource[indexPath.row-1]).height;
        return height;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_bannerSource.count>0){
        return _boxesSource.count+1;
    }else{
        return 0;
    }
    
}
/*
 主界面的cell类型要根据土豆返回来的display_type ＝ 1 返回两列 display_type ＝ 2三列 类型进行判断处理*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        JFImageScrollCell *cell = [JFImageScrollCell cellWithTableView:tableView frame:CGRectMake(0, 0, APPW, 180)];
        if (_headImageArray.count>0) {
            [cell setImageArray:_headImageArray];
        }
        return cell;
    }else{
        JFBoxesModel *box = _boxesSource[indexPath.row-1];
        if ([box.display_type intValue] == 1) {
            JFHomeBoxCell *cell = [JFHomeBoxCell cellWithTableView:tableView];
            [cell setBoxes:_boxesSource[indexPath.row-1]];
            cell.delegate = self;
            return cell;
        }else if([box.display_type intValue] == 2){
            JFHomeVideoBoxCell *cell = [JFHomeVideoBoxCell cellWithTableView:tableView];
            [cell setBoxes:box];
            return cell;
        }else{
            return nil;
        }
    }
}
#pragma mark - JFHomeBoxCellDelegate
-(void)didSelectHomeBox:(JFVideosModel *)video{
    JFVideoDetailViewController *videoDetailVC = [[JFVideoDetailViewController alloc]init];
    videoDetailVC.iid = video.iid;
    [self.navigationController pushViewController:videoDetailVC animated:YES];
    
}
@end
