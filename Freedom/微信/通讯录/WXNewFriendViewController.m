//  TLNewFriendViewController.m
//  Freedom
// Created by Super
#import "WXNewFriendViewController.h"
#import "WXSearchController.h"
#import "WXAddFriendViewController.h"
#import "WXContactsViewController.h"
#import "WXTableViewCell.h"
static const NSString *TLThirdPartFriendTypeContacts = @"1";
static const NSString *TLThirdPartFriendTypeQQ = @"2";
static const NSString *TLThirdPartFriendTypeGoogle = @"3";
@interface WXAddThirdPartFriendCell : WXTableViewCell
@property (nonatomic, assign) id<WXAddThirdPartFriendCellDelegate>delegate;
/*第三方类型
 *  {
 *      TLThirdPartFriendTypeContacts
 *      TLThirdPartFriendTypeQQ
 *      TLThirdPartFriendTypeGoogle
 *  }*/
@property (nonatomic, strong) NSArray *thridPartItems;
@end
@interface WXAddThirdPartFriendItem : UIButton
/*第三方类型
 *  {
 *      TLThirdPartFriendTypeContacts
 *      TLThirdPartFriendTypeQQ
 *      TLThirdPartFriendTypeGoogle
 *  }*/
@property (nonatomic, strong) NSString *itemTag;
- (id)initWithImagePath:(NSString *)imagePath andTitle:(NSString *)title;
@end
@interface WXAddThirdPartFriendItem ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textLabel;
@end
@implementation WXAddThirdPartFriendItem
- (id)initWithImagePath:(NSString *)imagePath andTitle:(NSString *)title{
    if (self = [super initWithFrame:CGRectZero]) {
        [self.iconImageView setImage:[UIImage imageNamed:imagePath]];
        [self.textLabel setText:title];
        [self addSubview:self.iconImageView];
        [self addSubview:self.textLabel];
        [self p_addMasonry];
    }
    return self;
}
#pragma mark - Pirvate Methods -
- (void)p_addMasonry{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(10);
        make.centerX.mas_equalTo(self);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_equalTo(5);
        make.centerX.mas_equalTo(self.iconImageView);
    }];
}
#pragma mark - Getter -
- (UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UILabel *)textLabel{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        [_textLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }
    return _textLabel;
}
@end
@interface WXAddThirdPartFriendCell ()
@property (nonatomic, strong) NSDictionary *itemsDic;
@property (nonatomic, strong) WXAddThirdPartFriendItem *contacts;
@property (nonatomic, strong) WXAddThirdPartFriendItem *qq;
@property (nonatomic, strong) WXAddThirdPartFriendItem *google;
@end
@implementation WXAddThirdPartFriendCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBottomLineStyle:TLCellLineStyleFill];
        _itemsDic = @{
                      TLThirdPartFriendTypeContacts : self.contacts,
                      TLThirdPartFriendTypeQQ : self.qq,
                      TLThirdPartFriendTypeGoogle : self.google};
    }
    return self;
}
- (void)setThridPartItems:(NSArray *)thridPartItems{
    if (_thridPartItems == thridPartItems) {
        return;
    }
    _thridPartItems = thridPartItems;
    WXAddThirdPartFriendItem *lastItem;
    for(UIView *v in self.contentView.subviews){
        [v removeFromSuperview];
    }
    for (int i = 0; i < thridPartItems.count; i++) {
        NSString *keyStr = [thridPartItems objectAtIndex:i];
        WXAddThirdPartFriendItem *item = [self.itemsDic objectForKey:keyStr];
        [self.contentView addSubview:item];
        [item mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.mas_equalTo(self.contentView);
        }];
        if (i == 0) {
            [item mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView);
            }];
        }else{
            [item mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lastItem.mas_right);
                make.width.mas_equalTo(lastItem);
            }];
        }
        if (i == self.thridPartItems.count - 1) {
            [item mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView);
            }];
        }
        lastItem = item;
    }
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextBeginPath(context);
    if (self.thridPartItems.count == 2) {
        CGContextMoveToPoint(context, self.frame.size.width / 2.0, 0);
        CGContextAddLineToPoint(context, self.frame.size.width / 2.0, self.frameHeight);
    }else if (self.thridPartItems.count == 3) {
        CGContextMoveToPoint(context, self.frame.size.width / 3.0, 0);
        CGContextAddLineToPoint(context, self.frame.size.width / 3.0, self.frameHeight);
        CGContextMoveToPoint(context, self.frame.size.width / 3.0 * 2, 0);
        CGContextAddLineToPoint(context, self.frame.size.width / 3.0 * 2, self.frameHeight);
    }
    CGContextStrokePath(context);
}
#pragma mark - Event Response -
- (void)itemButtonDown:(WXAddThirdPartFriendItem *)item{
    if (_delegate && [_delegate respondsToSelector:@selector(addThirdPartFriendCellDidSelectedType:)]) {
        [_delegate addThirdPartFriendCellDidSelectedType:item.itemTag];
    }
}
#pragma mark - Getter -
- (WXAddThirdPartFriendItem *)contacts{
    if (_contacts == nil) {
        _contacts = [[WXAddThirdPartFriendItem alloc] initWithImagePath:@"newFriend_contacts" andTitle:@"添加手机联系人"];
        _contacts.itemTag = [TLThirdPartFriendTypeContacts copy];
        [_contacts addTarget:self action:@selector(itemButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contacts;
}
- (WXAddThirdPartFriendItem *)qq{
    if (_qq == nil) {
        _qq = [[WXAddThirdPartFriendItem alloc] initWithImagePath:@"newFriend_qq" andTitle:@"添加QQ好友"];
        _qq.itemTag = [TLThirdPartFriendTypeQQ copy];
        [_qq addTarget:self action:@selector(itemButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qq;
}
- (WXAddThirdPartFriendItem *)google{
    if (_google == nil) {
        _google = [[WXAddThirdPartFriendItem alloc] initWithImagePath:@"newFriend_google" andTitle:@"添加Google好友"];
        _google.itemTag = [TLThirdPartFriendTypeGoogle copy];
        [_google addTarget:self action:@selector(itemButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _google;
}
@end
@interface WXNewFriendSearchViewController : WXTableViewController <UISearchResultsUpdating>
@end
@implementation WXNewFriendSearchViewController
#pragma mark - Delegate -
//MARK: UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}
@end
@interface WXNewFriendViewController ()
@property (nonatomic, strong) WXSearchController *searchController;
@property (nonatomic, strong) WXNewFriendSearchViewController *searchVC;
@end
@implementation WXNewFriendViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"新的朋友"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"添加朋友" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    [self registerCellClass];
}
#pragma mark - Event Response -
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
    WXAddFriendViewController *addFriendVC = [[WXAddFriendViewController alloc] init];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:addFriendVC animated:YES];
}
#pragma mark - Getter -
- (WXSearchController *)searchController{
    if (_searchController == nil) {
        _searchController = [[WXSearchController alloc] initWithSearchResultsController:self.searchVC];
        [_searchController setSearchResultsUpdater:self.searchVC];
        [_searchController.searchBar setPlaceholder:@"微信号/手机号"];
        [_searchController.searchBar setDelegate:self];
    }
    return _searchController;
}
- (WXNewFriendSearchViewController *)searchVC{
    if (_searchVC == nil) {
        _searchVC = [[WXNewFriendSearchViewController alloc] init];
    }
    return _searchVC;
}
#pragma mark - Private Methods -
- (void)registerCellClass{
    [self.tableView registerClass:[WXAddThirdPartFriendCell class] forCellReuseIdentifier:@"TLAddThirdPartFriendCell"];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WXAddThirdPartFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLAddThirdPartFriendCell"];
        [cell setThridPartItems:@[TLThirdPartFriendTypeContacts]];
        [cell setDelegate:self];
        return cell;
    }
    return nil;
}
//MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }
    return 60.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 20.0f;
    }
    return 0.0f;
}
//MARK: UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
}
//MARK: TLAddThirdPartFriendCellDelegate
- (void)addThirdPartFriendCellDidSelectedType:(NSString *)thirdPartFriendType{
    if ([TLThirdPartFriendTypeContacts isEqualToString:thirdPartFriendType]) {
        WXContactsViewController *contactsVC = [[WXContactsViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:contactsVC animated:YES];
    }else if ([TLThirdPartFriendTypeQQ isEqualToString:thirdPartFriendType]) {
        
    }else if ([TLThirdPartFriendTypeGoogle isEqualToString:thirdPartFriendType]) {
        
    }
}
@end
