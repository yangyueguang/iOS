//  JFVideoDetailViewController.m
//  Freedom
//  Created by Freedom on 15/10/17.//  项目详解：
//  github:https://github.com/tubie/JFTudou
//  简书：http://www.jianshu.com/p/2156ec56c55b
#import "JFVideoDetailViewController.h"
@interface JFVideoDetailModel : NSObject
@property(nonatomic, strong) NSString *total_vv;
@property(nonatomic, strong) NSNumber *duration;
@property(nonatomic, strong) NSNumber *total_comment;
@property(nonatomic, strong) NSString *img;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *play_url;
@property(nonatomic, strong) NSString *channel_pic;
@property(nonatomic, strong) NSString *cats;
@property(nonatomic, strong) NSString *plid;
@property(nonatomic, strong) NSString *isVuser;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSNumber *format_flag;
@property(nonatomic, strong) NSString *img_hd;
@property(nonatomic, strong) NSString *iid;
@property(nonatomic, strong) NSNumber *subed_num;
@property(nonatomic, strong) NSString *item_id;
@property(nonatomic, strong) NSString *user_desc;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) NSString *user_play_times;
@property(nonatomic, strong) NSString *stripe_bottom;
@property(nonatomic, strong) NSNumber *cid;
@property(nonatomic, strong) NSNumber *userid;
@property(nonatomic, strong) NSNumber *total_fav;
@property(nonatomic, strong) NSNumber *limit;
@property(nonatomic, strong) NSString *item_media_type;
@end
@implementation JFVideoDetailModel
@end
@interface JFRecommentModel : NSObject
@property(nonatomic, strong) NSNumber *total_pv;
@property(nonatomic, strong) NSString *pubdate;
@property(nonatomic, strong) NSString *img_16_9;
@property(nonatomic, strong) NSString *pv_pr;
@property(nonatomic, strong) NSNumber *duration;
@property(nonatomic, strong) NSString *pv;
@property(nonatomic, strong) NSNumber *total_comment;
@property(nonatomic, strong) NSString *img;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *state;
@property(nonatomic, strong) NSString *cats;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSMutableArray *tags;
@property(nonatomic, strong) NSString *img_hd;
@property(nonatomic, strong) NSString *itemCode;
@property(nonatomic, strong) NSString *total_down;
@property(nonatomic, strong) NSString *total_up;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) NSString *stripe_bottom;
@property(nonatomic, strong) NSString *userid;
@property(nonatomic, strong) NSNumber *total_fav;
@property(nonatomic, strong) NSString *reputation;
@property(nonatomic, strong) NSString *limit;
@property(nonatomic, strong) NSString *time;
@end
@implementation JFRecommentModel
@end
@interface JFRecommentVideoCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *PVLabel;
@property(nonatomic, strong)JFRecommentModel *recommentModel;
@end
@implementation JFRecommentVideoCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"JFRecommentVideoCell";
    JFRecommentVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[JFRecommentVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        cell.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 200, 20)];
        cell.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, 200, 20)];
        cell.PVLabel = [[UILabel alloc]initWithFrame:CGRectMake(APPW-100, 20, 80, 20)];
        cell.iconImageView.image = [UIImage imageNamed:PuserLogo];
        cell.titleLabel.text = @"title";
        cell.timeLabel.text = @"time";
        cell.PVLabel.text = @"pvlabel";
        [cell addSubviews:cell.iconImageView,cell.titleLabel,cell.timeLabel,cell.PVLabel,nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setRecommentModel:(JFRecommentModel *)recommentModel{
    _recommentModel = recommentModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:recommentModel.img] placeholderImage:[UIImage imageNamed:@"rec_holder"]];
    _titleLabel.text = recommentModel.title;
    self.PVLabel.text = recommentModel.pv_pr;
    _timeLabel.text = recommentModel.time;
}
@end
@interface JFVideoDetailCell : UITableViewCell
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *playItemsLabel;
@property (strong, nonatomic) UILabel *userDesLabel;
@property (strong, nonatomic) UIButton *subscribeButton;
@property (strong, nonatomic) UILabel *subedNumberLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descLabel;
@property(nonatomic, strong)JFVideoDetailModel *videoDetailModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
@implementation JFVideoDetailCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"JFVideoDetailCell";
    JFVideoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[JFVideoDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        cell.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 200, 20)];
        cell.playItemsLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, 200, 20)];
        cell.userDesLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 100, 20)];
        cell.subscribeButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 30, 100, 30)];
        cell.subedNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 100, 20)];
        cell.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, 100, 20)];
        cell.descLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, 100, 20)];
        cell.subscribeButton.backgroundColor = [UIColor greenColor];
        [cell addSubviews:cell.iconImageView,cell.userNameLabel,cell.playItemsLabel,cell.userDesLabel,cell.subscribeButton,cell.subedNumberLabel,cell.titleLabel,cell.descLabel,nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setVideoDetailModel:(JFVideoDetailModel *)videoDetailModel{
    _videoDetailModel = videoDetailModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:videoDetailModel.channel_pic] placeholderImage:[UIImage imageNamed:@"tudoulogo"]];
    _userNameLabel.text = videoDetailModel.username;
    _playItemsLabel.text = [NSString stringWithFormat:@"播放：%@",videoDetailModel.user_play_times];
    _userDesLabel.text = videoDetailModel.user_desc;
    self.subedNumberLabel.text = [NSString stringWithFormat:@"%d人订阅",[videoDetailModel.subed_num intValue]];
    //    CGSize contentSize = [videoDetailModel.desc sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(SCREENWIDTH-30, 60) lineBreakMode:NSLineBreakByTruncatingTail];
    _titleLabel.text = videoDetailModel.title;
    _descLabel.text = videoDetailModel.desc;
}
@end
@interface JFVideoDetailViewController ()<UITableViewDataSource, UITableViewDelegate>{
    JFVideoDetailModel *_videoDM;
    NSMutableArray *_recommendArray;
}
@property(nonatomic, strong)UITableView *videoDetailTableView;
@property(nonatomic, strong)UIWebView *videoDetailWebView;
@end
@implementation JFVideoDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;//用push方法推出时，Tabbar隐藏
    [self loadVideoDetailData];
    [self loadRecommentData];
    [self initTableView];
    [self initWebView];
    [self initNav];
}
-(void)initNav{
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, 20)];
    backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 20, 30, 30);
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:PcellLeft] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
}
#pragma mark - 初始化tableView
-(void)initTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 220, APPW, APPH-220) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    //将系统的Separator左边不留间隙
    tableView.separatorInset = UIEdgeInsetsZero;
    self.videoDetailTableView = tableView;
    [self.view addSubview:self.videoDetailTableView];
}
#pragma mark - 初始化webView
-(void)initWebView{
    self.videoDetailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, APPW, 220)];
    [self.view addSubview:self.videoDetailWebView];
}
-(void)OnBackBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark－视频详细信息
-(void)loadVideoDetailData{
    _videoDM = [[JFVideoDetailModel alloc] init];
    _recommendArray = [[NSMutableArray alloc] init];
    NSString *urlStr =  [[FreedomTools sharedManager]urlWithVideoDetailData:self.iid];
    
    NSString *url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [NetBase GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JFVideoDetailModel *videoDM = [JFVideoDetailModel mj_objectWithKeyValues:[responseObject objectForKey:@"detail"]];
        _videoDM = videoDM;
        NSString *videoUrl = [[FreedomTools sharedManager]urlWithVideo:self.iid];
        [self.videoDetailWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:videoUrl]]];
        [self.videoDetailTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark - 推荐视频
-(void)loadRecommentData{
    NSString *urlStr =  [[FreedomTools sharedManager]urlWithRecommentdata:self.iid];
    
    NSString *url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [NetBase GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //这个地方要先移除模型数组里面数据
        [_recommendArray removeAllObjects];
        NSMutableArray *resultArray = [responseObject objectForKey:@"results"];
        for (int i = 0; i < resultArray.count; i++) {
            JFRecommentModel  *recommendM = [JFRecommentModel mj_objectWithKeyValues:resultArray[i]];
            recommendM.time = [self convertTime:[recommendM.duration integerValue]];
            [_recommendArray addObject:recommendM];
        }
        [self.videoDetailTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(NSString *)convertTime:(NSInteger)time{
    Float64 currentSeconds = time;
    int mins = currentSeconds/60.0;
    int hours = mins / 60.0f;
    int secs = fmodf(currentSeconds, 60.0);
    mins = fmodf(mins, 60.0f);
    
    NSString *hoursString = hours < 10 ? [NSString stringWithFormat:@"0%d", hours] : [NSString stringWithFormat:@"%d", hours];
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    
    if (hours == 0) {
        return [NSString stringWithFormat:@"%@:%@",minsString, secsString];
    }else{
        return [NSString stringWithFormat:@"%@:%@:%@", hoursString,minsString, secsString];
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _recommendArray.count + 1 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 160;
    }else{
        return 75;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        JFVideoDetailCell *cell = [JFVideoDetailCell cellWithTableView:tableView];
        if (_videoDM) {
            cell.videoDetailModel = _videoDM;
        }
        return cell;
        
    }else{
        JFRecommentVideoCell *cell = [JFRecommentVideoCell cellWithTableView:tableView];
        cell.recommentModel = _recommendArray[indexPath.row-1];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>0) {
        JFRecommentModel *recommendM = _recommendArray[indexPath.row-1];
        self.iid = recommendM.itemCode;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadVideoDetailData];
            [self loadRecommentData];
        });
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
