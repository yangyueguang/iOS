//  SDYuEBaoTableViewController.m
//  GSD_ZHIFUBAO
//  Created by Super on 15-6-6.
#import "SDYuEBaoTableViewController.h"
#import "SDBasicTableViewControllerCell.h"
#import <Foundation/Foundation.h>
@interface SDYuEBaoTableViewCellModel : NSObject
@property (nonatomic, assign) float yesterdayIncome;
@property (nonatomic, assign) float totalMoneyAmount;
@end
@implementation SDYuEBaoTableViewCellModel
@end
@interface SDYuEBaoTableViewCellContentView : UIView
@property (nonatomic, assign) float yesterdayIncome;
@property (nonatomic, assign) float totalMoneyAmount;
@end
@interface SDYuEBaoTableViewCellContentView(){
    NSTimer *_yesterdayIncomeLabelAnimationTimer;
    NSTimer *_totalMoneyAmountLabelAnimationTimer;
}
@property (strong, nonatomic) UILabel *yesterdayIncomeLabel;
@property (strong, nonatomic) UILabel *totalMoneyAmountLabel;
@end
@implementation SDYuEBaoTableViewCellContentView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    UIView *yestodayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 180)];
    UIView *IncomeView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, APPW, 100)];
    UIView *shouyiView = [[UIView alloc]initWithFrame:CGRectMake(0, YH(IncomeView), APPW, 150)];
    yestodayView.backgroundColor = RGBCOLOR(255, 80, 2);
    shouyiView.backgroundColor = [UIColor lightGrayColor];
    UIImageView *yI = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 10, 10)];
    UILabel *yl = [[UILabel alloc]initWithFrame:CGRectMake(XW(yI), 15, 100, 20)];
    UILabel *yesIncomeL = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, APPW, 120)];
    yI.image = [UIImage imageNamed:@"calendar"];
    yl.text = @"昨日收益 (元)";
    yl.textColor = [UIColor whiteColor];
    yl.font = fontnomal;
    yesIncomeL.font = BoldFont(48);
    yesIncomeL.textColor = [UIColor whiteColor];
    self.yesterdayIncomeLabel = yesIncomeL;
    self.totalMoneyAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, APPW-20, 80)];
    UILabel *totalL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, APPW-20, 20)];
    totalL.textColor = [UIColor lightGrayColor];
    totalL.font = fontnomal;
    totalL.text = @"总金额（元）";
    self.totalMoneyAmountLabel.textColor = [UIColor redColor];
    self.totalMoneyAmountLabel.font = BoldFont(38);
    self.yesterdayIncomeLabel.text = @"0.00";
    self.totalMoneyAmountLabel.text = @"0.00";
    
    UILabel *a = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    UILabel *av = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 100, 20)];
    UILabel *b = [[UILabel alloc]initWithFrame:CGRectMake(APPW/2, 10, 100, 20)];
    UILabel *bv = [[UILabel alloc]initWithFrame:CGRectMake(APPW/2, 30, 100, 20)];
    UILabel *c = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 100, 20)];
    UILabel *cv = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 20)];
    UILabel *d = [[UILabel alloc]initWithFrame:CGRectMake(APPW/2, 60, 100, 20)];
    UILabel *dv = [[UILabel alloc]initWithFrame:CGRectMake(APPW/2, 80, 100, 20)];
    a.textColor = b.textColor = c.textColor = d.textColor = [UIColor grayColor];
    av.textColor = bv.textColor = cv.textColor = dv.textColor = [UIColor blackColor];
    a.font = b.font = c.font = d.font = av.font = bv.font = cv.font = dv.font = Font(14);
    a.text = @"万份收益（元）";
    av.text = @"1.0876";
    b.text = @"累计收益（元）";
    bv.text = @"1.0876";
    c.text = @"近一周收益（元）";
    cv.text = @"1.823";
    d.text = @"近一月收益（元）";
    dv.text = @"2.023";
    [yestodayView addSubviews:yI,yl,yesIncomeL,nil];
    [IncomeView addSubviews:totalL,self.totalMoneyAmountLabel,nil];
    [shouyiView addSubviews:a,av,b,bv,c,cv,d,dv,nil];
    [self addSubviews:yestodayView,IncomeView,shouyiView,nil];
    return self;
}
- (void)setYesterdayIncome:(float)yesterdayIncome{
    _yesterdayIncome = yesterdayIncome;
    
    [self setNumberTextOfLabel:self.yesterdayIncomeLabel WithAnimationForValueContent:yesterdayIncome];
}
- (void)setTotalMoneyAmount:(float)totalMoneyAmount{
    _totalMoneyAmount = totalMoneyAmount;
    
    [self setNumberTextOfLabel:self.totalMoneyAmountLabel WithAnimationForValueContent:totalMoneyAmount];
}
- (void)setNumberTextOfLabel:(UILabel *)label WithAnimationForValueContent:(CGFloat)value{
    CGFloat lastValue = [label.text floatValue];
    CGFloat delta = value - lastValue;
    if (delta == 0) return;
    
    if (delta > 0) {
        
        CGFloat ratio = value / 60.0;
        
        NSDictionary *userInfo = @{@"label" : label,
                                   @"value" : @(value),
                                   @"ratio" : @(ratio)
                                   };
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(setupLabel:) userInfo:userInfo repeats:YES];
        if (label == self.yesterdayIncomeLabel) {
            _yesterdayIncomeLabelAnimationTimer = timer;
        } else {
            _totalMoneyAmountLabelAnimationTimer = timer;
        }
    }
}
- (void)setupLabel:(NSTimer *)timer{
    NSDictionary *userInfo = timer.userInfo;
    UILabel *label = userInfo[@"label"];
    CGFloat value = [userInfo[@"value"] floatValue];
    CGFloat ratio = [userInfo[@"ratio"] floatValue];
    
    static int flag = 1;
    CGFloat lastValue = [label.text floatValue];
    CGFloat randomDelta = (arc4random_uniform(2) + 1) * ratio;
    CGFloat resValue = lastValue + randomDelta;
    
    if ((resValue >= value) || (flag == 50)) {
        label.text = [NSString stringWithFormat:@"%.2f", value];
        flag = 1;
        [timer invalidate];
        timer = nil;
        return;
    } else {
        label.text = [NSString stringWithFormat:@"%.2f", resValue];
    }
    
    flag++;
    
}
@end
@interface SDYuEBaoTableViewCell : SDBasicTableViewControllerCell
@end
const CGFloat kSDYuEBaoTableViewCellHeight = 550.0;
@implementation SDYuEBaoTableViewCell{
    SDYuEBaoTableViewCellContentView *_cellContentView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        SDYuEBaoTableViewCellContentView *contentView = [[SDYuEBaoTableViewCellContentView alloc] init];
        [self.contentView addSubview:contentView];
        _cellContentView = contentView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
// 重写父类方法
- (void)setModel:(NSObject *)model{
    [super setModel:model];
    
    SDYuEBaoTableViewCellModel *cellModel = (SDYuEBaoTableViewCellModel *)model;
    
    _cellContentView.totalMoneyAmount = cellModel.totalMoneyAmount;
    _cellContentView.yesterdayIncome = cellModel.yesterdayIncome;
}
@end
@interface SDYuEBaoTableViewController ()
@end
@implementation SDYuEBaoTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellClass = [SDYuEBaoTableViewCell class];
    
    SDYuEBaoTableViewCellModel *model = [[SDYuEBaoTableViewCellModel alloc] init];
    model.totalMoneyAmount = 8060.68;
    model.yesterdayIncome = 1.12;
    self.dataArray = @[model];
    
    self.refreshMode = SDBasicTableViewControllerRefeshModeHeaderRefresh;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
// 加载数据方法
- (void)pullDownRefreshOperation{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kSDYuEBaoTableViewCellHeight;
}
extern const CGFloat kSDYuEBaoTableViewCellHeight;
@end
