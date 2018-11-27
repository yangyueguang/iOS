//  SDServiceTableViewController.m
//  GSD_ZHIFUBAO
//  Created by Super on 15-6-4.
#import "SDServiceTableViewController.h"
#import "UIView+SDExtension.h"
#import "UIImageView+WebCache.h"
#import "SDBasicTableViewControllerCell.h"
@interface SDServiceTableViewCellModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailString;
@property (nonatomic, copy) NSString *iconImageURLString;
+ (instancetype)modelWithTitle:(NSString *)title detailString:(NSString *)detailString iconImageURLString:(NSString *)iconImageURLString;
@end
@implementation SDServiceTableViewCellModel
+ (instancetype)modelWithTitle:(NSString *)title detailString:(NSString *)detailString iconImageURLString:(NSString *)iconImageURLString{
    SDServiceTableViewCellModel *model = [[SDServiceTableViewCellModel alloc] init];
    model.title = title;
    model.detailString = detailString;
    model.iconImageURLString = iconImageURLString;
    return model;
}
@end
@interface SDServiceTableViewCell : SDBasicTableViewControllerCell
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@end
@implementation SDServiceTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 80)];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, 200, 20)];
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 40, 200, 20)];
    self.iconView.layer.cornerRadius = 4;
    self.iconView.clipsToBounds = YES;
    self.titleLabel.font = Font(16);
    self.detailLabel.font = Font(14);
    self.detailLabel.textColor = [UIColor grayColor];
    [self addSubviews:self.iconView,self.titleLabel,self.detailLabel,nil];
    return self;
}
- (void)setModel:(NSObject *)model{
    [super setModel:model];
    
    SDServiceTableViewCellModel *cellModel = (SDServiceTableViewCellModel *)model;
    
    self.titleLabel.text = cellModel.title;
    self.detailLabel.text = cellModel.detailString;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:cellModel.iconImageURLString] placeholderImage:nil];
}
@end
@interface SDServiceTableViewHeader : UIView <UITextFieldDelegate>
@property (nonatomic, copy) NSString *placeholderText;
@end
@implementation SDServiceTableViewHeader{
    UITextField *_textField;
    UIImageView *_textFieldSearchIcon;
    UILabel *_textFieldPlaceholderLabel;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
        UITextField *textField = [[UITextField alloc] init];
        textField.layer.cornerRadius = 5;
        textField.clipsToBounds = YES;
        textField.backgroundColor = [UIColor whiteColor];
        textField.font = [UIFont systemFontOfSize:15];
        [textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.delegate = self;
        [self addSubview:textField];
        _textField = textField;
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:Psearch]];
        searchIcon.contentMode = UIViewContentModeScaleAspectFill;
        [_textField addSubview:searchIcon];
        _textFieldSearchIcon = searchIcon;
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.font = _textField.font;
        placeholderLabel.textColor = [UIColor lightGrayColor];
        [_textField addSubview:placeholderLabel];
        _textFieldPlaceholderLabel = placeholderLabel;
    }    return self;
}
- (void)setPlaceholderText:(NSString *)placeholderText{
    _placeholderText = placeholderText;
    _textFieldPlaceholderLabel.text = placeholderText;
}
- (void)layoutSubviews{
    CGFloat margin = 8;
    _textField.frame = CGRectMake(margin, margin, self.sd_width - margin * 2, self.sd_height - margin * 2);
    [self layoutTextFieldSubviews];
    if (!_textField.leftView) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _textFieldSearchIcon.sd_height * 1.4, _textFieldSearchIcon.sd_height)];
        _textField.leftView = leftView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
    }
}
- (void)layoutTextFieldSubviews{
    CGRect rect = [self.placeholderText boundingRectWithSize:CGSizeMake(_textField.sd_width * 0.7, _textField.sd_height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _textFieldPlaceholderLabel.font} context:nil];
    _textFieldPlaceholderLabel.bounds = CGRectMake(0, 0, rect.size.width, _textField.sd_height);
    _textFieldPlaceholderLabel.center = CGPointMake(_textField.sd_width * 0.5, _textField.sd_height * 0.5);
    _textFieldSearchIcon.bounds = CGRectMake(0, 0, _textField.sd_height * 0.6, _textField.sd_height * 0.6);
    _textFieldSearchIcon.center = CGPointMake(_textFieldPlaceholderLabel.sd_x - _textFieldSearchIcon.sd_width * 0.5,  _textFieldPlaceholderLabel.center.y);
}
- (void)textFieldValueChanged:(UITextField *)field{
    _textFieldPlaceholderLabel.hidden = (field.text.length != 0);
}
#pragma mark - textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_textField becomeFirstResponder];
    CGFloat deltaX = _textFieldSearchIcon.sd_x - 5;
    [UIView animateWithDuration:0.4 animations:^{
        _textFieldSearchIcon.transform = CGAffineTransformMakeTranslation(- deltaX, 0);
        _textFieldPlaceholderLabel.transform = CGAffineTransformMakeTranslation(- deltaX, 0);
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.4 animations:^{
        _textFieldSearchIcon.transform = CGAffineTransformIdentity;
        _textFieldPlaceholderLabel.transform = CGAffineTransformIdentity;
    }];
    _textField.text = @"";
    _textFieldPlaceholderLabel.hidden = NO;
}
@end
@interface SDServiceTableViewController ()
@end
@implementation SDServiceTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
      self.navigationItem.title = @"朋友";
    self.refreshMode = SDBasicTableViewControllerRefeshModeHeaderRefresh;
    self.tableView.rowHeight = 70;
    SDServiceTableViewHeader *header = [[SDServiceTableViewHeader alloc] init];
    header.sd_height = 44;
    header.placeholderText = @"搜索朋友";
    self.tableView.tableHeaderView = header;
    self.cellClass = [SDServiceTableViewCell class];
    [self setupModel];
}
- (void)setupModel{
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        SDServiceTableViewCellModel *model = [SDServiceTableViewCellModel modelWithTitle:[NSString stringWithFormat:@"服务提醒 -- %d", i] detailString:[NSString stringWithFormat:@"服务提醒摘要 -- %d", i] iconImageURLString:@"http://f.vip.duba.net/data/avatar//201309/9/328/137871226483UB.jpg"];
        [temp addObject:model];
    }
    self.sectionsNumber = 1;
    self.dataArray = [temp copy];
}
#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SDServiceTableViewCellModel *model = self.dataArray[indexPath.row];
    UIViewController *vc = [[SDBasicTableViewController alloc] init];
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tableView endEditing:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    // 三个方法并用，实现自定义分割线效果
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = insets;
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:insets];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
#pragma mark - pull down refresh
- (void)pullDownRefreshOperation{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
}
@end
