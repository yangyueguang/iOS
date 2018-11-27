
#import "BaseOCViewController.h"
#include <objc/runtime.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Freedom-Swift.h"
@implementation BaseTableViewOCCell
#pragma mark 初始化
///单例初始化，兼容nib创建
+(id) getInstance {
    BaseTableViewOCCell *instance = nil;
    @try {
        NSString *nibFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.nib",NSStringFromClass(self)]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:nibFilePath]) {
            id o = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
            if ([o isKindOfClass:self]) {
                instance = o;
            } else {
                instance = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getTableCellIdentifier]];
            }
        } else {
            instance = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getTableCellIdentifier]];
        }
    }
    @catch (NSException *exception) {
        instance = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getTableCellIdentifier]];
    }
    return instance;
}
+(NSString*) getTableCellIdentifier {
    return [[NSString alloc] initWithFormat:@"%@Identifier",NSStringFromClass(self)];
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(id)init {
    self = [super init];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(void)loadBaseTableCellSubviews{
    [self initUI];
    [self setUserInteractionEnabled:YES];
    [self.contentView setUserInteractionEnabled:YES];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)initUI{
    self.backgroundColor = [UIColor colorWithRed:245 green:245 blue:245 alpha:1];
    self.icon =[[UIImageView alloc]init];
    self.icon.contentMode = UIViewContentModeScaleToFill;
    self.title = [[UILabel alloc]init];
    self.title.font = [UIFont systemFontOfSize:15];
    self.title.numberOfLines = 0;
    self.script = [[UILabel alloc]init];
    self.script.font = [UIFont systemFontOfSize:13];
    self.script.textColor = self.title.textColor = [UIColor colorWithRed:33 green:34 blue:35 alpha:1];
    self.line = [[UIView alloc]init];
    //    [self addSubviews:self.icon,self.title,self.script,self.line,nil];
    NSLog(@"请子类重写这个方法");
}
@end
@implementation BaseCollectionViewOCCell
#pragma mark 初始化
+(NSString*) getTableCellIdentifier {
    return [[NSString alloc] initWithFormat:@"%@Identifier",NSStringFromClass(self)];
}
-(id)init {
    self = [super init];
    if (self) {
        [self initUI];
    }return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }return self;
}
-(void)initUI{
    self.backgroundColor = [UIColor colorWithRed:245 green:245 blue:245 alpha:1];
    self.icon =[[UIImageView alloc]init];
    self.icon.contentMode = UIViewContentModeScaleToFill;
    self.title = [[UILabel alloc]init];
    self.title.font = [UIFont systemFontOfSize:15];
    self.title.numberOfLines = 0;
    self.script = [[UILabel alloc]init];
    self.script.font = [UIFont systemFontOfSize:13];
    self.script.textColor = self.title.textColor = [UIColor colorWithRed:33 green:34 blue:35 alpha:1];
    self.line = [[UIView alloc]init];
    //    [self addSubviews:self.icon,self.title,self.script,self.line,nil];
    NSLog(@"请子类重写这个方法");
}
@end
@interface BaseOCViewController ()
/*
#pragma mark UItableViewDelegagte
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
///子类重写
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
//子类重写
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath;
 */
@end
@implementation BaseOCViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0,APPW, TopHeight)];
    [[UINavigationBar appearance] setBackIndicatorImage:[[UIImage imageNamed:@"u_cellLeft"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"u_cellLeft"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor blackColor],[UIFont boldSystemFontOfSize:18.0f], nil] forKeys:[NSArray arrayWithObjects: NSForegroundColorAttributeName,NSFontAttributeName, nil]];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.view setClipsToBounds:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
}
#pragma mark - Methods
- (BaseOCViewController*)pushController:(Class)controller withInfo:(id)info{
    return [self pushController:controller withInfo:info withTitle:nil withOther:nil];
}
- (BaseOCViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other{
    DLog(@"\n跳转到 %@ 类",NSStringFromClass(controller));
    return [self pushController:[[controller alloc]init] withInfo:info withTitle:title withOther:other tabBarHid:YES];
}
- (BaseOCViewController*)pushController:(BaseOCViewController*)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other tabBarHid:(BOOL)abool{
    DLog(@"\n跳转到 %@ 页面\nBase UserInfo:%@\nBase OtherInfo:%@",title,info,other);
    if ([(NSObject*)controller respondsToSelector:@selector(setUserInfo:)]) {
        controller.userInfo = info;
        controller.otherInfo = other;
    }
    controller.title = title;
    controller.hidesBottomBarWhenPushed=abool;
    [self.navigationController pushViewController:controller animated:YES];
    return controller;
}
#pragma mark UItableViewDelegagte
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellName = @"cd";
    BaseTableViewOCCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSClassFromString(cellName) getTableCellIdentifier]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BaseCollectionViewOCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"" forIndexPath:indexPath];
    return cell;
}
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    AppDelegate *dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [dele showRadialMenu];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
