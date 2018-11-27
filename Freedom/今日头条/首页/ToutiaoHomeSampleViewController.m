//  ToutiaoHomeSampleViewController.m
//  Created by Super on 17/1/11.
//  Copyright © 2017年 Super. All rights reserved.
//
#import "ToutiaoHomeSampleViewController.h"
#import "ToutiaoHomeDetailViewController.h"
#import <XCategory/UILabel+expanded.h>
@interface ToutiaoHomeSampleViewCell:BaseTableViewCell{
    UIImageView *icon1, *icon2, *icon3;
    UILabel *source;
}
@end
@implementation ToutiaoHomeSampleViewCell
-(void)initUI{
    [super initUI];
    icon1 =[[UIImageView alloc]init];
    icon1.contentMode = UIViewContentModeScaleToFill;
    icon2 =[[UIImageView alloc]init];
    icon3 =[[UIImageView alloc]init];
    self.title.numberOfLines = 0;
    source = [[UILabel alloc]init];
    source.font = fontnomal;
    [self addSubviews:icon1,icon2,icon3,source,nil];
}
-(void)setDataWithDict:(NSDictionary *)dict{
    DLog(@"%@",dict);
    NSMutableArray *picA = [NSMutableArray arrayWithArray:dict[@"media"]];
    icon1.image = icon2.image = icon3.image = nil;
    for(int a=0;a<picA.count;a++){
        switch (a) {
            case 0:[icon1 imageWithURL:[picA[a]  valueForJSONStrKey:@"url"] useProgress:NO useActivity:NO];break;
            case 1:[icon2 imageWithURL:[picA[a]  valueForJSONStrKey:@"url"] useProgress:NO useActivity:NO];break;
            case 2:[icon3 imageWithURL:[picA[a]  valueForJSONStrKey:@"url"] useProgress:NO useActivity:NO];break;
            default:break;
        }
    }
    self.title.text = [dict valueForJSONStrKey:@"title"];
    source.text = [NSString stringWithFormat:@"%@ %@ %@",[dict valueForJSONKey:@"source"],[dict valueForJSONStrKey:@"author"],[[dict valueForJSONStrKey:@"date"]substringToIndex:10]];
    CGSize size = [self.title.text sizeOfFont:fontTitle maxSize:CGSizeMake(picA.count==1?(APPW-50)*2/3.0 : APPW - 2*Boardseperad, 40)];
    self.title.frame = CGRectMake(Boardseperad, Boardseperad, size.width, size.height);
    icon1.frame = CGRectMake(X(self.title), YH(self.title)+40,(APPW-40)/3.0,  picA.count?(APPW-40)*4/15.0:0);
    if(picA.count==1){
        icon1.frame = CGRectMake(Boardseperad, Boardseperad, (APPW-40)/3.0, (APPW-40)*4/15.0);
        self.title.frame = CGRectMake(XW(icon1)+Boardseperad, Boardseperad, size.width, size.height);
    }
    source.frame = CGRectMake(X(self.title), YH(self.title)+Boardseperad, APPW-100, 20);
    icon2.frame = CGRectMake(XW(icon1)+10, Y(icon1), W(icon1), H(icon1));
    icon3.frame = CGRectMake(XW(icon2)+10, Y(icon1), W(icon1), H(icon1));
    self.line.frame = CGRectMake(Boardseperad,picA.count?YH(icon1)+8:YH(icon1)-1, APPW - 2*Boardseperad, 1.5);
}
@end
@implementation ToutiaoHomeSampleViewController{
    NSArray *tops;
    NSString *nextURL;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0,0, APPW, APPH) style:UITableViewStyleGrouped];
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refresh];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMore];
    }];
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:120 footH:0 rowH:0 sectionN:1 rowN:11 cellName:@"ToutiaoHomeSampleViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self refresh];
}
-(void)refresh{
    [self.tableView stopLoadmore];
    [NetEngine createGetAction:[NSString stringWithFormat:TTEnergyURL,_tagID] onCompletion:^(id resData, BOOL isCache) {
        DLog(@"%@",resData);
        self.tableView.dataArray = [NSMutableArray arrayWithArray:resData[@"data"][@"lists"]];
        tops = [resData[@"data"] objectForJSONKey:@"top"];
        nextURL = [resData[@"data"]valueForJSONKey:@"nextUrl"];
        [self.tableView reloadData];
        [self.tableView stopRefresh];
        [self.tableView setContentOffset:CGPointMake(0, 35)];
    }];
}
-(void)loadMore{
    [self.tableView stopRefresh];
    if(!nextURL){
        [self.tableView stopLoadmore];return;
    }
    [Net GET:nextURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"\n%@",responseObject);
        [self.tableView.dataArray addObjectsFromArray:[responseObject[@"data"] objectForJSONKey:@"lists"]];
        nextURL = [responseObject[@"data"] valueForJSONKey:@"nextUrl"];
        [self.tableView reloadData];
        [self.tableView stopLoadmore];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:alertErrorTxt];
    }];
}
-(void)viewWillLayoutSubviews{
    self.tableView.frameHeight = self.view.frameHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *d =self.tableView.dataArray[indexPath.row];
    CGSize size = [d[@"title"] sizeOfFont:fontTitle maxSize:CGSizeMake([d[@"media"]count]==1?(APPW-50)*2/3.0 : APPW - 2*Boardseperad, 40)];
    if([d[@"media"]count]==0)return 50+size.height;// 70;
    else if([d[@"media"]count]==1)return 110;
    else return 150+size.height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BaseScrollView *headBanner = [BaseScrollView sharedViewBannerWithFrame:CGRectMake(0, 0, APPW, 120) viewsNumber:tops.count?tops.count:1 viewOfIndex:^UIView *(NSInteger index) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 120)];
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:view.bounds];
        NSArray *medias = [tops[index]objectForJSONKey:@"media"];
        [imageV imageWithURL:[medias[0]valueForJSONKey:@"url"]];
        UILabel *label = [UILabel labelWithFrame:CGRectMake(0, H(view)-20, APPW, 20) font:fontnomal color:blacktextcolor text:[tops[index] valueForJSONKey:@"title"]];
        [view addSubviews:imageV,label,nil];
        return view;
    } Vertically:NO setFire:YES];
    [headBanner setSelectBlock:^(NSInteger index, NSDictionary *dict) {
        DLog(@"选中了其中的某个banner：%ld",index);
    }];
    return headBanner;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.tableView.dataArray[indexPath.row];
    [self pushController:[ToutiaoHomeDetailViewController class] withInfo:dict withTitle:dict[@"title"]];
}
@end
