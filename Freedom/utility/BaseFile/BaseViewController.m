
#import "BaseViewController.h"
#import "Reachability.h"
#include <objc/runtime.h>
#import "User.h"
@interface BaseViewController ()
@end
@implementation BaseViewController
- (id)initWithNavStyle:(NSInteger)style{
    self = [super init];
    if (self) {
        
    }return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)name:kReachabilityChangedNotification object:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0,APPW, TopHeight)];
    [[UINavigationBar appearance] setBackIndicatorImage:[[UIImage imageNamed:PcellLeft]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:PcellLeft]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController.view setBackgroundColor:whitecolor];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor blackColor],[UIFont boldSystemFontOfSize:18.0f], nil] forKeys:[NSArray arrayWithObjects: NSForegroundColorAttributeName,NSFontAttributeName, nil]];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.view setClipsToBounds:YES];
    [self.view setBackgroundColor:whitecolor];
    [self.navigationController.navigationBar setBarTintColor:gradcolor];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.automaticallyAdjustsScrollViewInsets=NO;
}
#pragma mark - Methods
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info{
    return [self pushController:controller withInfo:info withTitle:nil withOther:nil tabBarHidden:YES];
}
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title{
    return [self pushController:controller withInfo:info withTitle:title withOther:nil tabBarHidden:YES];
}
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other{
   return [self pushController:controller withInfo:info withTitle:title withOther:other tabBarHidden:YES];
}
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other tabBarHidden:(BOOL)abool{
    DLog(@"\n跳转到 %@ 类",NSStringFromClass(controller));
    return [self pushController:[[controller alloc]init] withInfo:info withTitle:title withOther:other tabBarHid:abool];
}
- (BaseViewController*)pushController:(BaseViewController*)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other tabBarHid:(BOOL)abool{
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
- (void)popToControllerNamed:(NSString*)controller{
    Class cls = NSClassFromString(controller);
    if ([cls isSubclassOfClass:[UIViewController class]]) {
        [self.navigationController popToViewController:(UIViewController*)cls animated:YES];
    }else{
        DLog(@"popToController NOT FOUND.");
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)popToTheControllerNamed:(id)controller{
    if ([controller isKindOfClass:[UIViewController class]]) {
        [self.navigationController popToViewController:controller animated:YES];
    }else{
        DLog(@"popToController NOT FOUND.");
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)popToControllerNamed:(NSString*)controllerstr withSel:(SEL)sel withObj:(id)info{
    DLog(@"\n返回到 %@ 页面",controllerstr);
    if ([info isKindOfClass:[NSDictionary class]]) {
        DLog(@"\nBase UserInfo:%@",info);
    }
    for (id controller in self.navigationController.viewControllers) {
        if ([NSStringFromClass([controller class]) isEqualToString:controllerstr]) {
            if ([(NSObject*)controller respondsToSelector:sel]) {
                [controller performSelector:sel withObject:info afterDelay:0.01];
            }
            [self popToTheControllerNamed:controller];
            break;
        }
    }
}
#pragma mark - Actions
- (void)backToHomeViewController{
    NSArray *controllers = [(UITabBarController*)[(UIWindow*)[[UIApplication sharedApplication] windows][0] rootViewController] viewControllers];//首页的controllers
    if([controllers[0] navigationController]){
        [[controllers[0] navigationController]popToRootViewControllerAnimated:YES];//回到首页
    }else{
        [controllers[0] dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)goback{
    [SVProgressHUD dismiss];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark UItableViewDelegagte
- (void)fillTheTableDataWithHeadV:(UIView*)head footV:(UIView*)foot canMove:(BOOL)move canEdit:(BOOL)edit headH:(CGFloat)headH footH:(CGFloat)footH rowH:(CGFloat)rowH sectionN:(NSInteger)sectionN rowN:(NSInteger)rowN cellName:(NSString *)cell{
    self.tableView.tableHeaderView = head;
    self.tableView.tableFooterView = foot;
    self.tableView.canMoveRow = move;
    self.tableView.canEditRow = edit;
    self.tableView.headH = headH;
    self.tableView.footH = footH;
    self.tableView.rowH = rowH;
    self.tableView.sectionN = sectionN;
    self.tableView.rowN = rowN;
    self.tableView.cell = [NSClassFromString(cell) getInstance];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.rowH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.tableView.headH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.tableView.footH;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableView.sectionN;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.tableView.sectionN == 1){
//        return self.tableView.rowN;
        return self.tableView.dataArray.count;
    }else{
        NSArray *rows = self.tableView.dataArray[section];
        return rows.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellName = NSStringFromClass(self.tableView.cell.class);
    self.tableView.cell = [tableView dequeueReusableCellWithIdentifier:[NSClassFromString(cellName) getTableCellIdentifier]];
    if(!self.tableView.cell){
        self.tableView.cell = [NSClassFromString(cellName) getInstance];
    }
    if(self.tableView.sectionN==1){
        [self.tableView.cell  setDataWithDict:self.tableView.dataArray[indexPath.row]];
    }else{
        [self.tableView.cell  setDataWithDict:self.tableView.dataArray[indexPath.section][indexPath.row]];
    }
    return self.tableView.cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableView.tableHeaderView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.tableView.tableFooterView;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.canEditRow;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.canMoveRow;
}
#pragma mark  子类重写
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"请子类重写这个方法");
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    DLog(@"请子类重写这个方法");return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    DLog(@"请子类重写这个方法");return nil;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.tableView.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    // 2 添加一个置顶按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        DLog(@"点击了置顶");
        [self.tableView.dataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    }];
    topRowAction.backgroundColor = gradcolor;
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction,topRowAction];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView.dataArray removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [self.tableView.dataArray addObject:self.tableView.dataArray[indexPath.row]];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    DLog(@"请子类重写这个方法");
    [self.tableView.dataArray removeObjectAtIndex:sourceIndexPath.row];
    [self.tableView.dataArray insertObject:self.tableView.dataArray[sourceIndexPath.row] atIndex:destinationIndexPath.row];
}
#pragma mark UICollectionViewDelegate
-(void)fillTheCollectionViewDataWithCanMove:(BOOL)move sectionN:(NSInteger)sectionN itemN:(NSInteger)itemN itemName:(NSString *)item{
    self.collectionView.canMoveRow = move;
    self.collectionView.sectionN = sectionN;
    self.collectionView.itemN = itemN;
    [self.collectionView registerClass:NSClassFromString(item) forCellWithReuseIdentifier:[NSString stringWithFormat:@"%@Identifier",item]];
    self.collectionReuseId = [NSString stringWithFormat:@"%@Identifier",item];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.collectionView.sectionN;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.collectionView.sectionN==1) return self.collectionView.dataArray.count;
    else{
        NSArray *a = self.collectionView.dataArray[section];
        return a.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    self.collectionView.cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.collectionReuseId forIndexPath:indexPath];
    if(self.collectionView.sectionN==1){
        [self.collectionView.cell  setCollectionDataWithDic:self.collectionView.dataArray[indexPath.row]];
    }else{
        [self.collectionView.cell  setCollectionDataWithDic:self.collectionView.dataArray[indexPath.section][indexPath.row]];
    }
    return self.collectionView.cell;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.collectionView.canMoveRow;
}
//子类重写
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
      DLog(@"请子类重写这个方法");
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
      DLog(@"请子类重写这个方法");
}
#pragma mark -Notify
-(void) reachabilityChanged:(NSNotification*) notification{
    if ([(Reachability*)[notification object] currentReachabilityStatus] == ReachableViaWiFi) {
        DLog(@"网络状态改变了.");
    }
}
#pragma mark others
- (void)addFloatView{
    
}
- (void)readData {
    self.items = [NSMutableArray arrayWithArray:[User getControllerData]];
}
-(void)radialMenu:(CKRadialMenu *)radialMenu didSelectPopoutWithIndentifier:(NSString *)identifier{
    DLog(@"代理通知发现点击了控制器%@", identifier);
    int a = [identifier intValue];
    [radialMenu didTapCenterView:nil];
    NSString *controlName = [self.items[a] valueForKey:@"control"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if([controlName isEqualToString:@"Sina"]){
        NSString *s =[NSString stringWithFormat:@"%@TabBarController",controlName];
        UIViewController *con = [[NSClassFromString(s) alloc]init];
        CATransition *animation = [CATransition animation];
        animation.duration = 1;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self presentViewController:con animated:NO completion:^{
        }];
        return;
    }
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:controlName bundle:nil];
    UIViewController *con = [StoryBoard instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"%@TabBarController",controlName]];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
    //    animation.type = kCATransitionReveal;
    //    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
//    [self presentViewController:con animated:NO completion:^{}];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    win.rootViewController = con;
    [win makeKeyAndVisible];
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@",[self.items[a] valueForKey:@"title"]]];
    
    //    常见变换类型（type）
    //    kCATransitionFade//淡出
    //    kCATransitionMoveIn//覆盖原图
    //    kCATransitionPush  //推出
    //    kCATransitionReveal//底部显出来
    //SubType:
    //    kCATransitionFromRight
    //    kCATransitionFromLeft// 默认值
    //    kCATransitionFromTop
    //    kCATransitionFromBottom
    //(type):
    //    pageCurl   向上翻一页
    //    pageUnCurl 向下翻一页
    //    rippleEffect 滴水效果
    //    suckEffect 收缩效果
    //    cube 立方体效果
    //    oglFlip 上下翻转效果
}
-(void)showStoryboardWithStoryboardName:(NSString*)story andViewIdentifier:(NSString*)identifier{
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:story bundle:nil];
    [self showViewController:[StoryBoard instantiateViewControllerWithIdentifier:identifier] sender:self];
}
-(void)presentStoryboardWithStoryboardName:(NSString*)story andViewIdentifier:(NSString*)identifier{
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:story bundle:nil];
    UIViewController *dvc = [StoryBoard instantiateViewControllerWithIdentifier:identifier];
    dvc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:dvc animated:YES completion:NULL];
}
-(void)showRadialMenu{
    if(!self.radialView){
        [self readData];
        self.radialView = [[CKRadialMenu alloc] initWithFrame:CGRectMake(APPW/2-25, APPH/2-25, 50, 50)];
        for(int i = 0;i<self.items.count;i++){
            UIImageView *a = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            a.image = [UIImage imageNamed:[self.items[i] valueForKey:@"icon"]];
            [self.radialView addPopoutView:a withIndentifier:[NSString stringWithFormat:@"%d",i]];
        }
        [self.radialView enableDevelopmentMode];
        self.radialView.distanceBetweenPopouts = 2*180/self.items.count;
        self.radialView.delegate = self;
        [self.view addSubview:self.radialView];
        self.radialView.center = self.view.center;
        UIWindow *win = [[UIApplication sharedApplication]keyWindow];
        [win addSubview:self.radialView];
        [win bringSubviewToFront:self.radialView];
    }else{
        [self.radialView removeFromSuperview];
        self.radialView = nil;
    }
   
}
#pragma mark 摇一摇
/** 开始摇一摇 */
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    [self showRadialMenu];
}
/** 摇一摇结束 */
- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion != UIEventSubtypeMotionShake)return;
    DLog(@"结束摇一摇");
}
/** 摇一摇取消(被中断 比如突然来了电话 )*/
- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    DLog(@"取消摇一摇");
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
