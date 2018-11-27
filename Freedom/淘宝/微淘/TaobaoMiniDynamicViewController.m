//  TaobaoMiniDynamicViewController.m
#import "TaobaoMiniDynamicViewController.h"
#import <XCategory/UILabel+expanded.h>
@interface TaobaoMiniDynamicViewCell:BaseTableViewCell{
    UILabel *name,*sees,*times;
    UIButton *zan,*pinglun;
    UIImageView *type;
}
@end
@implementation TaobaoMiniDynamicViewCell
-(void)initUI{
    [super initUI];
    self.icon.frame = CGRectMake(10, 10, 30, 30);
    name = [UILabel labelWithFrame:CGRectMake(XW(self.icon)+10, Y(self.icon)-5, APPW-XW(self.icon)-20, 20) font:fontSmallTitle color:RGBCOLOR(0, 111, 255) text:nil];
    times = [UILabel labelWithFrame:CGRectMake(X(name), YH(name), W(name), 15) font:fontnomal color:graycolor text:nil];
    self.picV = [[UIImageView alloc]initWithFrame:CGRectMake(X(self.icon), YH(self.icon)+10, APPW-20, 130)];
    self.cellContentView = [[UIView alloc]initWithFrame:CGRectMake(X(self.picV), YH(self.picV), W(self.picV), 60)];
    self.cellContentView.backgroundColor = gradcolor;
    [self.title removeFromSuperview];
    [self.script removeFromSuperview];
    
    self.title.frame = CGRectMake(0, 0, W(self.cellContentView), 20);
    self.script.frame = CGRectMake(X(self.title), YH(self.title), W(self.title), 40);
    self.script.numberOfLines = 0;
    [self.cellContentView addSubviews:self.title,self.script,nil];
    sees = [UILabel labelWithFrame:CGRectMake(10, YH(self.cellContentView)+10,100, 15) font:fontnomal color:graycolor text:nil];
    zan = [[UIButton alloc]initWithFrame:CGRectMake(APPW-130, Y(sees)-2, 55, 19)];
    pinglun = [[UIButton alloc]initWithFrame:CGRectMake(XW(zan)+10, Y(zan), W(zan), H(zan))];
    zan.layer.cornerRadius = 7.5;zan.layer.borderWidth = 0.5;zan.clipsToBounds = YES;
    pinglun.layer.cornerRadius = 7.5;pinglun.layer.borderWidth = 0.5;pinglun.clipsToBounds = YES;
    sees.font = Font(12);
    zan.titleLabel.font = Font(12);
    pinglun.titleLabel.font = Font(12);
    self.line.frame = CGRectMake(0, 280-1, APPW, 1);
    [self addSubviews:name,times,self.picV,self.cellContentView,sees,zan,pinglun,nil];
}
-(void)setDataWithDict:(NSDictionary *)dict{
    self.icon.image = [UIImage imageNamed:@"xin@2x"];
    name.text = @"微淘发现";
    times.text = @"1-7";
    self.picV.image = [UIImage imageNamed:@"image4.jpg"];
    self.title.text = @"初心品质 不忘初心，惊喜大发现，原来。。。";
    self.script.text = @"与爱齐名，为有初心不变，小编为大家收集了超多好文好店，从手工匠人到原型设计，他们并没有忘记";
    sees.text = @"👀 145";
    [zan setTitle:@"👍3031" forState:UIControlStateNormal];
    [pinglun setTitle:@"🏃评论" forState:UIControlStateNormal];
}
@end
@implementation TaobaoMiniDynamicViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0,0, APPW, self.view.frameHeight-20) style:UITableViewStylePlain];
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:280 sectionN:1 rowN:11 cellName:@"TaobaoMiniDynamicViewCell"];
    self.tableView.dataArray = [NSMutableArray arrayWithObjects:@"b",@"a",@"v",@"f",@"d",@"a",@"w",@"u",@"n",@"o",@"2", nil];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
-(void)viewWillLayoutSubviews{
    self.tableView.frameHeight = self.view.frameHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
