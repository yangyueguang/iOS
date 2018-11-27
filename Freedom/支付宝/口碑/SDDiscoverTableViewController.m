//  SDDiscoverTableViewController.m
//  GSD_ZHIFUBAO
#import "SDDiscoverTableViewController.h"
#import "SDAssetsTableViewControllerCellModel.h"
#import "UIView+SDExtension.h"
#import "SDAssetsTableViewControllerCellModel.h"
#import "SDBasicTableViewControllerCell.h"
@interface SDDiscoverTableViewHeaderItemButton : UIButton
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;
@end
@implementation SDDiscoverTableViewHeaderItemButton
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x = contentRect.size.width * 0.2;
    CGFloat y = contentRect.size.height * 0.15;
    CGFloat w = contentRect.size.width - x * 2;
    CGFloat h = contentRect.size.height * 0.5;
    CGRect rect = CGRectMake(x, y, w, h);
    return rect;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rect = CGRectMake(0, contentRect.size.height * 0.65, contentRect.size.width, contentRect.size.height * 0.3);
    return rect;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
}
@end
@interface SDDiscoverTableViewHeader : UIView
@property (nonatomic, strong) NSArray *headerItemModelsArray;
@property (nonatomic, copy) void (^buttonClickedOperationBlock)(NSInteger index);
@end
// --------------------------SDDiscoverTableViewHeaderItemModel-----------
@interface SDDiscoverTableViewHeaderItemModel : NSObject
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) Class destinationControllerClass;
+ (instancetype)modelWithTitle:(NSString *)title imageName:(NSString *)imageName destinationControllerClass:(Class)destinationControllerClass;
@end
@implementation SDDiscoverTableViewHeader
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)setHeaderItemModelsArray:(NSArray *)headerItemModelsArray{
    _headerItemModelsArray = headerItemModelsArray;
    
    [headerItemModelsArray enumerateObjectsUsingBlock:^(SDDiscoverTableViewHeaderItemModel *model, NSUInteger idx, BOOL *stop) {
        SDDiscoverTableViewHeaderItemButton *button = [[SDDiscoverTableViewHeaderItemButton alloc] init];
        button.tag = idx;
        button.title = model.title;
        button.imageName = model.imageName;
        [button addTarget:self action:@selector(buttonClickd:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.subviews.count == 0) return;
    CGFloat w = self.sd_width / self.subviews.count;
    CGFloat h = self.sd_height;
    [self.subviews enumerateObjectsUsingBlock:^(UIView *button, NSUInteger idx, BOOL *stop) {
        button.frame = CGRectMake(idx * w, 0, w, h);
    }];
}
- (void)buttonClickd:(SDDiscoverTableViewHeaderItemButton *)button{
    if (self.buttonClickedOperationBlock) {
        self.buttonClickedOperationBlock(button.tag);
    }
}
@end
@implementation SDDiscoverTableViewHeaderItemModel
+ (instancetype)modelWithTitle:(NSString *)title imageName:(NSString *)imageName destinationControllerClass:(Class)destinationControllerClass{
    SDDiscoverTableViewHeaderItemModel *model = [[SDDiscoverTableViewHeaderItemModel alloc] init];
    model.title = title;
    model.imageName = imageName;
    model.destinationControllerClass = destinationControllerClass;
    return model;
}
@end
@interface SDDiscoverTableViewControllerCell : SDBasicTableViewControllerCell
@end
@implementation SDDiscoverTableViewControllerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:15];
    }return self;
}
- (void)setModel:(NSObject *)model{
    [super setModel:model];
    SDAssetsTableViewControllerCellModel *cellModel = (SDAssetsTableViewControllerCellModel *)model;
    self.textLabel.text = cellModel.title;
    self.imageView.image = [UIImage imageNamed:cellModel.iconImageName];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
@end
@interface SDDiscoverTableViewController ()
@property (nonatomic, strong) NSArray *headerDataArray;
@end
@implementation SDDiscoverTableViewController
- (void)viewDidLoad{
    [super viewDidLoad];
      self.navigationItem.title = @"口碑";
    self.cellClass = [SDDiscoverTableViewControllerCell class];
    
    [self setupHeader];
    
    [self setupModel];
    
    self.sectionsNumber = self.dataArray.count;
    
}
- (void)setupHeader{
    SDDiscoverTableViewHeaderItemModel *model0 = [SDDiscoverTableViewHeaderItemModel modelWithTitle:@"红包" imageName:@"adw_icon_apcoupon_normal" destinationControllerClass:[SDBasicTableViewController class]];
    
    SDDiscoverTableViewHeaderItemModel *model1 = [SDDiscoverTableViewHeaderItemModel modelWithTitle:@"电子券" imageName:@"adw_icon_coupon_normal" destinationControllerClass:[SDBasicTableViewController class]];
    
    SDDiscoverTableViewHeaderItemModel *model2 = [SDDiscoverTableViewHeaderItemModel modelWithTitle:@"行程单" imageName:@"adw_icon_travel_normal" destinationControllerClass:[SDBasicTableViewController class]];
    
    SDDiscoverTableViewHeaderItemModel *model3 = [SDDiscoverTableViewHeaderItemModel modelWithTitle:@"会员卡" imageName:@"adw_icon_membercard_normal" destinationControllerClass:[SDBasicTableViewController class]];
    
    self.headerDataArray = @[model0, model1, model2, model3];
    
    
    SDDiscoverTableViewHeader *header = [[SDDiscoverTableViewHeader alloc] init];
    header.sd_height = 90;
    header.headerItemModelsArray = self.headerDataArray;
    __weak typeof(self) weakSelf = self;
    header.buttonClickedOperationBlock = ^(NSInteger index){
        SDDiscoverTableViewHeaderItemModel *model = weakSelf.headerDataArray[index];
        UIViewController *vc = [[model.destinationControllerClass alloc] init];
        vc.title = model.title;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.tableView.tableHeaderView = header;
}
- (void)setupModel{
    // section 0 的model
    SDAssetsTableViewControllerCellModel *model01 = [SDAssetsTableViewControllerCellModel modelWithTitle:@"淘宝电影" iconImageName:@"adw_icon_movie_normal" destinationControllerClass:[SDBasicTableViewController class]];
    
    SDAssetsTableViewControllerCellModel *model02 = [SDAssetsTableViewControllerCellModel modelWithTitle:@"快抢" iconImageName:@"adw_icon_flashsales_normal" destinationControllerClass:[SDBasicTableViewController class]];
    
    SDAssetsTableViewControllerCellModel *model03 = [SDAssetsTableViewControllerCellModel modelWithTitle:@"快的打车" iconImageName:@"adw_icon_taxi_normal" destinationControllerClass:[SDBasicTableViewController class]];
    
    // section 1 的model
    SDAssetsTableViewControllerCellModel *model11 = [SDAssetsTableViewControllerCellModel modelWithTitle:@"我的朋友" iconImageName:@"adw_icon_contact_normal" destinationControllerClass:[SDBasicTableViewController class]];
    
    
    self.dataArray = @[@[model01, model02, model03],
                       @[model11]
                       ];
}
#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SDAssetsTableViewControllerCellModel *model = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
    UIViewController *vc = [[model.destinationControllerClass alloc] init];
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return (section == self.dataArray.count - 1) ? 10 : 0;
}
@end
