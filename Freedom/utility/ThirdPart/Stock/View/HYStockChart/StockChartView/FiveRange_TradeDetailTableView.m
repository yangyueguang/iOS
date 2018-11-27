//
//  FiveRangeTableView.m
//  RRCP
#import "FiveRange_TradeDetailTableView.h"
///分时折线图右边的小cell之五档
@interface FiveRangeCell : UITableViewCell
@end
@implementation FiveRangeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self makeView];
    }
    return self;
}
- (void)makeView{
    UILabel *rangeName = [[UILabel alloc]init];
    rangeName.text = @"卖5 35.56 38 B";
    rangeName.textColor = [UIColor colorWithWhite:153/255.0 alpha:1];
    rangeName.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:rangeName];
    WS(weakSelf);
    [rangeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView).offset(5);
    }];
}
@end
@interface FiveRangeTableView ()<UITableViewDelegate,UITableViewDataSource>
@end
#define FiveRangeCellIdentifer @"FiveRangeCellIdentifer"
@implementation FiveRangeTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[FiveRangeCell class] forCellReuseIdentifier:FiveRangeCellIdentifer];
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FiveRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:FiveRangeCellIdentifer];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (self.frame.size.height - 20)/ 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *sectionView =  [[UIView alloc]init];
    sectionView.backgroundColor = [UIColor whiteColor];
    UIView *lineView =  [[UIView alloc]init];
    [sectionView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(sectionView);
        make.centerY.equalTo(sectionView);
        make.left.equalTo(sectionView);
        make.height.mas_equalTo(@0.5);
    }];
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0){
        return 20.0f;
    }else{
        return 0.001f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
@end
@interface TradeDetailCell : UITableViewCell
@end
@implementation TradeDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self makeView];
    }
    return self;
}
- (void)makeView{
    UILabel *currentTimeLabel = [[UILabel alloc]init];
    currentTimeLabel.textColor = [UIColor colorWithWhite:153/255.0 alpha:1];
    currentTimeLabel.font = [UIFont systemFontOfSize:10];
    currentTimeLabel.text = @"14.56 35.56  38 B";
    [self.contentView addSubview:currentTimeLabel];
    WS(weakSelf);
    [currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView).offset(5);
    }];
}
@end
@interface TradeDetailTableView ()<UITableViewDelegate,UITableViewDataSource>
@end
#define TradeDetailCellIdentifer @"TradeDetailCellIdentifer"
@implementation TradeDetailTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[TradeDetailCell class] forCellReuseIdentifier:TradeDetailCellIdentifer];
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TradeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:TradeDetailCellIdentifer];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.frame.size.height / 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

@end
