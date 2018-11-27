//  TLTagsViewController.m
//  Freedom
// Created by Super
#import "WXTagsViewController.h"
#import "WXTableViewCell.h"
#import "WXUserHelper.h"
@interface WXTagCell : WXTableViewCell
@property (nonatomic, strong) NSString *title;
@end
@interface WXTagCell()
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation WXTagCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftSeparatorSpace = 15;
        [self.contentView addSubview:self.titleLabel];
        
        [self p_addMasonry];
    }
    return self;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    [self.titleLabel setText:title];
}
#pragma mark - 
- (void)p_addMasonry{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftSeparatorSpace);
        make.right.mas_lessThanOrEqualTo(-self.leftSeparatorSpace);
        make.centerY.mas_equalTo(self.contentView);
    }];
}
#pragma mark - 
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    return _titleLabel;
}
@end
@implementation WXTagsViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"标签"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self registerCellClass];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    self.data = [WXFriendHelper sharedFriendHelper].tagsData;
}
#pragma mark - Event Response -
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
    
}
#pragma mark - Public Methods -
- (void)registerCellClass{
    [self.tableView registerClass:[WXTagCell class] forCellReuseIdentifier:@"TLTagCell"];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUserGroup *group = [self.data objectAtIndex:indexPath.row];
    WXTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLTagCell"];
    [cell setTitle:[NSString stringWithFormat:@"%@(%ld)", group.groupName, (long)group.count]];
    [cell setTopLineStyle:(indexPath.row == 0 ? TLCellLineStyleFill : TLCellLineStyleNone)];
    [cell setBottomLineStyle:(indexPath.row == self.data.count - 1 ? TLCellLineStyleFill : TLCellLineStyleDefault)];
    return cell;
}
//MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
